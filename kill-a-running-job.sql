DECLARE @job_id VARCHAR(200) = 'job_id'

IF EXISTS (
	SELECT *
	FROM msdb.dbo.sysjobactivity AS ACT
	INNER JOIN msdb.dbo.syssessions AS SES1
		ON SES1.session_id = ACT.session_id
	INNER JOIN (SELECT MAX(agent_start_date) AS max_agent_start_date
				FROM msdb.dbo.syssessions) AS SES2 
		ON SES1.agent_start_date = SES2.max_agent_start_date
	WHERE stop_execution_date IS NULL
	AND run_requested_date IS NOT NULL
	AND job_id = @job_id)
EXEC msdb.dbo.sp_stop_job @job_id = @job_id