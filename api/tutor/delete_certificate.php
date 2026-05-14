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

    $certificate_id = (int)($_POST['certificate_id'] ?? 0);
    if (!$certificate_id) {
        throw new Exception('ID сертификата не указан');
    }

    $cert = $db->fetchOne(
        "SELECT * FROM tutor_certificates WHERE certificate_id = ? AND tutor_id = ?",
        [$certificate_id, $tutor['tutor_id']]
    );

    if (!$cert) {
        throw new Exception('Сертификат не найден');
    }

    $filepath = dirname(__DIR__, 2) . '/uploads/certificates/' . $cert['filename'];
    if (file_exists($filepath)) {
        unlink($filepath);
    }

    $db->delete('tutor_certificates', 'certificate_id = ?', [$certificate_id]);

    $response = ['success' => true, 'message' => 'Сертификат удален'];

} catch (Exception $e) {
    $response['message'] = $e->getMessage();
    http_response_code(400);
}

echo json_encode($response, JSON_UNESCAPED_UNICODE);
