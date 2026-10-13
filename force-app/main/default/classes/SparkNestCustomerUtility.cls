public with sharing class SparkNestCustomerUtility {
    public SparkNestCustomerUtility() {

    }
    public static void processCustomerData() {

        String companyName = 'SparkNest';
        Integer totalEnquiries = 5;
        Boolean hasDuplicateCustomer = true;

        System.debug('Company Name: ' + companyName);
        System.debug('Total Enquiries: ' + totalEnquiries);
        System.debug('Has Duplicate Customer: ' + hasDuplicateCustomer);

        List<String> customerNames = new List<String>{ 
        'Rahul Sharma', 
        'Aman Verma','Priya Singh',
        'Neha Kapoor','Rahul Sharma'
        };

        System.debug('Customer Names: ' + customerNames);

        System.debug('=== Individual Customers ===');
        for (String customerName : customerNames) {
            System.debug('Customer: ' + customerName);
        }

        Set<String> customerEmails = new Set<String>{
            'rahul@gmail.com',
            'aman@gmail.com',
            'priya@gmail.com',
            'rahul@gmail.com',
            'neha@gmail.com'
        };

        Map<Integer, String> storeMap = new Map<Integer, String>();
        storeMap.put(101, 'Hyderabad');
        storeMap.put(102, 'Bengaluru');
        storeMap.put(103, 'Mumbai');
        String storeCity = storeMap.get(102);
        System.debug('City for Store ID 102: ' +storeCity);




        Map<String, Decimal> productPrices = new Map<String, Decimal>();
        productPrices.put('SparkNest Phone X1', 45000);
        productPrices.put('SparkNest Smart Speaker', 8000);
        productPrices.put('SparkNest Laptop Pro', 75000);

        Decimal laptopPrice = productPrices.get('SparkNest Laptop Pro');
        System.debug('SparkNest Laptop Pro Price: ' +laptopPrice);

        



    }

    public static Decimal calculateOrderValue(Integer quantity,Decimal unitPrice) {
        Decimal totalOrderValue = quantity * unitPrice;
        return totalOrderValue;
    }





}