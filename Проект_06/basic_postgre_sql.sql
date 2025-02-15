1.
Отобразите все записи из таблицы company по компаниям, которые закрылись.
  
select *
from company
where status = 'closed'

2.
Отобразите количество привлечённых средств для новостных компаний США. Используйте данные из таблицы company. Отсортируйте таблицу по убыванию значений в поле funding_total.

SELECT funding_total
FROM company
WHERE category_code = 'news' AND country_code = 'USA'
ORDER BY funding_total DESC

3.
Найдите общую сумму сделок по покупке одних компаний другими в долларах. Отберите сделки, которые осуществлялись только за наличные с 2011 по 2013 год включительно.
SELECT SUM(price_amount)
FROM acquisition
WHERE term_code = 'cash' AND EXTRACT(YEAR FROM CAST(acquired_at AS DATE)) BETWEEN 2011 AND 2013 

4.
Отобразите имя, фамилию и названия аккаунтов людей в поле network_username, у которых названия аккаунтов начинаются на 'Silver'.
SELECT first_name,
       last_name,
       network_username
FROM people
WHERE network_username LIKE 'Silver%'

5.
Выведите на экран всю информацию о людях, у которых названия аккаунтов в поле network_username содержат подстроку 'money', а фамилия начинается на 'K'.

SELECT *
FROM people
WHERE network_username LIKE '%money%' AND last_name LIKE 'K%'

6.Для каждой страны отобразите общую сумму привлеченных инвестиций, которые получили компании, зарегистрированные в этой стране. Страну, в которой зарегистрирована компания, можно определить по коду страны. Отсортируйте данные по убыванию суммы.

SELECT country_code AS country,
       SUM(funding_total) AS total_sum
FROM company
GROUP BY country
ORDER BY total_sum DESC

7.
Составьте таблицу, в которую войдёт дата проведения раунда, а также минимальное и максимальное значения суммы инвестиций, привлечённых в эту дату.
Оставьте в итоговой таблице только те записи, в которых минимальное значение суммы инвестиций не равно нулю и не равно максимальному значению.

SELECT funded_at,
       MIN(raised_amount),
       MAX(raised_amount)
FROM funding_round
GROUP BY funded_at
HAVING MIN(raised_amount) != 0 AND MIN(raised_amount) != MAX(raised_amount)

8.
Создайте поле с категориями:
Для фондов, которые инвестируют в 100 и более компаний, назначьте категорию high_activity.
Для фондов, которые инвестируют в 20 и более компаний до 100, назначьте категорию middle_activity.
Если количество инвестируемых компаний фонда не достигает 20, назначьте категорию low_activity.
Отобразите все поля таблицы fund и новое поле с категориями.

SELECT *,
     CASE
      WHEN invested_companies >= 100 THEN 'high_activity'
      WHEN invested_companies BETWEEN 20 AND 100 THEN 'middle_activity'
      WHEN invested_companies < 20 THEN 'low_activity'
     END
FROM fund

9.
Для каждой из категорий, назначенных в предыдущем задании, посчитайте округлённое до ближайшего целого числа среднее количество инвестиционных раундов, в которых фонд принимал участие. Выведите на экран категории и среднее число инвестиционных раундов. Отсортируйте таблицу по возрастанию среднего.

SELECT ROUND(AVG(investment_rounds)) AS avg_rounds,
       CASE
           WHEN invested_companies>=100 THEN 'high_activity'
           WHEN invested_companies>=20 THEN 'middle_activity'
           ELSE 'low_activity'
       END AS activity
FROM fund
GROUP BY activity
ORDER BY avg_rounds

10.
Проанализируйте, в каких странах находятся фонды, которые чаще всего инвестируют в стартапы. 
Для каждой страны посчитайте минимальное, максимальное и среднее число компаний, в которые инвестировали фонды этой страны, основанные с 2010 по 2012 год включительно. Исключите страны с фондами, у которых минимальное число компаний, получивших инвестиции, равно нулю. 
Выгрузите десять самых активных стран-инвесторов: отсортируйте таблицу по среднему количеству компаний от большего к меньшему. Затем добавьте сортировку по коду страны в лексикографическом порядке.

SELECT country_code AS country,
       MIN(invested_companies) AS min_invested_companies,
       MAX(invested_companies) AS max_invested_companies,
       AVG(invested_companies) AS avg_invested_companies
FROM fund
WHERE EXTRACT(YEAR FROM CAST(founded_at AS DATE)) BETWEEN 2010 AND 2012
GROUP BY country
HAVING MIN(invested_companies) != 0
ORDER BY avg_invested_companies DESC, country
LIMIT 10

11.
Отобразите имя и фамилию всех сотрудников стартапов. Добавьте поле с названием учебного заведения, которое окончил сотрудник, если эта информация известна.

SELECT p.first_name,
       p.last_name,
       e.instituition
FROM people AS p
LEFT JOIN education AS e on p.id=e.person_id

12.
Для каждой компании найдите количество учебных заведений, которые окончили её сотрудники. Выведите название компании и число уникальных названий учебных заведений. Составьте топ-5 компаний по количеству университетов.

SELECT c.name,
       COUNT(DISTINCT e.instituition)   
FROM company AS c
JOIN people AS p on c.id=p.company_id
JOIN education AS e on p.id=e.person_id
GROUP BY c.name
ORDER BY COUNT(DISTINCT e.instituition) DESC
LIMIT 5

13.
Составьте список с уникальными названиями закрытых компаний, для которых первый раунд финансирования оказался последним.

SELECT DISTINCT c.name
FROM company AS c JOIN (SELECT company_id
FROM funding_round
WHERE is_last_round = 1 AND is_first_round = 1) AS f ON c.id=f.company_id
WHERE status = 'closed'

14.
Составьте список уникальных номеров сотрудников, которые работают в компаниях, отобранных в предыдущем задании.

SELECT DISTINCT p.id
FROM people AS p
JOIN (SELECT DISTINCT c.id
FROM company AS c JOIN (SELECT company_id
FROM funding_round
WHERE is_last_round = 1 AND is_first_round = 1) AS f ON c.id=f.company_id
WHERE status = 'closed'
) AS c ON p.company_id=c.id

15.
Составьте таблицу, куда войдут уникальные пары с номерами сотрудников из предыдущей задачи и учебным заведением, которое окончил сотрудник.

SELECT p.id,
       e.instituition
FROM education AS e
JOIN (SELECT DISTINCT p.id
FROM people AS p
JOIN (SELECT DISTINCT c.id
FROM company AS c JOIN (SELECT company_id
FROM funding_round
WHERE is_last_round = 1 AND is_first_round = 1) AS f ON c.id=f.company_id
WHERE status = 'closed'
) AS c ON p.company_id=c.id) AS p ON e.person_id=p.id
GROUP BY e.instituition, p.id

16.
Посчитайте количество учебных заведений для каждого сотрудника из предыдущего задания. При подсчёте учитывайте, что некоторые сотрудники могли окончить одно и то же заведение дважды.

SELECT p.id,
       COUNT(e.instituition)
FROM education AS e
JOIN (SELECT DISTINCT p.id
FROM people AS p
JOIN (SELECT DISTINCT c.id
FROM company AS c JOIN (SELECT company_id
FROM funding_round
WHERE is_last_round = 1 AND is_first_round = 1) AS f ON c.id=f.company_id
WHERE status = 'closed'
) AS c ON p.company_id=c.id) AS p ON e.person_id=p.id
GROUP BY  p.id

17.
Дополните предыдущий запрос и выведите среднее число учебных заведений (всех, не только уникальных), которые окончили сотрудники разных компаний. Нужно вывести только одну запись, группировка здесь не понадобится.

SELECT AVG(n.count)
FROM (SELECT p.id,
       COUNT(e.instituition)
FROM education AS e
JOIN (SELECT DISTINCT p.id
FROM people AS p
JOIN (SELECT DISTINCT c.id
FROM company AS c JOIN (SELECT company_id
FROM funding_round
WHERE is_last_round = 1 AND is_first_round = 1) AS f ON c.id=f.company_id
WHERE status = 'closed'
) AS c ON p.company_id=c.id) AS p ON e.person_id=p.id
GROUP BY  p.id) AS n

18.
Напишите похожий запрос: выведите среднее число учебных заведений (всех, не только уникальных), которые окончили сотрудники Socialnet.

SELECT AVG(n.count)
FROM (SELECT e.person_id,
       COUNT(e.instituition)
FROM education AS e
JOIN people AS p ON e.person_id=p.id
JOIN company AS c ON p.company_id=c.id
WHERE c.name ='Socialnet'
GROUP BY e.person_id) AS n

19.
Составьте таблицу из полей:
name_of_fund — название фонда;
name_of_company — название компании;
amount — сумма инвестиций, которую привлекла компания в раунде.
В таблицу войдут данные о компаниях, в истории которых было больше шести важных этапов, а раунды финансирования проходили с 2012 по 2013 год включительно.

SELECT f.name AS name_of_fund,
       c.name AS name_of_company,
       fr.raised_amount AS amount
FROM fund AS f
JOIN investment AS i ON f.id=i.fund_id
JOIN company AS c ON i.company_id=c.id
JOIN funding_round fr ON i.funding_round_id = fr.id
WHERE c.milestones > 6
AND fr.funded_at BETWEEN '2012-01-01' AND '2013-12-31';

20.
Выгрузите таблицу, в которой будут такие поля:
название компании-покупателя;
сумма сделки;
название компании, которую купили;
сумма инвестиций, вложенных в купленную компанию;
доля, которая отображает, во сколько раз сумма покупки превысила сумму вложенных в компанию инвестиций, округлённая до ближайшего целого числа.
Не учитывайте те сделки, в которых сумма покупки равна нулю. Если сумма инвестиций в компанию равна нулю, исключите такую компанию из таблицы. 
Отсортируйте таблицу по сумме сделки от большей к меньшей, а затем по названию купленной компании в лексикографическом порядке. Ограничьте таблицу первыми десятью записями.

SELECT acq.name AS acquiring_company, 
       a.price_amount AS deal_amount, 
       acq_comp.name AS acquired_company, 
       acq_comp.funding_total AS invested_amount,
       ROUND(a.price_amount / acq_comp.funding_total) AS ratio
FROM acquisition a
JOIN company acq ON a.acquiring_company_id = acq.id
JOIN company acq_comp ON a.acquired_company_id = acq_comp.id
WHERE a.price_amount > 0 
  AND acq_comp.funding_total > 0
ORDER BY a.price_amount DESC, acq_comp.name ASC
LIMIT 10;

21.
Выгрузите таблицу, в которую войдут названия компаний из категории social, получившие финансирование с 2010 по 2013 год включительно. Проверьте, что сумма инвестиций не равна нулю. Выведите также номер месяца, в котором проходил раунд финансирования.

SELECT c.name AS company_name, 
        
       EXTRACT(MONTH FROM fr.funded_at) AS funding_month
FROM company c
JOIN funding_round fr ON c.id = fr.company_id
WHERE c.category_code = 'social'
  AND fr.raised_amount > 0
  AND fr.funded_at BETWEEN '2010-01-01' AND '2013-12-31';


22.
Отберите данные по месяцам с 2010 по 2013 год, когда проходили инвестиционные раунды. Сгруппируйте данные по номеру месяца и получите таблицу, в которой будут поля:
номер месяца, в котором проходили раунды;
количество уникальных названий фондов из США, которые инвестировали в этом месяце;
количество компаний, купленных за этот месяц;
общая сумма сделок по покупкам в этом месяце.

with month_fund as 
(
    select
    extract(month from funded_at::timestamp) as month_round,
    count(distinct f.name) as cnt1
from
    funding_round as fr
left join
    investment as i1
    on fr.id = i1.funding_round_id
left join
    fund as f
    on i1.fund_id = f.id
where
    f.country_code = 'USA'
and
    extract(year from funded_at::timestamp) between 2010 and 2013
group by
    month_round
),
sum_month_acquisition as
(
select
    extract(month from acquired_at::timestamp) as month_acquisition,
    count(acquired_company_id) as count_company,
    sum(price_amount) as sum_total
from
    acquisition as a1
where
   extract(year from acquired_at::timestamp) between 2010 and 2013   
group by
    month_acquisition
)
select
    month_round,
    cnt1,
    count_company,
    sum_total
from
    month_fund as mf
join
    sum_month_acquisition as sm
    on mf.month_round = sm.month_acquisition

23.
Составьте сводную таблицу и выведите среднюю сумму инвестиций для стран, в которых есть стартапы, зарегистрированные в 2011, 2012 и 2013 годах. Данные за каждый год должны быть в отдельном поле. Отсортируйте таблицу по среднему значению инвестиций за 2011 год от большего к меньшему.

WITH
     inv_2011 AS 
         (
             select
                 country_code,
                 avg(funding_total) as avg_2011
              from
                 company as c1
             where
                 extract(year from founded_at::timestamp) = 2011
             group by
                 country_code
         ), 
         inv_2012 AS 
         (
             select
                 country_code,
                 avg(funding_total) as avg_2012
              from company as c2
             where
                 extract(year from founded_at::timestamp) = 2012
             group by
                 country_code
         ), 
         inv_2013 AS 
         (
             select
                 country_code,
                 avg(funding_total) as avg_2013
              from
                 company as c3
             where
                 extract(year from founded_at::timestamp) = 2013
             group by
                 country_code
         )
SELECT  i4.country_code,
       avg_2011,
       avg_2012,
       avg_2013
FROM  inv_2011 as i4
JOIN 
    inv_2012 as i5
    on i4.country_code = i5.country_code
join
    inv_2013 as i6
    on i5.country_code = i6.country_code
order by
    avg_2011 desc
