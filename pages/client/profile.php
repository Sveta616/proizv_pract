<?php
// сообщение обновления инфы
$update_message = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $changes_made = false;

  if (!empty($_POST['email']) && $_POST['email'] !== $currentUser['email']) {
    $existing = $db->fetchOne(
      "SELECT user_id FROM users WHERE email = ? AND user_id != ?",
      [trim($_POST['email']), $currentUser['user_id']]
    );
    if (!$existing) {
      $db->update(
        'users',
        ['email' => trim($_POST['email']), 'updated_at' => date('Y-m-d H:i:s')],
        'user_id = ?',
        [$currentUser['user_id']]
      );
      $changes_made = true;
    } else {
      $update_message .= '<span style="color: var(--primary-red);">Email уже занят другим пользователем.</span><br>';
    }
  }

  if (isset($_POST['city_id']) && is_numeric($_POST['city_id']) && $_POST['city_id'] != $currentUser['city_id']) {
    $db->update(
      'users',
      ['city_id' => (int) $_POST['city_id'], 'updated_at' => date('Y-m-d H:i:s')],
      'user_id = ?',
      [$currentUser['user_id']]
    );
    $changes_made = true;
  }

  if ($changes_made) {
    // обновляем данные пользователя
    $currentUser = $userClass->getById($currentUser['user_id']);
    $update_message = '<div class="alert alert-success">Профиль успешно обновлен!</div>';
  } elseif (empty($update_message)) {
    // если ничего не изменили но форма отправлена
    $update_message = '<div class="alert alert-info">Изменений не обнаружено.</div>';
  }
}

$cities = $db->fetchAll("SELECT city_id, city_name FROM cities WHERE is_active = 1 ORDER BY city_name");

$levels = $db->fetchAll("SELECT * FROM levels ORDER BY level_id");
?>

<div class="student-section">
  <h2>Мой профиль</h2>

  <?php if ($update_message): ?>
    <?php echo $update_message; ?>
  <?php endif; ?>

  <!-- форма в которой заполняется профиль -->
  <form method="POST" class="profile-form">
    <div style="background: var(--light-gray); padding: 20px; border-radius: 8px; margin-bottom: 20px;">
      <h3 style="color: var(--dark-blue); margin-bottom: 15px;">Информация об аккаунте</h3>
      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px;">
        <div>
          <label style="font-size: 12px; color: var(--gray-medium);">Дата регистрации</label>
          <div style="font-weight: 600;">
            <?php echo date('d.m.Y', strtotime($currentUser['registration_date'])); ?>
          </div>
        </div>
        <div>
          <label style="font-size: 12px; color: var(--gray-medium);">Статус аккаунта</label>
          <div style="font-weight: 600; color: <?php echo $currentUser['is_active'] ? '#2ed573' : '#d90429'; ?>;">
            <?php echo $currentUser['is_active'] ? ' Активен' : ' Заблокирован'; ?>
          </div>
        </div>
      </div>
    </div>

    <!-- поля ввода значений для изменения профиля -->
    <div class="form-group">
      <label for="username" class="required">Имя пользователя</label>
      <input type="text" id="username" class="form-control"
        value="<?php echo htmlspecialchars($currentUser['username']); ?>" disabled>
      <small style="color: var(--gray-medium);">Имя пользователя нельзя изменить</small>
    </div>

    <div class="form-group">
      <label for="email" class="required">Email</label>
      <input type="email" id="email" name="email" class="form-control"
        value="<?php echo htmlspecialchars($currentUser['email']); ?>"
        required>
      <small style="color: var(--gray-medium);">На этот email будут приходить уведомления</small>
    </div>

    <div class="form-group">
      <label for="full_name" class="required">Полное имя</label>
      <input type="text" id="full_name" class="form-control"
        value="<?php echo htmlspecialchars($currentUser['full_name']); ?>" disabled>
      <small style="color: var(--gray-medium);">Для изменения имени обратитесь в поддержку</small>
    </div>

    <div class="form-group">
      <label for="city_id">Город</label>
      <select id="city_id" name="city_id" class="form-control">
        <option value="">Выберите город</option>
        <?php foreach ($cities as $city): ?>
          <option value="<?php echo $city['city_id']; ?>" <?php echo ($currentUser['city_id'] ?? 0) == $city['city_id'] ? 'selected' : ''; ?>>
            <?php echo htmlspecialchars($city['city_name']); ?>
          </option>
        <?php endforeach; ?>
      </select>
      <small style="color: var(--gray-medium);">Укажите для поиска репетиторов в вашем городе</small>
    </div>

    <div class="form-group">
      <label for="current_level_id">Текущий уровень</label>
      <select id="current_level_id" class="form-control" disabled>
        <?php foreach ($levels as $level): ?>
          <option value="<?php echo $level['level_id']; ?>" <?php echo ($currentUser['current_level_id'] ?? 1) == $level['level_id'] ? 'selected' : ''; ?>>
            <?php echo $level['level_code']; ?> - <?php echo $level['level_name']; ?>
          </option>
        <?php endforeach; ?>
      </select>
      <small style="color: var(--gray-medium);">Уровень автоматически повышается при успешном обучении</small>
    </div>

    <div class="form-group">
      <button type="submit" class="btn btn-primary">Сохранить изменения</button>
      <a href="?page=dashboard" class="btn btn-outline" style="margin-left: 10px;">Отмена</a>
    </div>
  </form>
</div>

<!-- секция безопасности -->
<div class="student-section">
  <h2>Безопасность</h2>
  <p style="color: var(--gray-medium); margin-bottom: 20px;">
    Для изменения пароля или других настроек безопасности обратитесь в поддержку.
  </p>

  <div style="background: var(--light-gray); padding: 20px; border-radius: 8px;">
    <h4 style="color: var(--dark-blue); margin-bottom: 15px;"> Статистика безопасности</h4>
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 15px;">
      <div>
        <label style="font-size: 12px; color: var(--gray-medium);">Тип аутентификации</label>
        <div style="font-weight: 600;">Email + Пароль</div>
      </div>
    </div>
  </div>
</div>