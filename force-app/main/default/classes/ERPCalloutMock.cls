@IsTest
global class ERPCalloutMock implements HttpCalloutMock {

    global HttpResponse respond(HttpRequest request) {

        // Verify request method
        System.assertEquals(
            'POST',
            request.getMethod()
        );

        // Verify endpoint
        System.assertEquals(
            'https://example.com/erp/customers',
            request.getEndpoint()
        );

        // Verify JSON was sent
        System.assert(
            request.getBody() != null,
            'Request body should not be null'
        );

        // Convert JSON back to List
        List<Object> customers =
            (List<Object>) JSON.deserializeUntyped(
                request.getBody()
            );

        // Batch should send 5 customers
        System.assertEquals(
            5,
            customers.size(),
            'ERP should receive 5 customers'
        );

        // Return fake ERP response
        HttpResponse response = new HttpResponse();

        response.setStatusCode(200);

        response.setHeader(
            'Content-Type',
            'application/json'
        );

        response.setBody(
            '{"success":true,"message":"Customer data received by ERP"}'
        );

        return response;
    }
}