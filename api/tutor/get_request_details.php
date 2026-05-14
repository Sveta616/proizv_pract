<?php
require_once '../../config.php';

header('Content-Type: application/json; charset=utf-8');

$response = ['success' => false, 'request' => null];

try {
  if (!isset($_GET['id'])) {
    throw new Exception('ID заявки не указан');
  }

  $request_id = (int) $_GET['id'];

  $user = new User();
  $currentUser = $user->getCurrentUser();

  if (!$currentUser || $currentUser['user_type'] !== 'tutor') {
    throw new Exception('Доступ запрещен');
  }

  $db = new Database();
  $tutor = $db->fetchOne(
    "SELECT tutor_id FROM tutors WHERE user_id = ?",
    [$currentUser['user_id']]
  );

  if (!$tutor) {
    throw new Exception('Репетитор не найден');
  }

  $request = $db->fetchOne(
    "SELECT tr.*, u.full_name as student_name, u.email as student_email, 
                c.city_name as student_city
         FROM tutor_requests tr 
         LEFT JOIN users u ON tr.student_id = u.user_id 
         LEFT JOIN cities c ON u.city_id = c.city_id 
         WHERE tr.request_id = ? AND tr.tutor_id = ?",
    [$request_id, $tutor['tutor_id']]
  );

  if (!$request) {
    throw new Exception('Заявка не найдена');
  }

  $student_id = $request['student_id'];

  $student_level = $db->fetchOne(
    "SELECT l.level_code, l.level_name, u.current_level_id
     FROM users u
     JOIN levels l ON u.current_level_id = l.level_id
     WHERE u.user_id = ?",
    [$student_id]
  );

  $modules_detail = $db->fetchAll(
    "SELECT m.module_id, m.module_name, m.module_type, m.order_number,
            COUNT(DISTINCT t.task_id) as total_tasks,
            COUNT(DISTINCT ua.task_id) as done_tasks,
            COALESCE(SUM(t.points), 0) as max_points,
            COALESCE(SUM(ua.points_earned), 0) as earned_points,
            SUM(CASE WHEN ua.is_correct = 1 THEN 1 ELSE 0 END) as correct_answers,
            COUNT(ua.answer_id) as total_answers
     FROM modules m
     LEFT JOIN tasks t ON m.module_id = t.module_id AND t.is_active = 1
     LEFT JOIN user_answers ua ON t.task_id = ua.task_id AND ua.user_id = ?
     WHERE m.level_id = ? AND m.is_active = 1
     GROUP BY m.module_id, m.module_name, m.module_type, m.order_number
     ORDER BY m.order_number",
    [$student_id, $student_level['current_level_id'] ?? 1]
  );

  $modules_list = [];
  $completed_modules = 0;
  foreach ($modules_detail as $md) {
    $is_done = $md['total_tasks'] > 0 && $md['done_tasks'] >= $md['total_tasks'];
    if ($is_done) $completed_modules++;
    $correct_pct = $md['total_answers'] > 0 ? round(($md['correct_answers'] / $md['total_answers']) * 100) : 0;

    $type_label = match($md['module_type']) {
      'grammar' => 'Грамматика',
      'vocabulary' => 'Словарь',
      'reading' => 'Чтение',
      'listening' => 'Аудирование',
      default => $md['module_type']
    };

    $status = 'not_started';
    if ($md['done_tasks'] > 0) {
      $status = $is_done ? 'completed' : 'in_progress';
    }

    $modules_list[] = [
      'name' => $md['module_name'],
      'type' => $type_label,
      'status' => $status,
      'done_tasks' => (int)$md['done_tasks'],
      'total_tasks' => (int)$md['total_tasks'],
      'earned_points' => (int)$md['earned_points'],
      'max_points' => (int)$md['max_points'],
      'correct_pct' => $correct_pct
    ];
  }

  $recent_activity = $db->fetchOne(
    "SELECT answered_at FROM user_answers WHERE user_id = ? ORDER BY answered_at DESC LIMIT 1",
    [$student_id]
  );

  $response = [
    'success' => true,
    'request' => $request,
    'progress' => [
      'level_code' => $student_level['level_code'] ?? null,
      'level_name' => $student_level['level_name'] ?? null,
      'modules' => $modules_list,
      'modules_completed' => $completed_modules,
      'total_modules' => count($modules_detail),
      'last_activity' => $recent_activity['answered_at'] ?? null
    ]
  ];

} catch (Exception $e) {
  $response['error'] = $e->getMessage();
  http_response_code(400);
}

echo json_encode($response, JSON_UNESCAPED_UNICODE);
?>