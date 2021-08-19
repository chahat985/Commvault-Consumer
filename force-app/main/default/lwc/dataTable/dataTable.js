import { LightningElement, api } from 'lwc';

export default class DataTable extends LightningElement {

    @api title;
    @api id;
    @api records;
    @api columns;

}