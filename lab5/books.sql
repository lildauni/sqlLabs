-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Мар 23 2021 г., 12:59
-- Версия сервера: 10.4.17-MariaDB
-- Версия PHP: 7.3.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `books`
--

-- --------------------------------------------------------

--
-- Структура таблицы `bookformats`
--

CREATE TABLE `bookformats` (
  `format_id` smallint(2) NOT NULL,
  `format_name` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `bookformats`
--

INSERT INTO `bookformats` (`format_id`, `format_name`) VALUES
(4, '60х88/16'),
(2, '70х100/16'),
(3, '84х108/16'),
(1, 'n/a');

-- --------------------------------------------------------

--
-- Структура таблицы `categories`
--

CREATE TABLE `categories` (
  `category_id` smallint(3) NOT NULL,
  `category_name` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`) VALUES
(10, 'C&C++'),
(7, 'Linux'),
(1, 'n/a'),
(8, 'Unix'),
(6, 'Windows 2000'),
(5, 'Інші книги'),
(9, 'Інші операційні системи'),
(3, 'Апаратні засоби ПК'),
(4, 'Захист і безпека ПК'),
(2, 'Підручники'),
(11, 'Фентезі');

-- --------------------------------------------------------

--
-- Структура таблицы `maininfo`
--

CREATE TABLE `maininfo` (
  `n` smallint(3) NOT NULL,
  `id` int(4) NOT NULL DEFAULT 0,
  `isNew` varchar(3) NOT NULL DEFAULT 'No',
  `title` varchar(70) NOT NULL DEFAULT '',
  `price` float(5,2) NOT NULL CHECK (`price` > 0),
  `pages` int(11) DEFAULT NULL,
  `format` smallint(2) DEFAULT 0,
  `pub_date` date DEFAULT curdate(),
  `circulation` int(11) DEFAULT NULL,
  `topic` smallint(3) DEFAULT 0,
  `category` smallint(3) DEFAULT 0,
  `publisher` smallint(2) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `maininfo`
--

INSERT INTO `maininfo` (`n`, `id`, `isNew`, `title`, `price`, `pages`, `format`, `pub_date`, `circulation`, `topic`, `category`, `publisher`) VALUES
(2, 5110, 'No', 'Аппаратные средства мультимедия. Видеосистема РС', 15.51, 400, 2, '2000-07-24', 5000, 2, 2, 2),
(8, 4985, 'No', 'Освой самостоятельно модернизацию и ремонт ПК за 24 часа, 2-е изд.', 18.90, 288, 2, '2000-07-07', 5000, 2, 2, 3),
(9, 5141, 'No', 'Структуры данных и алгоритмы.', 37.80, 384, 2, '2000-09-29', 5000, 2, 2, 3),
(20, 5127, 'Yes', 'Автоматизация инженерно-графических работ', 11.58, 256, 2, '2000-06-15', 5000, 2, 2, 4),
(31, 5110, 'No', 'Аппаратные средства мультимедиа. Видеосистема PC', 15.51, 400, 2, '2000-07-24', 5000, 2, 3, 2),
(46, 5199, 'No', 'Железо IBM 2001.', 30.07, 368, 2, '2000-02-12', 5000, 2, 3, 5),
(50, 3851, 'Yes', 'Защита информации и безопасность компьютерных систем', 26.00, 480, 3, '1999-02-04', 5000, 2, 4, 6),
(58, 3932, 'No', 'Как превратить персональный компьютер в измерительный комплекс', 7.65, 144, 4, '1999-06-09', 5000, 2, 5, 7),
(59, 4713, 'No', 'Plug- ins. Встраиваемые приложения для музыкальных программ', 11.41, 144, 2, '2000-02-22', 5000, 2, 5, 7),
(175, 5217, 'No', 'Windows ME. Новейшие версии программ', 16.57, 320, 2, '2000-08-25', 5000, 3, 6, 8),
(176, 4829, 'No', 'Windows 2000 Professional шаг за шагом с СD', 27.25, 320, 2, '2000-04-28', 5000, 3, 6, 9),
(188, 5170, 'No', 'Linux Русские версии', 24.43, 346, 2, '2000-09-29', 5000, 3, 7, 7),
(191, 860, 'No', 'Операционная система UNIX', 3.50, 395, 3, '1997-05-05', 5000, 3, 8, 2),
(203, 44, 'No', 'Ответы на актуальные вопросы по OS/2 Warp', 5.00, 352, 4, '1996-03-20', 5000, 3, 9, 6),
(206, 5176, 'No', 'Windows Me. Спутник пользователя', 12.79, 306, 1, '2000-10-10', 5000, 3, 9, 10),
(209, 5462, 'No', 'Язык программирования С++. Лекции и упражнения', 29.00, 656, 3, '2000-12-12', 5000, 4, 10, 6),
(210, 4982, 'No', 'Язык программирования С. Лекции и упражнения', 29.00, 432, 3, '2000-07-12', 5000, 4, 10, 6),
(220, 4687, 'No', 'Эффективное использование C++ .50 рекомендаций по улучшению ваших прог', 17.60, 240, 2, '2000-02-03', 5000, 4, 10, 7),
(228, 1337, 'No', 'Harry Potter and the Sorcerer`s Stone', 7.84, 223, 1, '1997-06-26', 10000, 4, 11, 10),
(230, 1400, 'No', 'Harry Potter and the Chamber of Secrets', 8.01, NULL, 1, NULL, NULL, 1, 1, 11);

-- --------------------------------------------------------

--
-- Структура таблицы `publishernames`
--

CREATE TABLE `publishernames` (
  `pub_id` smallint(2) NOT NULL,
  `publisher_name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `publishernames`
--

INSERT INTO `publishernames` (`pub_id`, `publisher_name`) VALUES
(2, 'BHV С.-Петербург'),
(11, 'Bloomsbury'),
(6, 'DiaSoft'),
(1, 'n/a'),
(3, 'Вильямс'),
(7, 'ДМК'),
(5, 'МикроАрт'),
(4, 'Питер'),
(10, 'Русская редакция'),
(8, 'Триумф'),
(9, 'Эком');

-- --------------------------------------------------------

--
-- Структура таблицы `topics`
--

CREATE TABLE `topics` (
  `topic_id` smallint(3) NOT NULL,
  `topic_name` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы `topics`
--

INSERT INTO `topics` (`topic_id`, `topic_name`) VALUES
(1, 'n/a'),
(2, 'Використання ПК в цілому'),
(5, 'Магічний світ'),
(3, 'Операційні системи'),
(4, 'Програмування');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `bookformats`
--
ALTER TABLE `bookformats`
  ADD PRIMARY KEY (`format_id`),
  ADD UNIQUE KEY `format_name` (`format_name`);

--
-- Индексы таблицы `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`),
  ADD UNIQUE KEY `category_name` (`category_name`);

--
-- Индексы таблицы `maininfo`
--
ALTER TABLE `maininfo`
  ADD PRIMARY KEY (`n`),
  ADD KEY `publisher` (`publisher`),
  ADD KEY `format` (`format`),
  ADD KEY `topic` (`topic`),
  ADD KEY `category` (`category`);

--
-- Индексы таблицы `publishernames`
--
ALTER TABLE `publishernames`
  ADD PRIMARY KEY (`pub_id`),
  ADD UNIQUE KEY `publisher_name` (`publisher_name`);

--
-- Индексы таблицы `topics`
--
ALTER TABLE `topics`
  ADD PRIMARY KEY (`topic_id`),
  ADD UNIQUE KEY `topic_name` (`topic_name`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `bookformats`
--
ALTER TABLE `bookformats`
  MODIFY `format_id` smallint(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT для таблицы `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` smallint(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT для таблицы `publishernames`
--
ALTER TABLE `publishernames`
  MODIFY `pub_id` smallint(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT для таблицы `topics`
--
ALTER TABLE `topics`
  MODIFY `topic_id` smallint(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `maininfo`
--
ALTER TABLE `maininfo`
  ADD CONSTRAINT `maininfo_ibfk_1` FOREIGN KEY (`publisher`) REFERENCES `publishernames` (`pub_id`),
  ADD CONSTRAINT `maininfo_ibfk_2` FOREIGN KEY (`publisher`) REFERENCES `publishernames` (`pub_id`),
  ADD CONSTRAINT `maininfo_ibfk_3` FOREIGN KEY (`format`) REFERENCES `bookformats` (`format_id`),
  ADD CONSTRAINT `maininfo_ibfk_4` FOREIGN KEY (`topic`) REFERENCES `topics` (`topic_id`),
  ADD CONSTRAINT `maininfo_ibfk_5` FOREIGN KEY (`category`) REFERENCES `categories` (`category_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
