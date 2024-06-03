db.ApplicantHiringActivity.aggregate([
    { $match: { "JobInformations.JobId" : 1230305} },
    { $unwind: "$JobInformations" },
    { $match: { "JobInformations.JobId" : 1230305} },
    {
        $group : {
            _id: "$JobInformations.JobId",
            levelStatus: {
                $sum: {
                    $cond: [
                        { $eq: ["$JobInformations.HighestLevelStatus", 20] },
                        1,
                        0
                ]}
            }
        }},
    { $project: {
        _id: 0,
        count: "$levelStatus"
    }}
])