global class AniversarioAdocaoSchedule implements Schedulable{
    global void execute(SchedulableContext ctx) {
        List<Adocao__c> lAdocao = [SELECT Id, Data__c, Contato__c, Contato__r.OwnerId, Contato__r.Name, Pet__c, Pet__r.Name FROM Adocao__c WHERE AniversarioAdocao__c = true];
        List<Task> lTarefas = new List<Task>();

        if(lAdocao.size() > 0){
            for(Adocao__c i : lAdocao){
                Task tarefa = new Task();
                tarefa.Status = 'Não iniciado';
                tarefa.Subject = 'Aniversário de adoção';
                tarefa.Priority = 'Baixa';
                tarefa.WhatId = i.Id;
                tarefa.OwnerId = i.Contato__r.OwnerId;
                tarefa.Description = 'Envie os parabéns pelo aniversário de adoção do pet ' + i.Pet__r.Name + ' ao dono ' + i.Contato__r.Name;
                tarefa.ActivityDate = getDataVencimento();

                lTarefas.add(tarefa);
            }
        }

        if(lTarefas.size() > 0)
            insert lTarefas;
    }

    private Date getDataVencimento(){
        Date result = System.today();

        return result;
    }
}