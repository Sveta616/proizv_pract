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

  $input = json_decode(file_get_contents('php://input'), true);
  if (empty($input)) {
    $input = $_POST;
  }

  $receiverId = (int) ($input['receiver_id'] ?? 0);
  $messageText = trim($input['message'] ?? '');

  if (!$receiverId) {
    throw new Exception('Получатель не указан');
  }
  if ($messageText === '') {
    throw new Exception('Сообщение пустое');
  }

  $db = new Database();

  // проверяем что получатель существует
  $receiver = $db->fetchOne("SELECT user_id, user_type FROM users WHERE user_id = ?", [$receiverId]);
  if (!$receiver) {
    throw new Exception('Получатель не найден');
  }

  // студент может писать только репетитору и наоборот
  $senderType = $currentUser['user_type'];
  $receiverType = $receiver['user_type'];

  if ($senderType === 'student' && $receiverType !== 'tutor') {
    throw new Exception('Студент может писать только репетитору');
  }
  if ($senderType === 'tutor' && $receiverType !== 'student') {
    throw new Exception('Репетитор может писать только студенту');
  }

  $messageId = $db->insert('chat_messages', [
    'sender_id' => $currentUser['user_id'],
    'receiver_id' => $receiverId,
    'message_text' => $messageText,
    'is_read' => 0,
    'created_at' => date('Y-m-d H:i:s')
  ]);

  echo json_encode([
    'success' => true,
    'message' => 'Сообщение отправлено',
    'data' => ['message_id' => $messageId]
  ], JSON_UNESCAPED_UNICODE);

} catch (Exception $e) {
  http_response_code(400);
  echo json_encode([
    'success' => false,
    'message' => $e->getMessage()
  ], JSON_UNESCAPED_UNICODE);
}
