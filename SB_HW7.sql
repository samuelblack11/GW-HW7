USE sakila;
# 1a
SELECT first_name, last_name
FROM actor;

#1b
SELECT concat(first_name, ' ',last_name) as 'Actor Name'
FROM actor;

#2a

SELECT  actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

#2b
SELECT  actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%' ;

#2c 
SELECT  actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%LI%' 
ORDER BY last_name, first_name;

#2d
SELECT country_id, country
	FROM country
	WHERE country IN
	(
		SELECT country
		FROM country
		WHERE country = 'Afghanistan' OR country = 'Bangladesh' OR country ='China'
		);
        
#3a

ALTER TABLE actor
ADD middle_name VARCHAR(30) AFTER first_name;

#3b
ALTER TABLE actor
MODIFY COLUMN middle_name blob;

# SELECT * FROM actor

#3c 
ALTER TABLE actor
DROP column middle_name;

#4a
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name;

#4b
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name
HAVING COUNT(last_name)>1;

#4c
UPDATE actor
#Set updates the record. Where defines where.
SET first_name = 'Harpo'
WHERE first_name = 'Groucho' AND last_name='Williams';


SELECT * FROM actor;
#4d
UPDATE actor
#Set updates the record. Where defines where.
SET first_name = 'Groucho'
WHERE first_name = 'Harpo' AND last_name='Williams';

#5a
SHOW CREATE TABLE address;
# Code below taken from SHOW CREATE TABLE. Table already exists.
#CREATE TABLE `address` (
 # `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
 # `address` varchar(50) NOT NULL,
  #`address2` varchar(50) DEFAULT NULL,
  #`district` varchar(20) NOT NULL,
  #`city_id` smallint(5) unsigned NOT NULL,
  #`postal_code` varchar(10) DEFAULT NULL,
  #`phone` varchar(20) NOT NULL,
  #`location` geometry NOT NULL,
  #`last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  #PRIMARY KEY (`address_id`),
  #KEY `idx_fk_city_id` (`city_id`),
  #SPATIAL KEY `idx_location` (`location`),
 # CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
#) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8

#6a
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address
On staff.address_id=address.address_id;

SELECT * FROM staff;
# 6b
SELECT staff.first_name, staff.last_name, SUM(payment.amount)
FROM staff
INNER JOIN payment
On staff.staff_id=payment.staff_id
GROUP BY first_name,last_name;

#6c
CREATE TABLE actor_counts(
SELECT film.title, COUNT(film_actor.actor_id) AS 'Actor Count'
FROM film
INNER JOIN film_actor
ON film.film_id=film_actor.film_id
GROUP BY title
);

#6D
CREATE TABLE inv_counts(
SELECT film.title, COUNT(inventory.inventory_id) AS 'Inventory_Count'
FROM film
INNER JOIN inventory
ON film.film_id=inventory.film_id
GROUP BY title
);

SELECT title, Inventory_Count
FROM inv_counts
Where title = 'Hunchback Impossible';

#6e
SELECT customer.first_name, customer.last_name,SUM(payment.amount) As 'Total_Paid'
FROM payment
INNER JOIN customer
ON payment.customer_id=customer.customer_id
GROUP BY customer.first_name, customer.last_name
ORDER BY customer.last_name;

#7a
   SELECT title
   FROM film
   WHERE title like 'K%' OR title like 'Q%';

#7b

SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
  SELECT actor_id
  FROM film_actor
  WHERE film_id IN
  (
   SELECT film_id
   FROM film
   WHERE title = 'ALONE TRIP'
  )
);

#7c through joins
SELECT customer.first_name, customer.last_name,customer.email, country.country
FROM customer
INNER JOIN address
ON customer.address_id=address.address_id
INNER JOIN city 
ON address.city_id=city.city_id
INNER JOIN country
ON city.country_id = country.country_id
WHERE country = 'Canada';


###### 7c through subqueries instead of joins ######
# Customer address_id
# Address city_id
# City country_id
# Country
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN
(
SELECT address_id
FROM Address
WHERE city_id IN
(
SELECT city_id
FROM City
WHERE country_id in
(
SELECT country_id
FROM Country
WHERE country = 'Canada'
			)
		)
	);


# 7d
SELECT film.title, category.name
FROM film
INNER JOIN film_category
ON film.film_id=film_category.film_id
INNER JOIN category
ON film_category.category_id=category.category_id
WHERE category.name = 'Family';

#7e
# Relate film to inventory through film_id and inventory to rental through inventory_id
SELECT film.title, COUNT(rental.inventory_id) AS 'Rental_Count'
FROM film
INNER JOIN inventory
ON film.film_id=inventory.film_id
INNER JOIN rental
ON inventory.inventory_id=rental.inventory_id
GROUP BY film.title
ORDER BY Rental_Count DESC ;

#7f

# Payment rental_id
# Rental staff_id
# Staff store_id
# Store.store_id
SELECT store.store_id, SUM(payment.amount) AS 'Revenue'
FROM payment
INNER JOIN rental
ON payment.rental_id=rental.rental_id
INNER JOIN staff
ON rental.staff_id = staff.staff_id
INNER JOIN store
ON staff.store_id = store.store_id
GROUP BY store.store_id;

#7g

# Store address_id
# Address city_id
# City country_id
# Country country
SELECT store.store_id, city.city, country.country
FROM store
INNER JOIN address
ON store.address_id = address.address_id
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON city.country_id = country.country_id
ORDER BY store.store_id ASC;

# 7h

# Category category_id
# film_category film_id
# inventory inventory_id
# rental rental_id
# payment amount
CREATE TABLE Genre_Revenues(
SELECT category.name, SUM(payment.amount) AS ' Genre_Revenue'
FROM category
INNER JOIN film_category
ON category.category_id = film_category.category_id
INNER JOIN inventory
ON film_category.film_id = inventory.film_id
INNER JOIN rental
ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment
ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY Genre_Revenue DESC
LIMIT 5
);

SELECT * FROM Genre_Revenues;

# 8a
CREATE VIEW TOP_5_GENRES_BY_REV AS
SELECT name, Genre_Revenue
FROM Genre_Revenues;

# 8b
SELECT * FROM TOP_5_GENRES_BY_REV;

#8c 
DROP VIEW TOP_5_GENRES_BY_REV;
