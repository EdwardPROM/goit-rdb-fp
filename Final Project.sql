-- 1. Завантажте дані:
-- Створіть схему pandemic у базі даних за допомогою SQL-команди.
CREATE SCHEMA pandemic;

-- Оберіть її як схему за замовчуванням за допомогою SQL-команди.
USE pandemic;

-- Імпортуйте дані за допомогою Import wizard так, як ви вже робили це у темі 3.
-- Продивіться дані, щоб бути у контексті.
select * from `infectious_cases`

-- 2. Нормалізуйте таблицю infectious_cases до 3ї нормальної форми. 
-- Збережіть у цій же схемі дві таблиці з нормалізованими даними.

CREATE TABLE countries (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    entity VARCHAR(255),
    code VARCHAR(12)
);
DROP TABLE IF EXISTS diseases;
CREATE TABLE diseases (
    disease_id INT AUTO_INCREMENT PRIMARY KEY,
    disease_name VARCHAR(255)
);
CREATE TABLE infectious_cases_data (
    ic_data_id INT AUTO_INCREMENT PRIMARY KEY,
    country_id INT,
    Year INT,
    disease_id INT,
    cases INT,
    FOREIGN KEY (country_id) REFERENCES countries(country_id),
    FOREIGN KEY (disease_id) REFERENCES diseases(disease_id)
);

-- 3. Проаналізуйте дані:
-- Для кожної унікальної комбінації Entity та Code або їх id порахуйте середнє, мінімальне, 
-- максимальне значення та суму для атрибута Number_rabies.
-- Результат відсортуйте за порахованим середнім значенням у порядку спадання.
-- Оберіть тільки 10 рядків для виведення на екран.
SELECT 
    Entity,
    Code,
    AVG(Number_rabies) AS avg_rabies,
    MIN(Number_rabies) AS min_rabies,
    MAX(Number_rabies) AS max_rabies,
    SUM(Number_rabies) AS sum_rabies
FROM infectious_cases
WHERE Number_rabies <> '' 
GROUP BY Entity, Code
ORDER BY avg_rabies DESC
LIMIT 10;

-- 4. Побудуйте колонку різниці в роках.
-- Для оригінальної або нормованої таблиці для колонки Year побудуйте з використанням вбудованих SQL-функцій:
-- атрибут, що створює дату першого січня відповідного року,
-- 💡 Наприклад, якщо атрибут містить значення ’1996’, то значення нового атрибута має бути ‘1996-01-01’.
-- атрибут, що дорівнює поточній даті,
-- атрибут, що дорівнює різниці в роках двох вищезгаданих колонок.
-- 💡 Перераховувати всі інші атрибути, такі як Number_malaria, не потрібно.
-- 👉🏼 Для пошуку необхідних вбудованих функцій вам може знадобитися матеріал до теми 7.
SELECT 
    MAKEDATE(year, 1) AS new_date,
    CURDATE() AS current_date_,
    TIMESTAMPDIFF(YEAR, MAKEDATE(year, 1), CURDATE()) AS date_diff
FROM infectious_cases;

-- 5. Побудуйте власну функцію.
-- Створіть і використайте функцію, що будує такий же атрибут, як і в попередньому завданні: функція має приймати на вхід значення року, 
-- а повертати різницю в роках між поточною датою та датою, створеною з атрибута року (1996 рік → ‘1996-01-01’).

DROP FUNCTION IF EXISTS get_year_diff;

DELIMITER //

CREATE FUNCTION get_year_diff(in_year INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE diff INT;
    SET diff = TIMESTAMPDIFF(YEAR, MAKEDATE(in_year, 1), CURDATE());
    RETURN diff;
END //
DELIMITER ;


SELECT get_year_diff(2020);

