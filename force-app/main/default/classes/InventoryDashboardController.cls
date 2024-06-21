public with sharing class InventoryDashboardController {
    @AuraEnabled(cacheable=true)
    public static List<ItemTypeDetail> getItemTypeDetails() {
        List<ItemTypeDetail> details = new List<ItemTypeDetail>();

        // Query total number of items per type
        AggregateResult[] totalResults = [
            SELECT ItemType__r.Name itemTypeName, COUNT(Id) itemCount
            FROM InventoryItem__c
            GROUP BY ItemType__r.Name
        ];
        
        // Query available number of items per type
        AggregateResult[] availableResults = [
            SELECT ItemType__r.Name itemTypeName, COUNT(Id) itemCount
            FROM InventoryItem__c
            WHERE Status__c = 'Available'
            GROUP BY ItemType__r.Name
        ];

        // Query assigned number of items per type
        AggregateResult[] assignedResults = [
            SELECT ItemType__r.Name itemTypeName, COUNT(Id) itemCount
            FROM InventoryItem__c
            WHERE Status__c = 'Assigned'
            GROUP BY ItemType__r.Name
        ];

        // Create a map for easier aggregation
        Map<String, ItemTypeDetail> itemTypeMap = new Map<String, ItemTypeDetail>();

        for (AggregateResult ar : totalResults) {
            String itemTypeName = (String) ar.get('itemTypeName');
            Integer itemCount = ((Decimal) ar.get('itemCount')).intValue();
            itemTypeMap.put(itemTypeName, new ItemTypeDetail(itemTypeName, itemCount, 0, 0));
        }

        for (AggregateResult ar : availableResults) {
            String itemTypeName = (String) ar.get('itemTypeName');
            Integer itemCount = ((Decimal) ar.get('itemCount')).intValue();
            if (itemTypeMap.containsKey(itemTypeName)) {
                itemTypeMap.get(itemTypeName).availableCount = itemCount;
            }
        }

        for (AggregateResult ar : assignedResults) {
            String itemTypeName = (String) ar.get('itemTypeName');
            Integer itemCount = ((Decimal) ar.get('itemCount')).intValue();
            if (itemTypeMap.containsKey(itemTypeName)) {
                itemTypeMap.get(itemTypeName).assignedCount = itemCount;
            }
        }

        details.addAll(itemTypeMap.values());

        return details;
    }

    public class ItemTypeDetail {
        @AuraEnabled public String itemTypeName;
        @AuraEnabled public Integer totalCount;
        @AuraEnabled public Integer availableCount;
        @AuraEnabled public Integer assignedCount;

        public ItemTypeDetail(String itemTypeName, Integer totalCount, Integer availableCount, Integer assignedCount) {
            this.itemTypeName = itemTypeName;
            this.totalCount = totalCount;
            this.availableCount = availableCount;
            this.assignedCount = assignedCount;
        }
    }
}