import { LightningElement, api } from 'lwc';
import getRedditData from '@salesforce/apex/MyRedditPostsController.getRedditData';

export default class MyRedditPosts extends LightningElement {

    @api recordId;
    redditResults;
    isLoaded = false;

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
                this.isLoaded = true;
            } else {
                console.log('no results');
            }
        }).catch(error=>{
            console.log('error: ' + error)
        });
    }

    makeCallout(){
        console.log('makeCallout()');
        console.log('this.isLoaded = ' + this.isLoaded);
        this.isLoaded = !this.isLoaded;
        console.log('this.isLoaded = ' + this.isLoaded);      
        setTimeout(() => {
            console.log('in setTimeout()');
            this.getRedditData();
        }, 1500);
    }

}