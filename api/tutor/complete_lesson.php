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
    if (!$tutor) throw new Exception('Профиль не найден');

    $input = json_decode(file_get_contents('php://input'), true);
    $request_id = (int)($input['request_id'] ?? 0);
    $auto_complete = (bool)($input['auto_complete'] ?? false);
    if (!$request_id) throw new Exception('Не указан ID заявки');

    $request = $db->fetchOne(
        "SELECT * FROM tutor_requests WHERE request_id = ? AND tutor_id = ? AND status = 'accepted'",
        [$request_id, $tutor['tutor_id']]
    );
    if (!$request) throw new Exception('Заявка не найдена');

    if ($auto_complete) {
        $actual = (int)($request['lesson_duration'] ?? 60);
        $response_date = new DateTime($request['lesson_date']);
        $response_date->modify("+{$actual} minutes");
    } else {
        $now = new DateTime();
        $response_date = $now;
        $actual = null;
        if ($request['lesson_date']) {
            $lesson_start = new DateTime($request['lesson_date']);
            if ($now > $lesson_start) {
                $actual = (int)round(($now->getTimestamp() - $lesson_start->getTimestamp()) / 60);
                if ($actual < 1) $actual = 1;
            } else {
                $actual = 0;
            }
        }
    }

    $db->update('tutor_requests', [
        'status' => 'completed',
        'response_date' => $response_date->format('Y-m-d H:i:s'),
        'actual_duration' => $actual
    ], 'request_id = ?', [$request_id]);

    $response = ['success' => true, 'message' => 'Занятие завершено'];
} catch (Exception $e) {
    $response['message'] = $e->getMessage();
    http_response_code(400);
}

echo json_encode($response, JSON_UNESCAPED_UNICODE);
