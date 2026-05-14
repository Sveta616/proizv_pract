-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Хост: MySQL-8.0
-- Время создания: Май 14 2026 г., 21:22
-- Версия сервера: 8.0.43
-- Версия PHP: 8.1.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `english_learning`
--

-- --------------------------------------------------------

--
-- Структура таблицы `achievements`
--

CREATE TABLE `achievements` (
  `achievement_id` int NOT NULL,
  `user_id` int NOT NULL,
  `achievement_name` varchar(100) NOT NULL,
  `achievement_description` text,
  `badge_type` enum('level_completed','task_milestone','streak','first_login') NOT NULL,
  `points_awarded` int DEFAULT '0',
  `earned_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `achievements`
--

INSERT INTO `achievements` (`achievement_id`, `user_id`, `achievement_name`, `achievement_description`, `badge_type`, `points_awarded`, `earned_date`) VALUES
(1, 9, 'Первый вход', 'Вы впервые вошли в систему', 'first_login', 10, '2026-01-08 17:33:33'),
(2, 9, 'Начинающий ученик', 'Выполнено первое задание', 'task_milestone', 25, '2026-02-25 17:33:33'),
(3, 9, 'Серия 3 дня', 'Занимались 3 дня подряд', 'streak', 50, '2026-02-25 17:33:33'),
(4, 10, 'Первый вход', 'Вы впервые вошли в систему', 'first_login', 10, '2026-01-08 17:33:33'),
(5, 13, 'Первый вход', 'Вы впервые вошли в систему', 'first_login', 10, '2026-02-25 17:33:33'),
(6, 23, 'Первый вход', 'Вы впервые вошли в систему', 'first_login', 10, '2026-02-25 17:33:33'),
(7, 24, 'Первый вход', 'Вы впервые вошли в систему. Добро пожаловать!', 'first_login', 10, '2026-02-25 17:39:48'),
(8, 25, 'Первый вход', 'Вы впервые вошли в систему. Добро пожаловать!', 'first_login', 10, '2026-02-26 11:01:22'),
(9, 26, 'Первый вход', 'Вы впервые вошли в систему. Добро пожаловать!', 'first_login', 10, '2026-02-26 12:16:12'),
(10, 27, 'Первый вход', 'Вы впервые вошли в систему. Добро пожаловать!', 'first_login', 10, '2026-02-26 12:30:26'),
(11, 10, 'Первое задание', 'Вы выполнили своё первое задание!', 'task_milestone', 25, '2026-03-04 15:55:54'),
(12, 10, '10 заданий', 'Вы выполнили 10 заданий. Так держать!', 'task_milestone', 50, '2026-03-04 15:55:54'),
(13, 29, 'Первый вход', 'Вы впервые вошли в систему. Добро пожаловать!', 'first_login', 10, '2026-03-04 15:56:24'),
(14, 29, 'Первое задание', 'Вы выполнили своё первое задание!', 'task_milestone', 25, '2026-03-04 15:56:31'),
(15, 29, '10 заданий', 'Вы выполнили 10 заданий. Так держать!', 'task_milestone', 50, '2026-03-04 15:57:01'),
(16, 30, 'Первый вход', 'Вы впервые вошли в систему. Добро пожаловать!', 'first_login', 10, '2026-03-09 16:40:38'),
(17, 30, 'Первое задание', 'Вы выполнили своё первое задание!', 'task_milestone', 25, '2026-03-09 16:40:50'),
(18, 10, '50 заданий', 'Вы выполнили 50 заданий. Впечатляющий результат!', 'task_milestone', 100, '2026-03-12 15:06:37'),
(19, 31, 'Первый вход', 'Вы впервые вошли в систему. Добро пожаловать!', 'first_login', 10, '2026-03-12 15:18:33'),
(20, 31, 'Первое задание', 'Вы выполнили своё первое задание!', 'task_milestone', 25, '2026-03-12 15:18:39'),
(21, 32, 'Первый вход', 'Вы впервые вошли в систему. Добро пожаловать!', 'first_login', 10, '2026-03-17 07:55:58'),
(22, 33, 'Первый вход', 'Вы впервые вошли в систему. Добро пожаловать!', 'first_login', 10, '2026-04-11 12:07:59'),
(23, 34, 'Первый вход', 'Вы впервые вошли в систему. Добро пожаловать!', 'first_login', 10, '2026-04-23 11:57:01'),
(24, 34, 'Первое задание', 'Вы выполнили своё первое задание!', 'task_milestone', 25, '2026-04-23 12:01:48'),
(25, 34, '10 заданий', 'Вы выполнили 10 заданий. Так держать!', 'task_milestone', 50, '2026-04-23 12:05:15'),
(26, 34, 'Уровень пройден: A1 - Beginner', 'Вы завершили уровень A1 - Beginner!', 'level_completed', 150, '2026-04-26 06:15:04'),
(27, 36, 'Первый вход', 'Вы впервые вошли в систему. Добро пожаловать!', 'first_login', 10, '2026-04-26 06:50:21'),
(28, 36, 'Первое задание', 'Вы выполнили своё первое задание!', 'task_milestone', 25, '2026-04-26 06:50:44'),
(29, 37, 'Первый вход', 'Вы впервые вошли в систему. Добро пожаловать!', 'first_login', 10, '2026-05-04 17:52:51'),
(30, 37, 'Первое задание', 'Вы выполнили своё первое задание!', 'task_milestone', 25, '2026-05-04 17:53:12'),
(31, 39, 'Первый вход', 'Вы впервые вошли в систему. Добро пожаловать!', 'first_login', 10, '2026-05-14 14:40:14'),
(32, 39, 'Первое задание', 'Вы выполнили своё первое задание!', 'task_milestone', 25, '2026-05-14 14:40:21');

-- --------------------------------------------------------

--
-- Структура таблицы `audio_files`
--

CREATE TABLE `audio_files` (
  `audio_id` int NOT NULL,
  `filename` varchar(255) NOT NULL,
  `original_name` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `file_size` int DEFAULT NULL,
  `uploaded_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `audio_files`
--

INSERT INTO `audio_files` (`audio_id`, `filename`, `original_name`, `title`, `description`, `file_size`, `uploaded_at`) VALUES
(3, 'audio_1773073141_b4c45468.mp3', '1L1-world-of-movies.mp3', 'World of Movies', 'Listening exercise for level A1 - entertainment', 468637, '2026-03-09 21:19:02'),
(4, 'audio_1773073143_32db2d7e.mp3', '1L2-rockstar.mp3', 'Rockstar', 'Listening exercise for level A1 - music', 854976, '2026-03-09 21:19:04'),
(5, 'audio_1773073147_da1b4e7a.mp3', '1L3-the-new-class.mp3', 'The New Class', 'Listening exercise for level A1 - school', 1050544, '2026-03-09 21:19:06'),
(6, 'audio_1773073149_211108e8.mp3', '1L4-applepie.mp3', 'Apple Pie', 'Listening exercise for level A2 - food', 723959, '2026-03-09 21:19:07'),
(7, 'audio_1773073152_d22739ea.mp3', '1L5-bookworms.mp3', 'Bookworms', 'Listening exercise for level A2 - hobbies', 654368, '2026-03-09 21:19:09'),
(8, 'audio_1773073154_0a922ced.mp3', '1L6-leaving-on-a-jet-plane.mp3', 'Leaving on a Jet Plane', 'Listening exercise for level A2 - travel', 753697, '2026-03-09 21:19:10'),
(9, 'audio_1773073157_5138fa4d.mp3', '2L1-the-charity-show.mp3', 'The Charity Show', 'Listening exercise for level B1 - events', 621400, '2026-03-09 21:19:12'),
(10, 'audio_1773073159_3d7b9d0f.mp3', '2L2-dianas-new-job.mp3', 'Diana\'s New Job', 'Listening exercise for level B1 - work', 463644, '2026-03-09 21:19:13'),
(11, 'audio_1773073162_c6bf6149.mp3', '2L3-job-interview.mp3', 'Job Interview', 'Listening exercise for level B1 - career', 1392229, '2026-03-09 21:19:15'),
(12, 'audio_1773073165_3e9d5671.mp3', '3L1-youve-changed.mp3', 'You\'ve Changed', 'Listening exercise for level B2 - relationships', 1007757, '2026-03-09 21:19:17'),
(13, 'audio_1773073168_61cb3387.mp3', '3L2-sports.mp3', 'Sports Discussion', 'Listening exercise for level B2 - sports', 945230, '2026-03-09 21:19:19'),
(14, 'audio_1773073171_9f0983b0.mp3', '3L3-haybridge-hall.mp3', 'Haybridge Hall', 'Listening exercise for level B2 - culture', 1097590, '2026-03-09 21:19:21'),
(15, 'audio_1773073174_663af275.mp3', '4L1-actress.mp3', 'The Actress', 'Listening exercise for level C1 - arts', 2323868, '2026-03-09 21:19:25'),
(16, 'audio_1773073178_dbff7772.mp3', '4L2-seti.mp3', 'SETI', 'Listening exercise for level C1 - science', 2840449, '2026-03-09 21:19:28'),
(17, 'audio_1773073183_860befed.mp3', '4L3-the-pet-caterer.mp3', 'The Pet Caterer', 'Listening exercise for level C1 - business', 2778232, '2026-03-09 21:19:31'),
(18, 'audio_1773073186_9a373348.mp3', '4L4-survival.mp3', 'Survival', 'Listening exercise for level C2 - nature', 3561907, '2026-03-09 21:19:33'),
(19, 'audio_1773073190_c88b1090.mp3', '4L5-online-perils.mp3', 'Online Perils', 'Listening exercise for level C2 - technology', 2419621, '2026-03-09 21:19:36'),
(20, 'audio_1773073193_9c27218d.mp3', '4L6-turn-off-that-light.mp3', 'Turn Off That Light', 'Listening exercise for level C2 - environment', 1630422, '2026-03-09 21:19:38'),
(21, 'audio_1773074296_483de34a.mp3', '1L7-coming-to-town.mp3', 'Coming to Town', 'Listening A1', 775632, '2026-03-09 21:38:19'),
(22, 'audio_1773074300_f5260ecf.mp3', '1L8-at-the-airport.mp3', 'At the Airport', 'Listening A1', 710274, '2026-03-09 21:38:21'),
(23, 'audio_1773074303_850dbb0e.mp3', '1L9-at-the-department-store.mp3', 'At the Department Store', 'Listening A1', 829299, '2026-03-09 21:38:23'),
(24, 'audio_1773074306_ae68a5f9.mp3', '1L10-better-learning.mp3', 'Better Learning', 'Listening A2', 664705, '2026-03-09 21:38:25'),
(25, 'audio_1773074310_eaf5f8ee.mp3', '1L11-knowing-her-majesty.mp3', 'Knowing Her Majesty', 'Listening A2', 645153, '2026-03-09 21:38:27'),
(26, 'audio_1773074312_ae58247c.mp3', '1L12-perchance-to-dream.mp3', 'Perchance to Dream', 'Listening A2', 631480, '2026-03-09 21:38:29'),
(27, 'audio_1773074316_57853806.mp3', '2L4-vacation-stress.mp3', 'Vacation Stress', 'Listening B1', 651560, '2026-03-09 21:38:31'),
(28, 'audio_1773074319_e39bb737.mp3', '2L5-inspector.mp3', 'The Inspector', 'Listening B1', 1082524, '2026-03-09 21:38:34'),
(29, 'audio_1773074323_52087d50.mp3', '2L6-best-friends.mp3', 'Best Friends', 'Listening B1', 1183298, '2026-03-09 21:38:38'),
(30, 'audio_1773074327_e5627e13.mp3', '3L4-online-trouble.mp3', 'Online Trouble', 'Listening B2', 799252, '2026-03-09 21:38:40'),
(31, 'audio_1773074330_f3614792.mp3', '3L5-parent-teacher.mp3', 'Parent-Teacher Meeting', 'Listening B2', 1214967, '2026-03-09 21:38:43'),
(32, 'audio_1773074334_36264ab2.mp3', '3L6-answering-machine.mp3', 'Answering Machine', 'Listening B2', 955920, '2026-03-09 21:38:45'),
(33, 'audio_1773074337_46414b99.mp3', '3L7-love-is-in-the-air.mp3', 'Love Is in the Air', 'Listening C1', 1031420, '2026-03-09 21:38:47'),
(34, 'audio_1773074340_272043f0.mp3', '3L8-here-is-the-news.mp3', 'Here Is the News', 'Listening C1', 907790, '2026-03-09 21:38:49'),
(35, 'audio_1773074344_d629496e.mp3', '3L9-the-roommates.mp3', 'The Roommates', 'Listening C1', 910737, '2026-03-09 21:38:52'),
(36, 'audio_1773074347_6f7f99bf.mp3', '3L10-democracy-in-action.mp3', 'Democracy in Action', 'Listening C2', 724230, '2026-03-09 21:38:54'),
(37, 'audio_1773074351_5e554ff4.mp3', '3L11-eavesdropping.mp3', 'Eavesdropping', 'Listening C2', 1050230, '2026-03-09 21:38:58'),
(38, 'audio_1773074356_ff5ab25c.mp3', '3L12-vanuatu.mp3', 'Vanuatu', 'Listening C2', 1127709, '2026-03-09 21:39:02');

-- --------------------------------------------------------

--
-- Структура таблицы `chat_messages`
--

CREATE TABLE `chat_messages` (
  `message_id` int NOT NULL,
  `sender_id` int NOT NULL,
  `receiver_id` int NOT NULL,
  `message_text` text NOT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `chat_messages`
--

INSERT INTO `chat_messages` (`message_id`, `sender_id`, `receiver_id`, `message_text`, `is_read`, `created_at`) VALUES
(1, 28, 10, 'Здравствуйте', 1, '2026-03-04 20:10:40'),
(2, 10, 28, 'Здравствуйте, можно перенести занятие?', 1, '2026-03-04 20:11:27'),
(3, 28, 10, 'да, конечно', 1, '2026-03-04 20:12:01'),
(4, 10, 28, 'аававав', 1, '2026-03-04 20:16:36'),
(5, 28, 10, 'мивама', 1, '2026-03-04 20:17:24'),
(6, 8, 34, 'Здравствуйте', 1, '2026-04-23 17:11:54'),
(7, 34, 8, 'Добрый день', 1, '2026-04-23 17:12:15'),
(8, 34, 8, 'fchbfc', 1, '2026-04-24 18:04:49'),
(9, 8, 34, 'gh', 1, '2026-04-24 18:05:15'),
(10, 34, 8, 'hhfh', 1, '2026-04-25 10:32:33'),
(11, 8, 34, 'vhgh', 1, '2026-04-25 10:32:51'),
(12, 37, 6, 'здравствуйте, я хотел бы перенести время занятия', 1, '2026-05-04 23:06:10'),
(13, 6, 37, 'Добрый день, на какое время Вам удобно?', 0, '2026-05-04 23:23:14'),
(14, 40, 39, 'ddcd', 1, '2026-05-14 21:19:00'),
(15, 39, 40, 'csdc', 0, '2026-05-14 21:19:23');

-- --------------------------------------------------------

--
-- Структура таблицы `cities`
--

CREATE TABLE `cities` (
  `city_id` int NOT NULL,
  `city_name` varchar(100) NOT NULL,
  `region` varchar(100) DEFAULT NULL,
  `country` varchar(50) DEFAULT 'Россия',
  `is_active` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `cities`
--

INSERT INTO `cities` (`city_id`, `city_name`, `region`, `country`, `is_active`) VALUES
(1, 'Москва', 'Московская область', 'Россия', 1),
(2, 'Санкт-Петербург', 'Ленинградская область', 'Россия', 1),
(3, 'Екатеринбург', 'Свердловская область', 'Россия', 1),
(4, 'Новосибирск', 'Новосибирская область', 'Россия', 1),
(5, 'Казань', 'Татарстан', 'Россия', 1),
(6, 'Нижний Новгород', 'Нижегородская область', 'Россия', 1),
(7, 'Красноярск', 'Красноярский край', 'Россия', 1),
(8, 'Челябинск', 'Челябинская область', 'Россия', 1),
(9, 'Самара', 'Самарская область', 'Россия', 1),
(10, 'Уфа', 'Башкортостан', 'Россия', 1),
(11, 'Ростов-на-Дону', 'Ростовская область', 'Россия', 1),
(12, 'Краснодар', 'Краснодарский край', 'Россия', 1),
(13, 'Воронеж', 'Воронежская область', 'Россия', 1),
(14, 'Пермь', 'Пермский край', 'Россия', 1),
(15, 'Волгоград', 'Волгоградская область', 'Россия', 1),
(17, 'Уфалей', 'Волгоградская область', 'Россия', 1),
(18, 'Набережные Челны', 'Татарстан', 'Россия', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `levels`
--

CREATE TABLE `levels` (
  `level_id` int NOT NULL,
  `level_code` varchar(10) NOT NULL,
  `level_name` varchar(50) NOT NULL,
  `description` text,
  `min_score` int DEFAULT '0',
  `max_score` int DEFAULT '100'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `levels`
--

INSERT INTO `levels` (`level_id`, `level_code`, `level_name`, `description`, `min_score`, `max_score`) VALUES
(1, 'A1', 'Beginner', 'Понимание и использование знакомых повседневных выражений и простейших фраз для удовлетворения базовых потребностей.', 0, 100),
(2, 'A2', 'Elementary', 'Понимание предложений и часто используемых выражений, связанных с основными сферами жизни (покупки, семья, работа).', 0, 100),
(3, 'B1', 'Intermediate', 'Понимание основных идей текстов на знакомые темы. Умение описать впечатления, события, надежды и стремления.', 0, 100),
(4, 'B2', 'Upper Intermediate', 'Понимание основного содержания сложных текстов. Свободное общение с носителями языка без затруднений для обеих сторон.', 0, 100),
(5, 'C1', 'Advanced', 'Понимание широкого спектра сложных и объёмных текстов. Свободное и спонтанное владение языком в социальной, учебной и профессиональной сферах.', 0, 100),
(6, 'C2', 'Mastery', 'Свободное понимание практически всего услышанного или прочитанного. Умение обобщать информацию из различных источников и выражать мысли связно и точно.', 0, 100);

-- --------------------------------------------------------

--
-- Структура таблицы `modules`
--

CREATE TABLE `modules` (
  `module_id` int NOT NULL,
  `level_id` int NOT NULL,
  `module_name` varchar(100) NOT NULL,
  `description` text,
  `module_type` enum('grammar','vocabulary','reading','listening') NOT NULL,
  `order_number` int DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `modules`
--

INSERT INTO `modules` (`module_id`, `level_id`, `module_name`, `description`, `module_type`, `order_number`, `is_active`) VALUES
(1, 1, 'Основы грамматики A1', 'Базовые грамматические конструкции для начинающих', 'grammar', 1, 1),
(2, 1, 'Базовый словарный запас A1', 'Важные слова для общения', 'vocabulary', 2, 1),
(3, 1, 'Простое чтение A1', 'Короткие тексты и диалоги для начинающих', 'reading', 3, 1),
(4, 2, 'Грамматика A2', 'Past Simple и основы повествования', 'grammar', 1, 1),
(5, 2, 'Словарь A2', 'Расширенная лексика', 'vocabulary', 2, 1),
(6, 2, 'Чтение A2', 'Рассказы и истории среднего уровня', 'reading', 3, 1),
(7, 3, 'Грамматика B1', 'Present Perfect и сложные конструкции', 'grammar', 1, 1),
(8, 3, 'Словарь B1', 'Деловой английский и специализированная лексика', 'vocabulary', 2, 1),
(9, 3, 'Чтение B1', 'Статьи и аналитические тексты', 'reading', 3, 1),
(10, 4, 'Грамматика B2', 'Условные предложения всех типов', 'grammar', 1, 1),
(11, 4, 'Словарь B2', 'Научная и академическая лексика', 'vocabulary', 2, 1),
(12, 4, 'Чтение B2', 'Художественная литература', 'reading', 3, 1),
(13, 5, 'Грамматика C1', 'Косвенная речь и стилистика', 'grammar', 1, 1),
(14, 5, 'Словарь C1', 'Идиомы и фразовые глаголы', 'vocabulary', 2, 1),
(15, 5, 'Чтение C1', 'Академические и научные тексты', 'reading', 3, 1),
(16, 6, 'Грамматика C2', 'Продвинутые синтаксические конструкции', 'grammar', 1, 1),
(17, 6, 'Словарь C2', 'Редкие и сложные слова английского', 'vocabulary', 2, 1),
(18, 6, 'Чтение C2', 'Философские и сложные тексты', 'reading', 3, 1),
(20, 1, 'Аудирование A1', 'Понимание простых фраз и диалогов на слух для начинающих', 'listening', 4, 1),
(21, 2, 'Аудирование A2', 'Понимание коротких бесед и объявлений на повседневные темы', 'listening', 4, 1),
(22, 3, 'Аудирование B1', 'Понимание основного содержания разговоров и радиопередач на знакомые темы', 'listening', 4, 1),
(23, 4, 'Аудирование B2', 'Понимание развёрнутых докладов и лекций на сложные темы', 'listening', 4, 1),
(24, 5, 'Аудирование C1', 'Понимание длинных высказываний даже при нечёткой структуре и скрытых связях', 'listening', 4, 1),
(25, 6, 'Аудирование C2', 'Свободное понимание любой устной речи в живом и транслируемом виде', 'listening', 4, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `tasks`
--

CREATE TABLE `tasks` (
  `task_id` int NOT NULL,
  `module_id` int NOT NULL,
  `task_text` text NOT NULL,
  `audio_file` varchar(255) DEFAULT NULL,
  `instruction` text,
  `task_type` enum('multiple_choice','fill_blank','listening') NOT NULL,
  `difficulty_level` varchar(10) NOT NULL,
  `correct_answer` text NOT NULL,
  `points` int DEFAULT '10',
  `explanation` text,
  `is_active` tinyint(1) DEFAULT '1',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `tasks`
--

INSERT INTO `tasks` (`task_id`, `module_id`, `task_text`, `audio_file`, `instruction`, `task_type`, `difficulty_level`, `correct_answer`, `points`, `explanation`, `is_active`, `updated_at`) VALUES
(1, 1, 'Выберите правильный вариант: \"Hello, ___ name is John.\"', NULL, 'Выберите правильное притяжательное местоимение для заполнения пропуска.', 'multiple_choice', 'A1', 'my', 5, 'В английском языке используется притяжательное местоимение \"my\"', 1, '2026-02-25 12:23:15'),
(2, 1, 'Заполните пропуск: \"I ___ from London.\"', NULL, 'Выберите правильную форму глагола to be.', 'multiple_choice', 'A1', 'am', 5, 'С местоимением \"I\" используется глагол \"am\"', 1, '2026-02-25 12:34:38'),
(3, 1, 'Выберите правильный вопрос: \"___ are you?\"', NULL, 'Выберите подходящее вопросительное слово для этого вопроса.', 'multiple_choice', 'A1', 'How', 5, '\"How are you?\" - стандартный вопрос о самочувствии', 1, '2026-02-25 12:23:15'),
(4, 1, 'Заполните: \"What ___ your name?\"', NULL, 'Выберите правильную форму глагола to be.', 'multiple_choice', 'A1', 'is', 5, 'С существительным в единственном числе используется \"is\"', 1, '2026-02-25 12:34:15'),
(5, 2, 'Переведите слово \"house\"', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'A1', 'дом', 5, 'House - отдельно стоящий дом', 1, '2026-02-25 14:08:31'),
(6, 2, 'Что означает \"book\"?', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'A1', 'книга', 5, 'Book - книга для чтения', 1, '2026-02-25 14:08:35'),
(7, 2, 'Переведите \"семья\" на английский', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'A1', 'family', 5, 'Family - семья, родственники', 1, '2026-02-25 14:08:40'),
(8, 2, 'Что означает \"water\"?', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'A1', 'вода', 5, 'Water - вода, жидкость', 1, '2026-02-25 14:08:47'),
(9, 2, 'Переведите \"friend\"', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'A1', 'друг', 5, 'Friend - друг или подруга', 1, '2026-02-25 14:09:42'),
(10, 2, 'Что означает \"school\"?', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'A1', 'школа', 5, 'School - учебное заведение', 1, '2026-02-25 14:09:52'),
(11, 2, 'Переведите \"работа\" на английский', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'A1', 'work', 5, 'Work - работа, трудовая деятельность', 1, '2026-02-25 14:09:56'),
(12, 2, 'Что означает \"city\"?', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'A1', 'город', 5, 'City - крупный город', 1, '2026-02-25 14:10:03'),
(13, 3, 'Прочитайте: \"Tom has a cat. The cat is black.\" Какого цвета кот?', NULL, 'Прочитайте предложения и выберите правильный ответ на вопрос.', 'multiple_choice', 'A1', 'black', 5, 'Из текста следует: \"The cat is black\"', 1, '2026-02-25 13:39:29'),
(14, 3, 'Прочитайте текст и ответьте на вопрос:\n\n\"Hi! My name is Anna. I am from London. I am 25 years old. I have a cat. My cat is black and white.\"\n\nСколько лет Анне?', NULL, 'Прочитайте текст. Выберите правильный ответ на вопрос.', 'multiple_choice', 'A1', '25', 5, 'В тексте сказано: \"I am 25 years old.\"', 1, '2026-02-25 16:14:58'),
(15, 3, 'Прочитайте: \"Anna is a teacher.\" Кто Анна?', NULL, 'Прочитайте предложение и выберите правильный ответ на вопрос.', 'multiple_choice', 'A1', 'a teacher', 5, 'Прямо указано в тексте', 1, '2026-02-25 13:39:40'),
(16, 3, 'Прочитайте текст и ответьте на вопрос:\n\n\"Tom is a student. He studies at London University. He lives with his family. His parents are teachers.\"\n\nГде учится Том?', NULL, 'Прочитайте текст. Выберите правильный ответ на вопрос.', 'multiple_choice', 'A1', 'at London University', 5, 'В тексте сказано: \"He studies at London University.\"', 1, '2026-02-25 16:14:50'),
(21, 4, 'I___ to the cinema yesterday.', NULL, 'Выберите правильную форму глагола go в Past Simple.', 'multiple_choice', 'A2', 'went', 5, 'Past simple от go - went', 1, '2026-02-25 14:11:20'),
(22, 4, 'She ___ a book last week.', NULL, 'Выберите правильную форму глагола read в Past Simple.', 'multiple_choice', 'A2', 'read', 5, 'Read (прошлое) - read (произношение \"red\")', 1, '2026-02-25 14:11:31'),
(23, 4, 'They ____ football yesterday.', NULL, 'Поставьте глагол play в правильную форму времени.', 'fill_blank', 'A2', 'played', 5, 'Regular verb + ed (Past Simple)', 1, '2026-02-25 14:12:46'),
(24, 4, 'I ____ TV in the evening.', NULL, 'Поставьте глагол watch в форму Past Simple.', 'fill_blank', 'A2', 'watched', 5, 'Watch → watched', 1, '2026-02-25 14:13:22'),
(25, 4, 'She didn\'t ___ to school yesterday.', NULL, 'Поставьте глагол go в форму Past Simple для отрицательного предложения.', 'fill_blank', 'A2', 'go', 5, 'Did not go → didn\'t go. Когда есть did глагол не изменяется', 1, '2026-02-25 14:15:09'),
(26, 4, 'We ___ to Paris last year.', NULL, 'Выберите правильную форму глагола travel.', 'multiple_choice', 'A2', 'traveled', 5, 'Travel → traveled (амер.) / travelled (брит.) (Past Simple)', 1, '2026-02-25 14:15:47'),
(27, 5, 'Переведите \"environment\"', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'A2', 'окружающая среда', 5, 'Environment - окружающая среда', 1, '2026-02-25 14:16:27'),
(28, 5, 'Что означает \"opportunity\"?', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'A2', 'возможность', 5, 'Opportunity - шанс, возможность', 1, '2026-02-25 14:16:31'),
(29, 5, 'Переведите \"development\"', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'A2', 'развитие', 5, 'Development - развитие, рост', 1, '2026-02-25 14:16:34'),
(30, 5, 'Что означает \"government\"?', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'A2', 'правительство', 5, 'Government - государственная власть', 1, '2026-02-25 14:16:37'),
(31, 5, 'Переведите \"education\"', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'A2', 'образование', 5, 'Education - обучение, образование', 1, '2026-02-25 14:16:40'),
(32, 5, 'Что означает \"information\"?', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'A2', 'информация', 5, 'Information - сведения, данные', 1, '2026-02-25 14:16:43'),
(33, 5, 'Переведите \"technology\"', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'A2', 'технология', 5, 'Technology - технические средства', 1, '2026-02-25 14:16:46'),
(34, 6, 'Прочитайте: \"Yesterday was Monday. Today is Tuesday.\" Какой сегодня день?', NULL, 'Прочитайте предложения и выберите правильный ответ на вопрос.', 'multiple_choice', 'A2', 'Tuesday', 5, 'Из текста: \"Today is Tuesday\"', 1, '2026-02-25 12:23:15'),
(35, 6, 'Прочитайте текст и ответьте на вопрос:\n\n\"Last summer, the Wilson family went to Italy. They visited Rome and Florence. They saw the Colosseum and ate Italian pizza. The weather was hot and sunny. They stayed for two weeks.\"\n\n\nКак долго семья Уилсонов пробыла в Италии?', NULL, 'Прочитайте текст. Выберите правильный ответ на вопрос.', 'multiple_choice', 'A2', 'two weeks', 5, 'В тексте сказано: \"They stayed for two weeks.\"', 1, '2026-02-25 16:17:40'),
(36, 6, 'Прочитайте: \"She usually reads books in the evening.\" Когда она читает?', NULL, 'Прочитайте предложение и выберите правильный ответ на вопрос.', 'multiple_choice', 'A2', 'in the evening', 5, 'Прямо указано в тексте', 1, '2026-02-25 12:23:15'),
(37, 6, 'Прочитайте текст и ответьте на вопрос:\n\n\"Maria is from Spain. She moved to London two years ago. Now she works in a hotel. She speaks Spanish and English. She wants to learn French next year.\"\n\nКак долго Мария живет в Лондоне?', NULL, 'Прочитайте текст. Выберите правильный ответ на вопрос.', 'multiple_choice', 'A2', 'two years', 5, 'В тексте сказано: \"She moved to London two years ago.\"', 1, '2026-02-25 16:18:06'),
(38, 6, 'Прочитайте: \"If it rains, we will stay at home.\" Что произойдет если пойдет дождь?', NULL, 'Прочитайте предложения и выберите правильный ответ на вопрос.', 'multiple_choice', 'A2', 'stay at home', 5, 'Условное предложение первого типа', 1, '2026-02-25 14:18:27'),
(39, 6, 'Прочитайте текст и ответьте на вопрос:\n\n\"Tom and Sarah are students. Tom studies medicine. Sarah studies art. Tom has classes every day. Sarah has classes three times a week. On weekends, they both work at a café.\"\n\nКак часто у Сары бывают занятия?', NULL, 'Прочитайте текст. Выберите правильный ответ на вопрос.', 'multiple_choice', 'A2', 'three times a week', 5, 'В тексте сказано: \"Sarah has classes three times a week.\"', 1, '2026-02-25 16:18:25'),
(40, 6, 'Прочитайте: \"The movie was interesting but too long.\" Каким был фильм?', NULL, 'Прочитайте предложения и выберите правильный ответ на вопрос.', 'multiple_choice', 'A2', 'interesting but long', 5, 'Из описания фильма', 1, '2026-02-25 14:18:56'),
(41, 7, 'Выберите правильный вариант: \"I ___ here since 2010.\"', NULL, 'Выберите правильную форму Present Perfect.', 'multiple_choice', 'B1', 'have lived', 10, 'Present Perfect используется для действия, начавшегося в прошлом и продолжающегося до сих пор', 1, '2026-02-25 14:19:17'),
(42, 7, 'Заполните пропуск: \"If I ___  you, I would go there.\"', NULL, 'Выберите правильную форму глагола be.', 'multiple_choice', 'B1', 'were', 10, 'В сослагательном наклонении (Second Conditional) используется form \"were\" для всех лиц', 1, '2026-02-25 14:20:12'),
(43, 7, 'Заполните: \"This house ___  in 1995.\"', NULL, 'Поставьте глагол build в форму Past Simple Passive.', 'fill_blank', 'B1', 'was built', 10, 'Passive Voice в прошедшем времени (Past Simple Passive)', 1, '2026-02-25 14:20:36'),
(44, 7, 'Выберите: \"He told me that he ___ the work.\"', NULL, 'Выберите правильную форму для слова finish.', 'multiple_choice', 'B1', 'had finished', 10, 'Past Perfect используется в косвенной речи для предшествующего действия', 1, '2026-02-25 14:20:57'),
(45, 7, 'Заполните пропуск: \"I’m looking forward to ___ you.\"', NULL, 'Выберите правильную форму глагола meet', 'multiple_choice', 'B1', 'meeting', 10, 'После фразы \"look forward to\" используется герундий (-ing)', 1, '2026-02-25 14:21:52'),
(46, 7, 'Заполните: \"She ___ when the phone rang.\"', NULL, 'Поставьте глагол work в форму Past Continuous.', 'fill_blank', 'B1', 'was working', 10, 'Past Continuous для длительного процесса, прерванного другим действием', 1, '2026-02-25 14:22:15'),
(47, 8, 'Переведите слово \"entrepreneur\"', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'B1', 'предприниматель', 10, 'Entrepreneur - человек, организующий бизнес', 1, '2026-02-25 14:22:35'),
(48, 8, 'Что означает фразовый глагол \"put off\"?', NULL, 'Выберите правильное значение фразового глагола \"put off\".', 'multiple_choice', 'B1', 'откладывать', 10, 'To put off - перенести встречу или событие на более поздний срок', 1, '2026-02-25 12:23:15'),
(49, 8, 'Переведите \"переговоры\" на английский', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'B1', 'negotiations', 10, 'Negotiations - официальное обсуждение условий', 1, '2026-02-25 14:22:46'),
(50, 8, 'Что означает слово \"advantage\"?', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'B1', 'преимущество', 10, 'Advantage - положительная сторона чего-либо', 1, '2026-02-25 14:23:01'),
(51, 8, 'Переведите \"ответственность\"', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'B1', 'responsibility', 10, 'Responsibility - обязанность отвечать за что-либо', 1, '2026-02-25 14:23:04'),
(52, 8, 'Выберите синоним к слову \"decrease\"', NULL, 'Выберите слово, которое является синонимом слова \"decrease\" (уменьшать).', 'multiple_choice', 'B1', 'reduce', 10, 'Reduce и decrease означают уменьшение', 1, '2026-02-25 12:23:15'),
(53, 9, 'Прочитайте: \"Despite the delay, we arrived on time.\" Мы опоздали?', NULL, 'Прочитайте предложения и выберите правильный ответ на вопрос.', 'multiple_choice', 'B1', 'no', 10, 'Despite the delay означает \"несмотря на задержку\"', 1, '2026-02-25 14:23:32'),
(54, 9, 'Заполните: \"The meeting was cancelled ___ the rain.\"', NULL, 'Выберите правильный предлог причины для заполнения пропуска.', 'multiple_choice', 'B1', 'due to', 10, 'Due to используется для указания причины', 1, '2026-02-25 14:23:49'),
(55, 9, 'Прочитайте: \"I managed to solve the problem.\" Я решил проблему?', NULL, 'Прочитайте предложения и выберите правильный ответ на вопрос.', 'multiple_choice', 'B1', 'yes', 10, 'Manage to - успешно справиться с чем-то сложным', 1, '2026-02-25 14:23:55'),
(56, 9, 'Прочитайте текст и определите, правдиво ли утверждение:\n\n\"The Eiffel Tower is one of the most famous landmarks in the world. It is located in Paris, France. It was built in 1889. About 7 million people visit it every year. It is 330 meters tall.\"\n\nУтверждение: The Eiffel Tower was built in the 19th century.', NULL, 'Прочитайте текст. Определите, соответствует ли утверждение содержанию текста.', 'multiple_choice', 'B1', 'true', 10, 'Текст говорит: \"It was built in 1889.\" 1889 год относится к 19 веку.', 1, '2026-02-25 16:03:19'),
(57, 9, 'Прочитайте: \"The shop is open daily except Sundays.\" Можно ли прийти в воскресенье?', NULL, 'Прочитайте предложения и выберите правильный ответ на вопрос.', 'multiple_choice', 'B1', 'no', 10, 'Except Sundays означает \"кроме воскресений\"', 1, '2026-02-25 14:25:14'),
(58, 9, 'Прочитайте текст и выберите правильное утверждение:\n\n\"Many people believe that breakfast is the most important meal of the day. However, recent studies show that skipping breakfast may not be harmful for everyone. It depends on individual health needs and daily routines.\"\n\nЧто говорят последние исследования?', NULL, 'Прочитайте текст. Выберите правильный ответ на вопрос.', 'multiple_choice', 'B1', 'Skipping breakfast may not be harmful for everyone', 10, 'В тексте сказано: \"Recent studies show that skipping breakfast may not be harmful for everyone.\"', 1, '2026-02-25 16:03:19'),
(59, 9, 'Прочитайте: \"You should avoid eating fast food.\" Рекомендуется ли есть фастфуд?', NULL, 'Прочитайте предложения и выберите правильный ответ на вопрос.', 'multiple_choice', 'B1', 'no', 10, 'Avoid - избегать', 1, '2026-02-25 14:25:43'),
(60, 9, 'Прочитайте текст и ответьте на вопрос:\n\n\"Working from home has become common after the pandemic. Many people enjoy the flexibility, but others miss office communication. Some companies now offer hybrid models where employees work both from home and the office.\"\n\nЧто такое гибридная модель работы?', NULL, 'Прочитайте текст. Выберите правильный ответ на вопрос.', 'multiple_choice', 'B1', 'Working both from home and the office', 10, 'В тексте сказано: \"hybrid models where employees work both from home and the office.\"', 1, '2026-02-25 16:19:35'),
(61, 10, 'Выберите вариант: \"I wish I ___ about the meeting yesterday.\"', NULL, 'Выберите правильную форму для конструкции \"I wish\" о прошлом (сожаление: wish + Past Perfect). ', 'multiple_choice', 'B2', 'had known', 15, 'Regret about the past: wish + Past Perfect', 1, '2026-02-25 13:52:25'),
(62, 10, 'Заполните: \"By next year, I ___ my project.\"', NULL, 'Выберите правильную форму Future Perfect для действия, которое завершится к сроку в будущем.', 'multiple_choice', 'B2', 'will have completed', 15, 'Future Perfect для действия, которое завершится к сроку в будущем', 1, '2026-02-25 13:52:45'),
(63, 10, 'Заполните: \"It\'s about time you ___ a job.\"', NULL, 'Поставьте глагол find в правильную форму (Past Simple).', 'fill_blank', 'B2', 'found', 15, 'После \"It\'s about time\" используется Past Simple', 1, '2026-02-25 14:29:04'),
(64, 10, 'Выберите: \"He is said ___ the best doctor in town.\"', NULL, 'Выберите правильную форму инфинитива be для сложного пассивного оборота.', 'multiple_choice', 'B2', 'to be', 15, 'Complex Nominative (Passive Reporting Structure)', 1, '2026-02-25 14:29:57'),
(65, 10, 'Заполните: \"I\'d rather you ___ anyone my secret.\"', NULL, 'Поставьте глагол tell с отрицанием (not/tell) в правильную форму.', 'fill_blank', 'B2', 'didn\'t tell', 15, 'I\'d rather someone did something - сослагательное наклонение', 1, '2026-02-25 14:31:10'),
(66, 10, 'Выберите: \"___ the report, he went home.\"', NULL, 'Выберите правильную форму Perfect Participle для подчёркивания завершённости действия.', 'multiple_choice', 'B2', 'Having finished', 15, 'Perfect Participle для подчеркивания завершенности действия', 1, '2026-02-25 14:31:30'),
(67, 11, 'Переведите слово \"ambiguous\"', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'B2', 'двусмысленный', 15, 'Ambiguous - неясный, имеющий два значения', 1, '2026-02-25 14:31:55'),
(68, 11, 'Что означает идиома \"to face the music\"?', NULL, 'Выберите правильное значение идиомы.', 'multiple_choice', 'B2', 'принять последствия', 15, 'To face the music - нести ответственность за свои ошибки', 1, '2026-02-25 14:32:02'),
(69, 11, 'Переведите \"окружающая среда\" (более формально)', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'B2', 'environment', 15, 'Environment - среда обитания, природа', 1, '2026-02-25 14:32:13'),
(70, 11, 'Что означает слово \"inevitable\"?', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'B2', 'неизбежный', 15, 'Inevitable - то, чего нельзя избежать', 1, '2026-02-25 14:32:23'),
(71, 11, 'Переведите \"подчеркивать/акцентировать\"', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'B2', 'emphasize', 15, 'To emphasize - выделять что-то важное', 1, '2026-02-25 14:32:27'),
(72, 11, 'Что означает фразовый глагол \"look down on\"?', NULL, 'Выберите правильное значение фразового глагола.', 'multiple_choice', 'B2', 'смотреть свысока', 15, 'Считать кого-то ниже себя или хуже', 1, '2026-02-25 14:32:37'),
(73, 12, 'Прочитайте: \"The movie was highly acclaimed by critics.\" Понравился ли фильм критикам?', NULL, 'Прочитайте предложение и выберите правильный ответ на вопрос.', 'multiple_choice', 'B2', 'yes', 15, 'Acclaimed - получивший признание, одобрение', 1, '2026-02-25 14:32:52'),
(74, 12, 'Прочитайте текст и определите позицию автора:\n\n\"Some argue that social media has improved communication by connecting people across the globe. However, evidence suggests that it may actually increase feelings of loneliness and anxiety, especially among young users. The constant comparison with others\' curated lives can lead to decreased self-esteem.\"\n\nКак автор относится к влиянию социальных сетей?', NULL, 'Прочитайте текст. Выберите правильный ответ, отражающий позицию автора.', 'multiple_choice', 'B2', 'Social media may have negative effects', 15, 'Автор приводит аргументы о негативных эффектах: loneliness, anxiety, decreased self-esteem.', 1, '2026-02-25 16:03:19'),
(75, 12, 'Прочитайте: \"She was so engrossed in the book that she forgot to eat.\" Ей была интересна книга?', NULL, 'Прочитайте предложение и выберите правильный ответ на вопрос.', 'multiple_choice', 'B2', 'yes', 15, 'Engrossed in - поглощен чем-либо полностью', 1, '2026-02-25 14:33:58'),
(76, 12, 'Прочитайте текст и ответьте на вопрос:\n\n\"The concept of \"slow living\" has gained popularity in recent years. It encourages people to step away from constant busyness and instead focus on meaningful activities. Proponents argue that this lifestyle reduces stress and improves overall well-being, though critics say it is a luxury not everyone can afford.\"\n\nКакая критика приводится в адрес slow living?', NULL, 'Прочитайте текст. Выберите правильный ответ на вопрос.', 'multiple_choice', 'B2', 'It is a luxury not everyone can afford', 15, 'В тексте сказано: \"critics say it is a luxury not everyone can afford.\"', 1, '2026-02-25 16:03:20'),
(77, 12, 'Прочитайте: \"Unless you study, you won\'t pass.\" Нужно ли учиться для сдачи?', NULL, 'Прочитайте предложение и выберите правильный ответ на вопрос.', 'multiple_choice', 'B2', 'yes', 15, 'Unless = if not (пока не / если не)', 1, '2026-02-25 14:34:24'),
(78, 12, 'Прочитайте текст и выберите заголовок, который лучше всего отражает главную идею:\n\n\"Artificial intelligence is transforming industries from healthcare to finance. In medicine, AI helps doctors diagnose diseases more accurately. In finance, it detects fraudulent transactions. However, concerns about job displacement and ethical use of AI remain unresolved.\"\n\nВыберите заголовок для текста:', NULL, 'Прочитайте текст. Выберите заголовок, который лучше всего отражает главную идею.', 'multiple_choice', 'B2', 'The Impact of AI on Various Industries', 15, 'Текст описывает влияние AI на разные сферы и упоминает проблемы.', 1, '2026-02-25 16:03:20'),
(79, 12, 'Прочитайте: \"The results were consistent with our theory.\" Результаты совпали?', NULL, 'Прочитайте предложение и выберите правильный ответ на вопрос.', 'multiple_choice', 'B2', 'yes', 15, 'Consistent with - соответствующий чему-либо, согласующийся', 1, '2026-02-25 14:35:09'),
(80, 12, 'Прочитайте текст и найдите слово, которое значит \"to change something to suit new conditions\":\n\n\"Climate change is forcing many species to adapt to new environments. Animals that cannot adjust quickly enough may face extinction. Scientists are studying how different species respond to rising temperatures and changing weather patterns.\"\n\nКакое слово в тексте означает \"приспосабливаться\"?', NULL, 'Прочитайте текст. Найдите слово, соответствующее данному определению.', 'multiple_choice', 'B2', 'adapt', 15, 'Слово \"adapt\" означает приспосабливаться к новым условиям.', 1, '2026-02-25 16:03:20'),
(81, 13, 'Выберите правильную форму: \"Were it not for your help, I ___ in trouble.\"', NULL, 'Выберите правильную форму глагола (be) для инвертированного условного периода.', 'multiple_choice', 'C1', 'would be', 20, 'Инвертированный условный период (Conditionals inversion)', 1, '2026-02-25 14:37:13'),
(82, 13, 'Заполните пропуск: \"Never ___ such a masterpiece.\"', NULL, 'Поставьте глагол see в форму с отрицательной инверсией (I/see) ', 'fill_blank', 'C1', 'have I seen', 20, 'Отрицательная инверсия для усиления смысла предложения', 1, '2026-02-25 14:37:27'),
(83, 13, 'Выберите вариант: \"Such ___ the force of the wind that trees fell.\"', NULL, 'Выберите правильную форму глагола be для эмфатической структуры.', 'multiple_choice', 'C1', 'was', 20, 'Эмфатическая структура с Such + inversion', 1, '2026-02-25 14:38:25'),
(84, 13, 'Заполните: \"Try ___ , he couldn\'t open the door.\"', NULL, 'Заполните пропуск уступительной конструкцией с инверсией  (he/might).', 'fill_blank', 'C1', 'as he might', 20, 'Уступчивое предложение (Concession) с инверсией', 1, '2026-02-25 14:39:06'),
(85, 13, 'Заполните: \"Under no circumstances ___ sign this.\"', NULL, 'Поставьте модальный глагол в форму с инверсией (you/should).', 'fill_blank', 'C1', 'should you', 20, 'Инверсия после негативного выражения \"Under no circumstances\"', 1, '2026-02-25 14:39:01'),
(86, 13, 'Выберите: \"He acted as if he ___ the boss.\"', NULL, 'Выберите правильную форму глагола be.', 'multiple_choice', 'C1', 'were', 20, 'Unreal present после \"as if\"', 1, '2026-02-25 14:39:28'),
(87, 14, 'Что означает слово \"ubiquitous\"?', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'C1', 'вездесущий', 20, 'Ubiquitous - находящийся везде одновременно', 1, '2026-02-25 14:39:56'),
(88, 14, 'Переведите слово \"resilient\"', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'C1', 'стойкий', 20, 'Resilient - способный быстро восстанавливаться после трудностей', 1, '2026-02-25 14:40:06'),
(89, 14, 'Что означает идиома \"to take with a grain of salt\"?', NULL, 'Выберите правильное значение идиомы.', 'multiple_choice', 'C1', 'относиться скептически', 20, 'Означает не верить информации на 100%', 1, '2026-02-25 14:40:14'),
(90, 14, 'Переведите \"осуществимый/выполнимый\"', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'C1', 'feasible', 20, 'Feasible - то, что реально можно сделать', 1, '2026-02-25 14:40:18'),
(91, 14, 'Что означает слово \"mitigate\"?', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'C1', 'смягчать', 20, 'To mitigate - уменьшать суровость или болезненность чего-либо', 1, '2026-02-25 14:40:23'),
(92, 14, 'Выберите синоним к слову \"perplexed\"', NULL, 'Выберите слово, которое является синонимом слова \"perplexed\".', 'multiple_choice', 'C1', 'confused', 20, 'Обе формы означают замешательство или растерянность', 1, '2026-02-25 14:40:45'),
(93, 15, 'Прочитайте: \"The evidence was inconclusive.\" Помогли ли доказательства?', NULL, 'Прочитайте предложение и выберите правильный ответ на вопрос.', 'multiple_choice', 'C1', 'no', 20, 'Inconclusive - неубедительный, не дающий окончательного результата', 1, '2026-02-25 14:41:00'),
(94, 15, 'Прочитайте текст и ответьте на вопрос:\n\n\"The rescue team worked through the night to save the stranded climbers. But for their help, the climbers would not have survived the freezing temperatures. The operation was dangerous, but the team\'s training and experience made it possible.\"\n\nWhat would have happened to the climbers without the rescue team?', NULL, 'Прочитайте текст. Выберите правильный ответ на вопрос.', 'multiple_choice', 'C1', 'They would not have survived', 20, 'В тексте сказано: \"But for their help, the climbers would not have survived.\"', 1, '2026-02-25 16:33:39'),
(95, 15, 'Прочитайте: \"The manager alluded to future changes.\" Менеджер прямо сказал о них?', NULL, 'Прочитайте предложение и выберите правильный ответ на вопрос.', 'multiple_choice', 'C1', 'no', 20, 'To allude to - намекать, косвенно упоминать', 1, '2026-02-25 14:42:04'),
(96, 15, 'Прочитайте текст и ответьте на вопрос:\n\n\"Sarah waited anxiously for news about her brother\'s flight. The plane was delayed due to bad weather. Only after hearing his voice on the phone did she finally relax and stop worrying.\"\n\nWhen did Sarah stop worrying?', NULL, 'Прочитайте текст. Выберите правильный ответ на вопрос.', 'multiple_choice', 'C1', 'After hearing his voice', 20, 'В тексте сказано: \"Only after hearing his voice on the phone did she finally relax.\"', 1, '2026-02-25 16:33:39'),
(97, 15, 'Прочитайте: \"He is second to none in chemistry.\" Насколько он хорош?', NULL, 'Прочитайте предложение с идиомой \"second to none\" и выберите правильный ответ об уровне мастерства.', 'multiple_choice', 'C1', 'the best', 20, 'Second to none - лучший, никому не уступающий', 1, '2026-02-25 12:23:16'),
(98, 15, 'Прочитайте текст и ответьте на вопрос:\n\n\"The employees worked hard all year, hoping for a bonus. Little did they know that the company was planning to close the entire department. The announcement came as a complete shock to everyone.\"\n\nWhat didn\'t the employees know?', NULL, 'Прочитайте текст. Выберите правильный ответ на вопрос.', 'multiple_choice', 'C1', 'The company was closing the department', 20, 'В тексте сказано: \"Little did they know that the company was planning to close the entire department.\"', 1, '2026-02-25 16:33:39'),
(99, 15, 'Прочитайте: \"The law was repealed.\" Закон все еще действует?', NULL, 'Прочитайте предложение и выберите правильный ответ на вопрос.', 'multiple_choice', 'C1', 'no', 20, 'To repeal - аннулировать или отменить закон', 1, '2026-02-25 14:43:16'),
(100, 15, 'Прочитайте текст и ответьте на вопрос:\n\n\"The hotel provides 24-hour customer service for all guests. Should you require any assistance during your stay, simply dial 0 from your room phone. Staff are always ready to help with any questions or problems.\"\n\nWhat should guests do if they need help?', NULL, 'Прочитайте текст. Выберите правильный ответ на вопрос.', 'multiple_choice', 'C1', 'Dial 0 from their room phone', 20, 'В тексте сказано: \"Should you require any assistance, simply dial 0 from your room phone.\"', 1, '2026-02-25 16:33:39'),
(101, 16, 'Выберите форму: \"If the project ___ to fail, the company would fold.\"', NULL, 'Выберите правильную форму глагола be для гипотетического будущего.', 'multiple_choice', 'C2', 'were', 25, 'Unreal future hypothesis (Was/Were to structure)', 1, '2026-02-25 14:43:54'),
(102, 16, 'Заполните: \"___ it not for your intervention, the deal would have collapsed.\"', NULL, 'Поставьте правильное вспомогательное слово (be) в правильной форме для формальной инверсии Third Conditional', 'fill_blank', 'C2', 'Had', 25, 'Формальная инверсия Third Conditional', 1, '2026-02-25 14:45:13'),
(103, 16, 'Заполните: \"I would rather you ___ this at the gala yesterday.\"', NULL, 'Поставьте глагол mention в правильную форму с отрицанием. (not/mention)', 'fill_blank', 'C2', 'hadn\'t mentioned', 25, 'Would rather + Past Perfect для сожалений о прошлом', 1, '2026-02-25 14:45:48'),
(104, 16, 'Выберите: \"It is imperative that the CEO ___ the meeting.\"', NULL, 'Выберите правильную форму глагола attend для Mandative Subjunctive.', 'multiple_choice', 'C2', 'attend', 25, 'Mandative Subjunctive (без окончания -s)', 1, '2026-02-25 14:46:05'),
(105, 16, 'Заполните: \"___ I to tell you the truth, you wouldn\'t believe me.\"', NULL, 'Поставьте правильное вспомогательное слово (be) для инверсии Second Conditional в нужной форме.', 'fill_blank', 'C2', 'Were', 25, 'Inversion of Second Conditional', 1, '2026-02-25 14:46:40'),
(106, 16, 'Выберите: \"He spoke as though he ___ the event himself.\"', NULL, 'Выберите правильную форму глагола witness для нереального прошлого .', 'multiple_choice', 'C2', 'had witnessed', 25, 'Unreal past after \"as though\"', 1, '2026-02-25 14:47:04'),
(107, 17, 'Что означает слово \"panacea\"?', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'C2', 'универсальное средство', 25, 'Panacea - решение всех проблем или лекарство от всех болезней', 1, '2026-02-25 14:47:29'),
(108, 17, 'Переведите слово \"ephemeral\"', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'C2', 'эфемерный', 25, 'Ephemeral - мимолетный, существующий очень короткое время', 1, '2026-02-25 14:47:33'),
(109, 17, 'Что означает слово \"cacophony\"?', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'C2', 'какофония', 25, 'Cacophony - резкое, неприятное сочетание звуков', 1, '2026-02-25 14:47:37'),
(110, 17, 'Переведите \"quintessential\"', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'C2', 'наиболее типичный', 25, 'Quintessential - представляющий наиболее совершенный пример чего-либо', 1, '2026-02-25 14:47:40'),
(111, 17, 'Что означает глагол \"to abdicate\"?', NULL, 'Выберите правильный перевод слова.', 'multiple_choice', 'C2', 'отрекаться', 25, 'To abdicate - официально отказаться от трона или власти', 1, '2026-02-25 14:47:44'),
(112, 17, 'Выберите синоним к слову \"serendipity\"', NULL, 'Выберите слово или фразу, которая является синонимом слова \"serendipity\".', 'multiple_choice', 'C2', 'happy accident', 25, 'Serendipity - счастливая случайность, интуитивная прозорливость', 1, '2026-02-25 12:23:16'),
(113, 18, 'Прочитайте: \"The argument is flawed by a logical fallacy.\" Верно ли утверждение?', NULL, 'Прочитайте предложение и выберите правильный ответ на вопрос.', 'multiple_choice', 'C2', 'no', 25, 'Fallacy - заблуждение, ошибка в логике', 1, '2026-02-25 14:48:23'),
(114, 18, 'Прочитайте текст и ответьте на вопрос:\n\n\"The young scientist presented her research findings at the conference. Few people understood the significance at the time. Not until much later did the scientific community realize how groundbreaking her work truly was. Today, her discovery is considered one of the most important of the decade.\"\n\nWhen did the scientific community understand the importance of her work?', NULL, 'Прочитайте текст. Выберите правильный ответ на вопрос.', 'multiple_choice', 'C2', 'Much later after the conference', 25, 'В тексте сказано: \"Not until much later did the scientific community realize how groundbreaking her work was.\"', 1, '2026-02-25 16:33:39'),
(115, 18, 'Прочитайте: \"His remarks were rather facetious.\" Сказал ли он это серьезно?', NULL, 'Прочитайте предложение и выберите правильный ответ на вопрос.', 'multiple_choice', 'C2', 'no', 25, 'Facetious - шутливый, часто неуместно, несерьезный', 1, '2026-02-25 14:48:55'),
(116, 18, 'Прочитайте текст и ответьте на вопрос:\n\n\"When the new smartphone was released, thousands of customers lined up outside stores. So great was the demand that many stores sold out within hours. The company had to increase production to meet customer expectations.\"\n\nWhat happened because of the high demand?', NULL, 'Прочитайте текст. Выберите правильный ответ на вопрос.', 'multiple_choice', 'C2', 'Stores sold out within hours', 25, 'В тексте сказано: \"So great was the demand that many stores sold out within hours.\"', 1, '2026-02-25 16:33:39'),
(117, 18, 'Прочитайте: \"The dichotomy between theory and practice is clear.\" Есть ли разница?', NULL, 'Прочитайте предложение и выберите правильный ответ на вопрос.', 'multiple_choice', 'C2', 'yes', 25, 'Dichotomy - дихотомия, резкое деление на две части', 1, '2026-02-25 14:49:54'),
(118, 18, 'Прочитайте текст и ответьте на вопрос:\n\n\"The laboratory handles dangerous chemicals and sensitive experiments. For safety reasons, on no account must the door be left unlocked when no one is inside. All staff must check the door before leaving.\"\n\nWhat is the safety rule about the door?', NULL, 'Прочитайте текст. Выберите правильный ответ на вопрос.', 'multiple_choice', 'C2', 'It must never be left unlocked', 25, 'В тексте сказано: \"On no account must the door be left unlocked when no one is inside.\"', 1, '2026-02-25 16:33:39'),
(119, 18, 'Прочитайте: \"The company\'s assets are tangible.\" Можно ли их оценить/потрогать?', NULL, 'Прочитайте предложение и выберите правильный ответ на вопрос.', 'multiple_choice', 'C2', 'yes', 25, 'Tangible - материальный, ощутимый', 1, '2026-02-25 14:50:17'),
(120, 18, 'Прочитайте текст и ответьте на вопрос:\n\n\"The old professor was known for his deep understanding of philosophy. Rarely do we encounter such profound wisdom in one person. His students traveled from around the world to learn from him.\"\n\nHow common is such profound wisdom according to the text?', NULL, 'Прочитайте текст. Выберите правильный ответ на вопрос.', 'multiple_choice', 'C2', 'It is very rare', 25, 'В тексте сказано: \"Rarely do we encounter such profound wisdom in one person.\"', 1, '2026-02-25 16:33:40'),
(196, 20, 'Listen to the recording about movies. What type of films does the speaker talk about?', 'audio_1773073141_b4c45468.mp3', 'Прослушайте аудиозапись о фильмах. Обратите внимание на упомянутые типы фильмов и выберите правильный ответ.', 'listening', 'A1', 'Different film genres', 5, 'The speaker discusses various types of movies and film genres.', 1, '2026-03-12 15:08:53'),
(197, 20, 'Listen to the recording. What is the main topic of the conversation?', 'audio_1773073143_32db2d7e.mp3', 'Прислушайтесь к разговору. Сосредоточьтесь на том, о ком говорят выступающие, и выберите правильный ответ.', 'listening', 'A1', 'A famous musician', 5, 'The conversation is about a rockstar and their music career.', 1, '2026-03-12 15:09:09'),
(198, 20, 'Listen to the audio about school. What happens in the story?', 'audio_1773073147_da1b4e7a.mp3', 'Послушайте историю о школе. Обратите внимание на то, что происходит с главным героем, и выберите правильный ответ.', 'listening', 'A1', 'Someone joins a new class', 5, 'The story is about a person joining a new class at school.', 1, '2026-03-12 15:09:25'),
(199, 21, 'Listen to the recording about cooking. What are they making?', 'audio_1773073149_211108e8.mp3', 'Послушайте разговор о кулинарии. Обратите внимание на то, что они готовят, и выберите правильный ответ.', 'listening', 'A2', 'An apple pie', 8, 'The conversation is about making an apple pie with a recipe.', 1, '2026-03-12 15:09:37'),
(200, 21, 'Listen to the audio. What hobby do the speakers discuss?', 'audio_1773073152_d22739ea.mp3', 'Послушайте диалог о хобби. Обратите внимание на то, чем увлекаются выступающие, и выберите правильный ответ.', 'listening', 'A2', 'Reading books', 8, 'The speakers talk about reading as a hobby — they are bookworms.', 1, '2026-03-12 15:09:50'),
(201, 21, 'Listen to the conversation about travel. What is happening?', 'audio_1773073154_0a922ced.mp3', 'Послушайте беседу о путешествиях. Обратите внимание на то, как человек путешествует, и выберите правильный ответ.', 'listening', 'A2', 'Someone is going on a trip by plane', 8, 'The conversation is about leaving on a plane for a trip.', 1, '2026-03-12 15:09:59'),
(202, 22, 'Listen to the recording about the charity event. What are the speakers organizing?', 'audio_1773073157_5138fa4d.mp3', 'Прослушайте диалог о мероприятии. Сосредоточьтесь на том, что организуют выступающие, и выберите правильный ответ.', 'listening', 'B1', 'A charity show', 10, 'The speakers are discussing the organization of a charity show event.', 1, '2026-03-12 15:10:11'),
(203, 22, 'Listen to the conversation. What is happening in Diana\'s life?', 'audio_1773073159_3d7b9d0f.mp3', 'Послушайте разговор о работе. Обратите внимание на то, что меняется в жизни Дианы, и выберите правильный ответ.', 'listening', 'B1', 'She is starting a new job', 10, 'Diana is talking about starting her new job and what it involves.', 1, '2026-03-12 15:10:21'),
(204, 22, 'Listen to the audio about the job interview. What advice is given?', 'audio_1773073162_c6bf6149.mp3', 'Послушайте диалог о карьере. Сосредоточьтесь на данном совете и выберите правильный ответ.', 'listening', 'B1', 'How to prepare for an interview', 10, 'The conversation covers preparation tips for a job interview.', 1, '2026-03-12 15:10:32'),
(205, 23, 'Listen to the conversation. What is the main conflict between the speakers?', 'audio_1773073165_3e9d5671.mp3', 'Прослушайте разговор двух человек. Обратите внимание на то, что изменилось в их отношениях, и выберите правильный ответ.', 'listening', 'B2', 'One person has changed their behavior or lifestyle', 15, 'The dialogue centers on one person accusing the other of having changed.', 1, '2026-03-12 15:10:45'),
(206, 23, 'Listen to the sports discussion. What are the speakers debating?', 'audio_1773073168_61cb3387.mp3', 'Послушайте дискуссию о спорте. Сосредоточьтесь на том, с чем выступающие не согласны, и выберите правильный ответ.', 'listening', 'B2', 'Different opinions about sports and competition', 15, 'The speakers share different perspectives on sports and competitive activities.', 1, '2026-03-12 15:10:55'),
(207, 23, 'Listen to the audio about Haybridge Hall. What is being described?', 'audio_1773073171_9f0983b0.mp3', 'Прослушайте описание объекта. Обратите внимание на то, о каком здании идет речь, и выберите правильный ответ.', 'listening', 'B2', 'A historical building or estate', 15, 'The recording describes Haybridge Hall, a historical building with cultural significance.', 1, '2026-03-12 15:11:07'),
(208, 24, 'Listen to the interview with the actress. What does she reveal about her career?', 'audio_1773073174_663af275.mp3', 'Прослушайте интервью. Сосредоточьтесь на том, что актриса говорит о своей профессиональной жизни, и выберите правильный ответ.', 'listening', 'C1', 'The challenges and rewards of acting professionally', 20, 'The actress discusses the various challenges and rewards she has experienced in her professional acting career.', 1, '2026-03-12 15:13:17'),
(209, 24, 'Listen to the recording about SETI. What is the main topic?', 'audio_1773073178_dbff7772.mp3', 'Прослушайте запись о науке. Обратите внимание на основную тему обсуждения и выберите правильный ответ.', 'listening', 'C1', 'The search for extraterrestrial intelligence', 20, 'SETI stands for Search for Extraterrestrial Intelligence, and the recording discusses this scientific endeavor.', 1, '2026-03-12 15:13:26'),
(210, 24, 'Listen to the audio about the pet caterer. What unusual business is described?', 'audio_1773073183_860befed.mp3', 'Послушайте рассказ о необычной работе. Сосредоточьтесь на том, о какой услуге идет речь, и выберите правильный вариант ответа.', 'listening', 'C1', 'A catering service specifically for pets', 20, 'The recording describes an unusual business that provides catering services specifically designed for pets.', 1, '2026-03-12 15:13:35'),
(211, 25, 'Listen to the survival story. What is the central theme of the narrative?', 'audio_1773073186_9a373348.mp3', 'Внимательно слушайте рассказ. Сосредоточьтесь на главной теме рассказа и выберите правильный ответ.', 'listening', 'C2', 'Overcoming extreme challenges in nature', 25, 'The narrative focuses on survival in extreme natural conditions and how the protagonist overcame life-threatening challenges.', 1, '2026-03-12 15:13:45'),
(212, 25, 'Listen to the discussion about online perils. What dangers are highlighted?', 'audio_1773073190_c88b1090.mp3', 'Послушайте дискуссию о технологиях. Обратите внимание на то, какие риски выделены, и выберите правильный ответ.', 'listening', 'C2', 'Various risks and threats associated with internet use', 25, 'The discussion covers various dangers people face online, including scams, privacy concerns, and other internet-related threats.', 1, '2026-03-12 15:13:53'),
(213, 25, 'Listen to the environmental discussion. What issue is being addressed?', 'audio_1773073193_9c27218d.mp3', 'Послушайте дискуссию об окружающей среде. Сосредоточьтесь на конкретной рассматриваемой проблеме и выберите правильный ответ.', 'listening', 'C2', 'Energy waste and light pollution', 25, 'The recording discusses the environmental impact of excessive artificial lighting, energy waste, and light pollution.', 1, '2026-03-12 15:14:01'),
(214, 20, 'Listen to the dialogue. Where is the person going?', 'audio_1773074296_483de34a.mp3', 'Прослушайте аудиозапись и выберите правильный ответ. Вы услышите короткий разговор о том, как кто-то приезжает в город.', 'listening', 'A1', 'To a town to visit someone', 5, 'The speaker talks about coming to town — they are visiting someone there.', 1, '2026-03-12 15:14:14'),
(215, 20, 'Listen to the conversation at the airport. What is the person doing?', 'audio_1773074300_f5260ecf.mp3', 'Слушайте внимательно. Диалог происходит в аэропорту. Выберите, что делает собеседник.', 'listening', 'A1', 'Checking in for a flight', 5, 'The conversation takes place at an airport check-in desk where the person is preparing for their flight.', 1, '2026-03-12 15:14:21'),
(216, 20, 'Listen to the recording. Where does this conversation take place?', 'audio_1773074303_850dbb0e.mp3', 'Прослушайте диалог. Выступающие находятся в магазине. Выберите подходящее место.', 'listening', 'A1', 'In a department store', 5, 'The conversation happens in a department store — the speakers discuss different sections and items for sale.', 1, '2026-03-12 15:14:32'),
(217, 21, 'Listen to the audio about studying. What topic do the speakers discuss?', 'audio_1773074306_ae68a5f9.mp3', 'Послушайте беседу. Выступающие рассказывают о способах обучения. Выберите основную тему.', 'listening', 'A2', 'Tips and methods for better learning', 8, 'The speakers share advice about effective study habits and methods for better learning.', 1, '2026-03-12 15:14:41'),
(218, 21, 'Listen to the recording about a famous person. Who are they talking about?', 'audio_1773074310_eaf5f8ee.mp3', 'Слушайте внимательно. Выступающие обсуждают известного человека из Великобритании. Кто это?', 'listening', 'A2', 'The Queen of England', 8, 'The recording is about the Queen — \"Her Majesty\" refers to the British monarch.', 1, '2026-03-12 15:14:49'),
(219, 21, 'Listen to the conversation about dreams. What is the main idea?', 'audio_1773074312_ae58247c.mp3', 'Прослушайте аудиозапись. Выступающие рассказывают о сне и сновидениях. Выберите основную идею.', 'listening', 'A2', 'People share what they dream about at night', 8, 'The conversation focuses on people describing their dreams — what they see and experience during sleep.', 1, '2026-03-12 15:14:58'),
(220, 22, 'Listen to the dialogue about holidays. What problem does the speaker describe?', 'audio_1773074316_57853806.mp3', 'Внимательно прислушайтесь к разговору об отдыхе. Что пошло не так?', 'listening', 'B1', 'The vacation was stressful instead of relaxing', 10, 'The speaker describes how their vacation turned out to be stressful rather than the relaxing break they had hoped for.', 1, '2026-03-12 15:15:06'),
(221, 22, 'Listen to the recording. What is the inspector checking?', 'audio_1773074319_e39bb737.mp3', 'Инспектор посещает какое-то место, чтобы что-то проверить. Послушайте и выберите, что именно они проверяют.', 'listening', 'B1', 'They are inspecting a building or business', 10, 'The inspector is conducting an official inspection of a building or business premises.', 1, '2026-03-12 15:13:03'),
(222, 22, 'Listen to the conversation about friendship. What do the speakers talk about?', 'audio_1773074323_52087d50.mp3', 'Два человека обсуждают свою дружбу. Послушайте и выберите основную тему.', 'listening', 'B1', 'How their friendship has changed over time', 10, 'The best friends discuss how their relationship has developed and changed over the years.', 1, '2026-03-12 15:12:52'),
(223, 23, 'Listen to the discussion about the internet. What problem is described?', 'audio_1773074327_e5627e13.mp3', 'Послушайте диалог. Выступающие обсуждают негативный опыт в Интернете. Что случилось?', 'listening', 'B2', 'Someone had a bad experience with online communication', 15, 'The speakers discuss problems related to online interactions — misunderstandings and negative experiences in digital communication.', 1, '2026-03-12 15:12:45'),
(224, 23, 'Listen to the recording about school. Who is meeting and why?', 'audio_1773074330_f3614792.mp3', 'Внимательно прислушайтесь к разговору. Он происходит в школе. Выберите, с кем вы собираетесь встретиться и по какой причине.', 'listening', 'B2', 'A parent and teacher discuss a child\'s progress', 15, 'This is a parent-teacher meeting where they discuss how the child is performing at school.', 1, '2026-03-12 15:12:36'),
(225, 23, 'Listen to the phone messages. What kind of messages are left?', 'audio_1773074334_36264ab2.mp3', 'Вы услышите несколько сообщений, оставленных на автоответчике. Выберите наиболее подходящее описание.', 'listening', 'B2', 'Different people leave various personal messages', 15, 'The recording features different callers leaving personal messages on an answering machine about various everyday topics.', 1, '2026-03-12 15:12:26'),
(226, 24, 'Listen to the story about romance. What situation is described?', 'audio_1773074337_46414b99.mp3', 'Послушайте внимательно этот разговор о романтической ситуации. Что происходит между героями?', 'listening', 'C1', 'Two people are developing romantic feelings', 20, 'The story describes a romantic situation where feelings are developing between the characters — \"love is in the air.\"', 1, '2026-03-12 15:12:16'),
(227, 24, 'Listen to the news broadcast. What type of stories are reported?', 'audio_1773074340_272043f0.mp3', 'Вы услышите запись в новостном стиле. Прослушайте и определите, о каком типе новостей идет речь.', 'listening', 'C1', 'A mix of current events and local news stories', 20, 'The broadcast presents a variety of news items including current events and local stories, typical of a news bulletin.', 1, '2026-03-12 15:12:06'),
(228, 24, 'Listen to the conversation about living together. What is the main issue?', 'audio_1773074344_d629496e.mp3', 'Двое соседей по комнате разговаривают. Послушайте и выберите, что они в основном обсуждают.', 'listening', 'C1', 'Problems and disagreements about sharing a living space', 20, 'The roommates discuss common issues that arise when sharing a living space — habits, responsibilities, and compromises.', 1, '2026-03-12 15:11:55'),
(229, 25, 'Listen to the discussion about politics. What democratic process is being discussed?', 'audio_1773074347_6f7f99bf.mp3', 'Вы услышите разговор об участии в политической жизни. О какой конкретно демократической деятельности идет речь?', 'listening', 'C2', 'Voting and civic engagement in elections', 25, 'The discussion focuses on democracy in action — specifically voting, elections, and how citizens participate in the democratic process.', 1, '2026-03-12 15:11:45'),
(230, 25, 'Listen to the conversation. What social situation is described?', 'audio_1773074351_5e554ff4.mp3', 'Послушайте внимательно этот диалог. Один человек услышал то, чего не должен был слышать. Что происходит?', 'listening', 'C2', 'Someone accidentally overhears a private conversation', 25, 'Eavesdropping means listening to a private conversation without permission. The dialogue describes this awkward social situation.', 1, '2026-03-12 15:11:34'),
(231, 25, 'Listen to the recording about a distant place. What is being described?', 'audio_1773074356_ff5ab25c.mp3', 'Вы услышите об удаленном местоположении. Внимательно прослушайте и выберите то, что описано в записи.', 'listening', 'C2', 'A remote Pacific island nation and its culture', 25, 'Vanuatu is a remote island nation in the South Pacific Ocean. The recording describes its unique geography, culture, and way of life.', 1, '2026-03-12 15:11:25'),
(232, 20, 'Listen to the cinema recorded message. What type of film is showing on Screen 1? Say or type your answer.', 'audio_1773073141_b4c45468.mp3', 'Прослушайте сообщение кинотеатра. Какой жанр фильма идёт на экране 1? Произнесите ответ в микрофон или введите его.', 'listening', 'A1', 'horror', 10, 'На экране 1 идёт фильм жанра horror/thriller. Правильный ответ — «horror».', 1, '2026-03-13 11:04:32'),
(233, 20, 'Listen to the rockstar talking about her morning. What does she have for breakfast? Say or type three words.', 'audio_1773073143_32db2d7e.mp3', 'Прослушайте рассказ рок-звезды о её утре. Что она ест на завтрак? Произнесите ответ или введите его.', 'listening', 'A1', 'a pastry and a coffee', 10, 'Рок-звезда говорит, что на завтрак она берёт выпечку и кофе — «a pastry and a coffee».', 1, '2026-03-13 11:04:32'),
(234, 21, 'Listen to two friends talking about baking. What ingredient do they need to buy? Say or type one word.', 'audio_1773073149_211108e8.mp3', 'Прослушайте разговор двух друзей о выпечке. Какой ингредиент им нужно купить? Произнесите ответ или введите одно слово.', 'listening', 'A2', 'flour', 15, 'Друзья обсуждают приготовление яблочного пирога и понимают, что им нужно купить муку — «flour».', 1, '2026-03-13 11:04:32');
INSERT INTO `tasks` (`task_id`, `module_id`, `task_text`, `audio_file`, `instruction`, `task_type`, `difficulty_level`, `correct_answer`, `points`, `explanation`, `is_active`, `updated_at`) VALUES
(235, 21, 'Listen to the questionnaire about reading habits. How much does Charlie spend on books per month? Say or type the amount.', 'audio_1773073152_d22739ea.mp3', 'Прослушайте опрос о привычках чтения. Сколько Чарли тратит на книги в месяц? Произнесите ответ или введите сумму.', 'listening', 'A2', '$50', 15, 'Чарли говорит, что тратит около 50 долларов в месяц на книги — «$50».', 1, '2026-03-13 11:04:32'),
(236, 22, 'Listen to the conversation about the charity show. Where is the show going to take place? Say or type your answer.', 'audio_1773073157_5138fa4d.mp3', 'Прослушайте разговор о благотворительном шоу. Где будет проходить шоу? Произнесите ответ или введите его.', 'listening', 'B1', 'park', 20, 'Шоу будет проходить в парке — «park». Это подтверждается в диалоге.', 1, '2026-03-13 11:04:32'),
(237, 22, 'Listen to the job interview. Where was Pia born? Say or type the city name.', 'audio_1773073162_c6bf6149.mp3', 'Прослушайте собеседование. Где родилась Пиа? Произнесите ответ или введите название города.', 'listening', 'B1', 'Rome', 20, 'Пиа родилась в Риме — «Rome». Это указано в начале интервью.', 1, '2026-03-13 11:04:32'),
(238, 23, 'Listen to the sports news. Did Diego Garcia play well last year? Say \"yes\" or \"no\".', 'audio_1773073168_61cb3387.mp3', 'Прослушайте спортивные новости. Хорошо ли играл Диего Гарсия в прошлом году? Произнесите «yes» или «no».', 'listening', 'B2', 'no', 20, 'Диего Гарсия не играл хорошо в прошлом году. Правильный ответ — «no».', 1, '2026-03-13 11:04:32'),
(239, 23, 'Listen to the guide speaking about Haybridge Hall. What was the original name of the house? Say or type two words.', 'audio_1773073171_9f0983b0.mp3', 'Прослушайте рассказ гида о Хейбридж-холле. Как дом назывался изначально? Произнесите ответ или введите два слова.', 'listening', 'B2', 'Hawken Hall', 20, 'Изначально дом назывался Hawken Hall — «Hawken Hall».', 1, '2026-03-13 11:04:32'),
(240, 24, 'Listen to the interview with the actress Jenny. What does she say about the last six months? Say or type your answer.', 'audio_1773073174_663af275.mp3', 'Прослушайте интервью с актрисой Дженни. Что она говорит о последних шести месяцах? Произнесите ответ или введите его.', 'listening', 'C1', 'incredibly busy', 25, 'Дженни говорит, что последние шесть месяцев были невероятно загруженными — «incredibly busy».', 1, '2026-03-13 11:04:32'),
(241, 24, 'Listen to the interview about SETI. What do current SETI techniques involve — sending or listening for signals? Say or type your answer.', 'audio_1773073178_dbff7772.mp3', 'Прослушайте интервью о SETI. Что включают современные методы SETI — отправку или прослушивание сигналов? Произнесите ответ или введите его.', 'listening', 'C1', 'listening for signals', 25, 'Современные методы SETI включают прослушивание сигналов, а не их отправку — «listening for signals».', 1, '2026-03-13 11:04:32'),
(242, 25, 'Listen to the survival story. Jane was sailing from Panama. Did her boat hit an underwater or surface obstruction? Say or type one word.', 'audio_1773073186_9a373348.mp3', 'Прослушайте историю о выживании. Джейн плыла из Панамы. Её лодка столкнулась с подводным или надводным препятствием? Произнесите ответ или введите одно слово.', 'listening', 'C2', 'surface', 30, 'Лодка Джейн столкнулась с надводным препятствием — «surface obstruction».', 1, '2026-03-13 11:04:32'),
(243, 25, 'Listen to the discussion about light pollution. What is the odd thing — most people don\'t have much knowledge about it, or don\'t want legislation? Say or type your answer.', 'audio_1773073193_9c27218d.mp3', 'Прослушайте обсуждение о световом загрязнении. Что странно — люди мало знают об этом или не хотят закона? Произнесите ответ или введите его.', 'listening', 'C2', 'knowledge', 30, 'Странность в том, что большинство людей мало знают о световом загрязнении — они «don\'t have much knowledge about it».', 1, '2026-03-13 11:04:32');

-- --------------------------------------------------------

--
-- Структура таблицы `task_options`
--

CREATE TABLE `task_options` (
  `option_id` int NOT NULL,
  `task_id` int NOT NULL,
  `option_text` varchar(255) NOT NULL,
  `is_correct` tinyint(1) DEFAULT '0',
  `order_number` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `task_options`
--

INSERT INTO `task_options` (`option_id`, `task_id`, `option_text`, `is_correct`, `order_number`) VALUES
(5, 2, 'am', 1, 1),
(6, 2, 'is', 0, 2),
(7, 2, 'are', 0, 3),
(8, 2, 'be', 0, 4),
(9, 3, 'How', 1, 1),
(10, 3, 'What', 0, 2),
(11, 3, 'Where', 0, 3),
(12, 3, 'When', 0, 4),
(13, 4, 'is', 1, 1),
(14, 4, 'am', 0, 2),
(15, 4, 'are', 0, 3),
(16, 4, 'be', 0, 4),
(17, 5, 'дом', 1, 1),
(18, 5, 'квартира', 0, 2),
(19, 5, 'здание', 0, 3),
(20, 5, 'комната', 0, 4),
(21, 6, 'книга', 1, 1),
(22, 6, 'журнал', 0, 2),
(23, 6, 'газета', 0, 3),
(24, 6, 'тетрадь', 0, 4),
(25, 7, 'family', 1, 1),
(26, 7, 'parents', 0, 2),
(27, 7, 'relatives', 0, 3),
(28, 7, 'home', 0, 4),
(29, 8, 'вода', 1, 1),
(30, 8, 'сок', 0, 2),
(31, 8, 'молоко', 0, 3),
(32, 8, 'чай', 0, 4),
(33, 9, 'друг', 1, 1),
(34, 9, 'враг', 0, 2),
(35, 9, 'знакомый', 0, 3),
(36, 9, 'коллега', 0, 4),
(37, 10, 'школа', 1, 1),
(38, 10, 'университет', 0, 2),
(39, 10, 'колледж', 0, 3),
(40, 10, 'институт', 0, 4),
(41, 11, 'work', 1, 1),
(42, 11, 'job', 0, 2),
(43, 11, 'career', 0, 3),
(44, 11, 'profession', 0, 4),
(45, 12, 'город', 1, 1),
(46, 12, 'деревня', 0, 2),
(47, 12, 'поселок', 0, 3),
(48, 12, 'мегаполис', 0, 4),
(49, 13, 'black', 1, 1),
(50, 13, 'white', 0, 2),
(51, 13, 'brown', 0, 3),
(52, 13, 'gray', 0, 4),
(53, 15, 'a teacher', 1, 1),
(54, 15, 'a doctor', 0, 2),
(55, 15, 'a student', 0, 3),
(56, 15, 'a manager', 0, 4),
(65, 21, 'went', 1, 1),
(66, 21, 'go', 0, 2),
(67, 21, 'going', 0, 3),
(68, 21, 'gone', 0, 4),
(69, 22, 'read', 1, 1),
(70, 22, 'reads', 0, 2),
(71, 22, 'reading', 0, 3),
(72, 22, 'readed', 0, 4),
(73, 26, 'traveled', 1, 1),
(74, 26, 'travel', 0, 2),
(75, 26, 'travelling', 0, 3),
(76, 26, 'travels', 0, 4),
(77, 27, 'окружающая среда', 1, 1),
(78, 27, 'экономика', 0, 2),
(79, 27, 'политика', 0, 3),
(80, 27, 'культура', 0, 4),
(81, 28, 'возможность', 1, 1),
(82, 28, 'проблема', 0, 2),
(83, 28, 'вопрос', 0, 3),
(84, 28, 'ответ', 0, 4),
(85, 29, 'развитие', 1, 1),
(86, 29, 'упадок', 0, 2),
(87, 29, 'стагнация', 0, 3),
(88, 29, 'рост', 0, 4),
(89, 30, 'правительство', 1, 1),
(90, 30, 'компания', 0, 2),
(91, 30, 'организация', 0, 3),
(92, 30, 'ассоциация', 0, 4),
(93, 31, 'образование', 1, 1),
(94, 31, 'воспитание', 0, 2),
(95, 31, 'обучение', 0, 3),
(96, 31, 'развитие', 0, 4),
(97, 32, 'информация', 1, 1),
(98, 32, 'знание', 0, 2),
(99, 32, 'данные', 0, 3),
(100, 32, 'сведения', 0, 4),
(101, 33, 'технология', 1, 1),
(102, 33, 'наука', 0, 2),
(103, 33, 'инженерия', 0, 3),
(104, 33, 'прогресс', 0, 4),
(105, 34, 'Tuesday', 1, 1),
(106, 34, 'Monday', 0, 2),
(107, 34, 'Wednesday', 0, 3),
(108, 34, 'Thursday', 0, 4),
(109, 36, 'in the evening', 1, 1),
(110, 36, 'in the morning', 0, 2),
(111, 36, 'at noon', 0, 3),
(112, 36, 'at night', 0, 4),
(113, 38, 'stay at home', 1, 1),
(114, 38, 'go for a walk', 0, 2),
(115, 38, 'visit friends', 0, 3),
(116, 38, 'go shopping', 0, 4),
(117, 40, 'interesting but long', 1, 1),
(118, 40, 'boring and short', 0, 2),
(119, 40, 'funny and exciting', 0, 3),
(120, 40, 'sad but beautiful', 0, 4),
(137, 23, 'played', 1, 1),
(138, 23, 'plays', 0, 2),
(139, 23, 'play', 0, 3),
(140, 23, 'playing', 0, 4),
(141, 24, 'watched', 1, 1),
(142, 24, 'watch', 0, 2),
(143, 24, 'watches', 0, 3),
(144, 24, 'watching', 0, 4),
(145, 25, 'went', 1, 1),
(146, 25, 'go', 0, 2),
(147, 25, 'gone', 0, 3),
(148, 25, 'goes', 0, 4),
(149, 41, 'have lived', 1, 1),
(150, 41, 'live', 0, 2),
(151, 41, 'am living', 0, 3),
(152, 41, 'lived', 0, 4),
(153, 42, 'were', 1, 1),
(154, 42, 'was', 0, 2),
(155, 42, 'am', 0, 3),
(156, 42, 'be', 0, 4),
(157, 43, 'was built', 1, 1),
(158, 43, 'built', 0, 2),
(159, 43, 'has built', 0, 3),
(160, 43, 'is built', 0, 4),
(161, 44, 'had finished', 1, 1),
(162, 44, 'finished', 0, 2),
(163, 44, 'has finished', 0, 3),
(164, 44, 'was finishing', 0, 4),
(165, 45, 'meeting', 1, 1),
(166, 45, 'meet', 0, 2),
(167, 45, 'to meet', 0, 3),
(168, 45, 'met', 0, 4),
(169, 46, 'was working', 1, 1),
(170, 46, 'worked', 0, 2),
(171, 46, 'works', 0, 3),
(172, 46, 'had worked', 0, 4),
(173, 47, 'предприниматель', 1, 1),
(174, 47, 'учитель', 0, 2),
(175, 47, 'врач', 0, 3),
(176, 47, 'инженер', 0, 4),
(177, 48, 'откладывать', 1, 1),
(178, 48, 'терпеть', 0, 2),
(179, 48, 'надевать', 0, 3),
(180, 48, 'выключать', 0, 4),
(181, 49, 'negotiations', 1, 1),
(182, 49, 'conversations', 0, 2),
(183, 49, 'agreements', 0, 3),
(184, 49, 'meetings', 0, 4),
(185, 50, 'преимущество', 1, 1),
(186, 50, 'недостаток', 0, 2),
(187, 50, 'совет', 0, 3),
(188, 50, 'результат', 0, 4),
(189, 51, 'responsibility', 1, 1),
(190, 51, 'ability', 0, 2),
(191, 51, 'possibility', 0, 3),
(192, 51, 'opportunity', 0, 4),
(193, 52, 'reduce', 1, 1),
(194, 52, 'increase', 0, 2),
(195, 52, 'improve', 0, 3),
(196, 52, 'expand', 0, 4),
(197, 53, 'no', 1, 1),
(198, 53, 'yes', 0, 2),
(199, 54, 'due to', 1, 1),
(200, 54, 'because', 0, 2),
(201, 54, 'despite', 0, 3),
(202, 54, 'instead of', 0, 4),
(203, 55, 'yes', 1, 1),
(204, 55, 'no', 0, 2),
(209, 57, 'no', 1, 1),
(210, 57, 'yes', 0, 2),
(215, 59, 'no', 1, 1),
(216, 59, 'yes', 0, 2),
(221, 61, 'had known', 1, 1),
(222, 61, 'knew', 0, 2),
(223, 61, 'have known', 0, 3),
(224, 61, 'would know', 0, 4),
(225, 62, 'will have completed', 1, 1),
(226, 62, 'will complete', 0, 2),
(227, 62, 'complete', 0, 3),
(228, 62, 'will be completing', 0, 4),
(229, 63, 'found', 1, 1),
(230, 63, 'find', 0, 2),
(231, 63, 'have found', 0, 3),
(232, 63, 'would find', 0, 4),
(233, 64, 'to be', 1, 1),
(234, 64, 'being', 0, 2),
(235, 64, 'be', 0, 3),
(236, 64, 'that he is', 0, 4),
(237, 65, 'didn\'t tell', 1, 1),
(238, 65, 'don\'t tell', 0, 2),
(239, 65, 'not tell', 0, 3),
(240, 65, 'won\'t tell', 0, 4),
(241, 66, 'Having finished', 1, 1),
(242, 66, 'Finished', 0, 2),
(243, 66, 'Finishing', 0, 3),
(244, 66, 'To finish', 0, 4),
(245, 67, 'двусмысленный', 1, 1),
(246, 67, 'амбициозный', 0, 2),
(247, 67, 'древний', 0, 3),
(248, 67, 'красивый', 0, 4),
(249, 68, 'принять последствия', 1, 1),
(250, 68, 'слушать музыку', 0, 2),
(251, 68, 'купить билеты', 0, 3),
(252, 68, 'начать петь', 0, 4),
(253, 69, 'environment', 1, 1),
(254, 69, 'surroundings', 0, 2),
(255, 69, 'nature', 0, 3),
(256, 69, 'location', 0, 4),
(257, 70, 'неизбежный', 1, 1),
(258, 70, 'невероятный', 0, 2),
(259, 70, 'невидимый', 0, 3),
(260, 70, 'неэффективный', 0, 4),
(261, 71, 'emphasize', 1, 1),
(262, 71, 'imagine', 0, 2),
(263, 71, 'improve', 0, 3),
(264, 71, 'ignore', 0, 4),
(265, 72, 'смотреть свысока', 1, 1),
(266, 72, 'заботиться', 0, 2),
(267, 72, 'искать информацию', 0, 3),
(268, 72, 'ожидать', 0, 4),
(269, 73, 'yes', 1, 1),
(270, 73, 'no', 0, 2),
(275, 75, 'yes', 1, 1),
(276, 75, 'no', 0, 2),
(281, 77, 'yes', 1, 1),
(282, 77, 'no', 0, 2),
(287, 79, 'yes', 1, 1),
(288, 79, 'no', 0, 2),
(293, 81, 'would be', 1, 1),
(294, 81, 'will be', 0, 2),
(295, 81, 'had been', 0, 3),
(296, 81, 'am', 0, 4),
(297, 82, 'have I seen', 1, 1),
(298, 82, 'I have seen', 0, 2),
(299, 82, 'did I see', 0, 3),
(300, 82, 'I saw', 0, 4),
(301, 83, 'was', 1, 1),
(302, 83, 'were', 0, 2),
(303, 83, 'been', 0, 3),
(304, 83, 'is', 0, 4),
(305, 84, 'as he might', 1, 1),
(306, 84, 'though he might', 0, 2),
(307, 84, 'since he might', 0, 3),
(308, 84, 'because he might', 0, 4),
(309, 85, 'should you', 1, 1),
(310, 85, 'you should', 0, 2),
(311, 85, 'shall you', 0, 3),
(312, 85, 'do you', 0, 4),
(313, 86, 'were', 1, 1),
(314, 86, 'was', 0, 2),
(315, 86, 'is', 0, 3),
(316, 86, 'be', 0, 4),
(317, 87, 'вездесущий', 1, 1),
(318, 87, 'редкий', 0, 2),
(319, 87, 'опасный', 0, 3),
(320, 87, 'громкий', 0, 4),
(321, 88, 'стойкий', 1, 1),
(322, 88, 'хрупкий', 0, 2),
(323, 88, 'ленивый', 0, 3),
(324, 88, 'быстрый', 0, 4),
(325, 89, 'относиться скептически', 1, 1),
(326, 89, 'солить еду', 0, 2),
(327, 89, 'верить на слово', 0, 3),
(328, 89, 'быть злым', 0, 4),
(329, 90, 'feasible', 1, 1),
(330, 90, 'difficult', 0, 2),
(331, 90, 'unlikely', 0, 3),
(332, 90, 'optional', 0, 4),
(333, 91, 'смягчать', 1, 1),
(334, 91, 'ухудшать', 0, 2),
(335, 91, 'игнорировать', 0, 3),
(336, 91, 'праздновать', 0, 4),
(337, 92, 'confused', 1, 1),
(338, 92, 'excited', 0, 2),
(339, 92, 'angry', 0, 3),
(340, 92, 'bored', 0, 4),
(341, 93, 'no', 1, 1),
(342, 93, 'yes', 0, 2),
(347, 95, 'no', 1, 1),
(348, 95, 'yes', 0, 2),
(353, 97, 'the best', 1, 1),
(354, 97, 'the second', 0, 2),
(355, 97, 'average', 0, 3),
(356, 97, 'worst', 0, 4),
(361, 99, 'no', 1, 1),
(362, 99, 'yes', 0, 2),
(367, 101, 'were', 1, 1),
(368, 101, 'was', 0, 2),
(369, 101, 'be', 0, 3),
(370, 101, 'had been', 0, 4),
(371, 102, 'Had', 1, 1),
(372, 102, 'Were', 0, 2),
(373, 102, 'Should', 0, 3),
(374, 102, 'Been', 0, 4),
(375, 103, 'hadn\'t mentioned', 1, 1),
(376, 103, 'didn\'t mention', 0, 2),
(377, 103, 'not mention', 0, 3),
(378, 103, 'wouldn\'t mention', 0, 4),
(379, 104, 'attend', 1, 1),
(380, 104, 'attends', 0, 2),
(381, 104, 'attended', 0, 3),
(382, 104, 'should attend', 0, 4),
(383, 105, 'Were', 1, 1),
(384, 105, 'Was', 0, 2),
(385, 105, 'Should', 0, 3),
(386, 105, 'Had', 0, 4),
(387, 106, 'had witnessed', 1, 1),
(388, 106, 'witnessed', 0, 2),
(389, 106, 'witnesses', 0, 3),
(390, 106, 'would witness', 0, 4),
(391, 107, 'универсальное средство', 1, 1),
(392, 107, 'болезнь', 0, 2),
(393, 107, 'страх', 0, 3),
(394, 107, 'музыка', 0, 4),
(395, 108, 'эфемерный', 1, 1),
(396, 108, 'вечный', 0, 2),
(397, 108, 'красивый', 0, 3),
(398, 108, 'тяжелый', 0, 4),
(399, 109, 'какофония', 1, 1),
(400, 109, 'симфония', 0, 2),
(401, 109, 'тишина', 0, 3),
(402, 109, 'песня', 0, 4),
(403, 110, 'наиболее типичный', 1, 1),
(404, 110, 'редкий', 0, 2),
(405, 110, 'странный', 0, 3),
(406, 110, 'старый', 0, 4),
(407, 111, 'отрекаться', 1, 1),
(408, 111, 'соглашаться', 0, 2),
(409, 111, 'бороться', 0, 3),
(410, 111, 'помогать', 0, 4),
(411, 112, 'happy accident', 1, 1),
(412, 112, 'sad event', 0, 2),
(413, 112, 'planned trip', 0, 3),
(414, 112, 'hard work', 0, 4),
(415, 113, 'no', 1, 1),
(416, 113, 'yes', 0, 2),
(421, 115, 'no', 1, 1),
(422, 115, 'yes', 0, 2),
(427, 117, 'yes', 1, 1),
(428, 117, 'no', 0, 2),
(433, 119, 'yes', 1, 1),
(434, 119, 'no', 0, 2),
(559, 14, '20', 0, 1),
(560, 14, '25', 1, 2),
(561, 14, '30', 0, 3),
(562, 14, '35', 0, 4),
(563, 16, 'at school', 0, 1),
(564, 16, 'at London University', 1, 2),
(565, 16, 'at home', 0, 3),
(566, 16, 'at the library', 0, 4),
(575, 35, 'one week', 0, 1),
(576, 35, 'two weeks', 1, 2),
(577, 35, 'three weeks', 0, 3),
(578, 35, 'one month', 0, 4),
(579, 37, 'one year', 0, 1),
(580, 37, 'two years', 1, 2),
(581, 37, 'three years', 0, 3),
(582, 37, 'five years', 0, 4),
(583, 39, 'every day', 0, 1),
(584, 39, 'three times a week', 1, 2),
(585, 39, 'twice a week', 0, 3),
(586, 39, 'once a week', 0, 4),
(587, 56, 'true', 1, 1),
(588, 56, 'false', 0, 2),
(589, 56, 'not stated', 0, 3),
(590, 58, 'Breakfast is the most important meal', 0, 1),
(591, 58, 'Skipping breakfast may not be harmful for everyone', 1, 2),
(592, 58, 'Everyone should skip breakfast', 0, 3),
(593, 58, 'Breakfast is not important', 0, 4),
(594, 60, 'Working only from home', 0, 1),
(595, 60, 'Working only from the office', 0, 2),
(596, 60, 'Working both from home and the office', 1, 3),
(597, 60, 'Working part-time', 0, 4),
(598, 74, 'Social media is completely positive', 0, 1),
(599, 74, 'Social media may have negative effects', 1, 2),
(600, 74, 'Social media has no effect on people', 0, 3),
(601, 74, 'Social media only affects young people', 0, 4),
(602, 76, 'It increases stress', 0, 1),
(603, 76, 'It is a luxury not everyone can afford', 1, 2),
(604, 76, 'It is too slow', 0, 3),
(605, 76, 'It has no benefits', 0, 4),
(606, 78, 'How AI Works', 0, 1),
(607, 78, 'The Impact of AI on Various Industries', 1, 2),
(608, 78, 'AI is Dangerous', 0, 3),
(609, 78, 'The Future of Technology', 0, 4),
(610, 80, 'forcing', 0, 1),
(611, 80, 'adapt', 1, 2),
(612, 80, 'adjust', 0, 3),
(613, 80, 'respond', 0, 4),
(614, 94, 'They would have reached the top', 0, 1),
(615, 94, 'They would not have survived', 1, 2),
(616, 94, 'They would have found another way', 0, 3),
(617, 94, 'They would have called for help', 0, 4),
(618, 96, 'Before the flight departed', 0, 1),
(619, 96, 'After hearing his voice', 1, 2),
(620, 96, 'When the weather improved', 0, 3),
(621, 96, 'When the plane landed', 0, 4),
(622, 98, 'They would get a big bonus', 0, 1),
(623, 98, 'The company was closing the department', 1, 2),
(624, 98, 'The company was hiring new staff', 0, 3),
(625, 98, 'They would get a promotion', 0, 4),
(626, 100, 'Go to the reception desk', 0, 1),
(627, 100, 'Dial 0 from their room phone', 1, 2),
(628, 100, 'Send an email', 0, 3),
(629, 100, 'Wait for staff to come', 0, 4),
(630, 114, 'Immediately at the conference', 0, 1),
(631, 114, 'Much later after the conference', 1, 2),
(632, 114, 'Before she presented', 0, 3),
(633, 114, 'They never understood it', 0, 4),
(634, 116, 'Prices increased', 0, 1),
(635, 116, 'Stores sold out within hours', 1, 2),
(636, 116, 'The company stopped production', 0, 3),
(637, 116, 'Customers went home', 0, 4),
(638, 118, 'It must always be open', 0, 1),
(639, 118, 'It must never be left unlocked', 1, 2),
(640, 118, 'It can be left unlocked during the day', 0, 3),
(641, 118, 'Only managers can lock it', 0, 4),
(642, 120, 'It is very common', 0, 1),
(643, 120, 'It is very rare', 1, 2),
(644, 120, 'It is found everywhere', 0, 3),
(645, 120, 'Only professors have it', 0, 4),
(646, 196, 'Different film genres', 1, 1),
(647, 196, 'Only horror films', 0, 2),
(648, 196, 'Only comedies', 0, 3),
(649, 196, 'Documentary films', 0, 4),
(650, 197, 'A school teacher', 0, 1),
(651, 197, 'A famous musician', 1, 2),
(652, 197, 'A sports player', 0, 3),
(653, 197, 'A doctor', 0, 4),
(654, 198, 'A teacher leaves school', 0, 1),
(655, 198, 'Someone joins a new class', 1, 2),
(656, 198, 'Students take an exam', 0, 3),
(657, 198, 'School closes for vacation', 0, 4),
(658, 199, 'A chocolate cake', 0, 1),
(659, 199, 'An apple pie', 1, 2),
(660, 199, 'A fruit salad', 0, 3),
(661, 199, 'Pancakes', 0, 4),
(662, 200, 'Playing sports', 0, 1),
(663, 200, 'Watching TV', 0, 2),
(664, 200, 'Reading books', 1, 3),
(665, 200, 'Painting', 0, 4),
(666, 201, 'Someone is going on a trip by plane', 1, 1),
(667, 201, 'Someone is buying a car', 0, 2),
(668, 201, 'Someone is booking a hotel', 0, 3),
(669, 201, 'Someone is taking a train', 0, 4),
(670, 202, 'A birthday party', 0, 1),
(671, 202, 'A charity show', 1, 2),
(672, 202, 'A school play', 0, 3),
(673, 202, 'A concert', 0, 4),
(674, 203, 'She is moving to a new city', 0, 1),
(675, 203, 'She is starting a new job', 1, 2),
(676, 203, 'She is getting married', 0, 3),
(677, 203, 'She is going on vacation', 0, 4),
(678, 204, 'How to write a CV', 0, 1),
(679, 204, 'How to prepare for an interview', 1, 2),
(680, 204, 'How to quit a job', 0, 3),
(681, 204, 'How to ask for a raise', 0, 4),
(682, 205, 'They disagree about money', 0, 1),
(683, 205, 'One person has changed their behavior or lifestyle', 1, 2),
(684, 205, 'They are arguing about work', 0, 3),
(685, 205, 'They cannot agree on vacation plans', 0, 4),
(686, 206, 'The results of a football match', 0, 1),
(687, 206, 'Different opinions about sports and competition', 1, 2),
(688, 206, 'How to join a sports team', 0, 3),
(689, 206, 'The cost of sports equipment', 0, 4),
(690, 207, 'A modern shopping center', 0, 1),
(691, 207, 'A historical building or estate', 1, 2),
(692, 207, 'A new hotel', 0, 3),
(693, 207, 'A school campus', 0, 4),
(694, 208, 'She plans to retire soon', 0, 1),
(695, 208, 'The challenges and rewards of acting professionally', 1, 2),
(696, 208, 'She only does comedy roles', 0, 3),
(697, 208, 'She prefers theater to film', 0, 4),
(698, 209, 'A new telescope technology', 0, 1),
(699, 209, 'The search for extraterrestrial intelligence', 1, 2),
(700, 209, 'Space tourism opportunities', 0, 3),
(701, 209, 'A new planet discovery', 0, 4),
(702, 210, 'A veterinary clinic', 0, 1),
(703, 210, 'A pet grooming salon', 0, 2),
(704, 210, 'A catering service specifically for pets', 1, 3),
(705, 210, 'A pet training school', 0, 4),
(706, 211, 'Overcoming extreme challenges in nature', 1, 1),
(707, 211, 'Building a successful business', 0, 2),
(708, 211, 'Learning a new language', 0, 3),
(709, 211, 'Traveling around the world', 0, 4),
(710, 212, 'Computer hardware failures', 0, 1),
(711, 212, 'Various risks and threats associated with internet use', 1, 2),
(712, 212, 'The high cost of internet service', 0, 3),
(713, 212, 'Slow internet connection speeds', 0, 4),
(714, 213, 'Water pollution in rivers', 0, 1),
(715, 213, 'Deforestation in tropical areas', 0, 2),
(716, 213, 'Energy waste and light pollution', 1, 3),
(717, 213, 'Plastic waste in oceans', 0, 4),
(718, 214, 'To a town to visit someone', 1, 1),
(719, 214, 'To the beach for holiday', 0, 2),
(720, 214, 'To the hospital', 0, 3),
(721, 214, 'To a restaurant for dinner', 0, 4),
(722, 215, 'Buying a ticket at the counter', 0, 1),
(723, 215, 'Checking in for a flight', 1, 2),
(724, 215, 'Meeting a friend who arrived', 0, 3),
(725, 215, 'Looking for lost luggage', 0, 4),
(726, 216, 'In a supermarket', 0, 1),
(727, 216, 'In a department store', 1, 2),
(728, 216, 'In a pharmacy', 0, 3),
(729, 216, 'In a bookshop', 0, 4),
(730, 217, 'How to choose a university', 0, 1),
(731, 217, 'Tips and methods for better learning', 1, 2),
(732, 217, 'Problems with online classes', 0, 3),
(733, 217, 'A new language course', 0, 4),
(734, 218, 'A famous actor', 0, 1),
(735, 218, 'The Queen of England', 1, 2),
(736, 218, 'A popular singer', 0, 3),
(737, 218, 'A football player', 0, 4),
(738, 219, 'How to fall asleep faster', 0, 1),
(739, 219, 'People share what they dream about at night', 1, 2),
(740, 219, 'Why some people cannot sleep', 0, 3),
(741, 219, 'A doctor explains dream science', 0, 4),
(742, 220, 'The flight was cancelled', 0, 1),
(743, 220, 'The vacation was stressful instead of relaxing', 1, 2),
(744, 220, 'The hotel was too expensive', 0, 3),
(745, 220, 'They lost their passport abroad', 0, 4),
(746, 221, 'They are checking a crime scene', 0, 1),
(747, 221, 'They are inspecting a building or business', 1, 2),
(748, 221, 'They are testing a new car', 0, 3),
(749, 221, 'They are reviewing a school exam', 0, 4),
(750, 222, 'How they first met at school', 0, 1),
(751, 222, 'A fight they had recently', 0, 2),
(752, 222, 'How their friendship has changed over time', 1, 3),
(753, 222, 'Planning a birthday surprise', 0, 4),
(754, 223, 'A website was hacked by criminals', 0, 1),
(755, 223, 'Someone had a bad experience with online communication', 1, 2),
(756, 223, 'An online shop sent the wrong product', 0, 3),
(757, 223, 'The internet connection was very slow', 0, 4),
(758, 224, 'Two teachers plan a school trip', 0, 1),
(759, 224, 'A parent and teacher discuss a child\'s progress', 1, 2),
(760, 224, 'Students organize a school event', 0, 3),
(761, 224, 'A headmaster interviews a new teacher', 0, 4),
(762, 225, 'A company leaves business advertisements', 0, 1),
(763, 225, 'Different people leave various personal messages', 1, 2),
(764, 225, 'A doctor calls about test results', 0, 3),
(765, 225, 'A bank reports a security problem', 0, 4),
(766, 226, 'A couple is planning their wedding', 0, 1),
(767, 226, 'Two people are developing romantic feelings', 1, 2),
(768, 226, 'Someone is writing a love letter', 0, 3),
(769, 226, 'A person is going through a breakup', 0, 4),
(770, 227, 'Only international political news', 0, 1),
(771, 227, 'A mix of current events and local news stories', 1, 2),
(772, 227, 'Only sports results and updates', 0, 3),
(773, 227, 'Only weather forecasts for the week', 0, 4),
(774, 228, 'Deciding how to decorate their apartment', 0, 1),
(775, 228, 'Problems and disagreements about sharing a living space', 1, 2),
(776, 228, 'Planning a housewarming party', 0, 3),
(777, 228, 'Looking for a new apartment together', 0, 4),
(778, 229, 'A court trial about a political scandal', 0, 1),
(779, 229, 'Voting and civic engagement in elections', 1, 2),
(780, 229, 'A new law being passed in parliament', 0, 3),
(781, 229, 'A protest march in the city center', 0, 4),
(782, 230, 'Someone is interviewed by a journalist', 0, 1),
(783, 230, 'Someone accidentally overhears a private conversation', 1, 2),
(784, 230, 'Two people gossip about a colleague', 0, 3),
(785, 230, 'A detective listens to a phone call', 0, 4),
(786, 231, 'A city in South America', 0, 1),
(787, 231, 'A mountain village in Asia', 0, 2),
(788, 231, 'A remote Pacific island nation and its culture', 1, 3),
(789, 231, 'An ancient European castle', 0, 4),
(810, 1, 'my', 1, 1),
(811, 1, 'your', 0, 2),
(812, 1, 'his', 0, 3),
(813, 1, 'her', 0, 4);

-- --------------------------------------------------------

--
-- Структура таблицы `tutors`
--

CREATE TABLE `tutors` (
  `tutor_id` int NOT NULL,
  `user_id` int NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `city_id` int DEFAULT NULL,
  `bio` text,
  `experience_years` int DEFAULT NULL,
  `hourly_rate` decimal(10,2) DEFAULT NULL,
  `rating` decimal(3,2) DEFAULT '5.00',
  `total_reviews` int DEFAULT '0',
  `is_verified` tinyint(1) DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  `specialization_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `tutors`
--

INSERT INTO `tutors` (`tutor_id`, `user_id`, `full_name`, `email`, `phone`, `city_id`, `bio`, `experience_years`, `hourly_rate`, `rating`, `total_reviews`, `is_verified`, `is_active`, `specialization_id`, `created_at`, `updated_at`) VALUES
(4, 6, 'Екатеринбургская Репа Олеговна', 'ekb@rep.ru', '+7-902-902-90-22', 14, 'супер я', 7, 1300.00, 3.67, 3, 1, 1, 1, '2025-12-07 13:23:09', '2026-02-25 15:48:02'),
(6, 8, 'Московская Репа Ивановна', 'msk@rep.ru', '+7-900-22-22-22', 1, 'Имею большой опыт и знания!', 5, 1500.00, 4.38, 5, 1, 1, 2, '2025-12-07 13:26:49', '2026-02-23 10:51:27'),
(8, 14, '123123123', 'pe@ku.ru', NULL, 13, NULL, NULL, NULL, 4.00, 1, 0, 1, NULL, '2025-12-10 09:39:36', '2026-02-25 16:57:50'),
(12, 21, 'Николаев Николай Николаевич', 'rep@mail.com', '+7 996 176 93 24', NULL, 'я крутой', 7, 5000.00, 4.00, 1, 0, 1, 2, '2026-02-23 10:29:21', '2026-05-04 18:14:41'),
(13, 28, 'Проба1', 'repprob1@mail.ru', NULL, 15, 'я крут крут тут', 4, 1000.00, 5.00, 0, 1, 1, 2, '2026-03-02 13:01:57', '2026-03-02 13:20:36'),
(14, 35, 'Маринина Светлана Романовна', 'testrepet@mail.com', NULL, 3, NULL, NULL, NULL, 5.00, 0, 0, 0, NULL, '2026-04-25 18:11:32', '2026-04-25 18:11:32'),
(15, 38, 'u', 'reper@mail.com', NULL, NULL, NULL, NULL, NULL, 5.00, 0, 0, 0, NULL, '2026-05-13 12:34:37', '2026-05-13 12:34:37'),
(16, 40, 'Сидорова Анастасия Игоревна', 'sveta2@mail.ru', '+7-902-902-90-22', 1, NULL, 5, 900.00, 5.00, 0, 1, 1, 5, '2026-05-14 14:41:53', '2026-05-14 14:52:30');

-- --------------------------------------------------------

--
-- Структура таблицы `tutor_certificates`
--

CREATE TABLE `tutor_certificates` (
  `certificate_id` int NOT NULL,
  `tutor_id` int NOT NULL,
  `filename` varchar(255) NOT NULL,
  `original_name` varchar(255) NOT NULL,
  `file_size` int NOT NULL,
  `uploaded_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `tutor_certificates`
--

INSERT INTO `tutor_certificates` (`certificate_id`, `tutor_id`, `filename`, `original_name`, `file_size`, `uploaded_at`) VALUES
(1, 13, 'cert_13_1772456591_e37d2920.webp', 'серт.webp', 9940, '2026-03-02 18:03:11'),
(2, 15, 'cert_15_1778675701_f17e09dc.webp', 'i (2).webp', 61150, '2026-05-13 17:35:01'),
(5, 16, 'cert_16_1778769957_20404cd2.webp', 'orig.webp', 146604, '2026-05-14 19:45:57');

-- --------------------------------------------------------

--
-- Структура таблицы `tutor_requests`
--

CREATE TABLE `tutor_requests` (
  `request_id` int NOT NULL,
  `student_id` int NOT NULL,
  `tutor_id` int NOT NULL,
  `request_text` text,
  `student_contact_name` varchar(100) DEFAULT NULL,
  `student_contact_email` varchar(100) DEFAULT NULL,
  `student_contact_phone` varchar(20) DEFAULT NULL,
  `student_age` int DEFAULT NULL,
  `social_media` varchar(255) DEFAULT NULL,
  `status` enum('pending','accepted','rejected','completed') DEFAULT 'pending',
  `lesson_type` enum('online','offline') DEFAULT 'online',
  `lesson_date` datetime DEFAULT NULL,
  `lesson_duration` int DEFAULT '60',
  `tutor_notes` text,
  `actual_duration` int DEFAULT NULL,
  `lesson_topic` varchar(255) DEFAULT NULL,
  `request_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `response_date` timestamp NULL DEFAULT NULL,
  `is_rated` tinyint(1) DEFAULT '0',
  `rating_value` tinyint DEFAULT NULL,
  `review_text` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `tutor_requests`
--

INSERT INTO `tutor_requests` (`request_id`, `student_id`, `tutor_id`, `request_text`, `student_contact_name`, `student_contact_email`, `student_contact_phone`, `student_age`, `social_media`, `status`, `lesson_type`, `lesson_date`, `lesson_duration`, `tutor_notes`, `actual_duration`, `lesson_topic`, `request_date`, `response_date`, `is_rated`, `rating_value`, `review_text`) VALUES
(1, 10, 6, 'Хотел бы записаться на 12.30 в среду 10 декабря', 'Выворотов Иван Алексеевич', 'stud@msk.ru', NULL, 20, '', 'completed', 'online', NULL, 60, NULL, NULL, NULL, '2025-12-08 18:25:44', '2025-12-10 11:09:43', 0, NULL, NULL),
(2, 10, 8, 'Я так хочу заниматься с вами, можно пж!', 'Выворотов Иван Алексеевич', 'stud@msk.ru', '+7 990 909 09 90', 22, '@telegramm', 'completed', 'online', NULL, 60, NULL, NULL, NULL, '2025-12-10 11:44:53', '2025-12-10 11:47:17', 0, NULL, NULL),
(3, 10, 8, 'Ку', 'Выворотов Иван Алексеевич', 'stud@msk.ru', NULL, 22, NULL, 'completed', 'online', '2026-03-02 19:22:00', 60, NULL, 1, NULL, '2025-12-10 11:50:32', '2026-03-02 14:22:37', 0, NULL, NULL),
(4, 10, 6, 'ку', 'Выворотов Иван Алексеевич', 'stud@msk.ru', NULL, 22, NULL, 'completed', 'online', NULL, 60, NULL, NULL, NULL, '2025-12-10 11:51:24', '2025-12-22 19:58:00', 0, NULL, NULL),
(6, 10, 6, 'Очень хочу заниматься', 'Выворотов Иван Алексеевич', 'stud@msk.ru', '+7 123 123 12 31', 22, '@telega', 'completed', 'online', NULL, 60, NULL, NULL, NULL, '2025-12-22 19:56:37', '2025-12-22 19:57:17', 0, NULL, NULL),
(12, 9, 4, 'примите', 'Иванов Олег Олегович', 'stud@ekb.ru', '+7 996 176 93 44', 19, NULL, 'rejected', 'online', NULL, 60, NULL, NULL, NULL, '2026-01-18 15:19:19', NULL, 0, NULL, NULL),
(13, 9, 4, 'примите', 'Иванов Олег Олегович', 'stud@ekb.ru', '+7 996 176 93 44', 19, NULL, 'completed', 'online', NULL, 60, NULL, NULL, NULL, '2026-01-18 15:19:27', '2026-01-18 15:20:48', 0, NULL, NULL),
(14, 10, 4, 'р', 'Выворотов Иван Алексеевич', 'stud@msk.ru', '+7 996 176 93 44', 19, NULL, 'completed', 'online', NULL, 60, NULL, NULL, NULL, '2026-01-18 15:23:18', '2026-01-18 15:25:01', 0, NULL, NULL),
(15, 10, 6, 'ghgg', 'Выворотов Иван Алексеевич', 'stud@msk.ru', '+7 996 176 93 44', 19, NULL, 'completed', 'online', NULL, 60, NULL, NULL, NULL, '2026-01-18 15:25:48', '2026-02-23 10:51:27', 1, NULL, NULL),
(16, 9, 6, 'gdg', 'Иванов Олег Олегович', 'stud@ekb.ru', '+7 996 176 93 44', 19, NULL, 'completed', 'online', NULL, 60, NULL, NULL, NULL, '2026-01-18 15:27:48', '2026-01-18 15:28:21', 0, NULL, NULL),
(17, 9, 4, 'dfh', 'Иванов Олег Олегович', 'stud@ekb.ru', '+7 996 176 93 44', 19, NULL, 'completed', 'online', NULL, 60, NULL, NULL, NULL, '2026-01-18 16:07:41', '2026-01-18 16:08:47', 1, NULL, NULL),
(18, 9, 4, 'КРВРВРВР', 'Иванов Олег Олегович', 'stud@ekb.ru', '+7 996 176 93 44', 19, NULL, 'completed', 'online', NULL, 60, NULL, NULL, NULL, '2026-01-26 09:36:21', '2026-01-26 09:37:03', 0, NULL, NULL),
(19, 9, 4, 'ауауыаува', 'Иванов Олег Олегович', 'stud@ekb.ru', '+7 996 176 93 44', 19, NULL, 'completed', 'online', NULL, 60, NULL, NULL, NULL, '2026-01-26 09:44:03', '2026-01-26 09:44:47', 0, NULL, NULL),
(20, 9, 4, 'апапиа', 'Иванов Олег Олегович', 'stud@ekb.ru', '+7 996 176 93 44', 19, 'авпа', 'completed', 'online', NULL, 60, NULL, NULL, NULL, '2026-02-11 14:17:41', '2026-02-25 15:48:02', 1, 3, 'мм'),
(21, 10, 6, 'рарп', 'Выворотов Иван Алексеевич', 'stud@msk.ru', '+7 996 176 93 44', 19, 'авпа', 'completed', 'online', NULL, 60, NULL, NULL, NULL, '2026-02-12 16:23:50', '2026-02-12 20:00:40', 1, NULL, NULL),
(22, 10, 8, 'utjy', 'Выворотов Иван Алексеевич', 'stud@msk.ru', '+7 996 176 93 44', 19, 'авпа', 'rejected', 'online', '2026-03-02 20:14:00', 30, NULL, NULL, NULL, '2026-02-12 19:58:29', NULL, 0, NULL, NULL),
(23, 10, 12, 'я хлааеанр', 'Выворотов Иван Алексеевич', 'stud@msk.ru', '+7 996 176 93 45', 20, 'авпа', 'completed', 'online', NULL, 60, NULL, NULL, NULL, '2026-02-23 11:36:15', '2026-02-23 11:40:06', 1, 4, 'неплохой репетитор'),
(24, 9, 8, 'мм', 'Иванов Олег Олегович', 'stud@ekb.ru', '+7 996 176 93 45', 20, 'авпа', 'completed', 'online', NULL, 60, NULL, NULL, NULL, '2026-02-25 16:57:04', '2026-02-25 16:57:50', 1, 4, 'пойдет'),
(25, 9, 13, 'сывс', 'Иванов Олег Олегович', 'stud@ekb.ru', '+7 996 176 93 44', 19, 'емув', 'completed', 'online', '2026-03-02 18:30:00', 60, NULL, 60, NULL, '2026-03-02 13:21:22', '2026-03-02 14:30:08', 0, NULL, NULL),
(26, 9, 6, 'пп', 'Иванов Олег Олегович', 'stud@ekb.ru', '+7 996 176 93 44', 19, 'емув', 'completed', 'offline', '2026-03-16 22:12:00', 60, 'ывыв', 1, NULL, '2026-03-02 13:33:34', '2026-03-16 17:12:26', 0, NULL, NULL),
(27, 10, 6, 'аа', 'Выворотов Иван Алексеевич', 'stud@msk.ru', '+7 996 176 93 44', 19, 'емув', 'completed', 'online', '2026-03-02 18:54:00', 60, 'аааа', NULL, NULL, '2026-03-02 13:53:11', NULL, 0, NULL, NULL),
(28, 10, 6, 'мв', 'Выворотов Иван Алексеевич', 'stud@msk.ru', '+7 996 176 93 44', 19, 'емув', 'completed', 'online', '2026-03-02 19:10:00', 30, 'акпвка', 1, NULL, '2026-03-02 14:07:51', '2026-03-02 14:10:15', 0, NULL, NULL),
(29, 10, 4, 'а', 'Выворотов Иван Алексеевич', 'stud@msk.ru', '+7 996 176 93 44', 19, 'емув', 'completed', 'online', '2026-03-03 20:11:00', 60, NULL, 0, NULL, '2026-03-02 14:11:16', '2026-03-02 14:11:54', 0, NULL, NULL),
(30, 10, 8, 'мм', 'Выворотов Иван Алексеевич', 'stud@msk.ru', '+7 996 176 93 44', 19, 'емув', 'accepted', 'online', '2026-03-05 19:16:00', 30, 'лл', NULL, NULL, '2026-03-02 14:14:11', NULL, 0, NULL, NULL),
(31, 9, 13, 'аа', 'Иванов Олег Олегович', 'stud@ekb.ru', '+7 996 176 93 44', 19, 'емув', 'completed', 'online', '2026-03-02 19:32:00', 60, 'в', 64, NULL, '2026-03-02 14:31:01', '2026-03-02 15:36:19', 0, NULL, NULL),
(32, 10, 13, 'выы', 'Выворотов Иван Алексеевич', 'stud@msk.ru', '+7 996 176 93 44', 19, 'емув', 'rejected', 'online', NULL, 60, NULL, NULL, NULL, '2026-03-04 15:09:37', NULL, 0, NULL, NULL),
(33, 32, 13, 'лд', 'g g g', 'bnhn@mail.ru', NULL, 14, 'ьо', 'completed', 'offline', '2026-03-17 13:14:00', 30, NULL, NULL, NULL, '2026-03-17 07:56:30', NULL, 0, NULL, NULL),
(34, 32, 13, 'ьь', 'g g g', 'bnhn@mail.ru', '+7 996 176 93 44', 45, 'рр', 'completed', 'online', '2026-03-17 13:32:00', 30, NULL, 1, NULL, '2026-03-17 08:31:07', '2026-03-17 08:32:15', 0, NULL, NULL),
(35, 34, 6, 'я хочу изучить уровень а1', 'Тест', 'test@mail.ru', '+7 996 176 93 44', 16, 'ссылка на вк', 'rejected', 'online', NULL, 60, NULL, NULL, NULL, '2026-04-23 12:08:50', NULL, 0, NULL, NULL),
(36, 34, 6, 'оффлайн хочу обучаца', 'Тест', 'test@mail.ru', '+7 996 176 93 44', 16, 'ссылка на вк', 'rejected', 'offline', '2026-04-25 18:06:00', 60, NULL, NULL, NULL, '2026-04-24 13:06:07', NULL, 0, NULL, NULL),
(37, 34, 6, 'uujuj', 'Тест', 'test@mail.ru', '+7 996 176 93 44', 16, 'ссылка на вк', 'rejected', 'online', '2026-04-26 10:12:00', 30, 'gtty', NULL, NULL, '2026-04-25 05:11:43', NULL, 0, NULL, NULL),
(38, 34, 6, 'rrrr', 'Тест', 'test@mail.ru', '+7 996 176 93 44', 16, 'ссылка на вк', 'rejected', 'online', '2026-04-26 10:17:00', 30, 'gfgf', NULL, NULL, '2026-04-25 05:16:36', NULL, 0, NULL, NULL),
(39, 34, 6, 'gg', 'Тест', 'test@mail.ru', '+7 996 176 93 44', 16, 'ссылка на вк', 'rejected', 'online', NULL, 60, NULL, NULL, NULL, '2026-04-25 05:20:47', NULL, 0, NULL, NULL),
(40, 9, 6, 'ggg', 'Иванов Олег Олегович', 'stud@ekb.ru', '+7 996 176 93 44', 16, 'ссылка на вк', 'completed', 'online', '2026-04-26 10:25:00', 60, 'tghgt', 91, NULL, '2026-04-25 05:21:10', '2026-04-26 06:55:55', 0, NULL, NULL),
(41, 9, 6, 'ggg', 'Иванов Олег Олегович', 'stud@ekb.ru', '+7 996 176 93 44', 16, 'ссылка на вк', 'rejected', 'online', NULL, 60, NULL, NULL, NULL, '2026-04-25 05:22:19', NULL, 0, NULL, NULL),
(42, 34, 6, 'ff', 'Тест', 'test@mail.ru', '+7 996 176 93 44', 16, 'ссылка на вк', 'completed', 'online', '2026-04-26 11:56:00', 30, 'gg', 44, 'Основы грамматики A1', '2026-04-25 05:30:13', '2026-04-26 07:40:13', 0, NULL, NULL),
(43, 34, 6, 'онлайн', 'Тест', 'test@mail.ru', '+7 996 176 93 44', 16, 'ссылка на вк', 'rejected', 'online', NULL, 60, NULL, NULL, NULL, '2026-04-25 17:57:16', NULL, 0, NULL, NULL),
(44, 34, 4, 'jjj', 'Тест', 'test@mail.ru', '+7 996 176 93 44', 16, 'ссылка на вк', 'rejected', 'online', '2026-04-26 13:45:00', 30, 'hhh', NULL, 'Основы грамматики A1', '2026-04-26 06:41:40', NULL, 0, NULL, NULL),
(45, 36, 4, 'kkm', 'sv', 'sv@mail.ru', '+7 996 176 93 44', 16, 'ссылка на вк', 'accepted', 'online', '2026-04-26 12:59:00', 30, 'njn', NULL, 'Основы грамматики A1', '2026-04-26 06:57:14', NULL, 0, NULL, NULL),
(46, 34, 6, 'sadsad', 'Тест', 'test@mail.ru', '+7 996 176 93 44', 16, 'ссылка на вк', 'accepted', 'online', NULL, 60, NULL, NULL, NULL, '2026-04-26 07:44:35', NULL, 0, NULL, NULL),
(47, 34, 13, 'fff', 'Тест', 'test@mail.ru', '+7 996 176 93 44', 16, 'ссылка на вк', 'pending', 'online', NULL, 60, NULL, NULL, NULL, '2026-05-04 16:01:43', NULL, 0, NULL, NULL),
(48, 37, 4, 'Хочу изучить модуль А1, онлайн формат обучения', 'Тест Тестовый Тестович', 'new@mail.com', '+7 996 176 93 44', 16, 'ссылка на вк', 'accepted', 'online', '2026-05-05 10:30:00', 45, 'Ознакомительный урок, подготовьте пожалуйста вопросы по этому уровню.', NULL, 'Основы грамматики A1', '2026-05-04 17:59:05', NULL, 0, NULL, NULL),
(49, 34, 6, 'примите', 'Тест', 'test@mail.ru', '+7 996 176 93 44', 16, 'ссылка на вк', 'pending', 'online', NULL, 60, NULL, NULL, NULL, '2026-05-14 14:38:13', NULL, 0, NULL, NULL),
(50, 39, 16, 'время как вам удобно', 'Кузнецов Андрей Андреевич', 'sveta@mail.ru', '+7 996 176 93 44', 16, 'ссылка на вк', 'accepted', 'online', '2026-05-14 19:56:00', 30, 'знакомство и введение', NULL, 'Основы грамматики A1', '2026-05-14 14:54:16', NULL, 0, NULL, NULL),
(51, 9, 16, 'можно занятие на 16.05.2026? время 13:00, если есть свободные места.', 'Иванов Олег Олегович', 'stud@ekb.ru', '+7 996 176 93 45', 19, 'ссылка на тг', 'accepted', 'online', '2026-05-16 13:00:00', 45, NULL, NULL, 'Словарь C2', '2026-05-14 14:57:24', NULL, 0, NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `tutor_specializations`
--

CREATE TABLE `tutor_specializations` (
  `specialization_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `tutor_specializations`
--

INSERT INTO `tutor_specializations` (`specialization_id`, `name`, `description`) VALUES
(1, 'General English', 'Общий английский язык'),
(2, 'Business English', 'Деловой английский'),
(3, 'Exam Preparation', 'Подготовка к экзаменам (IELTS, TOEFL)'),
(4, 'Conversational English', 'Разговорный английский'),
(5, 'English for Kids', 'Английский для детей'),
(6, 'Technical English', 'Технический английский');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `user_id` int NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `city_id` int DEFAULT NULL,
  `current_level_id` int DEFAULT '1',
  `registration_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_login` timestamp NULL DEFAULT NULL,
  `user_type` enum('student','tutor','admin') DEFAULT 'student',
  `is_active` tinyint(1) DEFAULT '1',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`user_id`, `username`, `email`, `password_hash`, `full_name`, `city_id`, `current_level_id`, `registration_date`, `last_login`, `user_type`, `is_active`, `updated_at`) VALUES
(6, 'Реп екб', 'ekb@rep.ru', '$2y$10$hi4pCvsE2roP/MlNBTipjOmVDToomNsqAsgv5wr0yHFonbC4pvFbq', 'Екатеринбургская Репа Олеговна', 14, 1, '2025-12-07 13:23:09', '2026-05-14 14:34:20', 'tutor', 1, '2026-05-14 14:34:20'),
(8, 'Реп мск', 'msk@rep.ru', '$2y$10$Qal/TQXYozI3akNKwmif9uliOWIGr3sjOSTsXdPFjFJEX/kUyBlZO', 'Московская Репа Ивановна', 1, NULL, '2025-12-07 13:26:49', '2026-05-14 14:35:19', 'tutor', 1, '2026-05-14 14:35:19'),
(9, 'СкуфГерой', 'stud@ekb.ru', '$2y$10$HvYlqQr.R4u.talrwh2g2ejFlOBH1bWcZ3MUIyZuM5dc0XWZkw.r2', 'Иванов Олег Олегович', NULL, 6, '2025-12-08 13:18:18', '2026-05-14 14:55:47', 'student', 1, '2026-05-14 14:55:47'),
(10, 'Крутой Игорь', 'stud@msk.ru', '$2y$10$DweE/T69dKLmcSymPIVDAOQ0jmr36BWqZt3IIAUKaQ03ZB6f9JDgK', 'Выворотов Иван Алексеевич', 13, 3, '2025-12-08 13:43:10', '2026-03-12 12:16:13', 'student', 1, '2026-03-12 12:16:13'),
(13, '123', 'ku@ma.ru', '$2y$10$0t17hNYP0PeJntj/KYc/5.5gos8rRlZ9TjIfE76L8zixks092AJ6i', '123', 1, 1, '2025-12-10 09:38:54', '2025-12-10 09:38:54', 'student', 1, '2025-12-10 09:38:54'),
(14, '123123', 'pe@ku.ru', '$2y$10$fKn1hSBjaujAOgfzllEgyeOJH1WxnFqRvXwnrKij8vh6z9bGd/RtO', '123123123', NULL, 1, '2025-12-10 09:39:36', '2026-03-02 14:21:22', 'tutor', 1, '2026-03-02 14:21:22'),
(15, 'admin', 'adm@adm.ru', '$2y$10$Z5jELBs8bBQZktv.kvQwN.rJL1LBA1mBc1SNbwNh6aIBiOmRnwkyy', 'admin', NULL, 1, '2025-12-10 12:37:48', '2026-05-14 14:42:34', 'admin', 1, '2026-05-14 14:42:34'),
(21, 'rep', 'rep@mail.com', '$2y$10$AtdZmJ0mR1dptAnV4HSZ5OW9SpIdVwdjwgeMZe.mOfhgVYC1a4hBq', 'Николаев Николай Николаевич', NULL, 1, '2026-02-23 10:29:21', '2026-05-04 18:13:30', 'tutor', 1, '2026-05-04 18:14:41'),
(23, 'prob', 'probst@mail.ru', '$2y$10$dSqZEQ4BLBGAorrYitP4Ju9pz9XolbmiKCzXNF73CzxULiLkHUvSO', 'Михаилов Михаил Михайлович', NULL, 2, '2026-02-23 12:46:16', '2026-02-25 16:12:36', 'student', 1, '2026-02-25 16:12:56'),
(24, 'proba', 'prob2@mail.ru', '$2y$10$qDq1l4/UKQHd8ncO5PbakeQFulzLwZ/mLS9buZcO7kCIa8sc3pjeK', 'Пробую', 1, 1, '2026-02-25 17:39:48', '2026-02-25 17:42:32', 'student', 1, '2026-02-25 17:42:32'),
(25, 'proba3', 'proba3@mail.ru', '$2y$10$ecs2YedI/cdQY3XZwI6H7uJOyE4MLkEP2Tx7ydUHxi22oDO5AAoNi', 'Пробую3', 15, 1, '2026-02-26 11:01:22', '2026-02-26 12:02:12', 'student', 1, '2026-02-26 12:02:12'),
(26, 'proba4', 'proba4@mail.ru', '$2y$10$fl.fDUgbZkF3oAtualxbWekmxe8LqaLrQ7Iz3ZNMIOh2aBozp4H4y', 'Пробую4', NULL, 1, '2026-02-26 12:16:12', '2026-02-26 12:26:57', 'student', 1, '2026-02-26 12:26:57'),
(27, 'proba5', 'proba5@mail.ru', '$2y$10$/NOeqaDJ8o2SrPwY6wPD.ODJQGLgxPCnDjVjhJzUOCSx76p/twE1W', 'Пробую5', NULL, 1, '2026-02-26 12:30:26', '2026-02-27 10:19:17', 'student', 1, '2026-02-27 10:19:17'),
(28, 'repprob1', 'repprob1@mail.ru', '$2y$10$dtMiqLY8WfJuo4Cay/QgT.Y9uiJ7VVQykhllFO0mXOLd/g10j1HdW', 'Проба1', 15, 1, '2026-03-02 13:01:57', '2026-03-17 08:31:45', 'tutor', 1, '2026-03-17 08:31:45'),
(29, 'pr', 'pprob@mail.com', '$2y$10$PA.9/H0/TkhcLMCraoPv2eWtVbT4DBjxDUCrTHKW6nZvvVo4kz7Um', 'fdvd', NULL, 1, '2026-03-04 15:56:24', '2026-03-17 08:31:23', 'student', 1, '2026-03-17 08:31:23'),
(30, 'hth', 'proba6@mail.ru', '$2y$10$H7zWo/MBS1NA8ix1R3Y7KOBDbY3HEUxowKidq.dgE5SxElTt/CjPq', 'egr', 1, 1, '2026-03-09 16:40:38', '2026-03-12 16:07:51', 'student', 1, '2026-03-12 16:07:51'),
(31, 'd', 'fdvdf@mail.ru', '$2y$10$/bJ4NE9gzP.fptBUt.sVpOliVkd93JhWNd9XXPovVk84eOKyA/o.6', 'd', 1, 1, '2026-03-12 15:18:33', '2026-03-13 11:10:18', 'student', 1, '2026-03-13 11:10:18'),
(32, 'hb', 'bnhn@mail.ru', '$2y$10$Z9B5pwzcFpj4eoWWJVK1p.yZpfI37R0kBZyvc53huZjIXs0LSOdJe', 'g g g', 1, 1, '2026-03-17 07:55:58', '2026-03-17 08:30:51', 'student', 1, '2026-03-17 08:30:51'),
(33, 'j', 'sgs@mail.ru', '$2y$10$A9AtMT4YEA7uZmEsHHBVCOyJJgnzN5v1CxpSS7MzRpFKrkS.qteHe', 'jhkj mnhb nh', 3, 1, '2026-04-11 12:07:59', '2026-05-14 14:37:10', 'student', 1, '2026-05-14 14:37:10'),
(34, 'testuser', 'test@mail.ru', '$2y$10$rNiBvEHwYL/iDYt5hTwpmecldXtue3KgYO/PExhxUTy9FaQnyZ.Py', 'Тест', NULL, 1, '2026-04-23 11:57:01', '2026-05-14 14:37:43', 'student', 1, '2026-05-14 14:37:43'),
(35, 'Репетитор тест', 'testrepet@mail.com', '$2y$10$MBLMi2pV/9H7ZbBbjlfFvuD.UAz0MvxUonHlcnKy8ZqvDakH84h1u', 'Маринина Светлана Романовна', NULL, 1, '2026-04-25 18:11:32', '2026-05-14 14:36:05', 'tutor', 1, '2026-05-14 14:36:05'),
(36, 'sv', 'sv@mail.ru', '$2y$10$6gym5puJPng8xybJkYunyua/2z0fheksm6Rh6fZpHnt8kGpv/.E/i', 'sv', NULL, 1, '2026-04-26 06:50:21', '2026-05-13 12:33:36', 'student', 1, '2026-05-13 12:33:36'),
(37, 'Тест', 'new@mail.com', '$2y$10$2m3UYJ12gogJ9OaUwot14.ViMWdivygcqGKIVmfmA.rxKMh6vCV2m', 'Тест Тестовый Тестович', 3, 1, '2026-05-04 17:52:51', '2026-05-13 12:33:56', 'student', 1, '2026-05-13 12:33:56'),
(38, 'reper', 'reper@mail.com', '$2y$10$O3AVw0KN.g2vqNaeGDdk5uaRJjeuw0x0jKbuvDtKeIchcyBiUSFP.', 'u', NULL, 1, '2026-05-13 12:34:37', '2026-05-14 14:36:41', 'tutor', 1, '2026-05-14 14:36:41'),
(39, 'Андрей', 'sveta@mail.ru', '$2y$10$LeeBQeOT1s2OCXegWs7lS.9DDIGw3yB6A4rsKd2dcqNVsp0uApORe', 'Кузнецов Андрей Андреевич', 3, 1, '2026-05-14 14:40:14', '2026-05-14 16:19:16', 'student', 1, '2026-05-14 16:19:16'),
(40, 'Анастасия', 'sveta2@mail.ru', '$2y$10$f7qjRFR1wZ2EHtXKNKJ6SeriMe9QwuumuixYZYiTYJ5ifBpWcyHTO', 'Сидорова Анастасия Игоревна', 1, 1, '2026-05-14 14:41:53', '2026-05-14 16:18:32', 'tutor', 1, '2026-05-14 16:18:32');

-- --------------------------------------------------------

--
-- Структура таблицы `user_answers`
--

CREATE TABLE `user_answers` (
  `answer_id` int NOT NULL,
  `user_id` int NOT NULL,
  `task_id` int NOT NULL,
  `user_answer` text NOT NULL,
  `is_correct` tinyint(1) DEFAULT NULL,
  `points_earned` int DEFAULT '0',
  `attempt_number` int DEFAULT '1',
  `answered_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `user_answers`
--

INSERT INTO `user_answers` (`answer_id`, `user_id`, `task_id`, `user_answer`, `is_correct`, `points_earned`, `attempt_number`, `answered_at`) VALUES
(153, 23, 1, '1', 1, 5, 1, '2026-02-25 12:33:29'),
(154, 23, 2, '5', 1, 5, 1, '2026-02-25 12:33:37'),
(155, 23, 3, '9', 1, 5, 1, '2026-02-25 12:33:40'),
(156, 23, 4, '13', 1, 5, 1, '2026-02-25 12:34:58'),
(157, 23, 5, '17', 1, 5, 1, '2026-02-25 12:35:14'),
(158, 23, 6, '21', 1, 5, 1, '2026-02-25 12:35:20'),
(159, 23, 7, '25', 1, 5, 1, '2026-02-25 12:35:26'),
(160, 23, 8, '29', 1, 5, 1, '2026-02-25 12:35:30'),
(161, 23, 9, '33', 1, 5, 1, '2026-02-25 12:35:33'),
(162, 23, 10, '37', 1, 5, 1, '2026-02-25 12:35:35'),
(163, 23, 11, '41', 1, 5, 1, '2026-02-25 12:35:37'),
(164, 23, 12, '45', 1, 5, 1, '2026-02-25 12:35:40'),
(165, 23, 13, '49', 1, 5, 1, '2026-02-25 12:37:24'),
(166, 23, 14, 'have', 1, 5, 1, '2026-02-25 12:38:46'),
(167, 23, 15, '54', 0, 0, 1, '2026-02-25 12:39:29'),
(168, 23, 16, 'study', 1, 5, 1, '2026-02-25 12:40:14'),
(187, 9, 21, '65', 1, 5, 1, '2026-02-25 15:34:24'),
(188, 9, 22, '70', 0, 0, 1, '2026-02-25 15:34:30'),
(189, 9, 23, 'played', 1, 5, 1, '2026-02-25 15:34:41'),
(190, 9, 24, 'watched', 1, 5, 1, '2026-02-25 15:34:47'),
(191, 9, 25, 'went', 0, 0, 1, '2026-02-25 15:34:53'),
(192, 9, 26, '73', 1, 5, 1, '2026-02-25 15:35:05'),
(193, 9, 27, '77', 1, 5, 1, '2026-02-25 15:35:15'),
(194, 9, 28, '81', 1, 5, 1, '2026-02-25 15:35:20'),
(195, 9, 29, '85', 1, 5, 1, '2026-02-25 15:35:33'),
(196, 9, 30, '89', 1, 5, 1, '2026-02-25 15:35:35'),
(197, 9, 31, '93', 1, 5, 1, '2026-02-25 15:35:37'),
(198, 9, 32, '97', 1, 5, 1, '2026-02-25 15:35:39'),
(199, 9, 33, '101', 1, 5, 1, '2026-02-25 15:35:40'),
(200, 9, 34, '105', 1, 5, 1, '2026-02-25 15:35:45'),
(201, 9, 35, 'went', 1, 5, 1, '2026-02-25 15:35:59'),
(202, 9, 36, '109', 1, 5, 1, '2026-02-25 15:36:06'),
(203, 9, 37, 'studied', 0, 0, 1, '2026-02-25 15:36:19'),
(204, 9, 38, '113', 1, 5, 1, '2026-02-25 15:36:24'),
(205, 9, 39, 'has finished', 1, 5, 1, '2026-02-25 15:36:33'),
(206, 9, 40, '117', 1, 5, 1, '2026-02-25 15:36:38'),
(207, 9, 53, '197', 1, 10, 1, '2026-02-25 15:40:06'),
(208, 9, 54, '199', 1, 10, 1, '2026-02-25 15:40:09'),
(209, 9, 55, '204', 0, 0, 1, '2026-02-25 15:40:11'),
(222, 9, 47, '175', 0, 0, 1, '2026-02-25 15:42:51'),
(223, 9, 48, '177', 1, 10, 1, '2026-02-25 15:42:52'),
(224, 9, 49, '184', 0, 0, 1, '2026-02-25 15:42:53'),
(225, 9, 50, '187', 0, 0, 1, '2026-02-25 15:42:54'),
(226, 9, 51, '190', 0, 0, 1, '2026-02-25 15:42:55'),
(227, 9, 52, '195', 0, 0, 1, '2026-02-25 15:42:56'),
(228, 9, 41, '152', 0, 0, 1, '2026-02-25 15:43:00'),
(229, 9, 42, '153', 1, 10, 1, '2026-02-25 15:43:01'),
(230, 9, 43, 'с', 0, 0, 1, '2026-02-25 15:43:03'),
(231, 9, 44, '162', 0, 0, 1, '2026-02-25 15:43:05'),
(232, 9, 45, '165', 1, 10, 1, '2026-02-25 15:43:06'),
(233, 9, 46, 'в', 0, 0, 1, '2026-02-25 15:43:08'),
(234, 9, 56, 'ы', 0, 0, 1, '2026-02-25 15:43:13'),
(235, 9, 57, '209', 1, 10, 1, '2026-02-25 15:43:15'),
(236, 9, 58, 'вс', 0, 0, 1, '2026-02-25 15:43:17'),
(237, 9, 59, '216', 0, 0, 1, '2026-02-25 15:43:18'),
(238, 9, 60, 'с', 0, 0, 1, '2026-02-25 15:43:20'),
(239, 9, 61, '221', 1, 15, 1, '2026-02-25 15:43:30'),
(240, 9, 62, '226', 0, 0, 1, '2026-02-25 15:43:33'),
(241, 9, 63, 'с', 0, 0, 1, '2026-02-25 15:43:36'),
(242, 9, 64, '234', 0, 0, 1, '2026-02-25 15:43:37'),
(243, 9, 65, 'в', 0, 0, 1, '2026-02-25 15:43:38'),
(244, 9, 66, '241', 1, 15, 1, '2026-02-25 15:43:39'),
(257, 9, 67, '247', 0, 0, 1, '2026-02-25 15:44:13'),
(258, 9, 68, '250', 0, 0, 1, '2026-02-25 15:44:14'),
(259, 9, 69, '254', 0, 0, 1, '2026-02-25 15:44:15'),
(260, 9, 70, '258', 0, 0, 1, '2026-02-25 15:44:16'),
(261, 9, 71, '261', 1, 15, 1, '2026-02-25 15:44:17'),
(262, 9, 72, '267', 0, 0, 1, '2026-02-25 15:44:18'),
(263, 9, 73, '269', 1, 15, 1, '2026-02-25 15:44:22'),
(264, 9, 74, 'd', 0, 0, 1, '2026-02-25 15:44:26'),
(265, 9, 75, '275', 1, 15, 1, '2026-02-25 15:44:28'),
(266, 9, 76, 'd', 0, 0, 1, '2026-02-25 15:44:29'),
(267, 9, 77, '281', 1, 15, 1, '2026-02-25 15:44:30'),
(268, 9, 78, 'd', 0, 0, 1, '2026-02-25 15:44:31'),
(269, 9, 79, '288', 0, 0, 1, '2026-02-25 15:44:33'),
(270, 9, 80, 'а', 0, 0, 1, '2026-02-25 15:46:58'),
(271, 9, 93, '342', 0, 0, 1, '2026-02-25 15:52:37'),
(272, 9, 94, 'didn', 0, 0, 1, '2026-02-25 15:53:34'),
(273, 9, 95, '347', 1, 20, 1, '2026-02-25 16:03:27'),
(274, 9, 96, '349', 1, 20, 1, '2026-02-25 16:03:29'),
(275, 9, 97, '355', 0, 0, 1, '2026-02-25 16:03:31'),
(276, 9, 98, 'ма', 0, 0, 1, '2026-02-25 16:03:33'),
(277, 9, 99, '361', 1, 20, 1, '2026-02-25 16:03:35'),
(278, 9, 100, 'мв', 0, 0, 1, '2026-02-25 16:03:37'),
(279, 9, 81, '295', 0, 0, 1, '2026-02-25 16:04:34'),
(280, 9, 82, 'ма', 0, 0, 1, '2026-02-25 16:04:35'),
(281, 9, 83, '302', 0, 0, 1, '2026-02-25 16:04:36'),
(282, 9, 84, 'ма', 0, 0, 1, '2026-02-25 16:04:38'),
(283, 9, 85, 'ам', 0, 0, 1, '2026-02-25 16:04:39'),
(284, 9, 86, '313', 1, 20, 1, '2026-02-25 16:04:40'),
(285, 9, 87, '320', 0, 0, 1, '2026-02-25 16:04:43'),
(286, 9, 88, '321', 1, 20, 1, '2026-02-25 16:04:44'),
(287, 9, 89, '327', 0, 0, 1, '2026-02-25 16:04:45'),
(288, 9, 90, '330', 0, 0, 1, '2026-02-25 16:04:47'),
(289, 9, 91, '335', 0, 0, 1, '2026-02-25 16:04:49'),
(290, 9, 92, '339', 0, 0, 1, '2026-02-25 16:04:50'),
(303, 9, 113, '415', 1, 25, 1, '2026-02-25 16:05:19'),
(304, 9, 114, 'dd', 0, 0, 1, '2026-02-25 16:05:25'),
(305, 9, 115, '421', 1, 25, 1, '2026-02-25 16:05:28'),
(306, 9, 116, 'ff', 0, 0, 1, '2026-02-25 16:05:31'),
(307, 9, 117, '428', 0, 0, 1, '2026-02-25 16:05:32'),
(308, 9, 118, 'rfgf', 0, 0, 1, '2026-02-25 16:05:34'),
(319, 23, 21, '65', 1, 5, 1, '2026-02-25 16:13:01'),
(320, 23, 22, '70', 0, 0, 1, '2026-02-25 16:13:03'),
(321, 23, 23, 'с', 0, 0, 1, '2026-02-25 16:13:05'),
(322, 23, 24, 'а', 0, 0, 1, '2026-02-25 16:13:06'),
(323, 23, 25, 'а', 0, 0, 1, '2026-02-25 16:13:07'),
(324, 23, 26, '73', 1, 5, 1, '2026-02-25 16:13:08'),
(325, 23, 27, '78', 0, 0, 1, '2026-02-25 16:13:14'),
(326, 23, 28, '84', 0, 0, 1, '2026-02-25 16:13:15'),
(327, 23, 29, '87', 0, 0, 1, '2026-02-25 16:13:17'),
(328, 23, 30, '91', 0, 0, 1, '2026-02-25 16:13:18'),
(329, 23, 31, '95', 0, 0, 1, '2026-02-25 16:13:19'),
(330, 23, 32, '99', 0, 0, 1, '2026-02-25 16:13:21'),
(331, 23, 33, '102', 0, 0, 1, '2026-02-25 16:13:23'),
(332, 23, 34, '105', 1, 5, 1, '2026-02-25 16:13:29'),
(333, 9, 119, '433', 1, 25, 1, '2026-02-25 16:34:17'),
(334, 9, 120, '642', 0, 0, 1, '2026-02-25 16:34:21'),
(335, 9, 107, '391', 1, 25, 1, '2026-02-25 16:34:28'),
(336, 9, 108, '395', 1, 25, 1, '2026-02-25 16:34:32'),
(337, 9, 109, '399', 1, 25, 1, '2026-02-25 16:34:34'),
(338, 9, 110, '403', 1, 25, 1, '2026-02-25 16:34:41'),
(339, 9, 111, '407', 1, 25, 1, '2026-02-25 16:34:44'),
(340, 9, 112, '412', 0, 0, 1, '2026-02-25 16:34:59'),
(353, 10, 21, '68', 0, 0, 1, '2026-02-25 17:20:16'),
(354, 10, 22, '70', 0, 0, 1, '2026-02-25 17:20:18'),
(355, 10, 23, 'и', 0, 0, 1, '2026-02-25 17:20:19'),
(356, 10, 24, 'и', 0, 0, 1, '2026-02-25 17:20:20'),
(357, 10, 25, 'и', 0, 0, 1, '2026-02-25 17:20:22'),
(358, 10, 26, '73', 1, 5, 1, '2026-02-25 17:20:23'),
(359, 24, 13, '51', 0, 0, 1, '2026-02-25 17:42:39'),
(360, 24, 14, '560', 1, 5, 1, '2026-02-25 17:42:50'),
(361, 24, 15, '56', 0, 0, 1, '2026-02-25 17:42:52'),
(429, 10, 27, '78', 0, 0, 1, '2026-03-04 15:37:43'),
(430, 10, 28, '82', 0, 0, 1, '2026-03-04 15:37:44'),
(431, 10, 29, '88', 0, 0, 1, '2026-03-04 15:37:45'),
(432, 10, 30, '91', 0, 0, 1, '2026-03-04 15:37:46'),
(433, 10, 31, '94', 0, 0, 1, '2026-03-04 15:37:47'),
(434, 10, 32, '97', 1, 5, 1, '2026-03-04 15:37:49'),
(435, 10, 33, '104', 0, 0, 1, '2026-03-04 15:37:51'),
(436, 10, 34, '107', 0, 0, 1, '2026-03-04 15:37:57'),
(437, 10, 35, '575', 0, 0, 1, '2026-03-04 15:37:59'),
(438, 10, 36, '112', 0, 0, 1, '2026-03-04 15:38:00'),
(439, 10, 37, '579', 0, 0, 1, '2026-03-04 15:38:01'),
(440, 10, 38, '115', 0, 0, 1, '2026-03-04 15:38:03'),
(441, 10, 39, '583', 0, 0, 1, '2026-03-04 15:38:04'),
(442, 10, 40, '120', 0, 0, 1, '2026-03-04 15:38:05'),
(461, 10, 41, '152', 0, 0, 1, '2026-03-04 15:55:54'),
(462, 29, 1, '1', 1, 5, 1, '2026-03-04 15:56:31'),
(463, 29, 2, '5', 1, 5, 1, '2026-03-04 15:56:35'),
(464, 29, 3, '9', 1, 5, 1, '2026-03-04 15:56:38'),
(465, 29, 4, '13', 1, 5, 1, '2026-03-04 15:56:40'),
(466, 29, 5, '17', 1, 5, 1, '2026-03-04 15:56:53'),
(467, 29, 6, '21', 1, 5, 1, '2026-03-04 15:56:55'),
(468, 29, 7, '25', 1, 5, 1, '2026-03-04 15:56:56'),
(469, 29, 8, '29', 1, 5, 1, '2026-03-04 15:56:58'),
(470, 29, 9, '33', 1, 5, 1, '2026-03-04 15:57:00'),
(471, 29, 10, '37', 1, 5, 1, '2026-03-04 15:57:01'),
(472, 29, 11, '41', 1, 5, 1, '2026-03-04 15:57:03'),
(473, 29, 12, '45', 1, 5, 1, '2026-03-04 15:57:05'),
(497, 10, 53, '198', 0, 0, 1, '2026-03-12 15:06:37'),
(498, 10, 54, '200', 0, 0, 1, '2026-03-12 15:06:38'),
(552, 31, 196, '648', 0, 0, 1, '2026-03-13 11:10:24'),
(553, 31, 197, '651', 1, 5, 1, '2026-03-13 11:10:26'),
(554, 31, 198, '656', 0, 0, 1, '2026-03-13 11:10:27'),
(555, 31, 214, '719', 0, 0, 1, '2026-03-13 11:10:28'),
(556, 31, 215, '722', 0, 0, 1, '2026-03-13 11:10:30'),
(557, 31, 216, '727', 1, 5, 1, '2026-03-13 11:10:31'),
(570, 34, 196, '646', 1, 5, 1, '2026-04-24 13:03:57'),
(571, 34, 197, '650', 0, 0, 1, '2026-04-24 13:04:00'),
(572, 34, 198, '655', 1, 5, 1, '2026-04-24 13:04:01'),
(573, 34, 214, '720', 0, 0, 1, '2026-04-24 13:04:04'),
(574, 34, 215, '722', 0, 0, 1, '2026-04-24 13:04:05'),
(575, 34, 216, '726', 0, 0, 1, '2026-04-24 13:04:07'),
(576, 34, 232, 'Hello.', 0, 0, 1, '2026-04-24 13:04:36'),
(593, 34, 233, 'j', 0, 0, 1, '2026-04-26 06:15:04'),
(594, 34, 1, '810', 1, 5, 1, '2026-04-26 06:47:53'),
(595, 34, 2, '5', 1, 5, 1, '2026-04-26 06:47:55'),
(596, 34, 3, '9', 1, 5, 1, '2026-04-26 06:47:57'),
(597, 34, 4, '14', 0, 0, 1, '2026-04-26 06:48:05'),
(606, 34, 5, '17', 1, 5, 1, '2026-04-26 06:48:31'),
(607, 34, 6, '21', 1, 5, 1, '2026-04-26 06:48:33'),
(608, 34, 7, '25', 1, 5, 1, '2026-04-26 06:48:37'),
(609, 34, 8, '29', 1, 5, 1, '2026-04-26 06:48:39'),
(610, 34, 9, '33', 1, 5, 1, '2026-04-26 06:48:41'),
(611, 34, 10, '37', 1, 5, 1, '2026-04-26 06:48:43'),
(612, 34, 11, '41', 1, 5, 1, '2026-04-26 06:48:45'),
(613, 34, 12, '45', 1, 5, 1, '2026-04-26 06:48:46'),
(614, 34, 13, '51', 0, 0, 1, '2026-04-26 06:49:36'),
(615, 34, 14, '561', 0, 0, 1, '2026-04-26 06:49:38'),
(616, 34, 15, '56', 0, 0, 1, '2026-04-26 06:49:39'),
(617, 34, 16, '564', 1, 5, 1, '2026-04-26 06:49:40'),
(622, 36, 1, '810', 1, 5, 1, '2026-04-26 06:56:53'),
(623, 36, 2, '6', 0, 0, 1, '2026-04-26 06:56:55'),
(624, 36, 3, '10', 0, 0, 1, '2026-04-26 06:56:57'),
(625, 36, 4, '14', 0, 0, 1, '2026-04-26 06:57:00'),
(634, 37, 1, '810', 1, 5, 1, '2026-05-04 17:56:46'),
(635, 37, 2, '5', 1, 5, 1, '2026-05-04 17:56:48'),
(636, 37, 3, '10', 0, 0, 1, '2026-05-04 17:56:50'),
(637, 37, 4, '14', 0, 0, 1, '2026-05-04 17:56:52'),
(638, 39, 1, '810', 1, 5, 1, '2026-05-14 14:40:21'),
(639, 39, 2, '5', 1, 5, 1, '2026-05-14 14:40:24'),
(640, 39, 3, '10', 0, 0, 1, '2026-05-14 14:40:26'),
(641, 39, 4, '15', 0, 0, 1, '2026-05-14 14:40:30');

-- --------------------------------------------------------

--
-- Структура таблицы `user_progress`
--

CREATE TABLE `user_progress` (
  `progress_id` int NOT NULL,
  `user_id` int NOT NULL,
  `level_id` int NOT NULL,
  `tasks_completed` int DEFAULT '0',
  `total_tasks` int DEFAULT NULL,
  `current_score` int DEFAULT '0',
  `max_score` int DEFAULT '0',
  `completion_percentage` int DEFAULT '0',
  `last_activity_date` timestamp NULL DEFAULT NULL,
  `status` enum('not_started','in_progress','completed','certified') DEFAULT 'not_started',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `user_progress`
--

INSERT INTO `user_progress` (`progress_id`, `user_id`, `level_id`, `tasks_completed`, `total_tasks`, `current_score`, `max_score`, `completion_percentage`, `last_activity_date`, `status`, `updated_at`) VALUES
(5, 10, 1, 0, NULL, 0, 0, 0, '2025-12-20 17:05:13', 'not_started', '2026-02-23 12:50:17'),
(6, 9, 1, 0, NULL, 0, 0, 0, '2026-01-26 09:43:50', 'not_started', '2026-02-23 12:50:17'),
(8, 13, 1, 0, NULL, 0, 0, 0, NULL, 'not_started', '2025-12-10 09:38:54'),
(9, 15, 1, 0, NULL, 0, 0, 0, NULL, 'not_started', '2025-12-10 12:37:48'),
(11, 10, 2, 32, NULL, 10, 0, 100, '2026-03-04 15:38:30', 'completed', '2026-03-04 15:38:52'),
(14, 9, 2, 32, NULL, 115, 0, 100, '2026-02-25 15:36:38', 'completed', '2026-02-25 15:36:49'),
(17, 23, 1, 38, NULL, 110, 0, 119, '2026-02-25 16:12:53', 'completed', '2026-02-25 16:12:56'),
(18, 9, 3, 32, NULL, 70, 0, 100, '2026-02-25 15:43:20', 'completed', '2026-02-25 15:43:22'),
(19, 9, 4, 32, NULL, 120, 0, 100, '2026-02-25 15:46:58', 'completed', '2026-02-25 15:52:21'),
(20, 9, 5, 32, NULL, 120, 0, 100, '2026-02-25 16:05:08', 'completed', '2026-02-25 16:05:13'),
(21, 9, 6, 14, NULL, 200, 0, 44, '2026-02-25 16:34:59', 'in_progress', '2026-02-25 16:34:59'),
(22, 23, 2, 14, NULL, 15, 0, 44, '2026-02-25 16:13:29', 'in_progress', '2026-02-25 16:13:29'),
(23, 24, 1, 5, NULL, 5, 0, 16, '2026-02-25 17:44:09', 'in_progress', '2026-02-25 17:44:09'),
(24, 25, 1, 13, NULL, 0, 0, 38, '2026-02-26 11:40:54', 'in_progress', '2026-02-26 11:40:54'),
(25, 26, 1, 13, NULL, 15, 0, 39, '2026-02-26 12:27:35', 'in_progress', '2026-02-26 12:27:35'),
(26, 27, 1, 13, NULL, 10, 0, 39, '2026-02-27 10:20:23', 'in_progress', '2026-02-27 10:20:23'),
(27, 10, 3, 15, NULL, 20, 0, 58, '2026-03-12 15:16:51', 'in_progress', '2026-03-12 15:17:28'),
(28, 29, 1, 12, NULL, 60, 0, 50, '2026-03-12 15:50:41', 'in_progress', '2026-03-12 15:50:43'),
(29, 30, 1, 0, NULL, 0, 0, 0, '2026-03-12 16:09:30', 'not_started', '2026-03-12 16:09:32'),
(30, 31, 1, 6, NULL, 10, 0, 25, '2026-03-13 11:10:31', 'in_progress', '2026-03-13 11:10:31'),
(31, 32, 1, 0, NULL, 0, 0, 0, NULL, 'not_started', '2026-03-17 07:55:58'),
(32, 33, 1, 0, NULL, 0, 0, 0, NULL, 'not_started', '2026-04-11 12:07:59'),
(33, 34, 1, 24, NULL, 70, 0, 100, '2026-04-26 06:49:40', 'completed', '2026-04-26 06:49:40'),
(34, 36, 1, 4, NULL, 5, 0, 17, '2026-04-26 06:57:00', 'in_progress', '2026-04-26 06:57:00'),
(35, 37, 1, 4, NULL, 10, 0, 17, '2026-05-04 17:56:52', 'in_progress', '2026-05-04 17:56:52'),
(36, 39, 1, 4, NULL, 10, 0, 17, '2026-05-14 14:40:30', 'in_progress', '2026-05-14 14:40:30');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `achievements`
--
ALTER TABLE `achievements`
  ADD PRIMARY KEY (`achievement_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Индексы таблицы `audio_files`
--
ALTER TABLE `audio_files`
  ADD PRIMARY KEY (`audio_id`);

--
-- Индексы таблицы `chat_messages`
--
ALTER TABLE `chat_messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `idx_chat_sender_receiver` (`sender_id`,`receiver_id`),
  ADD KEY `idx_chat_receiver_read` (`receiver_id`,`is_read`);

--
-- Индексы таблицы `cities`
--
ALTER TABLE `cities`
  ADD PRIMARY KEY (`city_id`),
  ADD UNIQUE KEY `city_name` (`city_name`);

--
-- Индексы таблицы `levels`
--
ALTER TABLE `levels`
  ADD PRIMARY KEY (`level_id`),
  ADD UNIQUE KEY `level_code` (`level_code`);

--
-- Индексы таблицы `modules`
--
ALTER TABLE `modules`
  ADD PRIMARY KEY (`module_id`),
  ADD KEY `level_id` (`level_id`);

--
-- Индексы таблицы `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`task_id`),
  ADD KEY `module_id` (`module_id`),
  ADD KEY `idx_tasks_module` (`module_id`,`is_active`);

--
-- Индексы таблицы `task_options`
--
ALTER TABLE `task_options`
  ADD PRIMARY KEY (`option_id`),
  ADD KEY `task_id` (`task_id`);

--
-- Индексы таблицы `tutors`
--
ALTER TABLE `tutors`
  ADD PRIMARY KEY (`tutor_id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `fk_tutors_city` (`city_id`),
  ADD KEY `fk_tutors_specialization` (`specialization_id`);

--
-- Индексы таблицы `tutor_certificates`
--
ALTER TABLE `tutor_certificates`
  ADD PRIMARY KEY (`certificate_id`),
  ADD KEY `tutor_id` (`tutor_id`);

--
-- Индексы таблицы `tutor_requests`
--
ALTER TABLE `tutor_requests`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `tutor_id` (`tutor_id`);

--
-- Индексы таблицы `tutor_specializations`
--
ALTER TABLE `tutor_specializations`
  ADD PRIMARY KEY (`specialization_id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `city_id` (`city_id`),
  ADD KEY `current_level_id` (`current_level_id`);

--
-- Индексы таблицы `user_answers`
--
ALTER TABLE `user_answers`
  ADD PRIMARY KEY (`answer_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `task_id` (`task_id`),
  ADD KEY `idx_user_answers_user_task` (`user_id`,`task_id`);

--
-- Индексы таблицы `user_progress`
--
ALTER TABLE `user_progress`
  ADD PRIMARY KEY (`progress_id`),
  ADD UNIQUE KEY `unique_user_level` (`user_id`,`level_id`),
  ADD KEY `level_id` (`level_id`),
  ADD KEY `idx_user_progress_user_level` (`user_id`,`level_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `achievements`
--
ALTER TABLE `achievements`
  MODIFY `achievement_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT для таблицы `audio_files`
--
ALTER TABLE `audio_files`
  MODIFY `audio_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT для таблицы `chat_messages`
--
ALTER TABLE `chat_messages`
  MODIFY `message_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT для таблицы `cities`
--
ALTER TABLE `cities`
  MODIFY `city_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT для таблицы `levels`
--
ALTER TABLE `levels`
  MODIFY `level_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT для таблицы `modules`
--
ALTER TABLE `modules`
  MODIFY `module_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT для таблицы `tasks`
--
ALTER TABLE `tasks`
  MODIFY `task_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=244;

--
-- AUTO_INCREMENT для таблицы `task_options`
--
ALTER TABLE `task_options`
  MODIFY `option_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=814;

--
-- AUTO_INCREMENT для таблицы `tutors`
--
ALTER TABLE `tutors`
  MODIFY `tutor_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT для таблицы `tutor_certificates`
--
ALTER TABLE `tutor_certificates`
  MODIFY `certificate_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `tutor_requests`
--
ALTER TABLE `tutor_requests`
  MODIFY `request_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT для таблицы `tutor_specializations`
--
ALTER TABLE `tutor_specializations`
  MODIFY `specialization_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT для таблицы `user_answers`
--
ALTER TABLE `user_answers`
  MODIFY `answer_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=642;

--
-- AUTO_INCREMENT для таблицы `user_progress`
--
ALTER TABLE `user_progress`
  MODIFY `progress_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `achievements`
--
ALTER TABLE `achievements`
  ADD CONSTRAINT `achievements_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `chat_messages`
--
ALTER TABLE `chat_messages`
  ADD CONSTRAINT `chat_messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `chat_messages_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `modules`
--
ALTER TABLE `modules`
  ADD CONSTRAINT `modules_ibfk_1` FOREIGN KEY (`level_id`) REFERENCES `levels` (`level_id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `tasks`
--
ALTER TABLE `tasks`
  ADD CONSTRAINT `tasks_ibfk_1` FOREIGN KEY (`module_id`) REFERENCES `modules` (`module_id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `task_options`
--
ALTER TABLE `task_options`
  ADD CONSTRAINT `task_options_ibfk_1` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `tutors`
--
ALTER TABLE `tutors`
  ADD CONSTRAINT `fk_tutors_city` FOREIGN KEY (`city_id`) REFERENCES `cities` (`city_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_tutors_specialization` FOREIGN KEY (`specialization_id`) REFERENCES `tutor_specializations` (`specialization_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `tutors_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `tutor_certificates`
--
ALTER TABLE `tutor_certificates`
  ADD CONSTRAINT `tutor_certificates_ibfk_1` FOREIGN KEY (`tutor_id`) REFERENCES `tutors` (`tutor_id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `tutor_requests`
--
ALTER TABLE `tutor_requests`
  ADD CONSTRAINT `tutor_requests_ibfk_2` FOREIGN KEY (`tutor_id`) REFERENCES `tutors` (`tutor_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tutor_requests_ibfk_3` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`city_id`) REFERENCES `cities` (`city_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `users_ibfk_2` FOREIGN KEY (`current_level_id`) REFERENCES `levels` (`level_id`) ON DELETE SET NULL;

--
-- Ограничения внешнего ключа таблицы `user_answers`
--
ALTER TABLE `user_answers`
  ADD CONSTRAINT `user_answers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_answers_ibfk_2` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `user_progress`
--
ALTER TABLE `user_progress`
  ADD CONSTRAINT `user_progress_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_progress_ibfk_2` FOREIGN KEY (`level_id`) REFERENCES `levels` (`level_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
