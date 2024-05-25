--95
/* Вывести имена клиентов, у которых сумма покупок за март и апрель 2024 превышает 9200, и итоговую потраченную сумму за эти 2 месяца.
Поля в результирующей таблице: name, total_spent */

SELECT 
    Customer.name,
    SUM(Product.price*Purchase.quantity) as total_spent
FROM Purchase
JOIN Customer ON Customer.customer_key = Purchase.customer_key
LEFT JOIN Product ON Product.product_key = Purchase.product_key
WHERE Purchase.date LIKE '2024-03%' OR Purchase.date LIKE '2024-04%'
GROUP BY Purchase.customer_key
HAVING total_spent > 9200

--96
/* Вывести все товары, в наименовании которых содержится «самокат» (без учета регистра), и срок годности которых не превышает 7 суток.
Поля в результирующей таблице: product */

SELECT product
FROM Products
WHERE lower(product) like lower('%самокат%')
and shelf_life <= 7


--97
/* Посчитать количество работающих складов на текущую дату по каждому городу. Вывести только те города, у которых количество складов более 80. Данные на выходе - город, количество складов.
Поля в результирующей таблице: city warehouse_count */

SELECT 
    city,
    COUNT(name) AS warehouse_count
FROM Warehouses
WHERE date_close IS NULL
GROUP BY city
HAVING warehouse_count > 80

--98
/* Найти наибольшую зарплату по департаментам и отсортировать департаменты по убыванию максимальной зарплаты.
Поля в результирующей таблице: DepartmentName HighestSalary */

SELECT 
    d.name as DepartmentName,
    max(e.Salary) as HighestSalary
FROM Departments d
JOIN Employees e
ON d.id = e.Dep_id
GROUP by DepartmentName
ORDER by HighestSalary  DESC

--99
/* Посчитай доход с женской аудитории (доход = сумма(price * items)). Обратите внимание, что в таблице женская аудитория имеет поле user_gender «female» или «f». Поля в результирующей таблице: income_from_female */

SELECT 
    sum(items*price) as income_from_female
FROM Purchases
WHERE user_gender IN('f', 'female')


--100
/* Посчитай кол-во уникальных пользователей-мужчин, заказавших более чем три вещи (items) суммарно за все заказы. Обратите внимание, что в таблице мужская аудитория имеет поле user_gender «male» или «m». Поля в результирующей таблице: unique_male_users */

SELECT COUNT(*) as unique_male_users
FROM 
(SELECT 
    user_id
FROM Purchases
WHERE user_gender IN('male', 'm')
GROUP by user_id
HAVING SUM(items) > 3) as Subquery

--101
/* Выведи для каждого пользователя первое наименование, которое он заказал (первое по времени транзакции).
Поля в результирующей таблице: user_id  item */

SELECT 
    user_id, 
    item
FROM Transactions
WHERE transaction_ts IN (
SELECT MIN(transaction_ts)
FROM Transactions
GROUP BY user_id)

--103
/* Вывести список имён сотрудников, получающих большую заработную плату, чем у непосредственного руководителя.
Поля в результирующей таблице: name */

SELECT employees.name
FROM Employee AS employees,
    Employee AS chieves
WHERE chieves.id = employees.chief_id
    AND employees.salary > chieves.salary

--104
/* Вывести список имён сотрудников, получающих максимальную заработную плату в своем отделе
Поля в результирующей таблице: name */

SELECT name
FROM Employee
WHERE salary IN (
    SELECT MAX(salary)
    FROM Employee
    GROUP BY department_id
)
