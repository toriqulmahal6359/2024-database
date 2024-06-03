db.ApplicantHiringActivity.aggregate([
	{ $match: { "JobInformations.JobId": 1226863 } },
	{ $unwind: "$JobInformations" },
	{ $match: { "JobInformations.JobId": 1226863 } },
	{ $unwind: "$JobInformations.ApplicantProcessInformation" },
	{ $match: { "JobInformations.ApplicantProcessInformation.TestStepId" : { $exists: true } } },
	{ $group: { 
			_id: {
      			StepId: "$JobInformations.ApplicantProcessInformation.TestStepId",
				TestType: "$JobInformations.ApplicantProcessInformation.TestType",
				TestName: "$JobInformations.ApplicantProcessInformation.TestName",
				LevelStatus: "$JobInformations.ApplicantProcessInformation.CurrentStepLevelStatus",
    	 	},
			rejectedApplicants: {
				$sum: { $cond : [{ $eq: ["$JobInformations.ApplicantProcessInformation.IsRejectedInCurrentStep", true] }, 1, 0] }
			},
			scheduledApplicants: {
				$sum: { $cond : [
					{ $and: [
						{ $ne: ["$JobInformations.ApplicantProcessInformation.ScheduleId", 0] },
						{ $eq: ["$JobInformations.ApplicantProcessInformation.IsRejectedInCurrentStep", false] }
					] }
					, 1, 0
				] }
			},
			notScheduledApplicants: {
				$sum: { $cond : [{ $eq: ["$JobInformations.ApplicantProcessInformation.ScheduleId", 0] }, 1, 0] }
			},
	     	totalApplicants: { $addToSet: "$ApplicantId" },
       		count: { $sum: 1 }
	} },
	{ $sort: { "_id.LevelStatus": 1 } },
	{ $project: { 
		_id: 0, 
		StepId: "$_id.StepId",
		TestType: "$_id.TestType", 
		TestName: "$_id.TestName",
		LevelStatus: "$_id.LevelStatus", 
		TotalApplicantInStep: "$count",
		ScheduledApplicantCount: "$scheduledApplicants",
		NotScheduledApplicantCount: "$notScheduledApplicants",
		RejectedApplicantCount: "$rejectedApplicants",
	} }
])