Use sakila;

#1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name
FROM actor;

# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT UPPER(CONCAT(first_name,'  ', last_name)) 
AS Actor_name
FROM actor;

# 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name,
#     "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'JOE';

# 2b. Find all actors whose last name contain the letters GEN:
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%';

# 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT actor_id, last_name, first_name
FROM actor
WHERE last_name LIKE '%LI%';

# 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country 
WHERE country 
IN ('AFGHANISTAN', 'BANGLADESH', 'CHINA');

# 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
#     so create a column in the table actor named description and use the data type BLOB 
#     (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor
ADD COLUMN description VARCHAR(225);

ALTER TABLE actor
MODIFY COLUMN description BLOB;

# 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor
DROP COLUMN description;

# 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) AS 'Same'
FROM actor
GROUP BY last_name;

# 4b. List last names of actors and the number of actors who have that last name, 
#     but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) AS 'Same'
FROM actor
GROUP BY last_name
HAVING Same >=2;

# 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
SELECT actor_id, last_name, first_name
FROM actor
WHERE last_name = 'WILLIAMS';

UPDATE actor 
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

# 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
#     It turns out that GROUCHO was the correct name after all! In a single query, 
#     if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor 
SET first_name = 'GROUCHO'
WHERE actor_id = 172;

SELECT actor_id, last_name, first_name
FROM actor
WHERE last_name = 'WILLIAMS';

# 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
DESCRIBE sakila.address;

SHOW CREATE TABLE address;

# 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT address_id, last_name, first_name
FROM staff;

SELECT first_name, last_name, address
FROM staff s 
JOIN address a
ON s.address_id = a.address_id;

# 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT first_name, last_name, SUM(amount)
FROM staff s
JOIN payment p
ON s.staff_id = p.staff_id
AND payment_date LIKE '2005-08%'
GROUP BY p.staff_id;

# 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT title, COUNT(actor_id)
FROM film f
INNER JOIN film_actor fa
ON f.film_id = fa.film_id
GROUP BY title;

# 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT title, COUNT(inventory_id)
FROM film f
INNER JOIN inventory i 
ON f.film_id = i.film_id
WHERE title = 'HUNCHBACK IMPOSSIBLE';

# 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
#     List the customers alphabetically by last name:
SELECT last_name, first_name, SUM(amount)
FROM payment p
INNER JOIN customer c
ON p.customer_id = c.customer_id
GROUP BY last_name;
# If default wasn't alphabetical "ORDER BY last_name ASC;" for A-Z, or DESC for Z-A

# 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
#     films starting with the letters K and Q have also soared in popularity. 
#     Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT film_id, title, language_id
FROM film;

DESCRIBE sakila.film;

SELECT film_id, title
FROM film
WHERE title LIKE 'K%' OR title LIKE 'Q%'
AND language_id = '1';

# 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT last_name, first_name
FROM actor
WHERE actor_id 
IN (SELECT actor_id FROM film_actor WHERE film_id IN (SELECT film_id FROM film WHERE title = 'ALONE TRIP'));

# 7c. You want to run an email marketing campaign in Canada, 
#     for which you will need the names and email addresses of all Canadian customers. 
#     Use joins to retrieve this information.
SELECT country, last_name, first_name, email
FROM country c
JOIN customer cu
ON c.country_id = cu.customer_id;
WHERE country = 'CANADA';

# 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
#     Identify all movies categorized as family films.
SELECT title, category
FROM film_list
WHERE category = 'FAMILY';

# 7e. Display the most frequently rented movies in descending order.
SELECT i.inventory_id, f.title, COUNT(rental_id)
FROM rental r
JOIN inventory i
ON (r.inventory_id = i.inventory_id)
JOIN film f
ON (i.film_id = f.film_id)
GROUP BY f.title
ORDER BY COUNT(rental_id) DESC;

# 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, SUM(amount)
FROM payment p
JOIN rental r
ON p.rental_id = r.rental_id
JOIN inventory i
ON i.inventory_id = r.inventory_id
JOIN store s
ON s.store_id = i.store_id
GROUP BY s.store_id; 

# 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, ct.city, cn.country 
FROM store s
JOIN address a 
ON s.address_id = a.address_id
JOIN city ct
ON ct.city_id = a.city_id
JOIN country cn
ON cn.country_id = ct.country_id
GROUP BY s.store_id;

# 7h. List the top five genres in gross revenue in descending order. 
#     (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name, SUM(p.amount)
FROM category c
JOIN film_category AS fc
ON c.category_id = fc.category_id
JOIN inventory i
ON fc.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY name
ORDER BY SUM(p.amount) DESC
LIMIT 5;

# 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
#     Use the solution from the problem above to create a view. 
#     If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW Top_Five_Genres_By_Gross_Revenue AS

SELECT name AS Top_Genres, SUM(amount) AS Gross_Revenue
FROM category c
JOIN film_category fc
ON  c.category_id = fc.category_id
JOIN inventory i
ON fc.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
JOIN payment p 
ON r.rental_id = p.rental_id
GROUP BY Top_Genres 
ORDER BY Gross_Revenue DESC 
LIMIT 5;

# 8b. How would you display the view that you created in 8a?
#     Placed "CREATE VIEW Top_Five_Genres_By_Gross_Revenue AS" at top of code in 8a, so I can use following code to call it:
SELECT*FROM Top_Five_Genres_By_Gross_Revenue;

# 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW Top_Five_Genres_By_Gross_Revenue;


