-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW rental_information AS
SELECT
c.customer_id,
c.first_name,
c.last_name,
c.email,
(SELECT COUNT(*)
	FROM rental r
	WHERE c.customer_id = r.customer_id
	) AS rental_count
FROM customer c;

-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE amount_per_customer AS
SELECT
ri.customer_id,
ri.first_name,
ri.last_name,
ri.email,
ri.rental_count,
SUM(p.amount) AS total_paid
FROM rental_information ri
LEFT JOIN payment p
	ON ri.customer_id = p.customer_id
GROUP BY
ri.customer_id,
ri.first_name,
ri.last_name,
ri.email;

-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.
WITH cte AS (
		SELECT customer_id,
		first_name,
		last_name,
		email,
		rental_count,
		total_paid
		FROM amount_per_customer)

SELECT customer_id,
first_name,
last_name,
email,
rental_count,
total_paid,
total_paid / NULLIF(rental_count, 0) AS average_payment_per_rental
FROM cte;

-- Next, using the CTE, create the query to generate the final customer summary report, which should include: 
-- customer name, email, rental_count, total_paid and 
-- average_payment_per_rental, this last column is a derived column from total_paid and rental_count.