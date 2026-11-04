/*
 * This question and the next one are inspired by the Bacon Number:
 * https://en.wikipedia.org/wiki/Six_Degrees_of_Kevin_Bacon#Bacon_numbers
 *
 * List all actors with Bacall Number 1.
 * That is, list all actors that have appeared in a film with 'RUSSELL BACALL'.
 * Do not list 'RUSSELL BACALL', since he has a Bacall Number of 0.
 */

SELECT DISTINCT a.first_name || ' ' || a.last_name AS "Actor Name"
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
WHERE EXISTS (
    SELECT 1
    FROM film_actor fa2
    JOIN actor b ON b.actor_id = fa2.actor_id
    WHERE fa2.film_id = fa.film_id
      AND b.first_name = 'RUSSELL'
      AND b.last_name = 'BACALL'
)
  AND NOT (a.first_name = 'RUSSELL' AND a.last_name = 'BACALL')
ORDER BY "Actor Name";
