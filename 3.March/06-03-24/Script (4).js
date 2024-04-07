const options = {
    new: true,
    runValidators: true,
    useFindAndModify: false,
    context: 'query'
}

db.testbyAzhar.updateMany(
   { JobId: { $eq: 1124539 } },
   [
     {
       $addFields: {
         "ServiceType": {
           $switch: {
             branches: [
               { case: { $eq: ["$ServiceType", "Basic"] }, then: "Standard Listing" },
               { case: { $eq: ["$ServiceType", "Standout"] }, then: "Premium Listing" },
               { case: { $eq: ["$ServiceType", "Standout Premium"] }, then: "Premium Plus" },
               { case: { $eq: ["$ServiceType", "Uddokta"] }, then: "SME Package" },
               { case: { $eq: ["$ServiceType", "Free"] }, then: "Free listing" },
             ],
             default: "$ServiceType" // If none of the cases match, keep original value
           }
         }
       }
     }
   ], options
)

