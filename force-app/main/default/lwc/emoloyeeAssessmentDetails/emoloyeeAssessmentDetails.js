import { LightningElement, wire, track } from 'lwc';
import getEmployeeAssessmentDetails from '@salesforce/apex/EmployeeAssessmentDetailsController.getEmployeeAssessmentDetails';

const columns = [
    { label: 'Employee Name', fieldName: 'employeeName', type: 'text' },
    { label: 'Assigned Item', fieldName: 'assignedItem', type: 'text' },
    { label: 'Item Type', fieldName: 'itemType', type: 'text' }, // Added comma here
    { label: 'Equipment Number', fieldName: 'equipmentNumber', type: 'text' }
];

export default class EmployeeAssessmentDetails extends LightningElement {
    @track data = [];
    @track filteredData = [];
    columns = columns;
    searchKey = '';

    @wire(getEmployeeAssessmentDetails)
    wiredEmployeeAssessmentDetails({ error, data }) {
        if (data) {
            // Sort the data by employeeName in alphabetical order (A-Z)
            let sortedData = [...data].sort((a, b) => {
                let nameA = a.employeeName.toUpperCase(); // ignore upper and lowercase
                let nameB = b.employeeName.toUpperCase(); // ignore upper and lowercase
                if (nameA < nameB) {
                    return -1;
                }
                if (nameA > nameB) {
                    return 1;
                }
                // names must be equal
                return 0;
            });
            this.data = sortedData;
            this.filteredData = sortedData; // Initialize filteredData with sortedData
        } else if (error) {
            console.error(error);
        }
    }

    handleSearchChange(event) {
        this.searchKey = event.target.value.toLowerCase();
        this.handleSearch();
    }

    handleSearch() {
        if (this.searchKey) {
            this.filteredData = this.data.filter(item =>
                item.employeeName.toLowerCase().includes(this.searchKey)
            );
        } else {
            this.filteredData = this.data;
        }
    }
}
