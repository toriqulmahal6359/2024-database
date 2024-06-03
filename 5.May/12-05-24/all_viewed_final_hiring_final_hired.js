db.ApplicantHiringActivity.aggregate([
    { $match: { "JobInformations.JobId" : 1226863 } },              //1226863   1230305
    { $unwind: "$JobInformations" },
    { $match: { "JobInformations.JobId": 1226863 } },
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
        // viewedCount: {
        //     $sum: { $cond: [
        //         { $and: [
        //             //{ $eq: ["$JobInformations.JobId", 123035] },
        //             { $eq: ["$JobInformations.ApplicantProcessInformation.IsRejectedInCurrentStep", false] } ,
        //             { $eq: ["$JobInformations.IsViewedByCompany", true]}
        //         ] }
        //         , 1, 0
        //     ]}
        // },
        // finalHiringCount: {
        //     $sum: { $cond: [
        //         { $and: [
        //             //{ $eq: ["$JobInformations.JobId", 123035] },
        //             { $eq: ["$JobInformations.IsApplicantHired", false] },
        //             { $eq: ["$JobInformations.HighestLevelStatus", 20] },
        //         ] }
        //         , 1, 0
        //     ]}
        // },
        // finalHiredCount: {
        //     $sum: { $cond: [
        //         { $and: [
        //             //{ $eq: ["$JobInformations.JobId", 123035] },
        //             { $eq: ["$JobInformations.IsApplicantHired", true] },
        //             { $eq: ["$JobInformations.HighestLevelStatus", 20] }
        //         ] }
        //         , 1, 0
        //     ]}
        // },
    }},
    { $project: {
        _id: 0,
        All: "$allCount",
        // Viewed: "$viewedCount",
        // FinalHiring: "$finalHiringCount",
        // FinalHired: "$finalHiredCount",
    }}
])