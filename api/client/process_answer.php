<?php
session_start();
require_once dirname(__DIR__, 3) . '/config.php';

$userClass = new User();
$currentUser = $userClass->getCurrentUser();

if (!$currentUser || $currentUser['user_type'] !== 'student') {
  echo json_encode(['success' => false, 'message' => 'Доступ запрещен']);
  exit;
}

$db = new Database();

$response = ['success' => false, 'message' => 'Неизвестная ошибка'];

try {
  if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    throw new Exception('Только POST запросы разрешены');
  }

  $module_id = (int) ($_POST['module_id'] ?? 0);
  $task_id = (int) ($_POST['task_id'] ?? 0);
  $user_answer = $_POST['answer'] ?? '';

  if (!$module_id || !$task_id) {
    throw new Exception('Неверные данные задания');
  }

  $task = $db->fetchOne(
    "SELECT t.*, m.level_id 
         FROM tasks t
         JOIN modules m ON t.module_id = m.module_id
         WHERE t.task_id = ?",
    [$task_id]
  );

  if (!$task) {
    throw new Exception('Задание не найдено');
  }

  $existing_answer = $db->fetchOne(
    "SELECT answer_id FROM user_answers WHERE user_id = ? AND task_id = ?",
    [$currentUser['user_id'], $task_id]
  );

  if ($existing_answer) {
    throw new Exception('Вы уже отвечали на это задание');
  }

  $is_correct = 0;
  $points_earned = 0;
  $correct_answer = $task['correct_answer'];

  if ($task['task_type'] === 'multiple_choice') {
    $selected_option = $db->fetchOne(
      "SELECT option_text, is_correct FROM task_options WHERE option_id = ? AND task_id = ?",
      [$user_answer, $task_id]
    );

    if ($selected_option) {
      $is_correct = $selected_option['is_correct'];
      $points_earned = $is_correct ? $task['points'] : 0;
      $correct_option = $db->fetchOne(
        "SELECT option_text FROM task_options WHERE task_id = ? AND is_correct = 1 LIMIT 1",
        [$task_id]
      );
      if ($correct_option) {
        $correct_answer = $correct_option['option_text'];
      }
    }
  } elseif ($task['task_type'] === 'fill_blank') {
    $is_correct = (strtolower(trim($user_answer)) === strtolower(trim($task['correct_answer']))) ? 1 : 0;
    $points_earned = $is_correct ? $task['points'] : 0;
  } elseif ($task['task_type'] === 'listening') {
    $has_options = $db->fetchOne("SELECT COUNT(*) as cnt FROM task_options WHERE task_id = ?", [$task_id]);
    if ($has_options['cnt'] > 0) {
      $selected_option = $db->fetchOne(
        "SELECT option_text, is_correct FROM task_options WHERE option_id = ? AND task_id = ?",
        [$user_answer, $task_id]
      );
      if ($selected_option) {
        $is_correct = $selected_option['is_correct'];
        $points_earned = $is_correct ? $task['points'] : 0;
        $correct_option = $db->fetchOne(
          "SELECT option_text FROM task_options WHERE task_id = ? AND is_correct = 1 LIMIT 1",
          [$task_id]
        );
        if ($correct_option) {
          $correct_answer = $correct_option['option_text'];
        }
      }
    } else {
      // без вариантов — засчитываем всегда (факт прослушивания)
      $is_correct = 1;
      $points_earned = $task['points'];
    }
  }

  $answer_id = $db->insert('user_answers', [
    'user_id' => $currentUser['user_id'],
    'task_id' => $task_id,
    'user_answer' => $user_answer,
    'is_correct' => $is_correct,
    'points_earned' => $points_earned,
    'attempt_number' => 1,
    'answered_at' => date('Y-m-d H:i:s')
  ]);

  if (!$answer_id) {
    throw new Exception('Ошибка сохранения ответа');
  }

  $progress = $db->fetchOne(
    "SELECT * FROM user_progress WHERE user_id = ? AND level_id = ?",
    [$currentUser['user_id'], $task['level_id']]
  );

  if ($progress) {
    $new_score = ($progress['current_score'] ?? 0) + $points_earned;
    $new_tasks_completed = ($progress['tasks_completed'] ?? 0) + 1;

    $total_tasks_in_level = $db->fetchOne(
      "SELECT COUNT(*) as total FROM tasks t 
             JOIN modules m ON t.module_id = m.module_id 
             WHERE m.level_id = ? AND t.is_active = 1",
      [$task['level_id']]
    );

    $completion_percentage = $total_tasks_in_level['total'] > 0
      ? round(($new_tasks_completed / $total_tasks_in_level['total']) * 100)
      : 0;

    $status = 'in_progress';
    if ($completion_percentage >= 100) {
      $status = 'completed';
    } elseif ($new_tasks_completed > 0) {
      $status = 'in_progress';
    } else {
      $status = 'not_started';
    }

    $db->update('user_progress', [
      'tasks_completed' => $new_tasks_completed,
      'current_score' => $new_score,
      'completion_percentage' => $completion_percentage,
      'status' => $status,
      'last_activity_date' => date('Y-m-d H:i:s'),
      'updated_at' => date('Y-m-d H:i:s')
    ], 'progress_id = ?', [$progress['progress_id']]);
  }

  // начисляем достижения
  $total_user_tasks = $db->fetchOne(
    "SELECT COUNT(DISTINCT task_id) as cnt FROM user_answers WHERE user_id = ?",
    [$currentUser['user_id']]
  );
  $total_cnt = (int)($total_user_tasks['cnt'] ?? 0);

  // первое задание
  if ($total_cnt === 1) {
    $already = $db->fetchOne(
      "SELECT achievement_id FROM achievements WHERE user_id = ? AND badge_type = 'task_milestone' AND achievement_name = 'Первое задание'",
      [$currentUser['user_id']]
    );
    if (!$already) {
      $db->insert('achievements', [
        'user_id' => $currentUser['user_id'],
        'achievement_name' => 'Первое задание',
        'achievement_description' => 'Вы выполнили своё первое задание!',
        'badge_type' => 'task_milestone',
        'points_awarded' => 25,
        'earned_date' => date('Y-m-d H:i:s')
      ]);
    }
  }

  // 10 заданий
  if ($total_cnt === 10) {
    $already = $db->fetchOne(
      "SELECT achievement_id FROM achievements WHERE user_id = ? AND badge_type = 'task_milestone' AND achievement_name = '10 заданий'",
      [$currentUser['user_id']]
    );
    if (!$already) {
      $db->insert('achievements', [
        'user_id' => $currentUser['user_id'],
        'achievement_name' => '10 заданий',
        'achievement_description' => 'Выполнено 10 заданий. Так держать!',
        'badge_type' => 'task_milestone',
        'points_awarded' => 50,
        'earned_date' => date('Y-m-d H:i:s')
      ]);
    }
  }

  // 50 заданий
  if ($total_cnt === 50) {
    $already = $db->fetchOne(
      "SELECT achievement_id FROM achievements WHERE user_id = ? AND badge_type = 'task_milestone' AND achievement_name = '50 заданий'",
      [$currentUser['user_id']]
    );
    if (!$already) {
      $db->insert('achievements', [
        'user_id' => $currentUser['user_id'],
        'achievement_name' => '50 заданий',
        'achievement_description' => 'Выполнено 50 заданий. Вы настоящий ученик!',
        'badge_type' => 'task_milestone',
        'points_awarded' => 100,
        'earned_date' => date('Y-m-d H:i:s')
      ]);
    }
  }

  // завершение уровня
  if (isset($progress) && $status === 'completed') {
    $already = $db->fetchOne(
      "SELECT achievement_id FROM achievements WHERE user_id = ? AND badge_type = 'level_completed' AND achievement_name LIKE 'Уровень завершён%'",
      [$currentUser['user_id']]
    );
    if (!$already) {
      $level_info = $db->fetchOne("SELECT level_code FROM levels WHERE level_id = ?", [$task['level_id']]);
      $db->insert('achievements', [
        'user_id' => $currentUser['user_id'],
        'achievement_name' => 'Уровень завершён',
        'achievement_description' => 'Вы завершили уровень ' . ($level_info['level_code'] ?? ''),
        'badge_type' => 'level_completed',
        'points_awarded' => 150,
        'earned_date' => date('Y-m-d H:i:s')
      ]);
    }
  }

  $completed_tasks = $db->fetchOne(
    "SELECT COUNT(DISTINCT task_id) as completed_count
         FROM user_answers
         WHERE user_id = ? AND task_id IN (
             SELECT task_id FROM tasks WHERE module_id = ?
         )",
    [$currentUser['user_id'], $module_id]
  );

  $total_tasks_in_module = $db->fetchOne(
    "SELECT COUNT(*) as total FROM tasks WHERE module_id = ? AND is_active = 1",
    [$module_id]
  );

  $module_completed = $completed_tasks['completed_count'] >= $total_tasks_in_module['total'];

  $response = [
    'success' => true,
    'data' => [
      'answer_id' => $answer_id,
      'is_correct' => $is_correct,
      'points_earned' => $points_earned,
      'correct_answer' => $correct_answer,
      'explanation' => $task['explanation'] ?? '',
      'module_completed' => $module_completed,
      'module_id' => $module_id,
      'next_task_available' => !$module_completed
    ]
  ];

} catch (Exception $e) {
  $response = [
    'success' => false,
    'message' => $e->getMessage()
  ];
  http_response_code(400);
}

header('Content-Type: application/json; charset=utf-8');
echo json_encode($response, JSON_UNESCAPED_UNICODE);
?>