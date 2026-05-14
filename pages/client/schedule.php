<?php

// Недельный календарь
$week_offset = (int)($_GET['week'] ?? 0);
$today_cal = new DateTime();

$week_start = clone $today_cal;
$week_start->modify("monday this week");
if ($week_offset !== 0) {
    $week_start->modify("{$week_offset} weeks");
}
$week_end = clone $week_start;
$week_end->modify('+6 days')->setTime(23, 59, 59);

$days_ru_cal = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

// получаем расписание
$requests = $db->fetchAll(
  "SELECT tr.*,
            t.tutor_id,
            t.full_name as tutor_name,
            t.rating as tutor_rating,
            t.total_reviews,
            c.city_name,
            ts.name as specialization_name
     FROM tutor_requests tr
     JOIN tutors t ON tr.tutor_id = t.tutor_id
     LEFT JOIN cities c ON t.city_id = c.city_id
     LEFT JOIN tutor_specializations ts ON t.specialization_id = ts.specialization_id
     WHERE tr.student_id = ?
     ORDER BY COALESCE(tr.lesson_date, tr.request_date) DESC",
  [$currentUser['user_id']]
);

$message = '';

// логика выставления оценки
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['submit_rating'])) {
  $request_id = (int) ($_POST['request_id'] ?? 0);
  $rating = (int) ($_POST['rating'] ?? 0);
  $review_text = trim($_POST['review_text'] ?? '');

  $existing_request = $db->fetchOne(
    "SELECT * FROM tutor_requests WHERE request_id = ? AND student_id = ?",
    [$request_id, $currentUser['user_id']]
  );

  if ($existing_request && $existing_request['status'] === 'completed' && !$existing_request['is_rated']) {
    if ($rating >= 1 && $rating <= 5) {
      $tutor_data = $db->fetchOne(
        "SELECT rating, total_reviews FROM tutors WHERE tutor_id = ?",
        [$existing_request['tutor_id']]
      );

      if ($tutor_data) {
        $current_rating = (float) $tutor_data['rating'];
        $total_reviews = (int) $tutor_data['total_reviews'];

        // корректный расчет среднего рейтинга
        if ($total_reviews > 0) {
          $new_rating = ($current_rating * $total_reviews + $rating) / ($total_reviews + 1);
        } else {
          $new_rating = $rating;
        }
        $new_total_reviews = $total_reviews + 1;

        // обновляем рейтинг репетитора
        $db->update('tutors', [
          'rating' => round($new_rating, 2),
          'total_reviews' => $new_total_reviews,
          'updated_at' => date('Y-m-d H:i:s')
        ], 'tutor_id = ?', [$existing_request['tutor_id']]);

        // обновляем заявку: оценка, текст отзыва
        $db->update('tutor_requests', [
          'is_rated' => 1,
          'rating_value' => $rating,
          'review_text' => $review_text ?: null,
          'response_date' => date('Y-m-d H:i:s')
        ], 'request_id = ?', [$request_id]);

        $message = '<div class="alert alert-success">Отзыв отправлен!</div>';

        // обновляем данные
        foreach ($requests as &$req) {
          if ($req['request_id'] == $request_id) {
            $req['tutor_rating'] = $new_rating;
            $req['total_reviews'] = $new_total_reviews;
            $req['is_rated'] = 1;
            $req['rating_value'] = $rating;
            $req['review_text'] = $review_text ?: null;
            $req['response_date'] = date('Y-m-d H:i:s');
          }
        }
      }
    } else {
      $message = '<div class="alert alert-error">Выберите оценку от 1 до 5.</div>';
    }
  } else {
    $message = '<div class="alert alert-error">Нельзя оценить эту заявку.</div>';
  }
}

// фильтры
$status_filter = $_GET['status'] ?? 'all';
$filtered_requests = [];

foreach ($requests as $request) {
  if ($status_filter === 'all' || $request['status'] === $status_filter) {
    $filtered_requests[] = $request;
  }
}

// кол-во типов заявок
$status_stats = [
  'pending' => 0,
  'accepted' => 0,
  'completed' => 0,
  'rejected' => 0,
  'all' => count($requests)
];

foreach ($requests as $request) {
  if (isset($status_stats[$request['status']])) {
    $status_stats[$request['status']]++;
  }
}

// Группируем accepted заявки с датами по дням недели
$week_days_cal = [];
for ($i = 0; $i < 7; $i++) {
    $day = clone $week_start;
    $day->modify("+{$i} days");
    $day_key = $day->format('Y-m-d');
    $week_days_cal[$day_key] = [
        'date' => $day,
        'short' => $days_ru_cal[$i],
        'lessons' => [],
        'is_today' => $day->format('Y-m-d') === $today_cal->format('Y-m-d'),
        'is_past' => $day < $today_cal && $day->format('Y-m-d') !== $today_cal->format('Y-m-d')
    ];
}

$week_lesson_count = 0;
foreach ($requests as $req) {
    if ($req['status'] === 'accepted' && !empty($req['lesson_date'])) {
        $ld = new DateTime($req['lesson_date']);
        if ($ld >= $week_start && $ld <= $week_end) {
            $dk = $ld->format('Y-m-d');
            if (isset($week_days_cal[$dk])) {
                $week_days_cal[$dk]['lessons'][] = $req;
                $week_lesson_count++;
            }
        }
    }
}
?>

<div class="student-section">
  <h2>Мои занятия</h2>

  <?php echo $message; ?>

  <!-- Статистика -->
  <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap: 12px; margin-bottom: 25px;">
    <div style="padding: 16px; border-radius: 10px; text-align: center; background: rgba(52,152,219,0.1);">
      <div style="font-size: 28px; font-weight: bold; color: #3498db;"><?php echo $week_lesson_count; ?></div>
      <div style="font-size: 13px; color: #3498db;">На этой неделе</div>
    </div>
    <div style="padding: 16px; border-radius: 10px; text-align: center; background: rgba(46,213,115,0.1);">
      <div style="font-size: 28px; font-weight: bold; color: #2ed573;"><?php echo $status_stats['accepted']; ?></div>
      <div style="font-size: 13px; color: #2ed573;">Подтверждено</div>
    </div>
    <div style="padding: 16px; border-radius: 10px; text-align: center; background: rgba(255,193,7,0.1);">
      <div style="font-size: 28px; font-weight: bold; color: #e67e22;"><?php echo $status_stats['pending']; ?></div>
      <div style="font-size: 13px; color: #e67e22;">Ожидание</div>
    </div>
    <div style="padding: 16px; border-radius: 10px; text-align: center; background: rgba(155,89,182,0.1);">
      <div style="font-size: 28px; font-weight: bold; color: #9b59b6;"><?php echo $status_stats['completed']; ?></div>
      <div style="font-size: 13px; color: #9b59b6;">Завершено</div>
    </div>
  </div>

  <!-- Навигация по неделям -->
  <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; flex-wrap: wrap; gap: 10px;">
    <a href="?page=schedule&status=<?php echo $status_filter; ?>&week=<?php echo $week_offset - 1; ?>" class="btn btn-outline" style="padding: 8px 16px;">← Пред. неделя</a>
    <div style="text-align: center;">
      <div style="font-size: 18px; font-weight: 700; color: var(--dark-blue);">
        <?php echo $week_start->format('d.m') . ' — ' . $week_end->format('d.m.Y'); ?>
      </div>
      <?php if ($week_offset !== 0): ?>
        <a href="?page=schedule&status=<?php echo $status_filter; ?>&week=0" style="font-size: 13px; color: var(--primary-red);">Вернуться к текущей неделе</a>
      <?php else: ?>
        <span style="font-size: 13px; color: var(--medium-gray);">Текущая неделя</span>
      <?php endif; ?>
    </div>
    <a href="?page=schedule&status=<?php echo $status_filter; ?>&week=<?php echo $week_offset + 1; ?>" class="btn btn-outline" style="padding: 8px 16px;">След. неделя →</a>
  </div>

  <!-- Сетка недели -->
  <div style="display: grid; grid-template-columns: repeat(7, 1fr); gap: 8px; margin-bottom: 30px;">
    <?php foreach ($week_days_cal as $day_key => $day): ?>
      <div style="background: white; border-radius: 10px; border: 2px solid <?php echo $day['is_today'] ? 'var(--primary-red)' : (!empty($day['lessons']) ? 'var(--dark-blue)' : 'var(--light-gray)'); ?>; min-height: 120px; padding: 10px; <?php echo $day['is_past'] ? 'opacity: 0.6;' : ''; ?> <?php echo $day['is_today'] ? 'background: rgba(217,4,41,0.02);' : ''; ?>">
        <div style="text-align: center; padding-bottom: 8px; border-bottom: 1px solid var(--light-gray); margin-bottom: 8px;">
          <div style="font-size: 12px; font-weight: 700; color: var(--medium-gray); text-transform: uppercase;"><?php echo $day['short']; ?></div>
          <div style="font-size: 20px; font-weight: 700; color: <?php echo $day['is_today'] ? 'var(--primary-red)' : 'var(--dark-blue)'; ?>;"><?php echo $day['date']->format('d'); ?></div>
        </div>
        <?php if (!empty($day['lessons'])): ?>
          <?php foreach ($day['lessons'] as $dl):
            $dlt = new DateTime($dl['lesson_date']);
          ?>
            <div style="background: var(--light-gray); border-radius: 6px; padding: 6px 8px; margin-bottom: 4px; font-size: 12px;">
              <div style="font-weight: 700; color: var(--dark-blue);"><?php echo $dlt->format('H:i'); ?></div>
              <div style="color: var(--medium-gray); white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><?php echo htmlspecialchars($dl['tutor_name']); ?></div>
            </div>
          <?php endforeach; ?>
        <?php else: ?>
          <div style="text-align: center; color: var(--medium-gray); font-size: 12px; padding: 10px 0;">—</div>
        <?php endif; ?>
      </div>
    <?php endforeach; ?>
  </div>

  <!-- фильтры по статусу -->
  <div style="margin-bottom: 25px;">
    <div style="display: flex; gap: 10px; flex-wrap: wrap;">
      <a href="?page=schedule&status=all"
        style="background: var(--dark-blue); color: white; padding: 8px 16px; border-radius: 20px; text-decoration: none; font-size: 14px; font-weight: 600;"
        class="<?php echo $status_filter === 'all' ? 'active' : ''; ?>">
        Все (<?php echo $status_stats['all']; ?>)
      </a>
      <a href="?page=schedule&status=pending"
        style="background: #ffc107; color: #333; padding: 8px 16px; border-radius: 20px; text-decoration: none; font-size: 14px; font-weight: 600;"
        class="<?php echo $status_filter === 'pending' ? 'active' : ''; ?>">
        Ожидание (<?php echo $status_stats['pending']; ?>)
      </a>
      <a href="?page=schedule&status=accepted"
        style="background: #4cc9f0; color: white; padding: 8px 16px; border-radius: 20px; text-decoration: none; font-size: 14px; font-weight: 600;"
        class="<?php echo $status_filter === 'accepted' ? 'active' : ''; ?>">
        Подтверждено (<?php echo $status_stats['accepted']; ?>)
      </a>
      <a href="?page=schedule&status=completed"
        style="background: #2ed573; color: white; padding: 8px 16px; border-radius: 20px; text-decoration: none; font-size: 14px; font-weight: 600;"
        class="<?php echo $status_filter === 'completed' ? 'active' : ''; ?>">
        Завершено (<?php echo $status_stats['completed']; ?>)
      </a>
      <a href="?page=schedule&status=rejected"
        style="background: var(--primary-red); color: white; padding: 8px 16px; border-radius: 20px; text-decoration: none; font-size: 14px; font-weight: 600;"
        class="<?php echo $status_filter === 'rejected' ? 'active' : ''; ?>">
        Отклонено (<?php echo $status_stats['rejected']; ?>)
      </a>
    </div>
  </div>

  <?php if (empty($filtered_requests)): ?>
    <div style="text-align: center; padding: 50px 20px;">
      <div style="font-size: 48px; color: var(--medium-gray); margin-bottom: 20px;">📅</div>
      <h3 style="color: var(--dark-blue); margin-bottom: 10px;">Занятий пока нет</h3>
      <p style="color: var(--medium-gray); margin-bottom: 30px;">
        У вас пока нет запланированных занятий с репетиторами.
      </p>
      <a href="?page=tutors" class="btn btn-primary">Найти репетитора</a>
    </div>
  <?php else: ?>
    <div>
      <?php foreach ($filtered_requests as $request): ?>
        <?php
        $status_colors = [
          'pending' => '#ffc107',
          'accepted' => '#4cc9f0',
          'completed' => '#2ed573',
          'rejected' => '#d90429'
        ];

        $status_labels = [
          'pending' => 'Ожидание',
          'accepted' => 'Подтверждено',
          'completed' => 'Завершено',
          'rejected' => 'Отклонено'
        ];

        $status_color = $status_colors[$request['status']] ?? '#8d99ae';
        $status_label = $status_labels[$request['status']] ?? $request['status'];

        $has_rated = $request['status'] === 'completed' && $request['is_rated'];
        ?>
        <!-- вывод заявок, внутри логика обработки и вывод в зависимости от статуса и действий пользователя -->
        <div
          style="background: white; border-radius: 10px; padding: 20px; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); border-left: 4px solid <?php echo $status_color; ?>;">
          <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 15px;">
            <div>
              <h4 style="margin: 0; color: var(--dark-blue);">
                <?php echo htmlspecialchars($request['tutor_name']); ?>
              </h4>
              <div style="display: flex; align-items: center; gap: 10px; margin-top: 5px;">
                <span
                  style="background: <?php echo $status_color; ?>; color: white; padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: 600;">
                  <?php echo $status_label; ?>
                </span>
                <?php if (!empty($request['lesson_date'])): ?>
                  <?php
                    $lesson_start = new DateTime($request['lesson_date']);
                    $lesson_end = clone $lesson_start;
                    $lesson_end->modify('+' . ($request['lesson_duration'] ?? 60) . ' minutes');
                    $now_check = new DateTime();
                    $is_lesson_now = ($request['status'] === 'accepted' && $lesson_start <= $now_check && $lesson_end > $now_check);
                    $is_lesson_soon = ($request['status'] === 'accepted' && !$is_lesson_now && $lesson_start > $now_check && $lesson_start->diff($now_check)->days === 0 && $lesson_start->diff($now_check)->h < 1);
                  ?>
                  <?php if ($is_lesson_now): ?>
                    <span style="background: #d90429; color: white; padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: 700; animation: client-pulse 2s infinite;">
                      Идёт сейчас
                    </span>
                  <?php elseif ($is_lesson_soon): ?>
                    <span style="background: #e67e22; color: white; padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: 600;">
                      Скоро начнётся
                    </span>
                  <?php endif; ?>
                  <span style="color: var(--dark-blue); font-size: 14px; font-weight: 600;">
                    <?php echo date('d.m.Y H:i', strtotime($request['lesson_date'])); ?>
                    — <?php echo $lesson_end->format('H:i'); ?>
                    (<?php echo $request['lesson_duration'] ?? 60; ?> мин.)
                  </span>
                <?php else: ?>
                  <span style="color: var(--medium-gray); font-size: 14px;">
                    Заявка: <?php echo date('d.m.Y H:i', strtotime($request['request_date'])); ?>
                  </span>
                <?php endif; ?>
              </div>
            </div>

            <div style="text-align: center; min-width: 100px;">
              <?php if ($request['total_reviews'] > 0): ?>
                <div style="display: flex; align-items: center; justify-content: center; gap: 6px;">
                  <span style="color: #ffc107; font-size: 18px;">
                    <?php
                    $full_stars = floor($request['tutor_rating']);
                    $half_star = ($request['tutor_rating'] - $full_stars) >= 0.5;
                    $empty_stars = 5 - $full_stars - ($half_star ? 1 : 0);

                    echo str_repeat('★', $full_stars);
                    echo $half_star ? '☆' : '';
                    echo str_repeat('☆', $empty_stars);
                    ?>
                  </span>
                  <span style="font-size: 18px; font-weight: bold; color: var(--dark-blue);">
                    <?php echo number_format($request['tutor_rating'], 1); ?>
                  </span>
                </div>
                <div style="color: var(--medium-gray); font-size: 12px;">
                  <?php echo $request['total_reviews']; ?> отзывов
                </div>
              <?php else: ?>
                <div style="color: var(--medium-gray); font-size: 14px;">Нет оценок</div>
              <?php endif; ?>
            </div>
          </div>

          <div style="margin: 15px 0;">
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px;">
              <?php if ($request['city_name']): ?>
                <div>
                  <strong>Город:</strong> <?php echo htmlspecialchars($request['city_name']); ?>
                </div>
              <?php endif; ?>

              <?php if ($request['specialization_name']): ?>
                <div>
                  <strong>Специализация:</strong> <?php echo htmlspecialchars($request['specialization_name']); ?>
                </div>
              <?php endif; ?>

              <?php if ($request['status'] === 'completed' && !empty($request['actual_duration'])): ?>
                <?php
                  $client_planned = $request['lesson_duration'] ?? 60;
                  $client_actual = (int)$request['actual_duration'];
                  $client_fmt = function($min) {
                      if ($min < 60) return $min . ' мин.';
                      $h = floor($min / 60); $m = $min % 60;
                      return $h . ' ч.' . ($m > 0 ? ' ' . $m . ' мин.' : '');
                  };
                ?>
                <div>
                  <strong>Длительность урока:</strong>
                  <span style="font-weight: 700; color: <?php echo $client_actual < $client_planned ? '#e67e22' : '#2ed573'; ?>;">
                    <?php echo $client_fmt($client_actual); ?>
                  </span>
                  <span style="color: var(--medium-gray); font-size: 13px;">
                    из <?php echo $client_fmt($client_planned); ?>
                    <?php if ($client_actual < $client_planned): ?>
                      (завершено досрочно)
                    <?php elseif ($client_actual > $client_planned): ?>
                      (переработка)
                    <?php endif; ?>
                  </span>
                </div>
              <?php elseif ($request['status'] === 'completed' && !empty($request['lesson_duration'])): ?>
                <div>
                  <strong>Плановая длительность:</strong>
                  <?php echo ($request['lesson_duration'] ?? 60); ?> мин.
                </div>
              <?php endif; ?>

              <?php if ($request['status'] === 'accepted' && !empty($request['lesson_date'])):
                $client_ls = new DateTime($request['lesson_date']);
                $client_le = clone $client_ls;
                $client_le->modify('+' . ($request['lesson_duration'] ?? 60) . ' minutes');
                $client_now = new DateTime();
                $client_is_now = ($client_ls <= $client_now && $client_le > $client_now);
                if ($client_is_now):
                    $client_elapsed = (int)round(($client_now->getTimestamp() - $client_ls->getTimestamp()) / 60);
              ?>
                <div>
                  <strong>Прошло:</strong>
                  <span class="client-live-timer" data-start="<?php echo $client_ls->getTimestamp(); ?>" style="font-weight: 700; color: var(--dark-blue);">
                    <?php echo $client_elapsed; ?> мин.
                  </span>
                  <span style="color: var(--medium-gray); font-size: 13px;">из <?php echo $request['lesson_duration'] ?? 60; ?> мин.</span>
                </div>
              <?php endif; endif; ?>
            </div>

            <?php if ($request['request_text']): ?>
              <div style="margin-top: 15px; padding: 15px; background: var(--light-gray); border-radius: 5px;">
                <strong>Ваше сообщение:</strong>
                <p style="margin: 5px 0 0 0;"><?php echo nl2br(htmlspecialchars($request['request_text'])); ?></p>
              </div>
            <?php endif; ?>
          </div>

          <?php if ($request['status'] === 'completed' && !$has_rated): ?>
            <div style="margin-top: 20px; padding-top: 20px; border-top: 1px solid var(--light-gray);">
              <h5 style="color: var(--dark-blue); margin-bottom: 15px;">Оцените занятие</h5>
              <form method="POST">
                <input type="hidden" name="request_id" value="<?php echo $request['request_id']; ?>">

                <div style="margin-bottom: 15px;">
                  <div style="margin-bottom: 8px; color: var(--dark-blue); font-weight: 600;">
                    Оценка (1-5 звезд):
                  </div>
                  <div style="display: flex; gap: 5px;">
                    <?php for ($i = 1; $i <= 5; $i++): ?>
                      <label style="cursor: pointer; font-size: 24px; color: #e4e5e9;">
                        <input type="radio" name="rating" value="<?php echo $i; ?>" required style="display: none;">
                        <span class="star">☆</span>
                      </label>
                    <?php endfor; ?>
                  </div>
                </div>

                <div style="margin-bottom: 15px;">
                  <div style="margin-bottom: 8px; color: var(--dark-blue); font-weight: 600;">
                    Отзыв:
                  </div>
                  <textarea name="review_text" class="form-control" rows="3"
                    placeholder="Напишите отзыв о занятии (необязательно)"
                    style="width: 100%; padding: 10px; border: 2px solid var(--medium-gray); border-radius: 6px; font-size: 14px; resize: vertical;"></textarea>
                </div>

                <button type="submit" name="submit_rating" class="btn btn-primary">
                  Отправить отзыв
                </button>
              </form>
            </div>

          <?php elseif ($has_rated): ?>
            <div style="margin-top: 20px; padding: 15px; background: rgba(46, 213, 115, 0.1); border-radius: 5px;">
              <div style="color: var(--dark-blue); font-weight: 600;">
                Ваш отзыв
                <?php if ($request['rating_value']): ?>
                  — <span style="color: #ffc107;"><?php echo str_repeat('★', $request['rating_value']); ?><?php echo str_repeat('☆', 5 - $request['rating_value']); ?></span>
                <?php endif; ?>
              </div>
              <?php if (!empty($request['review_text'])): ?>
                <div style="color: var(--dark-blue); margin-top: 8px; font-style: italic;">
                  "<?php echo nl2br(htmlspecialchars($request['review_text'])); ?>"
                </div>
              <?php endif; ?>
              <div style="color: var(--medium-gray); font-size: 12px; margin-top: 8px;">
                Отправлено: <?php echo date('d.m.Y H:i', strtotime($request['response_date'])); ?>
              </div>
            </div>
          <?php endif; ?>
        </div>
      <?php endforeach; ?>
    </div>
  <?php endif; ?>
</div>

<style>
@keyframes client-pulse {
    0%, 100% { box-shadow: 0 0 0 0 rgba(217, 4, 41, 0.4); }
    50% { box-shadow: 0 0 0 8px rgba(217, 4, 41, 0); }
}
@media (max-width: 900px) {
    .student-section > div[style*="grid-template-columns: repeat(7"] {
        grid-template-columns: repeat(3, 1fr) !important;
    }
}
</style>

<script>
function updateClientTimers() {
    document.querySelectorAll('.client-live-timer').forEach(el => {
        const start = parseInt(el.dataset.start);
        const now = Math.floor(Date.now() / 1000);
        const elapsed = Math.floor((now - start) / 60);
        if (elapsed < 60) {
            el.textContent = elapsed + ' мин.';
        } else {
            const h = Math.floor(elapsed / 60);
            const m = elapsed % 60;
            el.textContent = h + ' ч.' + (m > 0 ? ' ' + m + ' мин.' : '');
        }
    });
}
setInterval(updateClientTimers, 15000);
</script>

<script>
  document.addEventListener('DOMContentLoaded', function () {
    // обработка звезд рейтинга
    document.querySelectorAll('form').forEach(form => {
      const stars = form.querySelectorAll('.star');
      const radios = form.querySelectorAll('input[type="radio"]');

      stars.forEach((star, index) => {
        star.addEventListener('click', function () {
          // выбираем радио-кнопку
          radios[index].checked = true;

          // подсвечиваем звезды
          stars.forEach((s, i) => {
            s.style.color = i <= index ? '#ffc107' : '#e4e5e9';
          });
        });

        // при наведении
        star.addEventListener('mouseenter', function () {
          for (let i = 0; i <= index; i++) {
            stars[i].style.color = '#ffc107';
          }
        });

        // при уходе мыши
        star.addEventListener('mouseleave', function () {
          const checkedIndex = Array.from(radios).findIndex(radio => radio.checked);
          stars.forEach((s, i) => {
            s.style.color = i <= checkedIndex ? '#ffc107' : '#e4e5e9';
          });
        });
      });
    });
  });
</script>