/* 
 * Finding movies with similar categories still gives you too many options.
 *
 * Write a SQL query that lists all movies that share 2 categories with AMERICAN CIRCUS and 1 actor.
 *
 * HINT:
 * It's possible to complete this problem both with and without set operations,
 * but I find the version using set operations much more intuitive.
 */

SELECT f.title
FROM film f
WHERE (
    SELECT count(*)
    FROM film_category fc
    WHERE fc.film_id = f.film_id
      AND fc.category_id IN (
          SELECT category_id
          FROM film_category
          WHERE film_id = (
              SELECT film_id FROM film WHERE title = 'AMERICAN CIRCUS'
          )
      )
) >= 2
AND EXISTS (
    SELECT 1
    FROM film_actor fa
    WHERE fa.film_id = f.film_id
      AND fa.actor_id IN (
          SELECT actor_id
          FROM film_actor
          WHERE film_id = (
              SELECT film_id FROM film WHERE title = 'AMERICAN CIRCUS'
          )
      )
)
ORDER BY f.title;
