-- Challenge

-- Write SQL queries to perform the following tasks using the Sakila database:

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.

SELECT
    title,
    (
        SELECT COUNT(*)
        FROM inventory i
        WHERE i.film_id = f.film_id
    ) AS number_copies
FROM film f
WHERE title = 'Hunchback Impossible';

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.

SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT 
    a.first_name,
    a.last_name
FROM actor a
WHERE a.actor_id IN (
    SELECT fa.actor_id
    FROM film_actor fa
    WHERE fa.film_id = (
        SELECT f.film_id
        FROM film f
        WHERE f.title = 'Alone Trip'
    )
);

-- Bonus:
-- 1. Sales have been lagging among young families, and you want to target family movies for a promotion. 
-- Identify all movies categorized as family films.

SELECT
    f.title,
    f.release_year,
    f.length
FROM film f
WHERE f.film_id IN (
    SELECT fc.film_id
    FROM film_category fc
    WHERE fc.category_id = (
        SELECT c.category_id
        FROM category c
        WHERE c.name = 'Family'
    )
);

-- 2. Retrieve the name and email of customers from Canada using both subqueries and joins. 
-- To use joins, you will need to identify the relevant tables and their primary and foreign keys.
-- customer (address_id) > address (city_id) > city (country_id) > country (country)

-- JOINS
SELECT
    c.first_name,
    c.last_name,
    c.email
FROM customer c
JOIN address a
    ON c.address_id = a.address_id
JOIN city ci
    ON a.city_id = ci.city_id
JOIN country co
    ON ci.country_id = co.country_id
WHERE co.country = 'Canada';


-- SUBQUERIES
SELECT
    c.first_name,
    c.last_name,
    c.email
FROM customer c
WHERE c.address_id IN (
    SELECT a.address_id
    FROM address a
    WHERE a.city_id IN (
        SELECT ci.city_id
        FROM city ci
        WHERE ci.country_id = (
            SELECT co.country_id
            FROM country co
            WHERE co.country = 'Canada'
        )
    )
);

-- 3. Determine which films were starred by the most prolific actor in the Sakila database. 
-- A prolific actor is defined as the actor who has acted in the most number of films. 
-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.

SELECT 
    f.film_id, 
    f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id = (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(film_id) DESC
    LIMIT 1
);


-- Find the films rented by the most profitable customer in the Sakila database. 
-- You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.

SELECT
    f.title,
    f.release_year
FROM film f
WHERE f.film_id IN (
    SELECT i.film_id  
    FROM rental r
    JOIN inventory i 
		ON r.inventory_id = i.inventory_id  
    WHERE r.customer_id = (
        SELECT customer_id
        FROM payment
        GROUP BY customer_id
        ORDER BY SUM(amount) DESC
        LIMIT 1
    )
);

-- Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. 
-- You can use subqueries to accomplish this.

SELECT
    c.customer_id AS client_id,
    c.first_name,
    c.last_name,
    ct.total_amount_spent
FROM (
    SELECT
        customer_id,
        SUM(amount) AS total_amount_spent
    FROM payment
    GROUP BY customer_id
) AS ct
JOIN customer c
  ON c.customer_id = ct.customer_id
WHERE ct.total_amount_spent > (
    SELECT AVG(total_amount_spent)
    FROM (
        SELECT
            customer_id,
            SUM(amount) AS total_amount_spent
        FROM payment
        GROUP BY customer_id
    ) AS avg_sub
);

