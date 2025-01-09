public with sharing class DataLord {
    public DataLord() {

    }

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

    public static List<Lead> LeadSources() {
        return [SELECT Contact.Account.Name, Count(Id) FROM Contact GROUP BY Contact.Account.Name ORDER BY Count(Id) DESC NULLS LAST LIMIT 1];
    }
}