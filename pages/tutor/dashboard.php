<?php
// получаем стату для дашборда
$stats = $db->fetchOne(
  "SELECT 
        COUNT(*) as total_requests,
        SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) as pending_requests,
        SUM(CASE WHEN status = 'accepted' THEN 1 ELSE 0 END) as accepted_requests,
        SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed_requests
     FROM tutor_requests 
     WHERE tutor_id = ?",
  [$tutor['tutor_id']]
);
// получаем последние заявки из бд
$recent_requests = $db->fetchAll(
  "SELECT tr.*, u.full_name as student_name, c.city_name as student_city 
     FROM tutor_requests tr 
     LEFT JOIN users u ON tr.student_id = u.user_id 
     LEFT JOIN cities c ON u.city_id = c.city_id 
     WHERE tr.tutor_id = ? 
     ORDER BY tr.request_date DESC 
     LIMIT 5",
  [$tutor['tutor_id']]
);
?>

<?php if (!$tutor['is_verified']): ?>
<div class="tutor-section" style="background: #fff3cd; border-left: 4px solid #ffc107;">
  <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 15px;">
    <div>
      <h3 style="color: #856404; margin: 0 0 5px 0;">Ваш аккаунт не верифицирован</h3>
      <p style="color: #856404; margin: 0;">Загрузите сертификаты для подтверждения квалификации. Администратор проверит их и верифицирует ваш профиль.</p>
    </div>
    <a href="?page=profile#certificates" class="btn btn-primary">Верифицировать</a>
  </div>
</div>
<?php endif; ?>

<!-- стата -->
<div class="tutor-stats">
  <div class="stat-card">
    <div class="stat-number"><?php echo $stats['total_requests'] ?? 0; ?></div>
    <div class="stat-label">Всего заявок</div>
  </div>
  <div class="stat-card">
    <div class="stat-number"><?php echo $stats['pending_requests'] ?? 0; ?></div>
    <div class="stat-label">Ожидают ответа</div>
  </div>
  <div class="stat-card">
    <div class="stat-number"><?php echo $stats['accepted_requests'] ?? 0; ?></div>
    <div class="stat-label">Принятые</div>
  </div>
  <div class="stat-card">
    <?php if (($tutor['total_reviews'] ?? 0) > 0): ?>
      <div class="stat-number"><?php echo number_format($tutor['rating'], 1); ?></div>
      <div class="stat-label">Рейтинг (<?php echo $tutor['total_reviews']; ?> отзывов)</div>
    <?php else: ?>
      <div class="stat-number" style="font-size: 20px; color: var(--medium-gray);">—</div>
      <div class="stat-label">Пока нет оценок</div>
    <?php endif; ?>
  </div>
</div>
<div class="tutor-section">
  <h2>Быстрые действия</h2>
  <div style="display: flex; gap: 15px; margin-top: 20px;">
    <a href="?page=profile" class="btn btn-primary">Редактировать профиль</a>
    <a href="?page=requests" class="btn btn-outline">Просмотреть заявки</a>
    <a href="?page=schedule" class="btn btn-outline">Посмотреть расписание</a>
  </div>
</div>

<!-- вывод последних заявок -->
<div class="tutor-section">
  <h2>Последние заявки</h2>
  <?php if (!empty($recent_requests)): ?>
    <div class="requests-list">
      <?php foreach ($recent_requests as $request): ?>
        <div class="request-item">
          <div class="request-header">
            <div class="request-student"><?php echo htmlspecialchars($request['student_name']); ?></div>
            <div class="request-date">
              <?php echo date('d.m.Y', strtotime($request['request_date'])); ?>
            </div>
          </div>
          <?php if ($request['request_text']): ?>
            <p><?php echo htmlspecialchars($request['request_text']); ?></p>
          <?php endif; ?>
          <div class="request-meta">
            <span>Город: <?php echo htmlspecialchars($request['student_city'] ?? 'Не указан'); ?></span>
            <span>Статус:
              <span style="color: 
                                <?php
                                $status_colors = [
                                  'pending' => 'var(--primary-red)',
                                  'accepted' => 'var(--success)',
                                  'rejected' => 'var(--medium-gray)',
                                  'completed' => 'var(--dark-blue)'
                                ];
                                echo $status_colors[$request['status']] ?? 'var(--medium-gray)';
                                ?>
                            ">
                <?php
                $status_names = [
                  'pending' => 'Ожидает',
                  'accepted' => 'Принята',
                  'rejected' => 'Отклонена',
                  'completed' => 'Завершена'
                ];
                echo $status_names[$request['status']] ?? $request['status'];
                ?>
              </span>
            </span>
          </div>
          <?php if ($request['status'] === 'pending'): ?>
            <div class="request-actions">
              <a href="?page=requests&action=accept&id=<?php echo $request['request_id']; ?>"
                class="btn btn-primary btn-sm">Принять</a>
              <a href="?page=requests&action=reject&id=<?php echo $request['request_id']; ?>"
                class="btn btn-secondary btn-sm">Отклонить</a>
            </div>
          <?php endif; ?>
        </div>
      <?php endforeach; ?>
    </div>
    <div style="text-align: center; margin-top: 20px;">
      <a href="?page=requests" class="btn btn-outline">Все заявки</a>
    </div>
  <?php else: ?>
    <p style="text-align: center; padding: 30px; color: var(--medium-gray);">
      У вас пока нет заявок от студентов
    </p>
  <?php endif; ?>
</div>

<?php
$reviews = $db->fetchAll(
  "SELECT tr.rating_value, tr.review_text, tr.response_date, u.full_name as student_name
     FROM tutor_requests tr
     LEFT JOIN users u ON tr.student_id = u.user_id
     WHERE tr.tutor_id = ? AND tr.is_rated = 1
     ORDER BY tr.response_date DESC
     LIMIT 5",
  [$tutor['tutor_id']]
);
?>
<div class="tutor-section">
  <h2>Отзывы студентов</h2>
  <?php if (!empty($reviews)): ?>
    <div style="margin-top: 15px;">
      <?php foreach ($reviews as $review): ?>
        <div style="padding: 15px; border: 1px solid var(--light-gray); border-radius: 8px; margin-bottom: 10px;">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
            <div style="font-weight: 600; color: var(--dark-blue);">
              <?php echo htmlspecialchars($review['student_name']); ?>
            </div>
            <div style="display: flex; align-items: center; gap: 8px;">
              <span style="color: #ffc107; font-size: 16px;">
                <?php $stars = (int)($review['rating_value'] ?? 0); echo str_repeat('★', $stars) . str_repeat('☆', 5 - $stars); ?>
              </span>
              <span style="color: var(--medium-gray); font-size: 12px;">
                <?php echo date('d.m.Y', strtotime($review['response_date'])); ?>
              </span>
            </div>
          </div>
          <?php if (!empty($review['review_text'])): ?>
            <p style="color: var(--dark-blue); margin: 0; font-style: italic;">
              "<?php echo nl2br(htmlspecialchars($review['review_text'])); ?>"
            </p>
          <?php else: ?>
            <p style="color: var(--medium-gray); margin: 0; font-size: 14px;">Без текста отзыва</p>
          <?php endif; ?>
        </div>
      <?php endforeach; ?>
    </div>
  <?php else: ?>
    <p style="text-align: center; padding: 30px; color: var(--medium-gray);">
      У вас пока нет отзывов от студентов
    </p>
  <?php endif; ?>
</div>

<div class="tutor-section">
  <h2>Статус аккаунта</h2>
  <div class="verification-status <?php echo $tutor['is_verified'] ? 'verified' : ''; ?>">
    <?php if ($tutor['is_verified']): ?>
      <h3 style="color: #2ed573; margin-bottom: 10px;">Ваш аккаунт подтвержден</h3>
      <p>Вы получаете больше заявок от студентов и отображаетесь в результатах поиска.</p>
    <?php else: ?>
      <h3 style="color: #ffc107; margin-bottom: 10px;">Аккаунт на проверке</h3>
      <p>Наш администратор проверяет ваши данные. Обычно это занимает 1-2 рабочих дня.</p>
      <p style="margin-top: 10px;">
        <strong>Что можно сделать:</strong><br>
        1. Заполните профиль полностью<br>
        2. Добавьте описание и опыт работы<br>
        3. Укажите специализацию и стоимость занятий
      </p>
      <div style="margin-top: 15px;">
        <a href="?page=profile" class="btn btn-primary">Заполнить профиль</a>
      </div>
    <?php endif; ?>
  </div>
</div>