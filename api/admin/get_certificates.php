<?php
require_once '../../config.php';

header('Content-Type: application/json; charset=utf-8');

$response = ['success' => false];

try {
    $user = new User();
    $currentUser = $user->getCurrentUser();

    if (!$currentUser || $currentUser['user_type'] !== 'admin') {
        throw new Exception('Доступ запрещен');
    }

    $tutor_id = (int)($_GET['tutor_id'] ?? 0);
    if (!$tutor_id) {
        throw new Exception('ID репетитора не указан');
    }

    $db = new Database();

    $certificates = $db->fetchAll(
        "SELECT * FROM tutor_certificates WHERE tutor_id = ? ORDER BY uploaded_at DESC",
        [$tutor_id]
    );

    $response = ['success' => true, 'certificates' => $certificates];

} catch (Exception $e) {
    $response['message'] = $e->getMessage();
    http_response_code(400);
}

echo json_encode($response, JSON_UNESCAPED_UNICODE);
