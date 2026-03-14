SELECT results.participants.agent AS "Agent", ROUND(results.avg, 1) AS "Avg (%)"
FROM results
ORDER BY results.avg DESC NULLS LAST;
