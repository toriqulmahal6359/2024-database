DECLARE 
	@Fair_Id int = 0
	, @Token_No int = 0


SELECT DISTINCT ex.ExId,p.ID, 1, P.Name,P.Mobile,P.E_Mail1, 'https://my.bdjobs.com/photos/'+pfi.FolderName+'/'+ rpi.PhotoName+'.jpg' , GETDATE(), 0, jix.applyid, 0, 1,cast(RAND()*10+1 as int) 
			FROM bdjJObfair..FairWithJobInfo fwj 
				inner join bdjJObfair..viewFairINfo VFI on Fwj.Att_id = VFI.Att_Id 
				inner join bdjJObfair..CompanyInfo ci on ci.Com_id = VFI.Com_Id
				inner join bdjJObfair..ApplicantInfo AI on VFI.Fair_Id = AI.Fair_Id
				inner join bdjResumes..PERSONAL P on p.ID = Ai.P_ID 
				left join bdjCorporate..DBO_JOB_INBOX Jix on fwj.jp_id = jix.jp_id and Jix.p_ID = Ai.P_ID
				left join bdjCorporate.rp.ApplicantProcess ap on ap.ApplyId = jix.ApplyID and ap.levelStatus = 1 
				left join bdjResumes..ResumePhotoInfo rpi on rpi.P_ID = p.ID
				left join bdjResumes..PhotoFolderInfo pfi ON pfi.ID = rpi.FolderID
				--left join bdjCorporate.rp.Schedule s on s.schid = ap.schId 
				left join bdjExaminations.exm.examinfo ex on ex.jp_id = Jix.JP_ID --and s.schid = exschId	--ex.ExamDateTime= S.ScheduleDate
				left join bdjExaminations.exm.ExamSlots exs on ex.ExID = exs.EXID and ap.schid = exs.schId	--ex.ExamDateTime= S.ScheduleDate
				left join bdjExaminations.exm.Participants pt on pt.ApplyID = Jix.ApplyID
			WHERE AI.Fair_Id = 0 and AI.Token_No = 0 and ex.ExId IS NOT NULL and pt.ParticipantID is null