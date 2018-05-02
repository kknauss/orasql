column profile format a24
column limit format a32
column effective_limit format a32

SELECT P.PROFILE, P.RESOURCE_NAME, P.RESOURCE_TYPE, P.LIMIT, CASE P.LIMIT WHEN 'DEFAULT' THEN D.LIMIT ELSE P.LIMIT END EFFECTIVE_LIMIT
FROM DBA_PROFILES P, DBA_PROFILES D
WHERE P.RESOURCE_NAME = D.RESOURCE_NAME
AND D.PROFILE = 'DEFAULT'
AND P.PROFILE = UPPER('&theProfile')
ORDER BY P.PROFILE, P.RESOURCE_TYPE, P.RESOURCE_NAME;