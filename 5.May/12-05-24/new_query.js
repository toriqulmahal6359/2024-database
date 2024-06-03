db.ApplicantHiringActivity.aggregate([
    
    { $match: { "JobInformations.JobId" : 1230305 } },      //1230305     1226863
    { $unwind: "$JobInformations" },
    { $facet: {
        allCount: [
            { $match: {
                "JobInformations.JobId": 1230305,
                "JobInformations.ApplicantProcessInformation.IsRejectedInCurrentStep" : false 
            } },
            { $group: {
                _id: "$JobInformations.JobId",
                count: { $sum: 1 }
            }}
        ],
        viewedCount: [
            { $match: {
                "JobInformations.JobId": 1230305,
                "JobInformations.ApplicantProcessInformation.IsRejectedInCurrentStep" : false,
                "JobInformations.IsViewedByCompany": true 
            } },
            { $group: {
                _id: "$JobInformations.JobId",
                count: { $sum: 1 }
            }}
        ],
        finalHiringCount: [
            { $unwind: "$JobInformations.HighestLevelStatus" },
            { $match: {
                "JobInformations.JobId": 1230305,
                "JobInformations.HighestLevelStatus" : 20,
                "JobInformations.IsApplicantHired": false
            } },
            { $group: {
                _id: "$JobInformations.HighestLevelStatus",
                count: { $sum: 1 }
            }}
        ],
        finalHiredCount: [
            { $unwind: "$JobInformations.HighestLevelStatus" },
            { $match: {
                "JobInformations.JobId": 1230305,
                "JobInformations.HighestLevelStatus" : 20,
                "JobInformations.IsApplicantHired": true
            } },
            { $group: {
                _id: "$JobInformations.HighestLevelStatus",
                count: { $sum: 1 }
            }}
        ],
        StaticActivities: [
            { $match: { "JobInformations.JobId": 1230305 } },
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
                    //totalApplicants: { $addToSet: "$ApplicantId" },
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
        ],
    TestTypewiseCount: [
        { $match: { "JobInformations.JobId": 1230305 } },
        { $unwind: "$JobInformations.ApplicantProcessInformation" },
        { $match: { "JobInformations.ApplicantProcessInformation.TestStepId" : { $exists: true } } },
        { $match: { "JobInformations.ApplicantProcessInformation.TestType": { $ne : "" } } },
        { $group: {
            _id: {
                TestType: "$JobInformations.ApplicantProcessInformation.TestType",
            },
            count: { $sum: 1 }
        }},
        { $project: {
            _id: 0,
            TestType: "$_id.TestType",
            Applicants: "$count"
        }}
    ] 
    }},
    { $project: {
        _id: 0,
        All: { $arrayElemAt: ["$allCount.count", 0] }, 
        Viewed: { $arrayElemAt: ["$viewedCount.count", 0] }, 
        FinalHiring: { $arrayElemAt: ["$finalHiringCount.count", 0] }, 
        FinalHired: { $arrayElemAt: ["$finalHiredCount.count", 0] },
        StaticActivities: 1,
        TestTypewiseCount: 1
    }},
    { $project: {
        StaticActivities: 1,
        TestTypewiseCount: 1,
        All: { $ifNull: ["$All", 0] }, 
        Viewed: { $ifNull: ["$Viewed", 0] }, 
        FinalHiring: { $ifNull: ["$FinalHiring", 0] }, 
        FinalHired: { $ifNull: ["$FinalHired", 0] }
    }}
])