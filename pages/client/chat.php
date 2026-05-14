<style>
  .chat-wrapper {
    display: flex;
    gap: 20px;
    height: calc(100vh - 120px);
  }

  .chat-contacts {
    width: 280px;
    background: white;
    border-radius: 10px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    overflow-y: auto;
    flex-shrink: 0;
  }

  .chat-contacts-header {
    padding: 15px 20px;
    border-bottom: 1px solid #eee;
    font-weight: 600;
    color: var(--blue-dark);
    font-size: 16px;
  }

  .contact-item {
    display: flex;
    align-items: center;
    padding: 12px 20px;
    cursor: pointer;
    transition: background 0.2s;
    border-bottom: 1px solid #f5f5f5;
  }

  .contact-item:hover, .contact-item.active {
    background: var(--gray-light);
  }

  .contact-avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: linear-gradient(135deg, var(--blue-dark), var(--blue-accent, #4a90d9));
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
    font-size: 14px;
    margin-right: 12px;
    flex-shrink: 0;
  }

  .contact-info {
    flex: 1;
    min-width: 0;
  }

  .contact-name {
    font-weight: 600;
    font-size: 14px;
    color: var(--blue-dark);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .contact-preview {
    font-size: 12px;
    color: var(--gray-medium);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .contact-unread {
    background: var(--red-dark);
    color: white;
    border-radius: 50%;
    min-width: 20px;
    height: 20px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 11px;
    font-weight: bold;
    margin-left: 8px;
  }

  .chat-area {
    flex: 1;
    background: white;
    border-radius: 10px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    display: flex;
    flex-direction: column;
  }

  .chat-area-header {
    padding: 15px 20px;
    border-bottom: 1px solid #eee;
    font-weight: 600;
    color: var(--blue-dark);
  }

  .chat-messages {
    flex: 1;
    overflow-y: auto;
    padding: 20px;
    display: flex;
    flex-direction: column;
    gap: 10px;
  }

  .chat-empty {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 100%;
    color: var(--gray-medium);
    font-size: 15px;
  }

  .msg {
    max-width: 70%;
    padding: 10px 15px;
    border-radius: 12px;
    font-size: 14px;
    line-height: 1.4;
    word-wrap: break-word;
  }

  .msg-out {
    align-self: flex-end;
    background: var(--blue-dark);
    color: white;
    border-bottom-right-radius: 4px;
  }

  .msg-in {
    align-self: flex-start;
    background: var(--gray-light);
    color: #333;
    border-bottom-left-radius: 4px;
  }

  .msg-time {
    font-size: 11px;
    margin-top: 4px;
    opacity: 0.7;
  }

  .chat-input-area {
    padding: 15px 20px;
    border-top: 1px solid #eee;
    display: flex;
    gap: 10px;
  }

  .chat-input-area input {
    flex: 1;
    padding: 10px 15px;
    border: 1px solid #ddd;
    border-radius: 20px;
    font-size: 14px;
    outline: none;
  }

  .chat-input-area input:focus {
    border-color: var(--blue-dark);
  }

  .chat-send-btn {
    padding: 10px 20px;
    background: var(--red-dark);
    color: white;
    border: none;
    border-radius: 20px;
    cursor: pointer;
    font-weight: 600;
    font-size: 14px;
    transition: background 0.2s;
  }

  .chat-send-btn:hover {
    background: var(--red-light);
  }

  .no-contacts {
    padding: 30px 20px;
    text-align: center;
    color: var(--gray-medium);
    font-size: 14px;
  }

  @media (max-width: 768px) {
    .chat-wrapper {
      flex-direction: column;
      height: auto;
    }
    .chat-contacts {
      width: 100%;
      max-height: 200px;
    }
    .chat-area {
      min-height: 400px;
    }
  }
</style>

<?php
// получаем репетиторов, с которыми есть принятые заявки ИЛИ уже есть переписка
$myId = $currentUser['user_id'];

$contacts = $db->fetchAll(
  "SELECT DISTINCT u.user_id, u.full_name
   FROM users u
   WHERE u.user_type = 'tutor' AND (
     u.user_id IN (
       SELECT t2.user_id FROM tutors t2
       INNER JOIN tutor_requests tr ON tr.tutor_id = t2.tutor_id
       WHERE tr.student_id = ? AND tr.status IN ('accepted','completed')
     )
     OR u.user_id IN (
       SELECT sender_id FROM chat_messages WHERE receiver_id = ?
       UNION
       SELECT receiver_id FROM chat_messages WHERE sender_id = ?
     )
   )
   ORDER BY u.full_name",
  [$myId, $myId, $myId]
);

// непрочитанные по собеседникам
$unreadMap = [];
$unreadRows = $db->fetchAll(
  "SELECT sender_id, COUNT(*) as cnt FROM chat_messages WHERE receiver_id = ? AND is_read = 0 GROUP BY sender_id",
  [$myId]
);
foreach ($unreadRows as $r) {
  $unreadMap[$r['sender_id']] = (int) $r['cnt'];
}

$activeContact = (int) ($_GET['contact_id'] ?? 0);
?>

<div class="chat-wrapper">
  <div class="chat-contacts">
    <div class="chat-contacts-header">Собеседники</div>
    <?php if (empty($contacts)): ?>
      <div class="no-contacts">Нет доступных собеседников. Запишитесь к репетитору.</div>
    <?php else: ?>
      <?php foreach ($contacts as $c):
        $names = explode(' ', $c['full_name'], 2);
        $initials = mb_strtoupper(mb_substr($names[0], 0, 1, 'UTF-8'));
        if (!empty($names[1])) $initials .= mb_strtoupper(mb_substr($names[1], 0, 1, 'UTF-8'));
        $unread = $unreadMap[$c['user_id']] ?? 0;
        $isActive = $activeContact === (int) $c['user_id'];
      ?>
        <div class="contact-item <?php echo $isActive ? 'active' : ''; ?>"
             onclick="openChat(<?php echo $c['user_id']; ?>, '<?php echo htmlspecialchars($c['full_name'], ENT_QUOTES); ?>')"
             data-uid="<?php echo $c['user_id']; ?>">
          <div class="contact-avatar"><?php echo $initials; ?></div>
          <div class="contact-info">
            <div class="contact-name"><?php echo htmlspecialchars($c['full_name']); ?></div>
            <div class="contact-preview" id="preview-<?php echo $c['user_id']; ?>"></div>
          </div>
          <?php if ($unread > 0): ?>
            <div class="contact-unread" id="unread-<?php echo $c['user_id']; ?>"><?php echo $unread; ?></div>
          <?php endif; ?>
        </div>
      <?php endforeach; ?>
    <?php endif; ?>
  </div>

  <div class="chat-area">
    <div class="chat-area-header" id="chatHeader">Выберите собеседника</div>
    <div class="chat-messages" id="chatMessages">
      <div class="chat-empty">Выберите собеседника для начала общения</div>
    </div>
    <div class="chat-input-area" style="display:none;" id="chatInputArea">
      <input type="text" id="chatInput" placeholder="Введите сообщение..." onkeydown="if(event.key==='Enter')sendMessage()">
      <button class="chat-send-btn" onclick="sendMessage()">Отправить</button>
    </div>
  </div>
</div>

<script>
const MY_ID = <?php echo $myId; ?>;
let currentPartnerId = 0;
let pollTimer = null;

function openChat(partnerId, partnerName) {
  currentPartnerId = partnerId;
  document.getElementById('chatHeader').textContent = partnerName;
  document.getElementById('chatInputArea').style.display = 'flex';

  document.querySelectorAll('.contact-item').forEach(el => el.classList.remove('active'));
  const active = document.querySelector('[data-uid="' + partnerId + '"]');
  if (active) active.classList.add('active');

  loadMessages();

  if (pollTimer) clearInterval(pollTimer);
  pollTimer = setInterval(loadMessages, 3000);
}

function loadMessages() {
  if (!currentPartnerId) return;

  fetch('../../api/chat/messages.php?partner_id=' + currentPartnerId)
    .then(r => r.json())
    .then(data => {
      if (!data.success) return;
      renderMessages(data.data);

      // убираем бейдж непрочитанных
      const badge = document.getElementById('unread-' + currentPartnerId);
      if (badge) badge.remove();
    });
}

function renderMessages(messages) {
  const container = document.getElementById('chatMessages');
  if (!messages.length) {
    container.innerHTML = '<div class="chat-empty">Нет сообщений. Напишите первым!</div>';
    return;
  }

  container.innerHTML = messages.map(m => {
    const isOut = m.sender_id == MY_ID;
    const time = new Date(m.created_at).toLocaleString('ru-RU', {hour:'2-digit', minute:'2-digit', day:'2-digit', month:'2-digit'});
    return '<div class="msg ' + (isOut ? 'msg-out' : 'msg-in') + '">' +
      '<div>' + escapeHtml(m.message_text) + '</div>' +
      '<div class="msg-time">' + time + '</div>' +
    '</div>';
  }).join('');

  container.scrollTop = container.scrollHeight;
}

function sendMessage() {
  const input = document.getElementById('chatInput');
  const text = input.value.trim();
  if (!text || !currentPartnerId) return;

  input.value = '';

  fetch('../../api/chat/send.php', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({receiver_id: currentPartnerId, message: text})
  })
  .then(r => r.json())
  .then(data => {
    if (data.success) {
      loadMessages();
    } else {
      alert(data.message || 'Ошибка отправки');
    }
  });
}

function escapeHtml(text) {
  const d = document.createElement('div');
  d.textContent = text;
  return d.innerHTML;
}

// авто-открытие если указан contact_id
<?php if ($activeContact): ?>
  document.addEventListener('DOMContentLoaded', function() {
    const el = document.querySelector('[data-uid="<?php echo $activeContact; ?>"]');
    if (el) el.click();
  });
<?php endif; ?>
</script>
