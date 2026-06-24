CREATE DATABASE project_1;
USE project_1;

CREATE TABLE Books (
    Book_id INT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_year INT,
    Price NUMERIC(10,2),
    Stock INT
);

CREATE TABLE Customers (
    Customer_id int PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

CREATE TABLE Orders (
    Order_id SERIAL PRIMARY KEY,
    Customer_id INT,
    Book_id INT,
    Order_date DATE,
    Quantity INT,
    Total_amount NUMERIC(10,2),
    
    FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id),
    FOREIGN KEY (Book_id) REFERENCES Books(Book_id)
);
select * from Books ;
select * from Customers ;
select * from Orders ;


-- Retrieve all books in the "Fiction" genre
select * from Books where Genre = "Fiction";

-- Find books published after the year 1950
select * from Books where Published_year > 1950 ;

-- List all customers from the Canada
select * from Customers where City = "Canada " ;

-- Show orders placed in November 
select  *from Orders where month(Order_date) = 11 ;

--  Retrieve the total stock of books available
select count(Stock) from Books ;

-- Find the details of the most expensive book
select * , max(Price ) as max_price from Books group by Book_id order by max_price  desc limit  1   ;

--  Show all customers who ordered more than 1 quantity of a book
select c.* , quantity from customers c join orders o on c.customer_id = o.customer_id where quantity > 1;

-- Retrieve all orders where the total amount exceeds $20
select * from orders where total_amount > 20 ;

-- List all genres available in the Books table
select distinct genre from  books  ;

-- Find the book with the lowest stock
select title  , min(stock) as min_stock from books where stock = ( select min(stock) from books ) group by title ;

-- Calculate the total revenue generated from all orders
select sum(total_amount) from orders ;


-- 1)	Retrieve the total number of books sold for each genre
select b.genre , sum(o.quantity) as total_book  from books b join 
orders o on b.book_id = o.book_id group by b.genre ;
-- 2)	Find the average price of books in the "Fantasy" genre
select genre , avg(price) as av_price  from books group by genre having genre = "Fantasy";
-- 3)	List customers who have placed at least 2 orders
select c.name , count(o.order_id) from customers c join orders o on c.customer_id = o.customer_id group by c.name having count(o.order_id)>2 ; 
-- 4)	Find the most frequently ordered book
select b.title , o.order_date from books b join orders o 
on o.book_id = b.book_id where o.order_date = curdate() ;
-- 5)	Show the top 3 most expensive books of 'Fantasy' Genre 
select title from books where genre = 'Fantasy'  order by price desc limit 3 ;
-- 6)	Retrieve the total quantity of books sold by each author
select author , stock as st_au from books  ;
-- List the cities where customers who spent over $30 are located
select distinct c.city , o.total_amount from customers c join orders o on c.customer_id  = o.customer_id where o.total_amount > 30 ;
-- 8)	Find the customer who spent the most on orders
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent Desc LIMIT 1;
-- 9)	Calculate the stock remaining after fulfilling all orders
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;

