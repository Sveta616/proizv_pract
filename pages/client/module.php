<?php
// проверка страницы и модуля
if (!isset($_GET['id'])) {
  header('Location: ?page=learning');
  exit;
}
$module_id = (int) $_GET['id'];

// сброс модуля для перерешивания
if (isset($_POST['reset_module']) && $module_id) {
  $task_ids = $db->fetchAll(
    "SELECT task_id FROM tasks WHERE module_id = ? AND is_active = 1",
    [$module_id]
  );

  if (!empty($task_ids)) {
    $ids = array_column($task_ids, 'task_id');
    $placeholders = implode(',', array_fill(0, count($ids), '?'));

    // считаем баллы и задания которые будем удалять
    $to_subtract = $db->fetchOne(
      "SELECT COUNT(*) as cnt, COALESCE(SUM(points_earned), 0) as pts
       FROM user_answers WHERE user_id = ? AND task_id IN ($placeholders)",
      array_merge([$currentUser['user_id']], $ids)
    );

    // удаляем ответы
    $db->executeQuery(
      "DELETE FROM user_answers WHERE user_id = ? AND task_id IN ($placeholders)",
      array_merge([$currentUser['user_id']], $ids)
    );

    // пересчитываем прогресс уровня
    $module_level = $db->fetchOne("SELECT level_id FROM modules WHERE module_id = ?", [$module_id]);
    if ($module_level) {
      $progress = $db->fetchOne(
        "SELECT * FROM user_progress WHERE user_id = ? AND level_id = ?",
        [$currentUser['user_id'], $module_level['level_id']]
      );
      if ($progress) {
        $new_tasks = max(0, ($progress['tasks_completed'] ?? 0) - ($to_subtract['cnt'] ?? 0));
        $new_score = max(0, ($progress['current_score'] ?? 0) - ($to_subtract['pts'] ?? 0));

        $total_tasks_in_level = $db->fetchOne(
          "SELECT COUNT(*) as total FROM tasks t
           JOIN modules m ON t.module_id = m.module_id
           WHERE m.level_id = ? AND t.is_active = 1",
          [$module_level['level_id']]
        );
        $new_pct = $total_tasks_in_level['total'] > 0
          ? round(($new_tasks / $total_tasks_in_level['total']) * 100)
          : 0;
        $new_status = $new_tasks === 0 ? 'not_started' : ($new_pct >= 100 ? 'completed' : 'in_progress');

        $db->update('user_progress', [
          'tasks_completed' => $new_tasks,
          'current_score' => $new_score,
          'completion_percentage' => $new_pct,
          'status' => $new_status,
          'updated_at' => date('Y-m-d H:i:s')
        ], 'progress_id = ?', [$progress['progress_id']]);
      }
    }
  }

  echo '<script>window.location.href="?page=module&id=' . $module_id . '";</script>';
  exit;
}

$module = $db->fetchOne(
  "SELECT m.*, l.level_id, l.level_code 
     FROM modules m
     JOIN levels l ON m.level_id = l.level_id
     WHERE m.module_id = ? AND m.is_active = 1",
  [$module_id]
);

if (!$module) {
  echo '<div class="student-section">
            <div class="alert alert-error">
                Модуль не найден или недоступен.
            </div>
            <a href="?page=learning" class="btn btn-primary">Вернуться к модулям</a>
          </div>';
  exit;
}

if ($module['level_id'] != $currentUser['current_level_id']) {
  echo '<div class="student-section">
            <div class="alert alert-error">
                Этот модуль не соответствует вашему текущему уровню.
            </div>
            <a href="?page=learning" class="btn btn-primary">Вернуться к модулям</a>
          </div>';
  exit;
}

// Проверка блокировки: предыдущий модуль завершён с < 70%
$prev_module = $db->fetchOne(
  "SELECT module_id, module_name FROM modules
   WHERE level_id = ? AND is_active = 1 AND order_number < ?
   ORDER BY order_number DESC LIMIT 1",
  [$module['level_id'], $module['order_number']]
);

if ($prev_module) {
  $prev_total_tasks = $db->fetchOne(
    "SELECT COUNT(*) as total FROM tasks WHERE module_id = ? AND is_active = 1",
    [$prev_module['module_id']]
  );
  $prev_completed_tasks = $db->fetchOne(
    "SELECT COUNT(DISTINCT task_id) as cnt FROM user_answers WHERE user_id = ? AND task_id IN (SELECT task_id FROM tasks WHERE module_id = ?)",
    [$currentUser['user_id'], $prev_module['module_id']]
  );

  $prev_is_completed = ($prev_completed_tasks['cnt'] ?? 0) >= ($prev_total_tasks['total'] ?? 0) && ($prev_total_tasks['total'] ?? 0) > 0;

  if ($prev_is_completed) {
    $prev_results = $db->fetchOne(
      "SELECT
          COUNT(ua.answer_id) as total_answered,
          SUM(CASE WHEN ua.is_correct = 1 THEN 1 ELSE 0 END) as correct_answers
       FROM user_answers ua
       JOIN tasks t ON ua.task_id = t.task_id
       WHERE ua.user_id = ? AND t.module_id = ?",
      [$currentUser['user_id'], $prev_module['module_id']]
    );

    $prev_pct = 0;
    if ($prev_results && $prev_results['total_answered'] > 0) {
      $prev_pct = round(($prev_results['correct_answers'] / $prev_results['total_answered']) * 100);
    }

    if ($prev_pct < 70) {
      echo '<div class="student-section">
              <div class="alert alert-error">
                  Модуль заблокирован. Предыдущий модуль «' . htmlspecialchars($prev_module['module_name']) . '» завершён с результатом ' . $prev_pct . '%.
                  Для продолжения необходимо набрать минимум 70%. Перерешайте предыдущий модуль.
              </div>
              <div style="display: flex; gap: 10px; margin-top: 15px;">
                  <form method="POST" action="?page=module&id=' . $prev_module['module_id'] . '">
                      <input type="hidden" name="reset_module" value="1">
                      <button type="submit" class="btn btn-primary">Перерешать «' . htmlspecialchars($prev_module['module_name']) . '»</button>
                  </form>
                  <a href="?page=learning" class="btn btn-outline">Вернуться к модулям</a>
              </div>
            </div>';
      exit;
    }
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

$total_tasks = $db->fetchOne(
  "SELECT COUNT(*) as total FROM tasks WHERE module_id = ? AND is_active = 1",
  [$module_id]
);

$is_completed = ($completed_tasks['completed_count'] ?? 0) >= ($total_tasks['total'] ?? 0);

if ($is_completed) {
  include 'module_results.php';
  exit;
}

$show_result = false;
$result_message = '';
$result_class = '';
$last_answer_data = null;

// логика обработки ответов

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['submit_answer'])) {
  $user_answer = $_POST['answer'] ?? '';
  $task_id = (int) ($_POST['task_id'] ?? 0);
  $is_correct = 0;
  $points_earned = 0;

  // если ничего не выбрано
  if (!$task_id) {
    $result_message = 'Ошибка: не указано задание';
    $result_class = 'alert-error';
  } else {
    $current_task = $db->fetchOne(
      "SELECT t.* FROM tasks t WHERE t.task_id = ? AND t.is_active = 1",
      [$task_id]
    );

    // обрабатываем ответ
    if ($current_task) {
      $existing_answer = $db->fetchOne(
        "SELECT answer_id FROM user_answers WHERE user_id = ? AND task_id = ?",
        [$currentUser['user_id'], $task_id]
      );

      if ($existing_answer) {
        $result_message = 'Вы уже отвечали на это задание';
        $result_class = 'alert-warning';
      } else {
        if ($current_task['task_type'] === 'multiple_choice') {
          $selected_option = $db->fetchOne(
            "SELECT option_text, is_correct FROM task_options WHERE option_id = ? AND task_id = ?",
            [$user_answer, $task_id]
          );
          if ($selected_option) {
            $is_correct = $selected_option['is_correct'];
            $points_earned = $is_correct ? $current_task['points'] : 0;
          }
        } elseif ($current_task['task_type'] === 'fill_blank') {
          $is_correct = (strtolower(trim($user_answer)) === strtolower(trim($current_task['correct_answer']))) ? 1 : 0;
          $points_earned = $is_correct ? $current_task['points'] : 0;
        } elseif ($current_task['task_type'] === 'listening') {
          // Аудирование: если есть варианты — проверяем как multiple_choice
          // Если нет вариантов — проверяем текстовый ввод как fill_blank
          $has_options = $db->fetchOne("SELECT COUNT(*) as cnt FROM task_options WHERE task_id = ?", [$task_id]);
          if ($has_options['cnt'] > 0) {
            $selected_option = $db->fetchOne(
              "SELECT option_text, is_correct FROM task_options WHERE option_id = ? AND task_id = ?",
              [$user_answer, $task_id]
            );
            if ($selected_option) {
              $is_correct = $selected_option['is_correct'];
              $points_earned = $is_correct ? $current_task['points'] : 0;
            }
          } else {
            // текстовый / голосовой ввод  сравниваем с правильным ответом
            $is_correct = (strtolower(trim($user_answer)) === strtolower(trim($current_task['correct_answer']))) ? 1 : 0;
            $points_earned = $is_correct ? $current_task['points'] : 0;
          }
        }

        // вставка ответов в бд
        $db->insert('user_answers', [
          'user_id' => $currentUser['user_id'],
          'task_id' => $task_id,
          'user_answer' => $user_answer,
          'is_correct' => $is_correct,
          'points_earned' => $points_earned,
          'attempt_number' => 1,
          'answered_at' => date('Y-m-d H:i:s')
        ]);

        // проверка на прогресс
        $progress = $db->fetchOne(
          "SELECT * FROM user_progress WHERE user_id = ? AND level_id = ?",
          [$currentUser['user_id'], $module['level_id']]
        );

        if ($progress) {
          $new_score = ($progress['current_score'] ?? 0) + $points_earned;
          $new_tasks_completed = ($progress['tasks_completed'] ?? 0) + 1;

          $total_tasks_in_level = $db->fetchOne(
            "SELECT COUNT(*) as total FROM tasks t 
                         JOIN modules m ON t.module_id = m.module_id 
                         WHERE m.level_id = ? AND t.is_active = 1",
            [$module['level_id']]
          );

          $completion_percentage = $total_tasks_in_level['total'] > 0
            ? round(($new_tasks_completed / $total_tasks_in_level['total']) * 100)
            : 0;

          // проверка на статус
          $status = 'in_progress';
          if ($completion_percentage >= 100) {
            $status = 'completed';
          } elseif ($new_tasks_completed > 0) {
            $status = 'in_progress';
          } else {
            $status = 'not_started';
          }

          // обновляем данные
          $db->update('user_progress', [
            'tasks_completed' => $new_tasks_completed,
            'current_score' => $new_score,
            'completion_percentage' => $completion_percentage,
            'status' => $status,
            'last_activity_date' => date('Y-m-d H:i:s'),
            'updated_at' => date('Y-m-d H:i:s')
          ], 'progress_id = ?', [$progress['progress_id']]);

          // --- достижения за выполнение заданий ---
          $milestones = [
            1  => ['name' => 'Первое задание',    'desc' => 'Вы выполнили своё первое задание!',  'points' => 25],
            10 => ['name' => '10 заданий',         'desc' => 'Вы выполнили 10 заданий. Так держать!', 'points' => 50],
            50 => ['name' => '50 заданий',         'desc' => 'Вы выполнили 50 заданий. Впечатляющий результат!', 'points' => 100],
          ];

          // общее кол-во заданий по всем уровням
          $totalAllTasks = $db->fetchOne(
            "SELECT SUM(tasks_completed) as total FROM user_progress WHERE user_id = ?",
            [$currentUser['user_id']]
          );
          $globalCompleted = (int) ($totalAllTasks['total'] ?? 0);

          foreach ($milestones as $threshold => $info) {
            if ($globalCompleted >= $threshold) {
              $exists = $db->fetchOne(
                "SELECT achievement_id FROM achievements WHERE user_id = ? AND badge_type = 'task_milestone' AND achievement_name = ?",
                [$currentUser['user_id'], $info['name']]
              );
              if (!$exists) {
                $db->insert('achievements', [
                  'user_id' => $currentUser['user_id'],
                  'achievement_name' => $info['name'],
                  'achievement_description' => $info['desc'],
                  'badge_type' => 'task_milestone',
                  'points_awarded' => $info['points'],
                  'earned_date' => date('Y-m-d H:i:s')
                ]);
              }
            }
          }

          // --- достижение за завершение уровня ---
          if ($status === 'completed') {
            $levelInfo = $db->fetchOne("SELECT level_code, level_name FROM levels WHERE level_id = ?", [$module['level_id']]);
            $levelLabel = $levelInfo ? $levelInfo['level_code'] . ' - ' . $levelInfo['level_name'] : '';
            $achName = 'Уровень пройден: ' . $levelLabel;

            $exists = $db->fetchOne(
              "SELECT achievement_id FROM achievements WHERE user_id = ? AND badge_type = 'level_completed' AND achievement_name = ?",
              [$currentUser['user_id'], $achName]
            );
            if (!$exists) {
              $db->insert('achievements', [
                'user_id' => $currentUser['user_id'],
                'achievement_name' => $achName,
                'achievement_description' => 'Вы завершили уровень ' . $levelLabel . '!',
                'badge_type' => 'level_completed',
                'points_awarded' => 150,
                'earned_date' => date('Y-m-d H:i:s')
              ]);
            }
          }
        }

        // верные / не верные ответы
        // Для multiple_choice берём текст правильного варианта из task_options
        $correct_answer_text = $current_task['correct_answer'] ?? '';
        if ($current_task['task_type'] === 'multiple_choice') {
          $correct_option = $db->fetchOne(
            "SELECT option_text FROM task_options WHERE task_id = ? AND is_correct = 1 LIMIT 1",
            [$task_id]
          );
          if ($correct_option) {
            $correct_answer_text = $correct_option['option_text'];
          }
        }

        $last_answer_data = [
          'is_correct' => $is_correct,
          'points_earned' => $points_earned,
          'explanation' => $current_task['explanation'] ?? '',
          'correct_answer' => $correct_answer_text
        ];

        $show_result = true;
        $result_class = $is_correct ? 'alert-success' : 'alert-error';
        $result_message = $is_correct
          ? 'Правильно! Вы заработали ' . $points_earned . ' баллов.'
          : 'Неправильно.';
      }
    } else {
      $result_message = 'Задание не найдено';
      $result_class = 'alert-error';
    }
  }
}

$current_task = $db->fetchOne(
  "SELECT t.* 
     FROM tasks t
     LEFT JOIN user_answers ua ON t.task_id = ua.task_id AND ua.user_id = ?
     WHERE t.module_id = ? AND t.is_active = 1 AND ua.answer_id IS NULL
     ORDER BY t.task_id
     LIMIT 1",
  [$currentUser['user_id'], $module_id]
);

if (!$current_task) {
  // session_start();
  $_SESSION['last_completed_module'] = $module_id;

  include 'module_results.php';
  exit;
}

// варианты ответа
$options = $db->fetchAll(
  "SELECT * FROM task_options WHERE task_id = ? ORDER BY order_number",
  [$current_task['task_id']]
);

// номер задания
$task_number = $db->fetchOne(
  "SELECT COUNT(*) as count 
     FROM user_answers ua
     JOIN tasks t ON ua.task_id = t.task_id
     WHERE ua.user_id = ? AND t.module_id = ?",
  [$currentUser['user_id'], $module_id]
);
$current_task_number = ($task_number['count'] ?? 0) + 1;

// Определяем аудирование по task_type
$is_listening = ($current_task['task_type'] === 'listening');
$has_audio_file = !empty($current_task['audio_file']);

// Варианты ответов для listening (если есть)
$listening_has_options = false;
if ($is_listening) {
  $listening_options_check = $db->fetchOne("SELECT COUNT(*) as cnt FROM task_options WHERE task_id = ?", [$current_task['task_id']]);
  $listening_has_options = ($listening_options_check['cnt'] > 0);
  if ($listening_has_options) {
    $options = $db->fetchAll("SELECT * FROM task_options WHERE task_id = ? ORDER BY order_number", [$current_task['task_id']]);
  }
}

// Инструкция к заданию
if ($is_listening) {
  $task_instruction = !empty($current_task['instruction'])
    ? $current_task['instruction']
    : ($listening_has_options
      ? 'Прослушайте аудио и выберите правильный вариант ответа.'
      : 'Прослушайте аудио и введите ответ (или используйте микрофон).');
} else {
  $task_instruction = !empty($current_task['instruction'])
    ? $current_task['instruction']
    : ($current_task['task_type'] === 'fill_blank'
      ? 'Введите ответ в поле ниже.'
      : 'Выберите правильный вариант ответа.');
}
?>

<!-- контент где выводится задание -->
<div class="task-container">
  <div style="margin-bottom: 20px;">
    <a href="?page=learning" style="color: var(--medium-gray); text-decoration: none;">← Назад к модулям</a>
  </div>

  <div class="task-card">
    <div class="task-header">
      <div>
        <h3 class="task-title">Задание <?php echo $current_task_number; ?> из <?php echo $total_tasks['total']; ?></h3>
        <div style="color: var(--medium-gray); font-size: 14px; margin-top: 5px;">
          Модуль: <?php echo htmlspecialchars($module['module_name']); ?>
        </div>
      </div>
      <div class="task-meta">
        <span class="task-points">+<?php echo $current_task['points']; ?> баллов</span>
        <span><?php echo $current_task['difficulty_level']; ?></span>
      </div>
    </div>

    <!-- вывод результатов предыдушего ответа -->
    <?php if ($show_result && $last_answer_data): ?>
      <div class="alert <?php echo $result_class; ?>" style="margin-bottom: 25px;">
        <?php echo $result_message; ?>
        <?php if (!$last_answer_data['is_correct']): ?>
          <div style="margin-top: 10px;">
            <strong>Правильный ответ:</strong> <?php echo htmlspecialchars($last_answer_data['correct_answer']); ?>
          </div>
        <?php endif; ?>
        <?php if ($last_answer_data['explanation']): ?>
          <div style="margin-top: 10px;">
            <strong>Объяснение:</strong> <?php echo htmlspecialchars($last_answer_data['explanation']); ?>
          </div>
        <?php endif; ?>
      </div>
    <?php endif; ?>

    <!-- Инструкция к заданию -->
    <div style="background: #f0f4ff; border-left: 4px solid var(--blue-dark, #1a3a6b); border-radius: 6px; padding: 12px 16px; margin-bottom: 20px; font-size: 14px; color: #2d4a7a;">
      <strong>Что нужно сделать:</strong> <?php echo htmlspecialchars($task_instruction); ?>
    </div>

    <?php if ($is_listening): ?>

      <div style="margin-bottom: 20px; padding: 16px; background: #f0f4ff; border-radius: 10px;">
        <audio id="taskAudio" controls style="width: 100%; border-radius: 8px;">
          <source src="../../uploads/audio/<?php echo htmlspecialchars($current_task['audio_file']); ?>">
        </audio>
      </div>
      <div class="task-question">
        <?php echo nl2br(htmlspecialchars($current_task['task_text'])); ?>
      </div>

    <?php else: ?>
      <div class="task-question">
        <?php echo nl2br(htmlspecialchars($current_task['task_text'])); ?>
      </div>
    <?php endif; ?>

    <form method="POST" id="taskForm">
      <input type="hidden" name="submit_answer" value="1">
      <input type="hidden" name="task_id" value="<?php echo $current_task['task_id']; ?>">

      <?php if ($current_task['task_type'] === 'multiple_choice'): ?>
        <div class="task-options">
          <?php foreach ($options as $option): ?>
            <label class="task-option" for="option_<?php echo $option['option_id']; ?>">
              <input type="radio" name="answer" id="option_<?php echo $option['option_id']; ?>"
                value="<?php echo $option['option_id']; ?>" required>
              <span class="option-radio"></span>
              <span class="option-text"><?php echo htmlspecialchars($option['option_text']); ?></span>
            </label>
          <?php endforeach; ?>
        </div>

      <?php elseif ($current_task['task_type'] === 'fill_blank'): ?>
        <div style="margin-bottom: 25px;">
          <input type="text" name="answer" class="form-control" placeholder="Введите ответ" required
            value="" style="font-size: 16px; padding: 15px;">
        </div>

      <?php elseif ($current_task['task_type'] === 'listening'): ?>
        <?php if ($listening_has_options): ?>
          <!-- Аудирование с вариантами ответа -->
          <div class="task-options">
            <?php foreach ($options as $option): ?>
              <label class="task-option" for="option_<?php echo $option['option_id']; ?>">
                <input type="radio" name="answer" id="option_<?php echo $option['option_id']; ?>"
                  value="<?php echo $option['option_id']; ?>" required>
                <span class="option-radio"></span>
                <span class="option-text"><?php echo htmlspecialchars($option['option_text']); ?></span>
              </label>
            <?php endforeach; ?>
          </div>
        <?php else: ?>
          <!-- Аудирование со свободным / голосовым вводом -->
          <div class="listening-answer-group" style="margin-bottom: 25px;">
            <input type="text" name="answer" id="listeningAnswer" class="form-control"
              placeholder="Введите ответ или нажмите на микрофон..."
              value="" style="font-size: 16px; padding: 15px;">
            <button type="button" class="btn-mic" onclick="voiceInput()" id="btnMic" title="Голосовой ввод">
              &#127908;
            </button>
          </div>
        <?php endif; ?>
      <?php endif; ?>

      <div class="task-navigation">
        <div class="task-progress">
          <span>Прогресс модуля:</span>
          <div class="task-progress-bar">
            <div class="task-progress-fill"
              style="width: <?php echo round((($current_task_number - 1) / $total_tasks['total']) * 100); ?>%"></div>
          </div>
          <span><?php echo round((($current_task_number - 1) / $total_tasks['total']) * 100); ?>%</span>
        </div>

        <button type="submit" class="btn btn-primary" id="submitBtn">
          <?php echo ($current_task_number == $total_tasks['total']) ? 'Завершить модуль' : 'Следующее задание'; ?>
        </button>
      </div>
    </form>
  </div>

  <div style="text-align: center; margin-top: 20px; color: var(--medium-gray);">
    <small>Задание можно выполнить только один раз. Ответы нельзя изменить после отправки.</small>
  </div>
</div>

<script>
  // считывание выбора варианта ответа
  document.addEventListener('DOMContentLoaded', function () {
    const options = document.querySelectorAll('.task-option');
    options.forEach(option => {
      option.addEventListener('click', function () {

        options.forEach(opt => {
          opt.classList.remove('selected');
          const radio = opt.querySelector('input[type="radio"]');
          if (radio) radio.checked = false;
        });

        this.classList.add('selected');
        const radio = this.querySelector('input[type="radio"]');
        if (radio) radio.checked = true;
      });
    });

    const selectedRadio = document.querySelector('input[name="answer"]:checked');
    if (selectedRadio) {
      selectedRadio.closest('.task-option').classList.add('selected');
    }
  });

  // Голосовой ввод ответа
  function voiceInput() {
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
    if (!SpeechRecognition) {
      alert('Ваш браузер не поддерживает голосовой ввод. Используйте Chrome или Edge.');
      return;
    }

    const btn = document.getElementById('btnMic');
    const input = document.getElementById('listeningAnswer');

    const recognition = new SpeechRecognition();
    recognition.lang = 'en-US';
    recognition.interimResults = false;
    recognition.maxAlternatives = 1;

    btn.innerHTML = '&#128308;';
    btn.disabled = true;
    btn.classList.add('recording');

    recognition.onresult = function(e) {
      input.value = e.results[0][0].transcript;
    };

    recognition.onend = function() {
      btn.innerHTML = '&#127908;';
      btn.disabled = false;
      btn.classList.remove('recording');
    };

    recognition.onerror = function(e) {
      btn.innerHTML = '&#127908;';
      btn.disabled = false;
      btn.classList.remove('recording');
      if (e.error === 'not-allowed') {
        alert('Доступ к микрофону запрещён. Разрешите доступ в настройках браузера.');
      }
    };

    recognition.start();
  }

</script>