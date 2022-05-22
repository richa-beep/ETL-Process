INSERT INTO videostart_dlt
SELECT Str_to_date(datetime, '%Y-%m-%dT%H:%i:%s') AS DATETIME,
    CASE
        WHEN Regexp_like(
            Upper(Substring_index(videotitle, '|', 1)),
            'IPHONE|ANDROID|IPAD|APP'
        ) THEN Substring_index(videotitle, '|', 1)
        WHEN Regexp_like(
            Upper(Substring_index(videotitle, '|', 1)),
            'NEWS'
        ) THEN 'Desktop'
        ELSE 'Unknown'
    END AS "PLATFORM",
    CASE
        WHEN Regexp_like(
            Upper(Substring_index(videotitle, '|', 1)),
            'NEWS'
        ) THEN Substring_index(videotitle, '|', 1)
        ELSE 'Unknown'
    END AS "SITE",
    Substring_index(videotitle, '|', -1) AS VIDEO
FROM videostart_raw.videostart_raw
WHERE events LIKE '%206%'
    AND videotitle LIKE '%|%';