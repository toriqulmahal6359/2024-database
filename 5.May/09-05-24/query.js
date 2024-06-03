db.ApplicantHiringActivity.aggregate([
    { $match: { "JobInformations.JobId" : 1230305 } },
    { $unwind: "$JobInformations" },
    { $match: { "JobInformations.JobId": 1230305 } },
    { $unwind: "$JobInformations.ApplicantProcessInformation" },
    { $unwind: "$JobInformations.HighestLevelStatus" },
    { $group: { 
        _id: {
            JobId: "$JobInformations.JobId"
        },
        allCount: {
            $sum: { $cond: [
                { $and: [
                    //{ $eq: ["$JobInformations.JobId", 123035] },
                    { $eq: ["$JobInformations.ApplicantProcessInformation.IsRejectedInCurrentStep", false] } 
                ]}
                , 1, 0 
            ]}
        },
        viewedCount: {
            $sum: { $cond: [
                { $and: [
                    //{ $eq: ["$JobInformations.JobId", 123035] },
                    { $eq: ["$JobInformations.ApplicantProcessInformation.IsRejectedInCurrentStep", false] } ,
                    { $eq: ["$JobInformations.IsViewedByCompany", true]}
                ] }
                , 1, 0
            ]}
        },
    }},
    { $match: { "JobInformations.JobId" : 1230305 } },
    { $unwind: "$JobInformations" },
    { $unwind: "$JobInformations.HighestLevelStatus" },
    {
        $match: {
            "JobInformations.IsApplicantHired": false,
            "JobInformations.HighestLevelStatus": 20
        }
    },
    { $group: {
        _id: "$JobInformations.HighestLevelStatus",
        finalHiringCount: { $sum: 1 }
    }},
    { $match: { "JobInformations.JobId" : 1230305 } },
    { $unwind: "$JobInformations" },
    { $unwind: "$JobInformations.HighestLevelStatus" },
    {
        $match: {
            "JobInformations.IsApplicantHired": true,
            "JobInformations.HighestLevelStatus": 20
        }
    },
    { $group: {
        _id: "$JobInformations.HighestLevelStatus",
        finalHiredCount: { $sum: 1 }
    }},
    { $project: {
        _id: 0,
        All: "$allCount",
        Viewed: "$viewedCount",
        FinalHiring: "$finalHiringCount",
        FinalHired: "$finalHiredCount",
    }}
])