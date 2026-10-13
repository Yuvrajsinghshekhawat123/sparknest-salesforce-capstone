public with sharing class SparkNestEnquiryUtility {
    public SparkNestEnquiryUtility() {
    }
    public static void organizeEnquiries() {
    List<String> customerNames = new List<String>{
        'Rahul Sharma',
        'Priya Reddy',
        'Arjun Patel',
        'Neha Verma'
    };
    List<String> customerEmails = new List<String>{
        'rahul@sparknest.com',
        'priya@sparknest.com',
        'arjun@sparknest.com',
        'neha@sparknest.com'
    };
    Set<String> stores = new Set<String>{
        'Hyderabad',
        'Bangalore',
        'Hyderabad',
        'Chennai'
    };
    Map<String, String> customerEmailMap = new Map<String, String>();
    customerEmailMap.put( 'rahul@sparknest.com','Rahul Sharma');
    customerEmailMap.put('priya@sparknest.com','Priya Reddy');
    customerEmailMap.put('arjun@sparknest.com','Arjun Patel');
    customerEmailMap.put('neha@sparknest.com','Neha Verma');
    for (String customer : customerNames) {
        System.debug('Customer: ' + customer);
    }
    System.debug('=== Unique Stores ===');
    for (String store : stores) {
        System.debug('Store: ' + store);
    }
    System.debug('=== Customer Email Map ===');
    for (String email : customerEmailMap.keySet()) {
        String customer = customerEmailMap.get(email);
        System.debug(
            'Email: ' + email +
            ' | Customer: ' + customer
        );
    }
    System.debug('Total Customers: ' + customerNames.size());
    System.debug('Total Unique Stores: ' + stores.size());
    }
}