public class AccountSearchService {
    
    private static string clientId = Integration_Properties__mdt.getInstance('clientId').Value__c ;
    private static string clientSecret = Integration_Properties__mdt.getInstance('clientSecret').Value__c ;
    private static string username = Integration_Properties__mdt.getInstance('username').Value__c ;
    private static string password = Integration_Properties__mdt.getInstance('password').Value__c ;
    private static string getTokenEndPoint = Integration_Properties__mdt.getInstance('getTokenEndPoint').Value__c ;
    private static string searchAccountEndPoint = Integration_Properties__mdt.getInstance('searchAccountEndPoint').Value__c ;
    
    public class response {
        public String id;
        public String access_token;
    }
    
    public static String getRequestToken() {
        String reqbody = 'grant_type=password'+'&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password ;
        Http h1 = new Http() ;
        HttpRequest req = new HttpRequest() ;
        req.setBody( reqbody ) ;
        req.setMethod( 'POST' ) ;
        req.setEndpoint( getTokenEndPoint ) ; 
        HttpResponse res = h1.send( req ) ;
        response resp = ( response )JSON.deserialize( res.getBody(),response.class ) ;
        return resp.access_token ;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<AccountInfo> callGetAccount(String accName) {
        List<AccountInfo> accountInfoObj = new List<AccountInfo> () ;
        String accessToken = '' ;
        accessToken = getRequestToken() ;
        Http http = new Http() ;
        HttpRequest req = new HttpRequest() ;
        req.setEndpoint( searchAccountEndPoint+accName ) ;
        req.setMethod( 'GET' ) ;
        req.setHeader( 'Accept','application/json' ) ;
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setHeader( 'Authorization','Bearer ' + accessToken ) ;
        HttpResponse res = http.send(req) ;
        if(res.getstatusCode() == 200 && res.getbody() != null) {
            accountInfoObj = (List<AccountInfo>)JSON.deserialize(res.getBody(), List<AccountInfo>.class);
        }
        return accountInfoObj ;
    }
    
    public class AccountInfo {
        @AuraEnabled 
        public string accountId ;
        @AuraEnabled 
        public string name ;
        @AuraEnabled 
        public string billingCountry ;
        @AuraEnabled 
        public integer numberOfContacts ;
        @AuraEnabled 
        public integer numberOfOpportunities ;
    }
    
}