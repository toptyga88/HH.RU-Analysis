-- Анализ вакансий аналитиков с hh.ru
-- PostgreSQL, таблица public.parcing_table


-- 1. Зарплаты

SELECT
    ROUND(AVG(salary_from)) AS avg_from,
    MIN(salary_from) AS min_from,
    MAX(salary_from) AS max_from,
    ROUND(AVG(salary_to)) AS avg_to,
    MIN(salary_to) AS min_to,
    MAX(salary_to) AS max_to
FROM public.parcing_table;

-- сколько вакансий вообще указали зарплату
SELECT
    COUNT(*) AS total,
    COUNT(salary_from) AS with_salary_from,
    COUNT(salary_to) AS with_salary_to
FROM public.parcing_table;


-- 2. Регионы и компании

SELECT area, COUNT(*) AS total
FROM public.parcing_table
GROUP BY area
ORDER BY total DESC
LIMIT 10;

SELECT employer, COUNT(*) AS total
FROM public.parcing_table
GROUP BY employer
ORDER BY total DESC
LIMIT 10;


-- 3. Занятость и график

SELECT employment, COUNT(*) AS amount
FROM public.parcing_table
GROUP BY employment
ORDER BY amount DESC;

SELECT schedule, COUNT(*) AS amount
FROM public.parcing_table
GROUP BY schedule
ORDER BY amount DESC;


-- 4. Грейды среди аналитиков данных и системных аналитиков

SELECT
    CASE
        WHEN name ILIKE '%данных%' OR name ILIKE '%data%' THEN 'Аналитик данных'
        WHEN name ILIKE '%системн%' OR name ILIKE '%system%' THEN 'Системный аналитик'
    END AS position,
    experience,
    COUNT(*) AS amount
FROM public.parcing_table
WHERE name ILIKE '%аналитик данных%'
   OR name ILIKE '%data analyst%'
   OR name ILIKE '%системный аналитик%'
   OR name ILIKE '%system analyst%'
GROUP BY position, experience
ORDER BY position, amount DESC;


-- 5. Работодатели для аналитиков

-- with_salary показывает, у скольких вакансий вообще есть зарплата,
-- иначе среднее по 2-3 вакансиям выглядит как среднее по сотне
SELECT
    employer,
    COUNT(*) AS vacancies,
    COUNT(salary_from) AS with_salary,
    ROUND(AVG(salary_from)) AS avg_from,
    ROUND(AVG(salary_to)) AS avg_to
FROM public.parcing_table
WHERE name ILIKE '%аналитик данных%'
   OR name ILIKE '%data analyst%'
   OR name ILIKE '%системный аналитик%'
   OR name ILIKE '%system analyst%'
GROUP BY employer
ORDER BY vacancies DESC
LIMIT 10;

-- условия труда по компаниям
SELECT
    employer,
    schedule,
    employment,
    COUNT(*) AS vacancies
FROM public.parcing_table
WHERE name ILIKE '%аналитик данных%'
   OR name ILIKE '%data analyst%'
   OR name ILIKE '%системный аналитик%'
   OR name ILIKE '%system analyst%'
GROUP BY employer, schedule, employment
ORDER BY vacancies DESC
LIMIT 10;


-- 6. Навыки
-- навыки лежат в 8 столбцах, запрос ниже гонял для каждого столбца отдельно
-- пустые ячейки это '', а не NULL, поэтому два условия в WHERE

SELECT key_skills_1 AS skill, COUNT(*) AS amount
FROM public.parcing_table
WHERE key_skills_1 IS NOT NULL AND key_skills_1 <> ''
GROUP BY key_skills_1
ORDER BY amount DESC
LIMIT 10;

SELECT soft_skills_1 AS skill, COUNT(*) AS amount
FROM public.parcing_table
WHERE soft_skills_1 IS NOT NULL AND soft_skills_1 <> ''
GROUP BY soft_skills_1
ORDER BY amount DESC
LIMIT 10;

-- то же самое в разрезе грейдов
SELECT experience, key_skills_1 AS skill, COUNT(*) AS amount
FROM public.parcing_table
WHERE key_skills_1 IS NOT NULL AND key_skills_1 <> ''
GROUP BY experience, key_skills_1
ORDER BY experience, amount DESC;

-- и по отдельной позиции, маску в name меняю
SELECT key_skills_1 AS skill, COUNT(*) AS amount
FROM public.parcing_table
WHERE key_skills_1 IS NOT NULL AND key_skills_1 <> ''
  AND name ILIKE '%аналитик данных%'
GROUP BY key_skills_1
ORDER BY amount DESC
LIMIT 10;
