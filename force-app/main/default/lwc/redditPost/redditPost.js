import { LightningElement, api } from 'lwc';

export default class RedditPost extends LightningElement {

 @api post;

 connectedCallback(){
    console.log('connectedCallback() redditPost.js');
    console.log('post: ' + JSON.stringify(this.post));
 }

 get upOrDownArrow(){
     return this.post.ups >= this.post.downs ? 'utility:arrowup' : 'utility:arrowdown';
 }
 get upsOrDowns(){
     return this.post.ups >= this.post.downs ? this.post.ups : this.post.downs;
 }

}