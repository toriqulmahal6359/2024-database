db.testbyAzhar.bulkWrite({}, [
    {
        $set: {
            "ServiceType": {
                $cond: {
                    if: { $eq: [ "$ServiceType", "Basic" ] }, then: "Standard Listing",
                    else: {$cond: {
                         if: { $eq: [ "$ServiceType", "Standout"] }, then: "Premium Listing",
                         else: {$cond: {
                             if: { $eq: [ "$ServiceType", "Standout Premium" ] }, then: "Premium Plus",
                             else: {$cond: {
                                 if: { $eq: [ "$ServiceType", "Uddokta" ] }, then: "SME Package",
                                 else: "Free Listing"
  }}}}}}}}}}
])