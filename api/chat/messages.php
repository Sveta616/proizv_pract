<?php
session_start();
require_once '../../config.php';

header('Content-Type: application/json; charset=utf-8');

try {
  $userClass = new User();
  $currentUser = $userClass->getCurrentUser();

  if (!$currentUser) {
    throw new Exception('Не авторизован');
  }

  $partnerId = (int) ($_GET['partner_id'] ?? 0);
  if (!$partnerId) {
    throw new Exception('Собеседник не указан');
  }

  $myId = $currentUser['user_id'];
  $db = new Database();

  // получаем сообщения между двумя пользователями
  $messages = $db->fetchAll(
    "SELECT m.*, u.full_name as sender_name
     FROM chat_messages m
     LEFT JOIN users u ON m.sender_id = u.user_id
     WHERE (m.sender_id = ? AND m.receiver_id = ?)
        OR (m.sender_id = ? AND m.receiver_id = ?)
     ORDER BY m.created_at ASC",
    [$myId, $partnerId, $partnerId, $myId]
  );

  // помечаем входящие как прочитанные
  $db->executeQuery(
    "UPDATE chat_messages SET is_read = 1
     WHERE sender_id = ? AND receiver_id = ? AND is_read = 0",
    [$partnerId, $myId]
  );

  echo json_encode([
    'success' => true,
    'data' => $messages
  ], JSON_UNESCAPED_UNICODE);

} catch (Exception $e) {
  http_response_code(400);
  echo json_encode([
    'success' => false,
    'message' => $e->getMessage()
  ], JSON_UNESCAPED_UNICODE);
}
