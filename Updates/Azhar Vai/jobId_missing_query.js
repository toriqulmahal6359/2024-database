var targetIds = [306258754, 302569874, 305745896, 302569874, 305896325, 306589547, 308955896, 307859652, 301147852];

// Find IDs that are not in the database
var missingIds = targetIds.filter(function(searchId) {
    return db.getCollection("GatewayCollection").countDocuments({ "JobId": searchId }) === 0;
});

// Print missing IDs using forEach
missingIds.forEach(function(id) {
    print(id);
});
