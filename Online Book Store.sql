create table books (
	Book_ID	serial primary key,
	Title	varchar(100),
	Author	varchar(100),
	Genre	varchar(50),
	Published_Year	int,
	Price	numeric(10,2),
	Stock	int

);
select * from books;


create table customers(
	Customer_ID serial primary key,
	Name varchar(100),
	Email varchar(100),
	Phone varchar(15),
	City varchar(50),
	Country varchar(150)
);
select * from customers;



create table orders(
	Order_ID	serial primary key,
	Customer_ID	int references customers(Customer_ID),
	Book_ID	int references books(Book_ID),
	Order_Date	Date,
	Quantity	int,
	Total_Amount numeric(10,2)		
);
select * from orders;


-- Import data into Books Table
copy books(Book_ID,	Title,	Author,	Genre,	Published_Year,	Price,	Stock)
from 'C:/Users/Indrajeet/Downloads/SQL_Resume_Project-main/SQL_Resume_Project-main/Books.csv'
csv header;

-- 1) Retrieve all books in the "Fiction" genre:
select * from books 
where genre = 'Fiction';


-- 2) Find books published after the year 1950:
select * from books
where published_year > 1950;


-- 3) List all customers from the Canada:
select * from customers
where country = 'Canada';



-- 4) Show orders placed in November 2023:
select * from orders
where order_date between '2023-11-01' and '2023-11-30';


-- 5) Retrieve the total stock of books available:
select sum(stock) as Total_Available_Books from books;


-- 6) Find the details of the most expensive book:
select * from books
where price =(select max(price) from books);

SELECT * FROM Books 
ORDER BY Price DESC 
LIMIT 1;


-- 7) Show all customers who ordered more than 1 quantity of a book:
select c.* from customers c inner join orders o on c.customer_id = o.customer_id 
where o.quantity > 1;

SELECT * FROM Orders 
WHERE quantity>1;


-- 8) Retrieve all orders where the total amount exceeds $20:
select * from orders where total_amount > 20;



-- 9) List all genres available in the Books table:
select distinct genre as All_Genre from books;


-- 10) Find the book with the lowest stock:
select * from books 
where stock = (select min(stock) from books);

SELECT * FROM Books 
ORDER BY stock 
LIMIT 1;


-- 11) Calculate the total revenue generated from all orders:
select sum(total_amount) as Total_Revenue from orders;


-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
select b.genre, sum(o.quantity) as Total_Books_Sold 
from books b inner join orders o
on b.book_id = o.book_id group by b.genre;



-- 2) Find the average price of books in the "Fantasy" genre:
select genre, avg(price) from books
group by genre having genre='Fantasy';

select avg(price) from books
where genre='Fantasy';


-- 3) List customers who have placed at least 2 orders:
SELECT c.customer_id, c.name, COUNT(o.order_id) AS total_orders
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) >= 2;



-- 4) Find the most frequently ordered book:
SELECT o.Book_id, b.title, COUNT(o.order_id) AS ORDER_COUNT
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY ORDER_COUNT DESC LIMIT 1;



-- Solution to: Find the most frequently ordered book(s)
-- This query returns all books that have been ordered the most number of times.
-- It ensures that if multiple books share the same maximum order frequency, they are all included.
SELECT b.title, o.book_id, COUNT(o.order_id) AS times_ordered
FROM orders o
JOIN books b ON o.book_id = b.book_id
GROUP BY o.book_id, b.title
HAVING COUNT(o.order_id) = (
  SELECT MAX(order_count)
  FROM (
    SELECT book_id, COUNT(order_id) AS order_count
    FROM orders
    GROUP BY book_id
  ) AS sub
);



-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
select * from books 
where genre ='Fantasy' 
order by price desc
limit 3;


-- 6) Retrieve the total quantity of books sold by each author:
select b.author, sum(o.quantity) as Total_Quantity_Sold
from books b join orders o on b.book_id = o.book_id
group by b.author 
order by Total_Quantity_Sold asc;


-- Retrieve total quantity of books sold by each author, including those with no sales:
SELECT b.author, COALESCE(SUM(o.quantity), 0) AS total_quantity_sold
FROM books b
LEFT JOIN orders o ON b.book_id = o.book_id
GROUP BY b.author order by total_quantity_sold desc;



-- 7) List the cities where customers who spent over $30 are located:
SELECT c.city, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.city
HAVING SUM(o.total_amount) > 30.00;


-- 8) Find the customer who spent the most on orders:
SELECT c.name,c.customer_id, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
order by total_spent desc
limit 1;


--9) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;




