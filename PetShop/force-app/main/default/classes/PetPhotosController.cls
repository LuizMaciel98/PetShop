public class PetPhotosController {

    @AuraEnabled(cacheable=false)
    public static List<ContentDocumentLink> getFiles(String petId){

        System.debug(petId);

        List<ContentDocumentLink> result = new List<ContentDocumentLink>();
        
        result = [SELECT Id
            ,ContentDocumentId
            ,ContentDocument.LatestPublishedVersionId
            ,ContentDocument.LatestPublishedVersion.Title 
        FROM ContentDocumentLink 
        WHERE LinkedEntityId =: petId];

        return result;
    }

    @AuraEnabled(cacheable=true)
    public static List<ContentVersion> getPictures(Id propertyId) {
        List<ContentDocumentLink> links = [
            SELECT Id, LinkedEntityId, ContentDocumentId
            FROM ContentDocumentLink
            WHERE
                LinkedEntityId = :propertyId
                AND ContentDocument.FileType IN ('PNG', 'JPG', 'GIF')
            WITH SECURITY_ENFORCED
        ];

        if (links.isEmpty()) {
            return null;
        }

        Set<Id> contentIds = new Set<Id>();

        for (ContentDocumentLink link : links) {
            contentIds.add(link.ContentDocumentId);
        }

        return [
            SELECT Id, Title
            FROM ContentVersion
            WHERE ContentDocumentId IN :contentIds AND IsLatest = TRUE
            WITH SECURITY_ENFORCED
            ORDER BY CreatedDate
        ];
    }
}