SELECT
		(@rownum:=@rownum+1) AS rownum
		, TT.*
		,success
		, (SELECT stf_name FROM j2t_staff WHERE stf_id = TT.stf_id) AS stf_name
		FROM(
				SELECT 	TOT.ctd_id
				, TOT.ctr_id
				, TOT.brc_id
				, TOT.mem_id
				, (SELECT mem_name FROM j2t_member WHERE TOT.mem_id = mem_id) AS mem_name
				, (SELECT mem_birthday FROM j2t_member_extend WHERE TOT.mem_id = mem_id) AS mem_birthday
				, TOT.ctr_registType
				, (select pub_desc from j2t_pubcode WHERE pub_group = 'ctr_registType' AND pub_name =  TOT.ctr_registType) AS ctr_registType_name
				, prg_id
				, (SELECT prg_name FROM j2t_program WHERE TOT.prg_id = prg_id) AS prg_name
				, ctd_startDate
				, ctd_endDate
				, ctd_stf_id
				, (SELECT stf_name FROM j2t_staff WHERE stf_id = TOT.ctd_stf_id) AS ctd_stf_name
				, IF(bnh.cnt > 0, 'Y', 'N') AS benefits_YN
				, IFNULL(bnh.cnt, 0) AS benefits_CNT
				, diary_cnt / (dt_cnt * 8) * 100 AS foodRate
				, TRUNCATE(IFNULL(ctd_afterWeight, ctd_contractWeight), 2) AS ctd_contractWeight
				, (SELECT stf_id FROM j2t_contract_staff_log WHERE csl_id = MAX(stl.csl_id)) AS stf_id
				FROM (
					SELECT  	ctd_id
					, T0.brc_id
					, T0.ctr_id
					, T0.mem_id
					, T0.ctr_registType
					, T0.prg_id
					, T0.ctd_startDate
					, T0.ctd_endDate
					, T0.ctd_stf_id
					, COUNT(T0.fdh_type_BF) AS diary_cnt
					, COUNT(DISTINCT T0.fdd_date) AS dt_cnt
					, T0.ctd_contractWeight
					, T0.ctd_afterWeight
					FROM (
						SELECT 	DISTINCT
								ctd.ctd_id
								, ctd.brc_id
								, ctd.ctr_id
								, ctd.mem_id
								, ctr.ctr_registType
								, ctd.prg_id
								, ctd.ctd_startDate
								, ctd.ctd_endDate
								, ctd.ctd_stf_id
								, fdd.fdd_date
								, CASE WHEN fdh_type IN ('water', 'water2', 'water3') THEN 'water' ELSE fdh_type END AS fdh_type_BF
								, ctd.ctd_contractWeight
								, ctd.ctd_afterWeight
						FROM 	j2t_contract_detail AS ctd
						INNER JOIN j2t_contract AS ctr ON (ctd.ctd_endDate BETWEEN '2020-10-01' AND '2020-10-31' AND ctd.prg_type = 'I' AND ctd.ctd_status = 'CT05' AND ctd.ctd_price > 0 AND ctd.ctr_id = ctr.ctr_id)
						INNER JOIN j2t_food_diary fdd ON (ctr.ctr_id = fdd.ctr_id AND fdd.fdd_deleteYN = 'N')
						INNER JOIN j2t_food_diary_history fdh ON (fdd.fdd_id = fdh.fdd_id
																	AND fdd.fdd_date BETWEEN ctd.ctd_startDate AND ctd.ctd_endDate
																	AND fdh.fdh_delYN = 'N'
																	AND fdh.fdh_type IN ('weight', 'weight2', 'breakfast', 'lunch', 'dinner', 'water', 'water2', 'water3', 'sleep', 'activity'))
						LEFT JOIN j2t_form_delay AS dly ON ( dly.ctd_id = ctd.ctd_id
															AND dly.ctr_id = ctd.ctr_id
															AND dly.mem_id = ctd.mem_id
															AND fdd.fdd_date BETWEEN dly_startDate AND dly_endDate
															AND dly.dly_status = 'DS02')
						WHERE 1 = 1
                        AND ctd.mem_id = '강미선7890'
						AND dly_startDate IS NULL AND dly_endDate IS NULL
						GROUP BY ctd_id, fdd.fdd_date, fdh_type_BF
				) AS T0
				GROUP BY ctd_id, ctr_id
			) AS TOT
			LEFT JOIN (	SELECT ctr_id, ctd_id, COUNT(bnh_ctd_id) AS CNT
			FROM j2t_benenfits_history
			GROUP BY mem_id, ctr_id, ctd_id) AS bnh ON (bnh.ctr_id = TOT.ctr_id AND bnh.ctd_id = TOT.ctd_id)
			INNER JOIN j2t_contract_staff_log AS stl ON (TOT.ctd_id = stl.ctd_id AND stl.csl_type = 'S')
			GROUP BY TOT.ctd_id
			HAVING foodRate >= 100
		) AS TT
		LEFT JOIN (	SELECT mem_id, bss_date, ctd_id, ctd_stf_id, success_w as success
					FROM j3t_business_stats bss 
						INNER JOIN j3t_business_history bsh ON (
							bss.bss_id = bsh.bss_id 
							AND bss.bss_date BETWEEN '2020-10-01' AND '2020-10-30' 
							AND bsh.bsh_date BETWEEN '2020-10-01' AND '2020-10-30' 
							AND bss.use_yn = 'Y'
							AND  bss.bss_type = 'F' 
							AND (bss.preview_yn is null or bss.preview_yn = 'N'))
					) AS history ON (history.mem_id = TT.mem_id AND DATE((CASE WHEN WEEKDAY(TT.ctd_endDate)  <  5 THEN TT.ctd_endDate
														WHEN WEEKDAY(TT.ctd_endDate ) = 5 THEN DATE_ADD(TT.ctd_endDate , INTERVAL -1 DAY)
														ELSE DATE_ADD(TT.ctd_endDate , INTERVAL -2 DAY) END))  =  history.bss_date)
		INNER JOIN j2t_member AS mem ON (TT.mem_id = mem.mem_id)
		, (SELECT @rownum:=0) TMP
			WHERE history.success = 'Y'
		ORDER BY ctd_endDate ASC;
        
        SELECT success_w FROM j3t_business_history WHERE bsh_date = '2020-10-07' AND mem_id = '강미선7890' AND use_yn = 'Y';
        
