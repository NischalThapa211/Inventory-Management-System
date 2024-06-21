public with sharing class EmployeeAssessmentdetailsController {
    
    @AuraEnabled(cacheable=true)
    public static List<EmployeeAssessmentWrapper> getEmployeeAssessmentDetails() {
        // Query to get assigned inventory details along with employee, inventory item names, and item type
        List<Assign_Inventory__c> assignedInventories = [
            SELECT Employee__r.Name, InventoryItem__r.Name, InventoryItem__r.ItemType__r.Name, InventoryItem__r.Equipment_Number__c
            FROM Assign_Inventory__c
        ];

        // Prepare the list of wrapper objects
        List<EmployeeAssessmentWrapper> assessmentDetails = new List<EmployeeAssessmentWrapper>();
        for (Assign_Inventory__c assign : assignedInventories) {
            assessmentDetails.add(new EmployeeAssessmentWrapper(
                assign.Employee__r.Name, 
                assign.InventoryItem__r.Name,
                assign.InventoryItem__r.ItemType__r.Name,
                assign.InventoryItem__r.Equipment_Number__c
            ));
        }
        return assessmentDetails;
    }

    // Wrapper class to hold employee name, assigned item name, item type, and equipment number
    public class EmployeeAssessmentWrapper {
        @AuraEnabled public String employeeName;
        @AuraEnabled public String assignedItem;
        @AuraEnabled public String itemType;
        @AuraEnabled public String equipmentNumber;

        public EmployeeAssessmentWrapper(String employeeName, String assignedItem, String itemType, String equipmentNumber) {
            this.employeeName = employeeName;
            this.assignedItem = assignedItem;
            this.itemType = itemType;
            this.equipmentNumber = equipmentNumber;
        }
    }
}
