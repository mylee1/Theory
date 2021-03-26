SELECT 	T0.brc_name, T0.brc_id, IFNULL(T1.CNT, 0) CNT			
FROM	j2t_branch T0 /*j2t_branch 지점정보 */			
		LEFT JOIN (		
			SELECT a.brc_id, count(a.mem_id) AS CNT	
			FROM  j2t_mp_memo a	/*앱 쪽지*/
			WHERE a.mmo_regDate between '2020-06-22 00:00:00' AND '2020-07-19 23:59:59'
			 	AND (a.mmo_text LIKE '%젓가락%' OR a.mmo_text LIKE '%숟가락%' OR a.mmo_text LIKE '%숫가락%')
				AND a.mmo_type = 'MT01'
			 	AND a.mmo_userType = 'admin'
			GROUP BY a.brc_id	
		) T1 ON T0.brc_id = T1.brc_id		
WHERE 	T0.brc_type = 'B' 	/*코드 구분 : B 지점*/		
	AND T0.brc_closeYN = 'N' /*폐점 YN*/			
	AND T0.brc_useYN = 'Y' 	/*지점 사용 유무*/		
	AND T0.brc_id != 'demo'			
ORDER BY brc_name;				
				
	
SELECT (SELECT brc_name FROM j2t_branch WHERE brc_id = a.brc_id) AS brc_name
		, (SELECT stf_name FROM j2t_staff WHERE stf_id = a.stf_id) AS stf_name
		, a.mem_id, mmo_regDate, mmo_text				
FROM  j2t_mp_memo a	/*앱 쪽지*/			
WHERE a.mmo_regDate between '2020-06-22 00:00:00' AND '2020-07-19 23:59:59'	
	AND (a.mmo_text LIKE '%젓가락%' OR a.mmo_text LIKE '%숟가락%' OR a.mmo_text LIKE '%숫가락%')			
	AND a.mmo_type = 'MT01'	/*일반 대화*/		
	AND a.mmo_userType = 'admin'			
ORDER BY brc_name/*사용자*/;				
