-- Randomize POS sales timestamps and backfill session IDs
-- 1. Randomize timestamp based on receiptdate (between 08:00 and 19:00)
UPDATE possales 
SET timestamp = DATE_ADD(DATE_ADD(DATE_ADD(DATE(receiptdate), INTERVAL (8 + FLOOR(RAND() * 11)) HOUR), INTERVAL FLOOR(RAND() * 60) MINUTE), INTERVAL FLOOR(RAND() * 60) SECOND);

-- 2. Update sessionid from active session for each branch/user
UPDATE possales p 
SET p.sessionid = (
    SELECT s.sessionid 
    FROM sessions s 
    WHERE s.branchid = p.branchid 
    AND s.addedby = p.addedby 
    AND s.status = 'active' 
    LIMIT 1
)
WHERE p.sessionid IS NULL;
