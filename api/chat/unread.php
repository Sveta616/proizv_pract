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

  $myId = $currentUser['user_id'];
  $db = new Database();

  // общее кол-во непрочитанных
  $total = $db->fetchOne(
    "SELECT COUNT(*) as cnt FROM chat_messages WHERE receiver_id = ? AND is_read = 0",
    [$myId]
  );

  // непрочитанные по каждому собеседнику
  $perUser = $db->fetchAll(
    "SELECT sender_id, COUNT(*) as cnt
     FROM chat_messages
     WHERE receiver_id = ? AND is_read = 0
     GROUP BY sender_id",
    [$myId]
  );

  echo json_encode([
    'success' => true,
    'data' => [
      'total' => (int) $total['cnt'],
      'per_user' => $perUser
    ]
  ], JSON_UNESCAPED_UNICODE);

} catch (Exception $e) {
  http_response_code(400);
  echo json_encode([
    'success' => false,
    'message' => $e->getMessage()
  ], JSON_UNESCAPED_UNICODE);
}
