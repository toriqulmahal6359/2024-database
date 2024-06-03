[
    { "$match": { "JobInformations.JobId": 1230305 } },
    { "$unwind": "$JobInformations" },
    { "$unwind": "$JobInformations.HighestLevelStatus" },
    {
      "$facet": {
        "finalHiredTrue20": [
          {
            "$match": {
              "JobInformations.IsApplicantHired": true,
              "JobInformations.HighestLevelStatus": 20
            }
          },
          {
            "$group": {
              "_id": "$JobInformations.HighestLevelStatus",
              "count": { "$sum": 1 }
            }
          }
        ],
        "finalHiredFalse20": [
          {
            "$match": {
              "JobInformations.IsApplicantHired": false,
              "JobInformations.HighestLevelStatus": 20
            }
          },
          {
            "$group": {
              "_id": "$JobInformations.HighestLevelStatus",
              "count": { "$sum": 1 }
            }
          }
        ],
        "allCount": [
          {
            "$match": {
              "JobInformations.JobId": 1230305,
              "JobInformations.ApplicantProcessInformation.IsRejectedInCurrentStep": false
            }
          },
          {
            "$group": {
              "_id": "$JobInformations.JobId",
              "count": { "$sum": 1 }
            }
          }
        ],
        "viewedCount": [
          {
            "$match": {
            //   "$and": [
            //     { "JobInformations.JobId": 1230305 },
            //     { "JobInformations.ApplicantProcessInformation.IsRejectedInCurrentStep": false },
            //     { "JobInformations.IsViewedByCompany": true }
            //   ]
            "JobInformations.JobId": 1230305 ,
            "JobInformations.ApplicantProcessInformation.IsRejectedInCurrentStep": false ,
            "JobInformations.IsViewedByCompany": true
            }
          },
          {
            "$group": {
              "_id": "$JobInformations.JobId",
              "count": { "$sum": 1 }
            }
          }
        ]
      }
    },
    {
      "$project": {
        "allCount": { "$arrayElemAt": ["$allCount.count", 0] },
        "viewedCount": { "$arrayElemAt": ["$viewedCount.count", 0] },
        "FinalHiring": { "$arrayElemAt": ["$finalHiredFalse20.count", 0] },
        "FinalHired": { "$arrayElemAt": ["$finalHiredTrue20.count", 0] },
      }
    }
  ]
  