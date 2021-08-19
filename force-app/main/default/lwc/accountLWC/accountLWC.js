import { LightningElement, track } from 'lwc';
import callGetAccount from '@salesforce/apex/AccountSearchService.callGetAccount';

export default class accountLWC extends LightningElement {

    @track accName = '';
    @track accountInfoObj;
    @track error;

    @track columns = [
        { label: 'Account Name', fieldName: 'name' },
        { label: 'Billing Country', fieldName: 'billingCountry' },
        { label: 'Number of Contacts', fieldName: 'numberOfContacts' },
        { label: 'Number of Open Opportunities', fieldName: 'numberOfOpportunities' }
    ];

    handleKeyChange(event) {
        this.accName = event.target.value;
    }

    handleSearch() {
        if (this.accName) {
            callGetAccount({ accName: this.accName })
                .then((result) => {
                    console.log('In then' + JSON.stringify(result))
                    this.accountInfoObj = result;
                    this.error = undefined;
                })
                .catch((error) => {
                    console.log('In catch' + JSON.stringify(error));
                    this.error = error;
                    this.accountInfoObj = undefined;
                });
        }
        else {
            alert('Please enter valid value.');
        }
    }

}