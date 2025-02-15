Часть 1.
1.
Найдите количество вопросов, которые набрали больше 300 очков или как минимум 100 раз были добавлены в «Закладки».

SELECT COUNT(*)
FROM stackoverflow.posts
WHERE post_type_id = 1
AND score > 300 OR favorites_count >=100

2.
Сколько в среднем в день задавали вопросов с 1 по 18 ноября 2008 включительно? Результат округлите до целого числа.

WITH t1 AS
(
SELECT 
        DATE_TRUNC('day', creation_date) :: DATE as dt,
        COUNT(*) AS question_count
FROM stackoverflow.posts
WHERE post_type_id = 1
AND creation_date BETWEEN '01/11/2008' AND '19/11/2008'
GROUP BY dt
ORDER BY dt
)
SELECT ROUND(AVG(t1.question_count),0)
FROM t1

3.
Сколько пользователей получили значки сразу в день регистрации? Выведите количество уникальных пользователей.
  WITH t1 AS
(SELECT 
        user_id, 
        DATE_TRUNC('day', creation_date) AS creation_date_badges
FROM stackoverflow.badges)

SELECT 
       COUNT(DISTINCT t1.user_id) 
FROM stackoverflow.users AS t2
JOIN t1 ON t1.user_id=t2.id
WHERE t1.creation_date_badges = DATE_TRUNC('day', t2.creation_date) 

4.
Сколько уникальных постов пользователя с именем Joel Coehoorn получили хотя бы один голос?

WITH t1 AS (
    SELECT id AS id_users
    FROM stackoverflow.users
    WHERE display_name = 'Joel Coehoorn'
),
     t2 AS
(SELECT *
FROM stackoverflow.posts
JOIN t1 ON stackoverflow.posts.user_id = t1.id_users)

SELECT COUNT(DISTINCT post_id)
FROM stackoverflow.votes AS v
JOIN t2 ON v.post_id= t2.id
WHERE post_type_id IS NOT NULL

5.
Выгрузите все поля таблицы vote_types. Добавьте к таблице поле rank, в которое войдут номера записей в обратном порядке. Таблица должна быть отсортирована по полю id.


SELECT 
    *,
    ROW_NUMBER() OVER (ORDER BY id DESC) AS rank
FROM stackoverflow.vote_types
ORDER BY id;

6.
Отберите 10 пользователей, которые поставили больше всего голосов типа Close. Отобразите таблицу из двух полей: идентификатором пользователя и количеством голосов. Отсортируйте данные сначала по убыванию количества голосов, потом по убыванию значения идентификатора пользователя.

SELECT 
    v.user_id,
    COUNT(*) AS close_votes_count
FROM stackoverflow.votes v
JOIN stackoverflow.vote_types vt ON v.vote_type_id = vt.id
WHERE vt.name = 'Close'
GROUP BY v.user_id
ORDER BY close_votes_count DESC, v.user_id DESC
LIMIT 10;

7.
Отберите 10 пользователей по количеству значков, полученных в период с 15 ноября по 15 декабря 2008 года включительно.
Отобразите несколько полей:
идентификатор пользователя;
число значков;
место в рейтинге — чем больше значков, тем выше рейтинг.
Пользователям, которые набрали одинаковое количество значков, присвойте одно и то же место в рейтинге.
Отсортируйте записи по количеству значков по убыванию, а затем по возрастанию значения идентификатора пользователя.

SELECT 
    b.user_id,
    COUNT(*) AS badge_count,
    DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS rank
FROM stackoverflow.badges b
WHERE b.creation_date BETWEEN '2008-11-15' AND '2008-12-16'
GROUP BY b.user_id
ORDER BY badge_count DESC, b.user_id ASC
LIMIT 10;

8.
Сколько в среднем очков получает пост каждого пользователя?
Сформируйте таблицу из следующих полей:
заголовок поста;
идентификатор пользователя;
число очков поста;
среднее число очков пользователя за пост, округлённое до целого числа.
Не учитывайте посты без заголовка, а также те, что набрали ноль очков.

SELECT 
        title,
        user_id,
        score,
        ROUND(AVG(score) OVER (PARTITION BY user_id))  
FROM stackoverflow.posts
WHERE title IS NOT NULL
AND score != 0

9.
Отобразите заголовки постов, которые были написаны пользователями, получившими более 1000 значков. Посты без заголовков не должны попасть в список.

WITH user_count_badges AS

(SELECT 
        user_id,
        COUNT(DISTINCT id) AS count_badges
FROM stackoverflow.badges
GROUP BY user_id
ORDER BY count_badges DESC)

SELECT p.title
FROM stackoverflow.posts AS p
JOIN user_count_badges ON p.user_id=user_count_badges.user_id
WHERE user_count_badges.count_badges > 1000
AND p.title IS NOT NULL

10.
Напишите запрос, который выгрузит данные о пользователях из Канады (англ. Canada). Разделите пользователей на три группы в зависимости от количества просмотров их профилей:
пользователям с числом просмотров больше либо равным 350 присвойте группу 1;
пользователям с числом просмотров меньше 350, но больше либо равно 100 — группу 2;
пользователям с числом просмотров меньше 100 — группу 3.
Отобразите в итоговой таблице идентификатор пользователя, количество просмотров профиля и группу. Пользователи с количеством просмотров меньше либо равным нулю не должны войти в итоговую таблицу.

SELECT 
        id AS users_id,
        views AS count_views,
    CASE
        WHEN views >= 350 THEN 1
        WHEN views >= 100 AND views < 350 THEN 2
        WHEN views < 100 THEN 3
    END AS view_group
FROM stackoverflow.users
WHERE location LIKE '%Canada%'
AND views > 0
ORDER BY view_group

11.
Дополните предыдущий запрос. Отобразите лидеров каждой группы — пользователей, которые набрали максимальное число просмотров в своей группе. Выведите поля с идентификатором пользователя, группой и количеством просмотров. Отсортируйте таблицу по убыванию просмотров, а затем по возрастанию значения идентификатора.

WITH user_groups AS (
    SELECT 
        id AS user_id,
        views AS count_views,
        CASE
            WHEN views >= 350 THEN 1
            WHEN views >= 100 AND views < 350 THEN 2
            WHEN views < 100 THEN 3
        END AS view_group
    FROM stackoverflow.users
    WHERE location LIKE '%Canada%'
      AND views > 0
)
SELECT 
    u.user_id,
    u.view_group,
    u.count_views
FROM user_groups u
JOIN (
    SELECT 
        view_group,
        MAX(count_views) AS max_views
    FROM user_groups
    GROUP BY view_group
) max_views_per_group
ON u.view_group = max_views_per_group.view_group
   AND u.count_views = max_views_per_group.max_views
ORDER BY u.count_views DESC, u.user_id ASC;

12.
Посчитайте ежедневный прирост новых пользователей в ноябре 2008 года. Сформируйте таблицу с полями:
номер дня;
число пользователей, зарегистрированных в этот день;
сумму пользователей с накоплением.

WITH daily_new_users AS (
    SELECT 
        EXTRACT(DAY FROM creation_date) AS day_number,
        COUNT(*) AS new_users
    FROM stackoverflow.users
    WHERE creation_date BETWEEN '2008-11-01' AND '2008-12-01'
    GROUP BY EXTRACT(DAY FROM creation_date)
)
SELECT 
    day_number,
    new_users,
    SUM(new_users) OVER (ORDER BY day_number) AS cumulative_users
FROM daily_new_users
ORDER BY day_number;

13.
Для каждого пользователя, который написал хотя бы один пост, найдите интервал между регистрацией и временем создания первого поста. Отобразите:
идентификатор пользователя;
разницу во времени между регистрацией и первым постом.

SELECT 
    u.id AS user_id,
    MIN(p.creation_date) - u.creation_date AS time_difference
FROM stackoverflow.users u
JOIN stackoverflow.posts p ON u.id = p.user_id
GROUP BY u.id, u.creation_date
HAVING COUNT(p.id) > 0;

Часть 2.
1.Выведите общую сумму просмотров у постов, опубликованных в каждый месяц 2008 года. Если данных за какой-либо месяц в базе нет, такой месяц можно пропустить. Результат отсортируйте по убыванию общего количества просмотров.

SELECT
        DATE_TRUNC('month', creation_date)::DATE AS date,
        SUM(views_count) AS sum_views
FROM stackoverflow.posts
GROUP BY date
ORDER BY sum_views DESC

2.
Выведите имена самых активных пользователей, которые в первый месяц после регистрации (включая день регистрации) дали больше 100 ответов. Вопросы, которые задавали пользователи, не учитывайте. Для каждого имени пользователя выведите количество уникальных значений user_id. Отсортируйте результат по полю с именами в лексикографическом порядке.
  
SELECT u.display_name,
       COUNT(DISTINCT u.id)
FROM stackoverflow.users AS u
JOIN stackoverflow.posts AS po ON u.id = po.user_id
JOIN stackoverflow.post_types AS pt ON po.post_type_id = pt.id
WHERE DATE_TRUNC('day', po.creation_date) >= DATE_TRUNC('day', u.creation_date)
  AND DATE_TRUNC('day', po.creation_date) <= DATE_TRUNC('day', u.creation_date) + INTERVAL '1 month'
  AND pt.type = 'Answer'
GROUP BY u.display_name
HAVING COUNT(po.id) > 100
ORDER BY u.display_name;

3.
Выведите количество постов за 2008 год по месяцам. Отберите посты от пользователей, которые зарегистрировались в сентябре 2008 года и сделали хотя бы один пост в декабре того же года. Отсортируйте таблицу по значению месяца по убыванию.
  
SELECT
    DATE_TRUNC('month', p.creation_date) :: DATE AS month_2008,
    COUNT(*) AS count_posts_2008
FROM stackoverflow.posts AS p
JOIN stackoverflow.users AS u ON u.id = p.user_id
WHERE DATE_TRUNC('month', u.creation_date) = '2008-09-01'
  AND EXISTS (
      SELECT 1
      FROM stackoverflow.posts AS p_dec
      WHERE p_dec.user_id = u.id
      AND DATE_TRUNC('month', p_dec.creation_date) = '2008-12-01'
  )
GROUP BY month_2008
ORDER BY month_2008 DESC;
  

4.
Используя данные о постах, выведите несколько полей:
идентификатор пользователя, который написал пост;
дата создания поста;
количество просмотров у текущего поста;
сумма просмотров постов автора с накоплением.
Данные в таблице должны быть отсортированы по возрастанию идентификаторов пользователей, а данные об одном и том же пользователе — по возрастанию даты создания поста.

SELECT 
    user_id,
    creation_date,
    views_count,
    SUM(views_count) OVER (PARTITION BY user_id ORDER BY creation_date) AS cumulative_views
FROM stackoverflow.posts
ORDER BY user_id, creation_date;

5.
Сколько в среднем дней в период с 1 по 7 декабря 2008 года включительно пользователи взаимодействовали с платформой? Для каждого пользователя отберите дни, в которые он или она опубликовали хотя бы один пост. Нужно получить одно целое число — не забудьте округлить результат.

SELECT 
    ROUND(AVG(days_active)) AS avg_days_active
FROM (
    SELECT 
        user_id,
        COUNT(DISTINCT DATE(creation_date)) AS days_active
    FROM stackoverflow.posts
    WHERE creation_date BETWEEN '2008-12-01' AND '2008-12-07'
    GROUP BY user_id
) AS user_activity;

6.
На сколько процентов менялось количество постов ежемесячно с 1 сентября по 31 декабря 2008 года? Отобразите таблицу со следующими полями:
Номер месяца.
Количество постов за месяц.
Процент, который показывает, насколько изменилось количество постов в текущем месяце по сравнению с предыдущим.
Если постов стало меньше, значение процента должно быть отрицательным, если больше — положительным. Округлите значение процента до двух знаков после запятой.
Напомним, что при делении одного целого числа на другое в PostgreSQL в результате получится целое число, округлённое до ближайшего целого вниз. Чтобы этого избежать, переведите делимое в тип numeric.

WITH monthly_posts AS (
    SELECT DATE_TRUNC('month', creation_date) AS month, COUNT(*) AS post_count
    FROM stackoverflow.posts
    WHERE creation_date BETWEEN '2008-09-01' AND '2008-12-31'
    GROUP BY month
    ORDER BY month
)
SELECT 
    EXTRACT(month FROM month) AS month_number,
    post_count,
    ROUND((post_count - LAG(post_count) OVER (ORDER BY month)) * 100.0 / NULLIF(LAG(post_count) OVER (ORDER BY month), 0), 2) AS percentage_change
FROM monthly_posts
ORDER BY month_number;

7.
Найдите пользователя, который опубликовал больше всего постов за всё время с момента регистрации. Выведите данные его активности за октябрь 2008 года в таком виде:
номер недели;
дата и время последнего поста, опубликованного на этой неделе.\

WITH top_user AS (
    SELECT user_id
    FROM stackoverflow.posts
    GROUP BY user_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
),
october_activity AS (
    SELECT 
        EXTRACT(week FROM creation_date) AS week_number,
        MAX(creation_date) AS last_post_date
    FROM stackoverflow.posts
    WHERE user_id = (SELECT user_id FROM top_user)
      AND DATE_TRUNC('month', creation_date) = '2008-10-01'
    GROUP BY week_number
)
SELECT week_number, last_post_date
FROM october_activity
ORDER BY week_number;
