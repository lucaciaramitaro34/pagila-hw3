/*
 * Management wants to create a "best sellers" list for each actor.
 *
 * Write a SQL query that:
 * For each actor, reports the three films that the actor starred in that have brought in the most revenue for the company.
 * (The revenue is the sum of all payments associated with that film.)
 *
 * HINT:
 * For correct output, you will have to rank the films for each actor.
 * My solution uses the `rank` window function.
 */

WITH film_revenue AS (
    SELECT
        fa.actor_id,
        f.film_id,
        f.title,
        sum(p.amount) AS revenue
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    JOIN payment p ON r.rental_id = p.rental_id
    GROUP BY fa.actor_id, f.film_id, f.title
),
ranked AS (
    SELECT
        actor_id,
        film_id,
        title,
        revenue,
        rank() OVER (PARTITION BY actor_id ORDER BY revenue DESC, film_id) AS rank
    FROM film_revenue
)
SELECT
    a.actor_id,
    a.first_name,
    a.last_name,
    r.film_id,
    r.title,
    r.rank,
    r.revenue
FROM ranked r
JOIN actor a ON a.actor_id = r.actor_id
WHERE r.rank <= 3
ORDER BY a.actor_id, r.rank;
