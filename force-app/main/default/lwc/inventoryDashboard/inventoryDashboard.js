import { LightningElement, wire, track } from 'lwc';
import getItemTypeDetails from '@salesforce/apex/InventoryDashboardController.getItemTypeDetails';

const columns = [
    { label: 'Item Type', fieldName: 'itemTypeName', type: 'text', cellAttributes: { alignment: 'left' } },
    { label: 'Total Number', fieldName: 'totalCount', type: 'number', cellAttributes: { alignment: 'left' } },
    { label: 'Available Numbers', fieldName: 'availableCount', type: 'number', cellAttributes: { alignment: 'left' } },
    { label: 'Assigned Numbers', fieldName: 'assignedCount', type: 'number', cellAttributes: { alignment: 'left' } }
];

export default class InventoryDashboard extends LightningElement {
    @track data = [];
    columns = columns;

    @wire(getItemTypeDetails)
    wiredItemTypeDetails({ error, data }) {
        if (data) {
            this.data = data;
        } else if (error) {
            console.error(error);
        }
    }
}