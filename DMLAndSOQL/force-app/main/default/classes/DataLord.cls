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
        return [SELECT COUNT() FROM Account WHERE Name LIKE '%&%'];
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

    public static void SpawnContacts() { //Certain matching rules preventing certain entries even though names are unique.
        List<Contact> conList = new List<Contact>();

        List<Contact> currentList = [SELECT FirstName, LastName FROM Contact];

        Integer targetSize = currentList.size() + 200;

        for(Integer i = 0; conList.size() < 200; i++) {
            Boolean unique = true;
            String Name = 'Temp' + i;
            String LName = 'TempL' + i;
            for(Integer j = 0; j < currentList.size(); j++) {
                if(Name.equals(currentList[j].FirstName) || LName.equals(currentList[j].LastName)) {
                    unique = false;
                    break;
                }
            }
            if(unique) {
                Contact con = new Contact(FirstName=Name, LastName=LName);
                conList.add(con);
            }
        }
        Database.insert(conList);
    }

    public static void CreateHomes() {
        List<Account> accList = new List<Account>();

        List<Account> currentList = [SELECT Name FROM Account];

        Integer targetSize = currentList.size() + 3;

        for(Integer i = 0; accList.size() < 3; i++) {
            Boolean unique = true;
            Account acc = new Account();
            acc.Name = 'Temp' + i;
            for(Integer j = 0; j < currentList.size(); j++) {
                // System.debug(acc.Name + ' = ' + currentList[j].Name);
                // System.debug(acc.Name.equals(currentList[j].Name));
                if(acc.Name.equals(currentList[j].Name)) {
                    unique = false;
                    break;
                }
            }
            if(unique) {
                accList.add(acc);
            }
        }

        Database.insert(accList);
    }

    public static void Relocate() {
        
        List<Contact> conList = [SELECT Name, ID FROM Contact ORDER BY CreatedDate DESC NULLS LAST LIMIT 50];

        System.debug(conList);

        Database.delete(conList);
    }

    public static void AssignHomes() {
        List<Contact> conList = [SELECT Name, Id FROM Contact WHERE Name LIKE 'Temp%'];

        List<Account> accList = [SELECT Name, Id FROM Account WHERE Name LIKE 'Temp%'];
        for(Integer i = 0; i < conList.size(); i++) {
            Double rand = math.random();
            if(rand <= .33) {
                conList[i].AccountId = accList[0].Id;
            }
            if(rand > .33 && rand < .67) {
                conList[i].AccountId = accList[1].Id;
            }
            if(rand >= .67) {
                conList[i].AccountId = accList[2].Id;
            }
        }
        update conList;
    }

    public static void Play() {
        SavePoint sp1 = Database.setSavepoint();

        System.debug('Number of Accounts before DML: ' + [SELECT COUNT(Id) FROM Account]);
        System.debug('Number of Contacts before DML: ' + [SELECT COUNT(Id) FROM Contact]);

        SpawnContacts();
        CreateHomes();
        Relocate();
        AssignHomes();

        System.debug('Number of Accounts after DML: ' + [SELECT COUNT(Id) FROM Account]);
        System.debug('Number of Contacts after DML: ' + [SELECT COUNT(Id) FROM Contact]);
        System.debug([SELECT Contact.Account.Name, Count(Id) FROM Contact GROUP BY Contact.Account.Name ORDER BY Count(Id) DESC NULLS LAST]);

        Database.rollback(sp1);
    }
    
}