import { LightningElement, api, track } from 'lwc';
import getRedditData from '@salesforce/apex/MyRedditPostsController.getRedditData';

export default class MyRedditPosts extends LightningElement {

    @api recordId;
    @track redditResults;

    connectedCallback(){
        console.log('connectedCallback');
        this.getRedditData();
    }

    getRedditData(){
        console.log('getRedditData');
        getRedditData()
        .then((result)=>{
            if(result){
                console.log('reddit results: ' + JSON.stringify(result));
                this.redditResults = result;
            } else {
                console.log('no results');
            }
        }).catch(error=>{
            console.log('error: ' + error)
        });
    }

}