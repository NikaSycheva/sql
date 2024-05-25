*/ Составьте запрос, который извлекает из таблицы users данные о пользователях, которые зарегистрировались в июле 2022 года и указали некорректную почту при регистрации. Для этого понадобятся поля: first_name — имя; email — электронная почта.
Будем считать, что корректная почта должна содержать адрес, затем символ @, затем домен, затем точку, затем национальную зону. Например, my_adress@google.com.

/* Напишите запрос, создающий таблицу users со следующими полями:

username — должно присутствовать
email — уникально должно присутствовать
created_at — должно присутствовать
Выберите типы данных самостоятельно. */

CREATE TABLE users (
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL
);


/*Напишите запросы, обновляющие таблицу структуры:
CREATE TABLE users (
    id bigint,
    email varchar(255) NOT NULL,
    age integer,
    name varchar(255)
);

В структуру:
CREATE TABLE users (
    id bigint,
    email varchar(255) NOT NULL UNIQUE,
    first_name varchar(255) NOT NULL,
    created_at timestamp
); */

 
ALTER TABLE users 
ADD UNIQUE(email),
DROP COLUMN age,
ALTER COLUMN name SET NOT NULL,
ADD COLUMN created_at Timestamp;

ALTER TABLE users RENAME COLUMN name TO first_name;


/* Составьте транзакцию, которая передает предмет Longclaw от пользователя lord_mormont пользователю jon. Передача предмета выполняется добавлением новой записи в таблицу. При этом все предметы уникальны, а значит они не могут быть у предыдущего владельца. */

BEGIN;

DELETE FROM user_items WHERE username = 'lord_mormont' AND item = 'Longclaw';
INSERT INTO user_items(username, item, received_at) VALUES('jon', 'Longclaw', NOW());

COMMIT;


/* В честь юбилея вашего проекта, вы решили провести конкурс, который спонсирует Google. Было решено, что участвовать в конкурсе могут только пользователи, зарегистрированные ранее 2020 года, либо пользователи, зарегистрированные с почты @gmail.com. В силу того, что призы довольно специфичные, возраст пользователя должен быть от 18 и до 50 лет включительно. Те пользователи, которые регистрировались ранее 2020 года с любой почты, будут участвовать в конкурсе независимо от возраста — компания подберет им приз индивидуально.

Составьте запрос, который извлекает из таблицы profiles данные о пользователях, которым позволено участвовать в конкурсе. Для этого понадобятся поля:

* username - имя пользователя
* email — электронная почта
* age — возраст пользователя
Отсортируйте пользователей по возрасту по возрастанию. */

SELECT
    username,
    email,
    age
FROM profiles
WHERE
    (email LIKE '%@gmail.com' AND age BETWEEN 18 AND 50)
    OR created_at < '2020-01-01'
ORDER BY age


/* Составьте запрос, который выберет самый популярный продукт по количеству продаж в марте. Для этого вам понадобятся поля:
product_name — название продукта
created_at — дата продажи

Итоговая таблица должна содержать следующие поля:
product_name — название продукта
total_sales — количество продаж */

SELECT
    product_name,
    COUNT(*) AS total_sales
FROM orders
WHERE created_at BETWEEN '2023-03-01 00:00:00' AND '2023-03-31 23:59:59'
GROUP BY product_name
ORDER BY total_sales

/* Составьте запрос, который извлекает из таблицы movies данные о фильмах по следующим условиям:
Фильмы без рейтинга в жанре Action
Фильмы в жанре Documentary, с рейтингом 80 и выше в этом жанре
Для этого понадобятся поля:
title — название фильма
rating — рейтинг фильма
Отсортируйте фильмы следующим образом: по убыванию рейтинга, по названию в алфавитном порядке, неоцененные фильмы должны идти в начале списка. Ограничьте выборку семью фильмами. */

SELECT
    title,
    rating
FROM movies
WHERE (genre = 'Action' AND rating IS NULL) OR
(genre = 'Documentary' AND rating > 80)
ORDER BY rating DESC NULLS FIRST, title ASC
LIMIT 7
