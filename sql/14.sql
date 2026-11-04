/*
 * Management also wants to create a "best sellers" list for each category.
 *
 * Write a SQL query that:
 * For each category, reports the five films that have been rented the most for each category.
 *
 * Note that in the last query, we were ranking films by the total amount of payments made,
 * but in this query, you are ranking by the total number of times the movie has been rented (and ignoring the price).
 */

WITH ranked AS (
    SELECT c.name,
           f.title,
           count(r.rental_id) AS rental_count,
           row_number() OVER (
               PARTITION BY c.name
               ORDER BY count(r.rental_id) DESC, f.title DESC
           ) AS rn
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN film f ON fc.film_id = f.film_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY c.name, f.title
)
SELECT name, title, rental_count AS "total rentals"
FROM ranked
WHERE rn <= 5
ORDER BY name, rental_count DESC, title;
