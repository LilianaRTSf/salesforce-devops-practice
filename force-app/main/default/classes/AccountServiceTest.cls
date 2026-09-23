/**
 * Test class for AccountService
 * Demonstrates best practices for Apex testing
 */
@IsTest
private class AccountServiceTest {

    @TestSetup
    static void setupTestData() {
        List<Account> accounts = new List<Account>();

        accounts.add(new Account(
            Name = 'Tech Corp',
            Industry = 'Technology',
            AnnualRevenue = 1000000
        ));

        accounts.add(new Account(
            Name = 'Finance Inc',
            Industry = 'Banking',
            AnnualRevenue = 2000000
        ));

        accounts.add(new Account(
            Name = 'Tech Solutions',
            Industry = 'Technology',
            AnnualRevenue = 500000
        ));

        insert accounts;
    }

    @IsTest
    static void testGetAccountsByIndustry_Success() {
        Test.startTest();
        List<Account> accounts = AccountService.getAccountsByIndustry('Technology');
        Test.stopTest();

        Assert.areEqual(2, accounts.size(), 'Should return 2 technology accounts');
        Assert.areEqual('Tech Corp', accounts[0].Name, 'First account should be Tech Corp');
    }

    @IsTest
    static void testGetAccountsByIndustry_NoResults() {
        Test.startTest();
        List<Account> accounts = AccountService.getAccountsByIndustry('Healthcare');
        Test.stopTest();

        Assert.areEqual(0, accounts.size(), 'Should return no accounts');
    }

    @IsTest
    static void testGetAccountsByIndustry_BlankIndustry() {
        Test.startTest();
        try {
            AccountService.getAccountsByIndustry('');
            Assert.fail('Should have thrown IllegalArgumentException');
        } catch (IllegalArgumentException e) {
            Assert.isTrue(e.getMessage().contains('cannot be blank'), 'Error message should mention blank value');
        }
        Test.stopTest();
    }

    @IsTest
    static void testUpdateAccountRevenue_Success() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Tech Corp' LIMIT 1];

        Test.startTest();
        AccountService.updateAccountRevenue(acc.Id, 1500000);
        Test.stopTest();

        Account updatedAcc = [SELECT AnnualRevenue FROM Account WHERE Id = :acc.Id];
        Assert.areEqual(1500000, updatedAcc.AnnualRevenue, 'Revenue should be updated');
    }

    @IsTest
    static void testUpdateAccountRevenue_NullId() {
        Test.startTest();
        try {
            AccountService.updateAccountRevenue(null, 1000000);
            Assert.fail('Should have thrown IllegalArgumentException');
        } catch (IllegalArgumentException e) {
            Assert.isTrue(e.getMessage().contains('cannot be null'), 'Error message should mention null ID');
        }
        Test.stopTest();
    }

    @IsTest
    static void testUpdateAccountRevenue_NegativeRevenue() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Tech Corp' LIMIT 1];

        Test.startTest();
        try {
            AccountService.updateAccountRevenue(acc.Id, -1000);
            Assert.fail('Should have thrown IllegalArgumentException');
        } catch (IllegalArgumentException e) {
            Assert.isTrue(e.getMessage().contains('cannot be negative'), 'Error message should mention negative value');
        }
        Test.stopTest();
    }

    @IsTest
    static void testGetTotalRevenueByIndustry_Success() {
        Test.startTest();
        Decimal totalRevenue = AccountService.getTotalRevenueByIndustry('Technology');
        Test.stopTest();

        Assert.areEqual(1500000, totalRevenue, 'Total revenue should be 1,500,000');
    }

    @IsTest
    static void testGetTotalRevenueByIndustry_NoResults() {
        Test.startTest();
        Decimal totalRevenue = AccountService.getTotalRevenueByIndustry('Healthcare');
        Test.stopTest();

        Assert.areEqual(0, totalRevenue, 'Total revenue should be 0');
    }

    @IsTest
    static void testGetTotalRevenueByIndustry_BlankIndustry() {
        Test.startTest();
        Decimal totalRevenue = AccountService.getTotalRevenueByIndustry('');
        Test.stopTest();

        Assert.areEqual(0, totalRevenue, 'Total revenue should be 0 for blank industry');
    }
}
