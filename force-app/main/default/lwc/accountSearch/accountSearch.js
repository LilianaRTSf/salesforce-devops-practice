import { LightningElement, track } from 'lwc';
import getAccountsByIndustry from '@salesforce/apex/AccountService.getAccountsByIndustry';

export default class AccountSearch extends LightningElement {
    @track accounts = [];
    @track error;
    @track isLoading = false;
    selectedIndustry = '';

    industryOptions = [
        { label: 'Technology', value: 'Technology' },
        { label: 'Banking', value: 'Banking' },
        { label: 'Healthcare', value: 'Healthcare' },
        { label: 'Manufacturing', value: 'Manufacturing' },
        { label: 'Retail', value: 'Retail' }
    ];

    columns = [
        { label: 'Account Name', fieldName: 'Name', type: 'text' },
        { label: 'Industry', fieldName: 'Industry', type: 'text' },
        { label: 'Annual Revenue', fieldName: 'AnnualRevenue', type: 'currency' },
        { label: 'Employees', fieldName: 'NumberOfEmployees', type: 'number' }
    ];

    handleIndustryChange(event) {
        this.selectedIndustry = event.detail.value;
    }

    handleSearch() {
        if (!this.selectedIndustry) {
            this.error = 'Please select an industry';
            return;
        }

        this.isLoading = true;
        this.error = undefined;

        getAccountsByIndustry({ industry: this.selectedIndustry })
            .then(result => {
                this.accounts = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error.body.message;
                this.accounts = [];
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    get hasAccounts() {
        return this.accounts.length > 0;
    }
}
