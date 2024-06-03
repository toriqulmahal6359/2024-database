db.ApplicantHiringActivity.aggregate([
    
    { $match: { "JobInformations.JobId" : 1226863 } },      //1230305     1226863
    { $unwind: "$JobInformations" },
    { $facet: {
        allCount: [
            { $match: {
                "JobInformations.JobId": 1226863,
                "JobInformations.ApplicantProcessInformation.IsRejectedInCurrentStep" : false 
            } },
            { $group: {
                _id: "$JobInformations.JobId",
                count: { $sum: 1 }
            }}
        ],
        viewedCount: [
            { $match: {
                "JobInformations.JobId": 1226863,
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
                "JobInformations.JobId": 1226863,
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
                "JobInformations.JobId": 1226863,
                "JobInformations.HighestLevelStatus" : 20,
                "JobInformations.IsApplicantHired": true
            } },
            { $group: {
                _id: "$JobInformations.HighestLevelStatus",
                count: { $sum: 1 }
            }}
        ]
    }},
    { $project: {
        _id: 0,
        All: { $arrayElemAt: ["$allCount.count", 0] }, 
        Viewed: { $arrayElemAt: ["$viewedCount.count", 0] }, 
        FinalHiring: { $arrayElemAt: ["$finalHiringCount.count", 0] }, 
        FinalHired: { $arrayElemAt: ["$finalHiredCount.count", 0] },

    }},
    { $project: {
        All: { $ifNull: ["$All", 0] }, 
        Viewed: { $ifNull: ["$Viewed", 0] }, 
        FinalHiring: { $ifNull: ["$FinalHiring", 0] }, 
        FinalHired: { $ifNull: ["$FinalHired", 0] },
    }}
])