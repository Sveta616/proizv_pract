<?php
// сообщение и логика обработки обновления профиля
$update_message = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $update_data = [
    'bio' => $_POST['bio'] ?? null,
    'experience_years' => !empty($_POST['experience_years']) ? (int) $_POST['experience_years'] : null,
    'hourly_rate' => !empty($_POST['hourly_rate']) ? (float) $_POST['hourly_rate'] : null,
    'specialization_id' => !empty($_POST['specialization_id']) ? (int) $_POST['specialization_id'] : null,
    'phone' => $_POST['phone'] ?? null
  ];

  if (!empty($_POST['city_id'])) {
    $update_data['city_id'] = (int) $_POST['city_id'];
  } else {
    $update_data['city_id'] = null;
  }

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
      $db->update(
        'tutors',
        ['email' => trim($_POST['email']), 'updated_at' => date('Y-m-d H:i:s')],
        'tutor_id = ?',
        [$tutor['tutor_id']]
      );
      $update_message .= 'Email успешно обновлен.<br>';
    } else {
      $update_message .= '<span style="color: var(--primary-red);">Email уже занят другим пользователем.</span><br>';
    }
  }

  // убираем только те поля, которые не были отправлены в форме
  // null значения оставляем — они нужны для сброса полей в БД
  $update_data = array_filter($update_data, function ($value, $key) {
    // оставляем null значения для FK-полей, чтобы можно было сбросить выбор
    if (in_array($key, ['specialization_id', 'city_id', 'experience_years', 'hourly_rate'])) {
      return true;
    }
    return $value !== null && $value !== '';
  }, ARRAY_FILTER_USE_BOTH);

  // если профиль успешно обновлен то выводим сообщение об успехе
  if (!empty($update_data)) {
    // Устанавливаем текущее время как время обновления
    $update_data['updated_at'] = date('Y-m-d H:i:s');

    $db->update('tutors', $update_data, 'tutor_id = ?', [$tutor['tutor_id']]);
    $update_message .= 'Профиль успешно обновлен!';

    // обновляем updated_at у пользователя
    $db->update(
      'users',
      ['updated_at' => date('Y-m-d H:i:s')],
      'user_id = ?',
      [$currentUser['user_id']]
    );

    // обновляем город у пользователя, если он изменен
    if (isset($update_data['city_id'])) {
      $db->update(
        'users',
        ['city_id' => $update_data['city_id']],
        'user_id = ?',
        [$currentUser['user_id']]
      );
    }

    // перезагрузка данные
    $tutor = $db->fetchOne(
      "SELECT t.*, c.city_name, ts.name as specialization_name
             FROM tutors t
             LEFT JOIN cities c ON t.city_id = c.city_id
             LEFT JOIN tutor_specializations ts ON t.specialization_id = ts.specialization_id
             WHERE t.tutor_id = ?",
      [$tutor['tutor_id']]
    );

    $currentUser = $userClass->getById($currentUser['user_id']);
  }
}

// Создаем таблицу сертификатов если не существует
$db->executeQuery("CREATE TABLE IF NOT EXISTS tutor_certificates (
    certificate_id INT AUTO_INCREMENT PRIMARY KEY,
    tutor_id INT NOT NULL,
    filename VARCHAR(255) NOT NULL,
    original_name VARCHAR(255) NOT NULL,
    file_size INT NOT NULL,
    uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tutor_id) REFERENCES tutors(tutor_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");

$specializations = $db->fetchAll("SELECT * FROM tutor_specializations ORDER BY name");
$cities = $db->fetchAll("SELECT city_id, city_name FROM cities WHERE is_active = 1 ORDER BY city_name");
$certificates = $db->fetchAll("SELECT * FROM tutor_certificates WHERE tutor_id = ? ORDER BY uploaded_at DESC", [$tutor['tutor_id']]);
?>

<div class="tutor-section">
  <h2>Редактирование профиля</h2>

  <?php if ($update_message): ?>
    <div class="alert <?php echo strpos($update_message, 'успешно') !== false ? 'alert-success' : 'alert-warning'; ?>">
      <?php echo $update_message; ?>
    </div>
  <?php endif; ?>

  <!-- форма с основной инфой и полями редактирования -->
  <form method="POST" class="profile-form">
    <div style="background: var(--light-gray); padding: 20px; border-radius: 8px; margin-bottom: 20px;">
      <h3 style="color: var(--dark-blue); margin-bottom: 15px;">Информация об аккаунте</h3>
      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px;">
        <div>
          <label style="font-size: 12px; color: var(--medium-gray);">Дата регистрации</label>
          <div style="font-weight: 600;"><?php echo date('d.m.Y', strtotime($currentUser['registration_date'])); ?>
          </div>
        </div>
        <div>
          <label style="font-size: 12px; color: var(--medium-gray);">Статус аккаунта</label>
          <div style="font-weight: 600; color: <?php echo $tutor['is_verified'] ? '#2ed573' : '#ffc107'; ?>;">
            <?php echo $tutor['is_verified'] ? 'Подтвержден' : '⏳ На проверке'; ?>
          </div>
        </div>
      </div>
    </div>

    <div class="form-group">
      <label for="email" class="required">Email</label>
      <input type="email" id="email" name="email" class="form-control"
        value="<?php echo htmlspecialchars($currentUser['email']); ?>"
        required>
      <small style="color: var(--medium-gray);">На этот email будут приходить уведомления о заявках</small>
    </div>

    <div class="form-group">
      <label for="full_name" class="required">Полное имя</label>
      <input type="text" id="full_name" class="form-control"
        value="<?php echo htmlspecialchars($currentUser['full_name']); ?>" disabled>
      <small style="color: var(--medium-gray);">Для изменения имени обратитесь в поддержку</small>
    </div>

    <div class="form-group">
      <label for="city_id">Город</label>
      <select id="city_id" name="city_id" class="form-control">
        <option value="">Выберите город</option>
        <?php foreach ($cities as $city): ?>
          <option value="<?php echo $city['city_id']; ?>" <?php echo ($tutor['city_id'] ?? 0) == $city['city_id'] ? 'selected' : ''; ?>>
            <?php echo htmlspecialchars($city['city_name']); ?>
          </option>
        <?php endforeach; ?>
      </select>
      <small style="color: var(--medium-gray);">Студенты будут искать репетиторов по городу</small>
    </div>

    <div class="form-group">
      <label for="phone">Телефон</label>
      <input type="tel" id="phone" name="phone" class="form-control"
        value="<?php echo htmlspecialchars($tutor['phone'] ?? ''); ?>"
        placeholder="+7 (999) 123-45-67">
      <small style="color: var(--medium-gray);">Укажите номер для связи со студентами</small>
    </div>

    <div class="form-group">
      <label for="specialization_id">Специализация</label>
      <select id="specialization_id" name="specialization_id" class="form-control">
        <option value="">Выберите специализацию</option>
        <?php foreach ($specializations as $spec): ?>
          <option value="<?php echo $spec['specialization_id']; ?>" <?php echo ($tutor['specialization_id'] ?? 0) == $spec['specialization_id'] ? 'selected' : ''; ?>>
            <?php echo htmlspecialchars($spec['name']); ?>
          </option>
        <?php endforeach; ?>
      </select>
    </div>

    <div class="form-group">
      <label for="experience_years">Опыт работы (лет)</label>
      <input type="number" id="experience_years" name="experience_years" class="form-control"
        value="<?php echo $tutor['experience_years'] ?? ''; ?>" min="0"
        max="50" step="1">
    </div>

    <div class="form-group">
      <label for="hourly_rate">Стоимость занятия (₽/час)</label>
      <input type="number" id="hourly_rate" name="hourly_rate" class="form-control"
        value="<?php echo $tutor['hourly_rate'] ?? ''; ?>" min="0"
        step="100">
    </div>

    <div class="form-group">
      <label for="bio">О себе</label>
      <textarea id="bio" name="bio" class="form-control" rows="6"
        placeholder="Расскажите о себе, своем опыте преподавания, методиках, образовании..."><?php echo htmlspecialchars($tutor['bio'] ?? ''); ?></textarea>
      <small style="color: var(--medium-gray);">Чем подробнее описание, тем больше студентов заинтересуются</small>
    </div>

    <div class="form-group">
      <button type="submit" class="btn btn-primary">Сохранить изменения</button>
      <a href="?page=dashboard" class="btn btn-outline" style="margin-left: 10px;">Отмена</a>
    </div>
  </form>
</div>

<div class="tutor-section" id="certificates">
  <h2>Сертификаты и документы</h2>
  <?php if (!$tutor['is_verified']): ?>
    <p style="color: #856404; background: #fff3cd; padding: 12px; border-radius: 8px; margin-bottom: 20px;">
      Загрузите сертификаты для верификации аккаунта. Администратор проверит документы и подтвердит ваш профиль.
    </p>
  <?php else: ?>
    <p style="color: #155724; background: #d4edda; padding: 12px; border-radius: 8px; margin-bottom: 20px;">
      Ваш аккаунт верифицирован. Вы можете обновить сертификаты при необходимости.
    </p>
  <?php endif; ?>

  <div id="certificates-list" style="margin-bottom: 20px;">
    <?php if (!empty($certificates)): ?>
      <?php foreach ($certificates as $cert): ?>
        <div class="certificate-item" data-id="<?php echo $cert['certificate_id']; ?>" style="display: flex; align-items: center; justify-content: space-between; padding: 12px; border: 1px solid var(--light-gray); border-radius: 8px; margin-bottom: 10px;">
          <div>
            <strong><?php echo htmlspecialchars($cert['original_name']); ?></strong>
            <span style="color: var(--medium-gray); font-size: 12px; margin-left: 10px;">
              <?php echo number_format($cert['file_size'] / 1024, 0, ',', ' '); ?> КБ |
              <?php echo date('d.m.Y H:i', strtotime($cert['uploaded_at'])); ?>
            </span>
          </div>
          <div style="display: flex; gap: 10px;">
            <a href="../../uploads/certificates/<?php echo htmlspecialchars($cert['filename']); ?>" target="_blank" class="btn btn-outline btn-sm">Просмотр</a>
            <button type="button" class="btn btn-secondary btn-sm" onclick="deleteCertificate(<?php echo $cert['certificate_id']; ?>)">Удалить</button>
          </div>
        </div>
      <?php endforeach; ?>
    <?php else: ?>
      <p id="no-certs-msg" style="color: var(--medium-gray); text-align: center; padding: 20px;">Нет загруженных сертификатов</p>
    <?php endif; ?>
  </div>

  <?php if (count($certificates) < 5): ?>
    <form id="certificateForm" enctype="multipart/form-data" style="display: flex; align-items: center; gap: 15px; flex-wrap: wrap;">
      <input type="file" id="certificateFile" name="certificate" accept=".jpg,.jpeg,.png,.webp,.pdf" style="flex: 1; min-width: 200px;">
      <button type="submit" class="btn btn-primary">Загрузить сертификат</button>
    </form>
    <small style="color: var(--medium-gray); display: block; margin-top: 8px;">Форматы: JPG, PNG, WEBP, PDF. Максимум 5 МБ. Можно загрузить до 5 файлов.</small>
  <?php endif; ?>

  <div id="uploadStatus" style="margin-top: 10px;"></div>
</div>

<script>
document.getElementById('certificateForm')?.addEventListener('submit', function(e) {
    e.preventDefault();
    const fileInput = document.getElementById('certificateFile');
    if (!fileInput.files.length) {
        document.getElementById('uploadStatus').innerHTML = '<span style="color: red;">Выберите файл</span>';
        return;
    }

    const formData = new FormData();
    formData.append('certificate', fileInput.files[0]);

    document.getElementById('uploadStatus').innerHTML = '<span style="color: var(--medium-gray);">Загрузка...</span>';

    fetch('../../api/tutor/upload_certificate.php', {
        method: 'POST',
        body: formData
    })
    .then(r => r.json())
    .then(data => {
        if (data.success) {
            location.reload();
        } else {
            document.getElementById('uploadStatus').innerHTML = '<span style="color: red;">' + data.message + '</span>';
        }
    })
    .catch(err => {
        document.getElementById('uploadStatus').innerHTML = '<span style="color: red;">Ошибка сети</span>';
    });
});

function deleteCertificate(id) {
    if (!confirm('Удалить сертификат?')) return;

    const formData = new FormData();
    formData.append('certificate_id', id);

    fetch('../../api/tutor/delete_certificate.php', {
        method: 'POST',
        body: formData
    })
    .then(r => r.json())
    .then(data => {
        if (data.success) {
            location.reload();
        } else {
            alert(data.message);
        }
    });
}
</script>