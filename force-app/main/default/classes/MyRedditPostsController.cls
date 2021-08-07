public with sharing class MyRedditPostsController {
    // private static final String REDDIT_URL = 'http://www.reddit.com/r/SalesforceDeveloper/comments/ocq49l/whats_everybody_making.json';
    private static final String REDDIT_URL = 'https://www.reddit.com/r/SalesforceDeveloper/hot.json';
    // private static final String REDDIT_URL = 'https://www.reddit.com/r/SalesforceDeveloper/top.json';
    private static final String GET = 'GET';

    public MyRedditPostsController() {
        System.debug('Hi, We\'re calling Reddit');
    }

    @AuraEnabled(cacheable=true)
    public static List<RedditWrapper.Children> getRedditData(){

        List<RedditWrapper.Data> redditData = new List<RedditWrapper.Data>();

        Http httpCallout = new http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(REDDIT_URL);
        request.setMethod(GET);
        HttpResponse redditResponse = httpCallout.send(request);
        RedditWrapper wrapperResponse = RedditWrapper.parse(redditResponse.getBody());
        List<RedditWrapper.Children> redditPosts = wrapperResponse.data.children;

        System.debug('redditPosts/RedditWrapper.Children: ' + redditPosts);

        for(RedditWrapper.Children child : redditPosts){
            redditData.add(child.data);
            System.debug('child: ' + child);
        }
        System.debug('redditData: ' + redditData);

        for (RedditWrapper.Data data : redditData){
            System.debug('data.author: ' + data.author);
            System.debug('data.title:' + data.title);
            System.debug('data.selftext: ' + data.selftext);
            System.debug('data.ups: ' + data.ups);
            System.debug('data.downs: ' + data.downs);
        }
        
        return redditPosts;

    }

    // public class RedditWrapper {

    //     public Post data;
    
    //     public class Post {
    //         public List<Children> children;
    //     }
        
    //     public class Children {
    //         public Data data;
    //     }
        
    //     public class Data { // child data
    //         public String author_fullname;
    //         public String title;
    //         public Integer downs;
    //         public Integer ups;
    //         public String name;		
    //         public String author;
    //     }
        
    //     public static JSON2Apex parse(String json) {
    //         return (JSON2Apex) System.JSON.deserialize(json, JSON2Apex.class);
    //     }
    // }

    // public class RedditWrapper{

    //     public Post post;

    // }
    // public class Post{
    //     public List<Children> children;
    // }

    // public class Children{
    //     public Data data;
    // }

    // public class Data{
    //     public String author;
    //     public String title;
    //     public String selftext;
    // }

    // public static RedditWrapper parse(String json){
    //     return (RedditWrapper) System.JSON.deserialize(json, RedditWrapper.class);
    // }

}