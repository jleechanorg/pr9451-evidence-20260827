-- Bounded lookup used by testing_mcp/core/test_level_up_organic.py.
-- Parameters: campaign_id, request_id, window_start, window_end.
-- This public copy documents the query shape; raw response text is not
-- included in this public evidence package.
SELECT response_text,
       FORMAT_TIMESTAMP('%Y-%m-%dT%H:%M:%E6SZ', ingested_at) AS ingested_at
FROM `worldarchitecture-ai.llm_forensics.llm_payloads`
WHERE campaign_id = @campaign_id
  AND JSON_VALUE(extra_json, '$.request_id') = @request_id
  AND event_type = 'gameplay_streaming'
  AND ingested_at BETWEEN @window_start AND @window_end
ORDER BY ingested_at;
