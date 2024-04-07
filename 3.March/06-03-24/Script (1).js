db.GatewayCollection.updateMany({}, [
    {
        $set: {
            "ServiceType": {
                $cond: {
                    if: { $eq: ["$ServiceType", "Basic"] }, then: "Standard Listing",
                    else: {$cond: {
                         if: { $eq: ["$ServiceType", "Standout"] }, then: "Premium Listing",
                         else: {$cond: {
                             if: { $eq: ["$ServiceType", "Standout Premium"] }, then: "Premium Plus",
                             else: {$cond: {
                                 if: { $eq: ["$ServiceType", "Uddokta"] }, then: "SME Package",
                                 else: {$cond: {
                                     if: { $eq: ["$ServiceType", "Free"] }, then: "Free Listing",
                                     }
  }}}}}}}}}}}
])