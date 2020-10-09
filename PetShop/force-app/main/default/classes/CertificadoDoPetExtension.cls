public class CertificadoDoPetExtension {
    
    private Pet__c pet;

    public Boolean temFotos {get;set;}

    public CertificadoDoPetExtension(ApexPages.StandardController standardPageController) {
		pet = (Pet__c)standardPageController.getRecord();
	}

    public PageReference attachPDF() {
        pet = getPetValues(pet);
        
        PageReference pdfPage =  Page.PDFCertificado;
        pdfPage.getParameters().put('Id',pet.Id);
        Blob pdfBlob;
        if (!Test.isRunningTest()) {
            pdfBlob = pdfPage.getContent();
        } else {
            pdfBlob = Blob.valueOf('Some Text for a boring PDF file...');
        }
        
        Attachment attach = new Attachment(parentId = pet.Id, Name = 'CertificadoPet.pdf', body = pdfBlob, ContentType='application/pdf');
		insert attach;
        
        PageReference pageWhereWeWantToGo = new ApexPages.StandardController(pet).view();
        pageWhereWeWantToGo.setRedirect(true);
        return pageWhereWeWantToGo;
    }


    public PageReference loadInfo(){
        temFotos = false;
        List<ContentDocumentLink> files = PetPhotosController.getFiles(pet.Id);

        if(files.size() > 0)
            temFotos = true;
        
        return null;
    }
    
    
    private static Pet__c getPetValues(Pet__c pet){
        Pet__c result = new Pet__c();
        if(pet != null && pet.Id != null){
            result = [SELECT Id, Name, Raca__c, Especie__c FROM Pet__c WHERE Id =: pet.Id];
        }
        return result;
    }
    
}