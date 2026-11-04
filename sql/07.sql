/*
 * List all actors with Bacall Number 2;
 * That is, list all actors that have appeared in a film with an actor that has appeared in a film with 'RUSSELL BACALL',
 * but do not include actors that have Bacall Number < 2.
 */

WITH bacall0 AS (
    SELECT actor_id
    FROM actor
    WHERE first_name = 'RUSSELL' AND last_name = 'BACALL'
),
bacall1 AS (
    SELECT DISTINCT fa.actor_id
    FROM film_actor fa
    JOIN film_actor fb ON fa.film_id = fb.film_id
    JOIN bacall0 b0 ON fb.actor_id = b0.actor_id
    WHERE fa.actor_id NOT IN (SELECT actor_id FROM bacall0)
),
bacall2 AS (
    SELECT DISTINCT fa.actor_id
    FROM film_actor fa
    JOIN film_actor fb ON fa.film_id = fb.film_id
    JOIN bacall1 b1 ON fb.actor_id = b1.actor_id
    WHERE fa.actor_id NOT IN (SELECT actor_id FROM bacall0)
      AND fa.actor_id NOT IN (SELECT actor_id FROM bacall1)
)
SELECT a.first_name || ' ' || a.last_name AS "Actor Name"
FROM actor a
JOIN bacall2 b2 ON a.actor_id = b2.actor_id
ORDER BY a.first_name || a.last_name;
