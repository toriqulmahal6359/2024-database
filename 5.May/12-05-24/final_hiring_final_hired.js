db.ApplicantHiringActivity.aggregate([
    { $match: { "JobInformations.JobId" : 1230305 } },
    { $unwind: "$JobInformations" },
    { $unwind: "JobInformations.HighestLevelStatus"},
    { $match: {
        "JobInformations.IsApplicantHired": true,
        "JobInformations.HighestLevelStatus": 20
    }}
    { $group: {
        _id: "JobInformations.HighestLevelStatus",
        finalCount: { $sum: }
    }}
])