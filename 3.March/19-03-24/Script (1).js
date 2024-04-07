//db.getCollection("JobSeekerProfileETL_Test").find({})

//db.JobSeekerProfileETL_Test.aggregate([
//  { $group: {
//      _id: "$ApplicantId",
//      count: { $sum: 1 } 
//    }
//  },
//  { $match: { count: { $gt: 1 } },
//  { $project: { _id: 1 } }
//])


db.JobSeekerProfileETL_Test.aggregate([
  { $group: {
		_id: "$ApplicantId",
    	count: { $sum: 1 }
	}},
  { $match: { count: { $gte: 1 } }},
  { $project: { _id: 1, count: 1 } }
])

