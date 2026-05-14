<?php
require_once '../../config.php';

header('Content-Type: application/json; charset=utf-8');

$response = ['success' => false];

try {
    $user = new User();
    $currentUser = $user->getCurrentUser();

    if (!$currentUser || $currentUser['user_type'] !== 'tutor') {
        throw new Exception('Доступ запрещен');
    }

    $db = new Database();

    $tutor = $db->fetchOne("SELECT tutor_id FROM tutors WHERE user_id = ?", [$currentUser['user_id']]);
    if (!$tutor) {
        throw new Exception('Профиль не найден');
    }

    $input = json_decode(file_get_contents('php://input'), true);

    $request_id = (int)($input['request_id'] ?? 0);
    $lesson_date = trim($input['lesson_date'] ?? '');
    $lesson_duration = (int)($input['lesson_duration'] ?? 60);
    $lesson_type = trim($input['lesson_type'] ?? 'online');
    if (!in_array($lesson_type, ['online', 'offline'])) $lesson_type = 'online';
    $tutor_notes = trim($input['tutor_notes'] ?? '');
    $lesson_topic = trim($input['lesson_topic'] ?? '');

    if (!$request_id || !$lesson_date) {
        throw new Exception('Укажите ID заявки и дату занятия');
    }

    if ($lesson_duration < 15 || $lesson_duration > 300) {
        throw new Exception('Длительность от 15 до 300 минут');
    }

    $lessonDt = new DateTime($lesson_date);
    $now = new DateTime();
    if ($lessonDt < $now) {
        throw new Exception('Дата занятия не может быть в прошлом');
    }

    $request = $db->fetchOne(
        "SELECT * FROM tutor_requests WHERE request_id = ? AND tutor_id = ? AND status = 'accepted'",
        [$request_id, $tutor['tutor_id']]
    );

    if (!$request) {
        throw new Exception('Заявка не найдена или не принята');
    }

    // Проверяем пересечение с другими занятиями (только для оффлайн)
    $lessonEnd = clone $lessonDt;
    $lessonEnd->modify("+{$lesson_duration} minutes");

    if ($lesson_type === 'offline') {
        $conflicts = $db->fetchAll(
            "SELECT tr.*, u.full_name as student_name FROM tutor_requests tr
             LEFT JOIN users u ON tr.student_id = u.user_id
             WHERE tr.tutor_id = ? AND tr.status = 'accepted' AND tr.request_id != ?
             AND tr.lesson_date IS NOT NULL
             AND tr.lesson_type = 'offline'
             AND tr.lesson_date < ? AND DATE_ADD(tr.lesson_date, INTERVAL tr.lesson_duration MINUTE) > ?",
            [$tutor['tutor_id'], $request_id, $lessonEnd->format('Y-m-d H:i:s'), $lessonDt->format('Y-m-d H:i:s')]
        );

        if (!empty($conflicts)) {
            $conflict = $conflicts[0];
            throw new Exception('Пересечение с оффлайн-занятием: ' . $conflict['student_name'] . ' в ' . date('H:i', strtotime($conflict['lesson_date'])));
        }
    }

    $updateData = [
        'lesson_date' => $lessonDt->format('Y-m-d H:i:s'),
        'lesson_duration' => $lesson_duration,
        'lesson_type' => $lesson_type
    ];

    if ($tutor_notes !== '') {
        $updateData['tutor_notes'] = $tutor_notes;
    }
    $updateData['lesson_topic'] = $lesson_topic !== '' ? $lesson_topic : null;

    $db->update('tutor_requests', $updateData, 'request_id = ?', [$request_id]);

    $response = ['success' => true, 'message' => 'Дата занятия назначена'];

} catch (Exception $e) {
    $response['message'] = $e->getMessage();
    http_response_code(400);
}

echo json_encode($response, JSON_UNESCAPED_UNICODE);
