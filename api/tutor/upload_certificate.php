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

    // Создаем таблицу если не существует
    $db->executeQuery("CREATE TABLE IF NOT EXISTS tutor_certificates (
        certificate_id INT AUTO_INCREMENT PRIMARY KEY,
        tutor_id INT NOT NULL,
        filename VARCHAR(255) NOT NULL,
        original_name VARCHAR(255) NOT NULL,
        file_size INT NOT NULL,
        uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (tutor_id) REFERENCES tutors(tutor_id) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");

    $tutor = $db->fetchOne("SELECT tutor_id FROM tutors WHERE user_id = ?", [$currentUser['user_id']]);
    if (!$tutor) {
        throw new Exception('Профиль репетитора не найден');
    }

    if (empty($_FILES['certificate'])) {
        throw new Exception('Файл не выбран');
    }

    $file = $_FILES['certificate'];
    if ($file['error'] !== UPLOAD_ERR_OK) {
        throw new Exception('Ошибка загрузки файла');
    }

    $allowed_types = ['image/jpeg', 'image/png', 'image/webp', 'application/pdf'];
    $finfo = finfo_open(FILEINFO_MIME_TYPE);
    $mime = finfo_file($finfo, $file['tmp_name']);
    finfo_close($finfo);

    if (!in_array($mime, $allowed_types)) {
        throw new Exception('Допустимые форматы: JPG, PNG, WEBP, PDF');
    }

    if ($file['size'] > 5 * 1024 * 1024) {
        throw new Exception('Максимальный размер файла: 5 МБ');
    }

    // Проверяем лимит (макс 5 сертификатов)
    $count = $db->fetchOne("SELECT COUNT(*) as cnt FROM tutor_certificates WHERE tutor_id = ?", [$tutor['tutor_id']]);
    if ($count['cnt'] >= 5) {
        throw new Exception('Максимум 5 сертификатов');
    }

    $upload_dir = dirname(__DIR__, 2) . '/uploads/certificates/';
    if (!is_dir($upload_dir)) {
        mkdir($upload_dir, 0755, true);
    }

    $ext = pathinfo($file['name'], PATHINFO_EXTENSION);
    $filename = 'cert_' . $tutor['tutor_id'] . '_' . time() . '_' . bin2hex(random_bytes(4)) . '.' . $ext;

    if (!move_uploaded_file($file['tmp_name'], $upload_dir . $filename)) {
        throw new Exception('Не удалось сохранить файл');
    }

    $db->insert('tutor_certificates', [
        'tutor_id' => $tutor['tutor_id'],
        'filename' => $filename,
        'original_name' => $file['name'],
        'file_size' => $file['size']
    ]);

    $response = ['success' => true, 'message' => 'Сертификат загружен'];

} catch (Exception $e) {
    $response['message'] = $e->getMessage();
    http_response_code(400);
}

echo json_encode($response, JSON_UNESCAPED_UNICODE);
