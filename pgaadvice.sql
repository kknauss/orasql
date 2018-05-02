SELECT 
        PGA_TARGET_FOR_ESTIMATE/(1024*1024) pga_est_MB,
        PGA_TARGET_FACTOR,
        ADVICE_STATUS,
        ROUND(BYTES_PROCESSED /(1024*1024),2) MB_PROCESSED,
        ROUND(ESTD_EXTRA_BYTES_RW/(1024*1024),2) ESTD_EXTRA_MB_RW,
        ESTD_PGA_CACHE_HIT_PERCENTAGE,
        ESTD_OVERALLOC_COUNT
FROM 
      V$PGA_TARGET_ADVICE;