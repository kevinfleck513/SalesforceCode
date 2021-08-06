//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class RedditWrapper {
    @AuraEnabled
    public Post data;

    public class Post {
        @AuraEnabled
		public List<Children> children;
    }
    
    public class Children {
        @AuraEnabled
		public Data data;
	}
    
    public class Data { // child data
        
        @AuraEnabled
        public String selftext;

        @AuraEnabled
        public String title;

        @AuraEnabled
        public Integer downs;

        @AuraEnabled
        public Integer ups;

        @AuraEnabled
        public String author;
        
	}
	
	public static RedditWrapper parse(String json) {
		return (RedditWrapper) System.JSON.deserialize(json, RedditWrapper.class);
	}
}