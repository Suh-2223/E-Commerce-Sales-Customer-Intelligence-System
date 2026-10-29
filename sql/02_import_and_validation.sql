
-- Step 1: Check the number of rows and duplicate review IDs
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT review_id) AS unique_review_ids,
    COUNT(*) - COUNT(DISTINCT review_id) AS duplicate_rows
FROM reviews_staging;


-- Step 2: Insert one row per review ID into the final table
INSERT INTO order_reviews (
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
)
SELECT DISTINCT ON (review_id)
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
FROM reviews_staging
ORDER BY review_id, review_creation_date DESC NULLS LAST;


-- Step 3: Verify the number of imported reviews
SELECT COUNT(*) AS imported_reviews
FROM order_reviews;
