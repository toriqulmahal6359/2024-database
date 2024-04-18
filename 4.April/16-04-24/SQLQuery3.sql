with person as (	SELECT DISTINCT P_ID FROM bdjCorporate..DBO_JOB_INBOX WHERE JP_ID = 1236811),final as (SELECT     p_id,    MAX(CASE WHEN rn = 1 THEN Efrom END) AS currentExp_sdate,	MAX(CASE WHEN rn = 1 THEN Eto END) AS currentExp_edate,	MAX(CASE WHEN rn = 1 THEN company END) AS orgname1,	MAX(CASE WHEN rn = 1 THEN eposition END) AS designation1,    MAX(CASE WHEN rn = 2 THEN Efrom END) AS Experience2_sdate,	MAX(CASE WHEN rn = 2 THEN Eto END) AS Experience2_edate,	MAX(CASE WHEN rn = 2 THEN company END) AS orgname2,	MAX(CASE WHEN rn = 2 THEN eposition END) AS designation2,    MAX(CASE WHEN rn = 3 THEN Efrom END) AS Experience3_sdate,	MAX(CASE WHEN rn = 3 THEN Eto END) AS Experience3_edate,	MAX(CASE WHEN rn = 3 THEN company END) AS orgname3,	MAX(CASE WHEN rn = 3 THEN eposition END) AS designation3,    MAX(CASE WHEN rn = 4 THEN Efrom END) AS Experience4_sdate,	MAX(CASE WHEN rn = 4 THEN Eto END) AS Experience4_edate,	MAX(CASE WHEN rn = 4 THEN company END) AS orgname4,	MAX(CASE WHEN rn = 4 THEN eposition END) AS designation4FROM (    SELECT         e.p_id,		e.company,		e.eposition,        e.Efrom,		e.eto,        ROW_NUMBER() OVER (PARTITION BY e.p_id ORDER BY e.Efrom DESC) AS rn    FROM exp e	inner join person p on e.P_ID = p.P_ID) AS subqueryGROUP BY  p_id)select *  from final