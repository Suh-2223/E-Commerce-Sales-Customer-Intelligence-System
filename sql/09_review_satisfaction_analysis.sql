
-- Customer Review and Satisfaction Analysis

-- 1. Overall review satisfaction

SELECT
    COUNT(*) AS total_reviews,
    ROUND(AVG(review_score), 2) AS average_review_score,
    COUNT(*) FILTER (WHERE review_score = 5) AS five_star_reviews,
    COUNT(*) FILTER (WHERE review_score = 1) AS one_star_reviews,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE review_score = 5)
        / NULLIF(COUNT(*), 0),
        2
    ) AS five_star_percentage
FROM order_reviews;


-- 2. Distribution of review scores

SELECT
    review_score,
    COUNT(*) AS number_of_reviews,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM order_reviews
GROUP BY review_score
ORDER BY review_score;
