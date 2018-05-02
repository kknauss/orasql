SELECT OWNER, JOB_NAME, JOB_CLASS
FROM DBA_SCHEDULER_JOBS SJ
WHERE EXISTS (
                SELECT 1 
                FROM DBA_OBJECTS O 
                WHERE O.OWNER = SJ.OWNER 
                AND O.OBJECT_NAME = SJ.JOB_NAME 
                AND O.OBJECT_ID IN (547687,547689,547690,547691,547692,547693,547694,547695,547696,547697,547698,547699,547700)
              );
    
--grep unexpected *log | awk '{print $9}' | awk -F"(" '{print $2}' |awk -F"," '{print $1}' | sort | uniq | awk -v x=0 '{ if (x==0) {printf("%s", $0)} else {printf(",%s",$0)}; x++; } END { printf("\n"); }'
547687,547689,547690,547691,547692,547693,547694,547695,547696,547697,547698,547699,547700

--grep unexpected dw_star.expdp.mdonly.log |awk '{print $9}' |awk -F"(" '{print $2}' |awk -F"," '{print $1}' |sort |uniq |awk -v x=0 '{if(x==0){printf("%s",$0)}else{printf(",%s",$0)};x++;}END{printf("\n");}'
706256,706258,706259,706260,706261,706262,706263,706264,706265,706266,706267,706268,706269

SELECT * FROM V$INSTANCE;

SELECT OBJECT_ID, OWNER, OBJECT_NAME, OBJECT_TYPE, LENGTH(OBJECT_NAME)
FROM DBA_OBJECTS
WHERE OBJECT_ID IN (547687,547689,547690,547691,547692,547693,547694,547695,547696,547697,547698,547699,547700)
ORDER BY OBJECT_ID;
/*
547687	DW_STAR	START_RET_KPI_AGGR_DAILY_RULE	RULE	29
547689	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE10	RULE	29
547690	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE11	RULE	29
547691	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE12	RULE	29
547692	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE13	RULE	29
547693	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE14	RULE	29
547694	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE15	RULE	29
547695	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE16	RULE	29
547696	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE17	RULE	29
547697	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE18	RULE	29
547698	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE19	RULE	29
547699	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE20	RULE	29
547700	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE21	RULE	29
*/

SELECT OBJECT_ID, OWNER, OBJECT_NAME, OBJECT_TYPE, LENGTH(OBJECT_NAME)
FROM DBA_OBJECTS
WHERE OBJECT_ID IN (706256,706258,706259,706260,706261,706262,706263,706264,706265,706266,706267,706268,706269)
ORDER BY OBJECT_ID;
/*
706256	DW_STAR	START_RET_KPI_AGGR_DAILY_RULE	RULE	29
706258	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE10	RULE	29
706259	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE11	RULE	29
706260	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE12	RULE	29
706261	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE13	RULE	29
706262	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE14	RULE	29
706263	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE15	RULE	29
706264	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE16	RULE	29
706265	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE17	RULE	29
706266	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE18	RULE	29
706267	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE19	RULE	29
706268	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE20	RULE	29
706269	DW_STAR	CONTINUE_RET_KPI_DAILY_RULE21	RULE	29
*/