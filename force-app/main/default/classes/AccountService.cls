/**
 * Service class for Account operations
 * Demonstrates best practices for Apex development
 */
public with sharing class AccountService {

    /**
     * Get accounts by industry
     * @param industry The industry to filter by
     * @return List of matching accounts
     */
    public static List<Account> getAccountsByIndustry(String industry) {
        if (String.isBlank(industry)) {
            throw new IllegalArgumentException('Industry cannot be blank');
        }

        return [
            SELECT Id, Name, Industry, AnnualRevenue, NumberOfEmployees
            FROM Account
            WHERE Industry = :industry
            WITH SECURITY_ENFORCED
            ORDER BY Name
            LIMIT 100
        ];
    }

    /**
     * Update account annual revenue
     * @param accountId The account ID to update
     * @param newRevenue The new annual revenue
     */
    public static void updateAccountRevenue(Id accountId, Decimal newRevenue) {
        if (accountId == null) {
            throw new IllegalArgumentException('Account ID cannot be null');
        }

        if (newRevenue < 0) {
            throw new IllegalArgumentException('Revenue cannot be negative');
        }

        Account acc = new Account(
            Id = accountId,
            AnnualRevenue = newRevenue
        );

        update acc;
    }

    /**
     * Get total revenue by industry
     * @param industry The industry to aggregate
     * @return Total annual revenue for the industry
     */
    public static Decimal getTotalRevenueByIndustry(String industry) {
        if (String.isBlank(industry)) {
            return 0;
        }

        AggregateResult[] results = [
            SELECT SUM(AnnualRevenue) totalRevenue
            FROM Account
            WHERE Industry = :industry
            AND AnnualRevenue != null
            WITH SECURITY_ENFORCED
        ];

        Decimal totalRevenue = (Decimal) results[0].get('totalRevenue');
        return totalRevenue != null ? totalRevenue : 0;
    }
}
