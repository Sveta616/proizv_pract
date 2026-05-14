<?php
// Миграция: lesson_type
try {
    $db->executeQuery("SELECT lesson_type FROM tutor_requests LIMIT 1");
} catch (Exception $e) {
    $db->executeQuery("ALTER TABLE tutor_requests ADD COLUMN lesson_type ENUM('online', 'offline') DEFAULT 'online' AFTER status");
}

// Миграция: добавляем колонки если их нет
try {
    $db->executeQuery("SELECT lesson_date FROM tutor_requests LIMIT 1");
} catch (Exception $e) {
    $db->executeQuery("ALTER TABLE tutor_requests ADD COLUMN lesson_date DATETIME NULL AFTER status");
    $db->executeQuery("ALTER TABLE tutor_requests ADD COLUMN lesson_duration INT DEFAULT 60 AFTER lesson_date");
    $db->executeQuery("ALTER TABLE tutor_requests ADD COLUMN tutor_notes TEXT NULL AFTER lesson_duration");
}
try {
    $db->executeQuery("SELECT actual_duration FROM tutor_requests LIMIT 1");
} catch (Exception $e) {
    $db->executeQuery("ALTER TABLE tutor_requests ADD COLUMN actual_duration INT NULL AFTER tutor_notes");
}

// Миграция: lesson_topic
try {
    $db->executeQuery("SELECT lesson_topic FROM tutor_requests LIMIT 1");
} catch (Exception $e) {
    $db->executeQuery("ALTER TABLE tutor_requests ADD COLUMN lesson_topic VARCHAR(255) NULL AFTER actual_duration");
}

// Темы занятий из модулей
$all_modules = $db->fetchAll(
    "SELECT m.module_id, m.module_name, m.module_type, l.level_code
     FROM modules m
     JOIN levels l ON m.level_id = l.level_id
     WHERE m.is_active = 1
     ORDER BY l.level_id, m.order_number"
);

// Вспомогательная функция для форматирования длительности
function formatDuration($minutes) {
    if ($minutes < 60) {
        return $minutes . ' мин.';
    }
    $h = floor($minutes / 60);
    $m = $minutes % 60;
    return $h . ' ч.' . ($m > 0 ? ' ' . $m . ' мин.' : '');
}

// Завершение занятия
if (isset($_POST['complete_lesson'])) {
    $request_id = (int)$_POST['request_id'];
    $request = $db->fetchOne(
        "SELECT * FROM tutor_requests WHERE request_id = ? AND tutor_id = ? AND status = 'accepted'",
        [$request_id, $tutor['tutor_id']]
    );
    if ($request) {
        $now = new DateTime();
        $actual = null;
        if ($request['lesson_date']) {
            $lesson_start = new DateTime($request['lesson_date']);
            if ($now > $lesson_start) {
                $actual = (int)round(($now->getTimestamp() - $lesson_start->getTimestamp()) / 60);
                if ($actual < 1) $actual = 1;
            } else {
                $actual = 0; // завершено до начала
            }
        }
        $db->update('tutor_requests', [
            'status' => 'completed',
            'response_date' => $now->format('Y-m-d H:i:s'),
            'actual_duration' => $actual
        ], 'request_id = ?', [$request_id]);
        $duration_text = $actual !== null ? ' (фактически: ' . formatDuration($actual) . ')' : '';
        echo '<div class="alert alert-success">Занятие завершено!' . $duration_text . '</div>';
    }
}

// Отмена занятия
if (isset($_POST['cancel_lesson'])) {
    $request_id = (int)$_POST['request_id'];
    $request = $db->fetchOne(
        "SELECT * FROM tutor_requests WHERE request_id = ? AND tutor_id = ? AND status = 'accepted'",
        [$request_id, $tutor['tutor_id']]
    );
    if ($request) {
        $db->update('tutor_requests', [
            'status' => 'rejected'
        ], 'request_id = ?', [$request_id]);
        echo '<div class="alert alert-success">Занятие отменено</div>';
    }
}

// Текущая неделя или выбранная
$week_offset = (int)($_GET['week'] ?? 0);
$today = new DateTime();
$view_mode = $_GET['view'] ?? 'week';

// Получаем активные занятия (принятые)
$all_accepted = $db->fetchAll(
    "SELECT tr.*, u.full_name as student_name, u.email as student_email,
            c.city_name as student_city, tr.student_contact_phone, tr.student_age,
            tr.social_media, l.level_code as student_level
     FROM tutor_requests tr
     LEFT JOIN users u ON tr.student_id = u.user_id
     LEFT JOIN cities c ON u.city_id = c.city_id
     LEFT JOIN levels l ON u.current_level_id = l.level_id
     WHERE tr.tutor_id = ? AND tr.status = 'accepted'
     ORDER BY tr.lesson_date ASC, tr.request_date ASC",
    [$tutor['tutor_id']]
);

// Добавляем прогресс студентов
foreach ($all_accepted as &$lesson) {
    $sp = $db->fetchOne(
        "SELECT completion_percentage, current_score
         FROM user_progress
         WHERE user_id = ? AND level_id = (SELECT current_level_id FROM users WHERE user_id = ?)",
        [$lesson['student_id'], $lesson['student_id']]
    );
    $lesson['student_progress'] = $sp['completion_percentage'] ?? 0;
    $lesson['student_score'] = $sp['current_score'] ?? 0;
}
unset($lesson);

// Разделяем: с датой и без даты
$scheduled = [];
$unscheduled = [];
foreach ($all_accepted as $lesson) {
    if ($lesson['lesson_date']) {
        $scheduled[] = $lesson;
    } else {
        $unscheduled[] = $lesson;
    }
}

// Рассчитываем границы недели
$week_start = clone $today;
$week_start->modify("monday this week");
if ($week_offset !== 0) {
    $week_start->modify("{$week_offset} weeks");
}
$week_end = clone $week_start;
$week_end->modify('+6 days')->setTime(23, 59, 59);

// Фильтруем занятия этой недели
$week_lessons = [];
foreach ($scheduled as $lesson) {
    $ld = new DateTime($lesson['lesson_date']);
    if ($ld >= $week_start && $ld <= $week_end) {
        $week_lessons[] = $lesson;
    }
}

// Группируем по дням недели
$days_ru = ['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'];
$days_short = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
$week_days = [];
for ($i = 0; $i < 7; $i++) {
    $day = clone $week_start;
    $day->modify("+{$i} days");
    $day_key = $day->format('Y-m-d');
    $week_days[$day_key] = [
        'date' => $day,
        'name' => $days_ru[$i],
        'short' => $days_short[$i],
        'lessons' => [],
        'is_today' => $day->format('Y-m-d') === $today->format('Y-m-d'),
        'is_past' => $day < $today && $day->format('Y-m-d') !== $today->format('Y-m-d')
    ];
}

foreach ($week_lessons as $lesson) {
    $day_key = (new DateTime($lesson['lesson_date']))->format('Y-m-d');
    if (isset($week_days[$day_key])) {
        $week_days[$day_key]['lessons'][] = $lesson;
    }
}

// Будущие занятия (после текущей недели)
$upcoming_future = [];
foreach ($scheduled as $lesson) {
    $ld = new DateTime($lesson['lesson_date']);
    if ($ld > $week_end) {
        $upcoming_future[] = $lesson;
    }
}

// Завершённые (последние 10)
$completed_lessons = $db->fetchAll(
    "SELECT tr.*, u.full_name as student_name, u.email as student_email,
            c.city_name as student_city
     FROM tutor_requests tr
     LEFT JOIN users u ON tr.student_id = u.user_id
     LEFT JOIN cities c ON u.city_id = c.city_id
     WHERE tr.tutor_id = ? AND tr.status = 'completed'
     ORDER BY COALESCE(tr.lesson_date, tr.response_date) DESC
     LIMIT 10",
    [$tutor['tutor_id']]
);

// Статистика
$total_scheduled = count($scheduled);
$total_unscheduled = count($unscheduled);
$total_this_week = count($week_lessons);
$total_completed = $db->fetchOne(
    "SELECT COUNT(*) as cnt FROM tutor_requests WHERE tutor_id = ? AND status = 'completed'",
    [$tutor['tutor_id']]
)['cnt'];
?>

<style>
.schedule-stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap: 12px; margin-bottom: 25px; }
.schedule-stat { padding: 16px; border-radius: 10px; text-align: center; }
.schedule-stat-number { font-size: 28px; font-weight: bold; }
.schedule-stat-label { font-size: 13px; margin-top: 4px; }
.week-nav { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; flex-wrap: wrap; gap: 10px; }
.week-nav-title { font-size: 18px; font-weight: 700; color: var(--dark-blue); }
.week-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 8px; margin-bottom: 30px; }
.week-day { background: white; border-radius: 10px; border: 2px solid var(--light-gray); min-height: 120px; padding: 10px; transition: all 0.2s; }
.week-day.today { border-color: var(--primary-red); background: rgba(217, 4, 41, 0.02); }
.week-day.past { opacity: 0.6; }
.week-day.has-lessons { border-color: var(--dark-blue); }
.week-day-header { text-align: center; padding-bottom: 8px; border-bottom: 1px solid var(--light-gray); margin-bottom: 8px; }
.week-day-name { font-size: 12px; font-weight: 700; color: var(--medium-gray); text-transform: uppercase; }
.week-day-date { font-size: 20px; font-weight: 700; color: var(--dark-blue); }
.week-day.today .week-day-date { color: var(--primary-red); }
.lesson-mini { background: var(--light-gray); border-radius: 6px; padding: 6px 8px; margin-bottom: 4px; cursor: pointer; transition: all 0.2s; font-size: 12px; }
.lesson-mini:hover { background: rgba(217, 4, 41, 0.1); }
.lesson-mini-time { font-weight: 700; color: var(--dark-blue); }
.lesson-mini-name { color: var(--medium-gray); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.unscheduled-card { background: white; border: 2px dashed #ffc107; border-radius: 10px; padding: 16px; margin-bottom: 12px; }
.lesson-detail-card { background: white; border-radius: 10px; border: 1px solid var(--light-gray); padding: 20px; margin-bottom: 15px; box-shadow: 0 2px 6px rgba(0,0,0,0.05); }
.lesson-time-badge { display: inline-block; background: var(--dark-blue); color: white; padding: 4px 12px; border-radius: 15px; font-size: 13px; font-weight: 700; }
.lesson-time-badge.past { background: var(--medium-gray); }
.lesson-time-badge.now { background: #ffe0e0; color: #333; animation: pulse 2s infinite; }
.completed-row { display: grid; grid-template-columns: 1fr 1fr auto; gap: 15px; align-items: center; padding: 12px 0; border-bottom: 1px solid var(--light-gray); }
@keyframes pulse { 0%,100% { box-shadow: 0 0 0 0 rgba(217,4,41,0.4); } 50% { box-shadow: 0 0 0 8px rgba(217,4,41,0); } }
@media (max-width: 900px) { .week-grid { grid-template-columns: 1fr; } }

.modal-overlay { display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); z-index: 10000; align-items: center; justify-content: center; }
.modal-overlay.active { display: flex; }
.modal-box { background: white; border-radius: 12px; padding: 30px; max-width: 500px; width: 90%; max-height: 85vh; overflow-y: auto; }
</style>

<div class="tutor-section">
    <h2>Расписание занятий</h2>

    <!-- Статистика -->
    <div class="schedule-stats">
        <div class="schedule-stat" style="background: rgba(52,152,219,0.1);">
            <div class="schedule-stat-number" style="color: #3498db;"><?php echo $total_this_week; ?></div>
            <div class="schedule-stat-label" style="color: #3498db;">На этой неделе</div>
        </div>
        <div class="schedule-stat" style="background: rgba(46,213,115,0.1);">
            <div class="schedule-stat-number" style="color: #2ed573;"><?php echo $total_scheduled; ?></div>
            <div class="schedule-stat-label" style="color: #2ed573;">Запланировано</div>
        </div>
        <div class="schedule-stat" style="background: rgba(255,193,7,0.1);">
            <div class="schedule-stat-number" style="color: #e67e22;"><?php echo $total_unscheduled; ?></div>
            <div class="schedule-stat-label" style="color: #e67e22;">Без даты</div>
        </div>
        <div class="schedule-stat" style="background: rgba(155,89,182,0.1);">
            <div class="schedule-stat-number" style="color: #9b59b6;"><?php echo $total_completed; ?></div>
            <div class="schedule-stat-label" style="color: #9b59b6;">Завершено</div>
        </div>
    </div>

    <!-- Навигация по неделям -->
    <div class="week-nav">
        <a href="?page=schedule&week=<?php echo $week_offset - 1; ?>" class="btn btn-outline" style="padding: 8px 16px;">← Пред. неделя</a>
        <div style="text-align: center;">
            <div class="week-nav-title">
                <?php echo $week_start->format('d.m') . ' — ' . $week_end->format('d.m.Y'); ?>
            </div>
            <?php if ($week_offset !== 0): ?>
                <a href="?page=schedule&week=0" style="font-size: 13px; color: var(--primary-red);">Вернуться к текущей неделе</a>
            <?php else: ?>
                <span style="font-size: 13px; color: var(--medium-gray);">Текущая неделя</span>
            <?php endif; ?>
        </div>
        <a href="?page=schedule&week=<?php echo $week_offset + 1; ?>" class="btn btn-outline" style="padding: 8px 16px;">След. неделя →</a>
    </div>

    <!-- Сетка недели -->
    <div class="week-grid">
        <?php foreach ($week_days as $day_key => $day): ?>
            <div class="week-day <?php echo $day['is_today'] ? 'today' : ''; ?> <?php echo $day['is_past'] ? 'past' : ''; ?> <?php echo !empty($day['lessons']) ? 'has-lessons' : ''; ?>">
                <div class="week-day-header">
                    <div class="week-day-name"><?php echo $day['short']; ?></div>
                    <div class="week-day-date"><?php echo $day['date']->format('d'); ?></div>
                </div>
                <?php if (!empty($day['lessons'])): ?>
                    <?php foreach ($day['lessons'] as $lesson):
                        $lt = new DateTime($lesson['lesson_date']);
                    ?>
                        <div class="lesson-mini" onclick="showLessonDetail(<?php echo $lesson['request_id']; ?>)">
                            <div class="lesson-mini-time"><?php echo $lt->format('H:i'); ?></div>
                            <div class="lesson-mini-name"><?php echo htmlspecialchars($lesson['student_name']); ?></div>
                        </div>
                    <?php endforeach; ?>
                <?php else: ?>
                    <div style="text-align: center; color: var(--medium-gray); font-size: 12px; padding: 10px 0;">—</div>
                <?php endif; ?>
            </div>
        <?php endforeach; ?>
    </div>

    <!-- Детали занятий на выбранной неделе -->
    <?php if (!empty($week_lessons)): ?>
        <h3 style="color: var(--dark-blue); margin-bottom: 15px;">Занятия на неделе</h3>
        <?php
        // Группируем по дням для детального вида
        $lessons_by_day = [];
        foreach ($week_lessons as $lesson) {
            $dk = (new DateTime($lesson['lesson_date']))->format('Y-m-d');
            $lessons_by_day[$dk][] = $lesson;
        }
        ?>
        <?php foreach ($lessons_by_day as $dk => $day_lessons):
            $day_dt = new DateTime($dk);
            $day_idx = (int)$day_dt->format('N') - 1;
            $is_today_detail = $dk === $today->format('Y-m-d');
        ?>
            <div style="margin-bottom: 20px;">
                <div style="font-weight: 700; color: <?php echo $is_today_detail ? 'var(--primary-red)' : 'var(--dark-blue)'; ?>; font-size: 16px; margin-bottom: 10px; padding-bottom: 8px; border-bottom: 2px solid <?php echo $is_today_detail ? 'var(--primary-red)' : 'var(--light-gray)'; ?>;">
                    <?php echo $days_ru[$day_idx]; ?>, <?php echo $day_dt->format('d.m.Y'); ?>
                    <?php if ($is_today_detail): ?>
                        <span style="background: var(--primary-red); color: white; padding: 2px 10px; border-radius: 10px; font-size: 11px; margin-left: 8px;">Сегодня</span>
                    <?php endif; ?>
                    <span style="color: var(--medium-gray); font-size: 13px; margin-left: 8px;">(<?php echo count($day_lessons); ?> зан.)</span>
                </div>

                <?php foreach ($day_lessons as $lesson):
                    $lt = new DateTime($lesson['lesson_date']);
                    $lt_end = clone $lt;
                    $lt_end->modify('+' . ($lesson['lesson_duration'] ?? 60) . ' minutes');
                    $now = new DateTime();
                    $is_now = ($lt <= $now && $lt_end > $now);
                    $is_past_lesson = $lt_end < $now;
                ?>
                    <div class="lesson-detail-card" id="lesson-<?php echo $lesson['request_id']; ?>">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 10px;">
                            <div>
                                <span class="lesson-time-badge <?php echo $is_now ? 'now' : ($is_past_lesson ? 'past' : ''); ?>">
                                    <?php echo $lt->format('H:i'); ?> — <?php echo $lt_end->format('H:i'); ?>
                                </span>
                                <span style="color: var(--medium-gray); font-size: 13px; margin-left: 8px;">
                                    <?php echo $lesson['lesson_duration'] ?? 60; ?> мин.
                                </span>
                                <?php if ($is_now):
                                    $elapsed_min = (int)round(($now->getTimestamp() - $lt->getTimestamp()) / 60);
                                ?>
                                    <span style="color: var(--primary-red); font-weight: 700; font-size: 13px; margin-left: 5px;">
                                        ИДЁТ СЕЙЧАС
                                    </span>
                                    <span class="live-timer" data-start="<?php echo $lt->getTimestamp(); ?>" style="display: inline-block; background: #fff3cd; color: #333; padding: 2px 10px; border-radius: 10px; font-size: 12px; font-weight: 700; margin-left: 5px;">
                                        прошло: <?php echo formatDuration($elapsed_min); ?>
                                    </span>
                                    <?php $remaining_sec = $lt_end->getTimestamp() - $now->getTimestamp(); ?>
                                    <span class="countdown-timer"
                                          data-end="<?php echo $lt_end->getTimestamp(); ?>"
                                          data-request-id="<?php echo $lesson['request_id']; ?>"
                                          style="display: inline-block; background: #ffe0e0; color: #c0392b; padding: 2px 10px; border-radius: 10px; font-size: 12px; font-weight: 700; margin-left: 5px;">
                                        осталось: <?php echo formatDuration(max(0, (int)floor($remaining_sec / 60))); ?>
                                    </span>
                                <?php endif; ?>
                            </div>
                            <div style="display: flex; gap: 6px;">
                                <button type="button" class="btn btn-outline btn-sm" onclick="openScheduleModal(<?php echo $lesson['request_id']; ?>, '<?php echo htmlspecialchars(addslashes($lesson['student_name'])); ?>', '<?php echo $lt->format('Y-m-d\TH:i'); ?>', <?php echo $lesson['lesson_duration'] ?? 60; ?>, '<?php echo htmlspecialchars(addslashes($lesson['tutor_notes'] ?? '')); ?>', '<?php echo $lesson['lesson_type'] ?? 'online'; ?>', '<?php echo htmlspecialchars(addslashes($lesson['lesson_topic'] ?? '')); ?>')">Перенести</button>
                                <?php if ($is_now || $is_past_lesson): ?>
                                    <form method="POST" style="display:inline;" onsubmit="return confirm('<?php echo $is_now ? 'Завершить занятие досрочно?' : 'Завершить занятие?'; ?>')">
                                        <input type="hidden" name="request_id" value="<?php echo $lesson['request_id']; ?>">
                                        <button type="submit" name="complete_lesson" class="btn btn-primary btn-sm">Завершить</button>
                                    </form>
                                <?php endif; ?>
                                <form method="POST" style="display:inline;" onsubmit="return confirm('Отменить занятие?')">
                                    <input type="hidden" name="request_id" value="<?php echo $lesson['request_id']; ?>">
                                    <button type="submit" name="cancel_lesson" class="btn btn-secondary btn-sm" style="background: #e74c3c; color: white;">Отменить</button>
                                </form>
                            </div>
                        </div>

                        <div style="margin-top: 15px; display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                            <div>
                                <div style="font-weight: 700; font-size: 16px; color: var(--dark-blue);">
                                    <?php echo htmlspecialchars($lesson['student_name']); ?>
                                </div>
                                <?php if ($lesson['student_level']): ?>
                                    <span style="background: var(--light-gray); padding: 2px 8px; border-radius: 8px; font-size: 12px; color: var(--dark-blue); font-weight: 600;">
                                        <?php echo $lesson['student_level']; ?>
                                    </span>
                                <?php endif; ?>
                                <span style="background: #f0f7ff; padding: 2px 8px; border-radius: 8px; font-size: 12px; color: var(--dark-blue); font-weight: 600; margin-left: 4px;">
                                    Прогресс: <?php echo $lesson['student_progress']; ?>%
                                </span>
                                <span style="background: <?php echo ($lesson['lesson_type'] ?? 'online') === 'offline' ? '#e67e22' : '#2ecc71'; ?>; color: white; padding: 2px 8px; border-radius: 8px; font-size: 12px; font-weight: 600; margin-left: 4px;">
                                    <?php echo ($lesson['lesson_type'] ?? 'online') === 'offline' ? 'Оффлайн' : 'Онлайн'; ?>
                                </span>
                                <?php if ($lesson['student_age']): ?>
                                    <span style="font-size: 13px; color: var(--medium-gray); margin-left: 8px;"><?php echo $lesson['student_age']; ?> лет</span>
                                <?php endif; ?>
                            </div>
                            <div style="font-size: 13px; color: var(--medium-gray);">
                                <div><?php echo htmlspecialchars($lesson['student_email']); ?></div>
                                <?php if ($lesson['student_contact_phone']): ?>
                                    <div><?php echo htmlspecialchars($lesson['student_contact_phone']); ?></div>
                                <?php endif; ?>
                                <?php if ($lesson['student_city']): ?>
                                    <div><?php echo htmlspecialchars($lesson['student_city']); ?></div>
                                <?php endif; ?>
                            </div>
                        </div>

                        <?php if (!empty($lesson['lesson_topic'])): ?>
                            <div style="margin-top: 10px; padding: 8px 12px; background: #e8f5e9; border-radius: 6px; font-size: 13px; color: #2e7d32;">
                                <strong>Тема:</strong> <?php echo htmlspecialchars($lesson['lesson_topic']); ?>
                            </div>
                        <?php endif; ?>

                        <?php if (!empty($lesson['tutor_notes'])): ?>
                            <div style="margin-top: 10px; padding: 8px 12px; background: #f0f7ff; border-radius: 6px; font-size: 13px; color: var(--dark-blue);">
                                <strong>Заметка:</strong> <?php echo htmlspecialchars($lesson['tutor_notes']); ?>
                            </div>
                        <?php endif; ?>

                        <?php if ($lesson['request_text']): ?>
                            <div style="margin-top: 8px; padding: 8px 12px; background: var(--light-gray); border-radius: 6px; font-size: 13px; color: var(--medium-gray); font-style: italic;">
                                "<?php echo htmlspecialchars(mb_strimwidth($lesson['request_text'], 0, 150, '...')); ?>"
                            </div>
                        <?php endif; ?>
                    </div>
                <?php endforeach; ?>
            </div>
        <?php endforeach; ?>
    <?php else: ?>
        <div style="text-align: center; padding: 30px; background: var(--light-gray); border-radius: 10px; margin-bottom: 20px;">
            <p style="color: var(--medium-gray); margin: 0;">Нет занятий на этой неделе</p>
        </div>
    <?php endif; ?>

    <!-- Занятия без назначенной даты -->
    <?php if (!empty($unscheduled)): ?>
        <h3 style="color: #e67e22; margin: 30px 0 15px;">Принятые заявки без даты (<?php echo count($unscheduled); ?>)</h3>
        <p style="color: var(--medium-gray); font-size: 14px; margin-bottom: 15px;">Назначьте дату и время для каждого занятия</p>

        <?php foreach ($unscheduled as $lesson): ?>
            <div class="unscheduled-card">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 10px;">
                    <div>
                        <div style="font-weight: 700; font-size: 16px; color: var(--dark-blue);">
                            <?php echo htmlspecialchars($lesson['student_name']); ?>
                        </div>
                        <div style="font-size: 13px; color: var(--medium-gray); margin-top: 3px;">
                            Заявка от <?php echo date('d.m.Y', strtotime($lesson['request_date'])); ?>
                            <?php if ($lesson['student_level']): ?>
                                | Уровень: <?php echo $lesson['student_level']; ?>
                            <?php endif; ?>
                            <?php if ($lesson['student_age']): ?>
                                | <?php echo $lesson['student_age']; ?> лет
                            <?php endif; ?>
                        </div>
                        <?php if ($lesson['request_text']): ?>
                            <div style="font-size: 13px; color: var(--medium-gray); font-style: italic; margin-top: 5px;">
                                "<?php echo htmlspecialchars(mb_strimwidth($lesson['request_text'], 0, 100, '...')); ?>"
                            </div>
                        <?php endif; ?>
                    </div>
                    <div style="display: flex; gap: 8px;">
                        <button type="button" class="btn btn-primary btn-sm" onclick="openScheduleModal(<?php echo $lesson['request_id']; ?>, '<?php echo htmlspecialchars(addslashes($lesson['student_name'])); ?>', '', 60, '', '<?php echo $lesson['lesson_type'] ?? 'online'; ?>', '<?php echo htmlspecialchars(addslashes($lesson['lesson_topic'] ?? '')); ?>')">
                            Назначить дату
                        </button>
                        <form method="POST" style="display:inline;" onsubmit="return confirm('Отменить занятие?')">
                            <input type="hidden" name="request_id" value="<?php echo $lesson['request_id']; ?>">
                            <button type="submit" name="cancel_lesson" class="btn btn-secondary btn-sm">Отменить</button>
                        </form>
                    </div>
                </div>
            </div>
        <?php endforeach; ?>
    <?php endif; ?>

    <!-- Будущие (вне текущей недели) -->
    <?php if (!empty($upcoming_future)): ?>
        <h3 style="color: var(--dark-blue); margin: 30px 0 15px;">Предстоящие занятия</h3>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Дата и время</th>
                        <th>Студент</th>
                        <th>Длительность</th>
                        <th>Действия</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($upcoming_future as $lesson):
                        $lt = new DateTime($lesson['lesson_date']);
                    ?>
                        <tr>
                            <td>
                                <div style="font-weight: 600;"><?php echo $lt->format('d.m.Y'); ?></div>
                                <div style="color: var(--medium-gray); font-size: 13px;"><?php echo $lt->format('H:i'); ?>
                                    <?php
                                    $day_idx = (int)$lt->format('N') - 1;
                                    echo '(' . $days_ru[$day_idx] . ')';
                                    ?>
                                </div>
                            </td>
                            <td>
                                <div style="font-weight: 600;"><?php echo htmlspecialchars($lesson['student_name']); ?></div>
                                <div style="font-size: 12px; color: var(--medium-gray);"><?php echo htmlspecialchars($lesson['student_email']); ?></div>
                            </td>
                            <td><?php echo $lesson['lesson_duration'] ?? 60; ?> мин.</td>
                            <td>
                                <button type="button" class="btn btn-outline btn-sm" onclick="openScheduleModal(<?php echo $lesson['request_id']; ?>, '<?php echo htmlspecialchars(addslashes($lesson['student_name'])); ?>', '<?php echo $lt->format('Y-m-d\TH:i'); ?>', <?php echo $lesson['lesson_duration'] ?? 60; ?>, '<?php echo htmlspecialchars(addslashes($lesson['tutor_notes'] ?? '')); ?>', '<?php echo $lesson['lesson_type'] ?? 'online'; ?>', '<?php echo htmlspecialchars(addslashes($lesson['lesson_topic'] ?? '')); ?>')">Перенести</button>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    <?php endif; ?>

    <!-- История завершённых -->
    <?php if (!empty($completed_lessons)): ?>
        <h3 style="color: var(--dark-blue); margin: 30px 0 15px;">История занятий</h3>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Дата занятия</th>
                        <th>Студент</th>
                        <th>Тип</th>
                        <th>Длительность</th>
                        <th>Завершено</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($completed_lessons as $lesson):
                        $ld = $lesson['lesson_date'] ? new DateTime($lesson['lesson_date']) : null;
                        $rd = $lesson['response_date'] ? new DateTime($lesson['response_date']) : null;
                        $planned = $lesson['lesson_duration'] ?? 60;
                        $actual = $lesson['actual_duration'] ?? null;
                    ?>
                        <tr>
                            <td>
                                <?php if ($ld): ?>
                                    <div style="font-weight: 600;"><?php echo $ld->format('d.m.Y H:i'); ?></div>
                                <?php else: ?>
                                    <div style="color: var(--medium-gray);">Без даты</div>
                                <?php endif; ?>
                            </td>
                            <td>
                                <div style="font-weight: 600;"><?php echo htmlspecialchars($lesson['student_name']); ?></div>
                                <div style="font-size: 12px; color: var(--medium-gray);"><?php echo htmlspecialchars($lesson['student_email']); ?></div>
                            </td>
                            <td>
                                <span style="background: <?php echo ($lesson['lesson_type'] ?? 'online') === 'offline' ? '#e67e22' : '#2ecc71'; ?>; color: white; padding: 2px 8px; border-radius: 8px; font-size: 12px; font-weight: 600;">
                                    <?php echo ($lesson['lesson_type'] ?? 'online') === 'offline' ? 'Оффлайн' : 'Онлайн'; ?>
                                </span>
                            </td>
                            <td>
                                <?php if ($actual !== null): ?>
                                    <div style="font-weight: 600; color: <?php echo $actual < $planned ? '#e67e22' : '#2ed573'; ?>;">
                                        <?php echo formatDuration($actual); ?>
                                    </div>
                                    <div style="font-size: 11px; color: var(--medium-gray);">
                                        из <?php echo formatDuration($planned); ?>
                                        <?php if ($actual < $planned): ?>
                                            <span style="color: #e67e22;">(досрочно)</span>
                                        <?php elseif ($actual > $planned): ?>
                                            <span style="color: #3498db;">(переработка)</span>
                                        <?php endif; ?>
                                    </div>
                                <?php else: ?>
                                    <div style="color: var(--medium-gray);"><?php echo formatDuration($planned); ?></div>
                                <?php endif; ?>
                            </td>
                            <td>
                                <?php if ($rd): ?>
                                    <span style="color: #2ed573; font-weight: 600;"><?php echo $rd->format('d.m.Y H:i'); ?></span>
                                <?php endif; ?>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    <?php endif; ?>

    <?php if (empty($all_accepted) && empty($completed_lessons)): ?>
        <div style="text-align: center; padding: 60px 20px;">
            <h3 style="color: var(--dark-blue); margin-bottom: 15px;">Расписание пусто</h3>
            <p style="color: var(--medium-gray); margin-bottom: 25px;">Примите заявки от студентов, чтобы начать планировать занятия</p>
            <a href="?page=requests" class="btn btn-primary">Перейти к заявкам</a>
        </div>
    <?php endif; ?>
</div>

<!-- Модалка назначения даты -->
<div id="scheduleModal" class="modal-overlay">
    <div class="modal-box">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h3 style="margin: 0; color: var(--dark-blue);" id="scheduleModalTitle">Назначить дату занятия</h3>
            <button type="button" onclick="closeScheduleModal()" style="background: none; border: none; font-size: 24px; cursor: pointer; color: var(--medium-gray);">×</button>
        </div>

        <div style="margin-bottom: 20px; padding: 12px; background: var(--light-gray); border-radius: 8px;">
            <strong>Студент:</strong> <span id="scheduleStudentName"></span>
        </div>

        <div class="form-group" style="margin-bottom: 15px;">
            <label style="display: block; font-weight: 600; margin-bottom: 5px; color: var(--dark-blue);">Дата и время занятия</label>
            <input type="datetime-local" id="scheduleLessonDate" class="form-control" style="width: 100%;" required>
        </div>

        <div class="form-group" style="margin-bottom: 15px;">
            <label style="display: block; font-weight: 600; margin-bottom: 5px; color: var(--dark-blue);">Длительность (минуты)</label>
            <select id="scheduleDuration" class="form-control" style="width: 100%;">
                <option value="30">30 мин</option>
                <option value="45">45 мин</option>
                <option value="60" selected>60 мин (1 час)</option>
                <option value="90">90 мин (1.5 часа)</option>
                <option value="120">120 мин (2 часа)</option>
            </select>
        </div>

        <div class="form-group" style="margin-bottom: 15px;">
            <label style="display: block; font-weight: 600; margin-bottom: 5px; color: var(--dark-blue);">Тип занятия</label>
            <select id="scheduleLessonType" class="form-control" style="width: 100%;">
                <option value="online">Онлайн</option>
                <option value="offline">Оффлайн</option>
            </select>
        </div>

        <div class="form-group" style="margin-bottom: 15px;">
            <label style="display: block; font-weight: 600; margin-bottom: 5px; color: var(--dark-blue);">Тема занятия (необязательно)</label>
            <select id="scheduleLessonTopic" class="form-control" style="width: 100%;">
                <option value="">— Без темы —</option>
                <?php foreach ($all_modules as $mod): ?>
                    <option value="<?php echo htmlspecialchars($mod['module_name']); ?>">
                        [<?php echo $mod['level_code']; ?>] <?php echo htmlspecialchars($mod['module_name']); ?>
                    </option>
                <?php endforeach; ?>
            </select>
        </div>

        <div class="form-group" style="margin-bottom: 20px;">
            <label style="display: block; font-weight: 600; margin-bottom: 5px; color: var(--dark-blue);">Заметка (необязательно)</label>
            <textarea id="scheduleTutorNotes" class="form-control" rows="2" placeholder="Подготовить материалы, комментарии..." style="width: 100%;"></textarea>
        </div>

        <div id="scheduleError" style="display: none; color: #e74c3c; margin-bottom: 15px; padding: 10px; background: rgba(231,76,60,0.1); border-radius: 6px;"></div>

        <div style="display: flex; gap: 10px; justify-content: flex-end;">
            <button type="button" class="btn btn-secondary" onclick="closeScheduleModal()">Отмена</button>
            <button type="button" class="btn btn-primary" id="scheduleSaveBtn" onclick="saveLessonDate()">Сохранить</button>
        </div>

        <input type="hidden" id="scheduleRequestId">
    </div>
</div>

<script>
function openScheduleModal(requestId, studentName, currentDate, duration, notes, lessonType, lessonTopic) {
    document.getElementById('scheduleRequestId').value = requestId;
    document.getElementById('scheduleStudentName').textContent = studentName;
    document.getElementById('scheduleLessonDate').value = currentDate || '';
    document.getElementById('scheduleDuration').value = duration || 60;
    document.getElementById('scheduleTutorNotes').value = notes || '';
    document.getElementById('scheduleLessonType').value = lessonType || 'online';
    document.getElementById('scheduleLessonTopic').value = lessonTopic || '';
    document.getElementById('scheduleError').style.display = 'none';
    document.getElementById('scheduleModalTitle').textContent = currentDate ? 'Перенести занятие' : 'Назначить дату занятия';
    document.getElementById('scheduleModal').classList.add('active');
}

function closeScheduleModal() {
    document.getElementById('scheduleModal').classList.remove('active');
}

function saveLessonDate() {
    const requestId = document.getElementById('scheduleRequestId').value;
    const lessonDate = document.getElementById('scheduleLessonDate').value;
    const duration = document.getElementById('scheduleDuration').value;
    const lessonType = document.getElementById('scheduleLessonType').value;
    const notes = document.getElementById('scheduleTutorNotes').value;
    const lessonTopic = document.getElementById('scheduleLessonTopic').value;
    const errorDiv = document.getElementById('scheduleError');
    const saveBtn = document.getElementById('scheduleSaveBtn');

    if (!lessonDate) {
        errorDiv.textContent = 'Укажите дату и время';
        errorDiv.style.display = 'block';
        return;
    }

    saveBtn.disabled = true;
    saveBtn.textContent = 'Сохранение...';
    errorDiv.style.display = 'none';

    fetch('../../api/tutor/set_lesson_date.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            request_id: parseInt(requestId),
            lesson_date: lessonDate,
            lesson_duration: parseInt(duration),
            lesson_type: lessonType,
            tutor_notes: notes,
            lesson_topic: lessonTopic
        })
    })
    .then(r => r.json())
    .then(data => {
        if (data.success) {
            location.reload();
        } else {
            errorDiv.textContent = data.message;
            errorDiv.style.display = 'block';
            saveBtn.disabled = false;
            saveBtn.textContent = 'Сохранить';
        }
    })
    .catch(() => {
        errorDiv.textContent = 'Ошибка сети';
        errorDiv.style.display = 'block';
        saveBtn.disabled = false;
        saveBtn.textContent = 'Сохранить';
    });
}

function showLessonDetail(requestId) {
    const el = document.getElementById('lesson-' + requestId);
    if (el) {
        el.scrollIntoView({ behavior: 'smooth', block: 'center' });
        el.style.boxShadow = '0 0 0 3px var(--primary-red)';
        setTimeout(() => { el.style.boxShadow = ''; }, 2000);
    }
}

document.getElementById('scheduleModal').addEventListener('click', function(e) {
    if (e.target === this) closeScheduleModal();
});

// Живой таймер для текущих занятий
function updateLiveTimers() {
    document.querySelectorAll('.live-timer').forEach(el => {
        const start = parseInt(el.dataset.start);
        const now = Math.floor(Date.now() / 1000);
        const elapsed = Math.floor((now - start) / 60);
        if (elapsed < 60) {
            el.textContent = 'прошло: ' + elapsed + ' мин.';
        } else {
            const h = Math.floor(elapsed / 60);
            const m = elapsed % 60;
            el.textContent = 'прошло: ' + h + ' ч.' + (m > 0 ? ' ' + m + ' мин.' : '');
        }
    });
}
setInterval(updateLiveTimers, 15000);

function updateCountdownTimers() {
    document.querySelectorAll('.countdown-timer').forEach(el => {
        const endTs = parseInt(el.dataset.end);
        const requestId = el.dataset.requestId;
        const now = Math.floor(Date.now() / 1000);
        const remaining = endTs - now;

        if (remaining <= 0) {
            el.textContent = 'Время истекло!';
            el.style.background = '#e74c3c';
            el.style.color = 'white';
            if (!el.dataset.completed) {
                el.dataset.completed = 'true';
                autoCompleteLesson(requestId);
            }
        } else {
            const min = Math.floor(remaining / 60);
            if (min < 60) {
                el.textContent = 'осталось: ' + min + ' мин.';
            } else {
                const h = Math.floor(min / 60);
                const m = min % 60;
                el.textContent = 'осталось: ' + h + ' ч.' + (m > 0 ? ' ' + m + ' мин.' : '');
            }
        }
    });
}

function autoCompleteLesson(requestId) {
    if (!confirm('Время занятия истекло. Завершить занятие?')) {
        return;
    }
    fetch('../../api/tutor/complete_lesson.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ request_id: parseInt(requestId), auto_complete: true })
    })
    .then(r => r.json())
    .then(data => {
        if (data.success) {
            location.reload();
        }
    })
    .catch(err => console.error('Auto-complete error:', err));
}

setInterval(updateCountdownTimers, 15000);
updateCountdownTimers();
</script>
