public with sharing class DataLord {
    public DataLord() {

    }
    
    //SOQL PROBLEMS

    public static Integer NumAccounts() {
        return [SELECT COUNT() FROM Account];
    }

    public static Integer NumHot() {
        return [SELECT COUNT() FROM Account WHERE rating = 'Hot'];
    }

    public static Integer NumComplex() {
        return [SELECT COUNT() FROM Account WHERE Name LIKE '*&*'];
    }

    public static List<Account> BigFive() {
        return [SELECT Name, AnnualRevenue FROM Account ORDER BY AnnualRevenue DESC NULLS LAST LIMIT 5];
    }

    public static List<Opportunity> LastBigOpportunity() {
        return [SELECT Name, CloseDate FROM Opportunity WHERE Amount > 100000 ORDER BY CloseDate DESC NULLS LAST LIMIT 1];
    }

    public static List<Contact> MajorPlayers() {
        return [SELECT Name, Account.Rating FROM Contact WHERE Account.Rating = 'Hot'];
    }

    public static List<AggregateResult> MostPopularAccount() {
        return [SELECT Contact.Account.Name, Count(Id) FROM Contact GROUP BY Contact.Account.Name ORDER BY Count(Id) DESC NULLS LAST LIMIT 1];
    }

    public static List<AggregateResult> LeadSources() {
        return [SELECT LeadSource FROM Lead WHERE LeadSource != '' AND Rating != '' AND Status = 'Working - Contacted' GROUP BY LeadSource, Rating ORDER BY RATING ASC NULLS LAST LIMIT 5];
    }

    //SOSL Problems

    public static List<List<SObject>> getAllContactsAndLeads() {
        return [FIND 'Tom' IN ALL FIELDS RETURNING Contact(Name), Lead(Name)];
    }

    public static List<List<SObject>> getAccountsWithAO() {
        return [FIND '*a* and *o*' IN ALL FIELDS RETURNING Account(Name)];
    }

    public static List<List<SObject>> get1000() {
        return [FIND '*100?' IN ALL FIELDS RETURNING Account(Name), Contact(Name), Lead(Name)];
    }

    //DML Problems

    public static void SpawnContacts() {
        List<Contact> conList = new List<Contact>();

        for(Integer i = 0; i < 200; i++) {
            String Name = 'Temp' + i;
            String LName = 'TempL' + i;
            Contact con = new Contact(FirstName=Name, LastName=LName);
            conList.add(con);
        }

        Database.insert(conList);
    }

    public static void CreateHomes() {
        List<Account> accList = new List<Account>();

        for(Integer i = 0; i < 3; i++) {
            Account acc = new Account();
            acc.Name = 'Temp' + i;
            accList.add(acc);
        }

        Database.insert(accList);
    }

    public static void Relocate() {
        
        List<Contact> conList = [SELECT Name, ID FROM Contact ORDER BY CreatedDate DESC NULLS LAST LIMIT 50];

        System.debug(conList);

        Database.delete(conList);
    }

    
}