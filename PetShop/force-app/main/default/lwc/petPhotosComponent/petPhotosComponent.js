import { LightningElement, wire, api } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import getPictures from '@salesforce/apex/PetPhotosController.getPictures';

import NAME_FIELD from '@salesforce/schema/Pet__c.Name';

const FIELDS = [NAME_FIELD];

export default class PetPhotosComponent extends LightningElement {
    @api recordId;

    urls;

    pictures;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    property;

    @wire(getPictures, { propertyId: '$recordId' })
    wiredPictures(pictures) {
        this.pictures = pictures;
        if (pictures.data) {
            const files = pictures.data;
            if (Array.isArray(files) && files.length) {
                this.urls = files.map(
                    (file) =>
                        '/sfc/servlet.shepherd/version/download/' + file.Id
                );
            } else {
                this.urls = null;
            }
        }
    }

}