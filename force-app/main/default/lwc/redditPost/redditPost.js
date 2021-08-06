import { LightningElement, api } from 'lwc';

export default class RedditPost extends LightningElement {

 @api post;
 downs;

 connectedCallback(){
    console.log('connectedCallback() redditPost.js');
    console.log('post: ' + JSON.stringify(this.post));
    // this.downs = this.post.downs = null ? 0 : this.post.downs;
 }

 get upOrDownArrow(){
     return this.post.ups >= this.post.downs ? 'utility:arrowup' : 'utility:arrowdown';
 }
 get upsOrDowns(){
     return this.post.ups >= this.post.downs ? this.post.ups : this.post.downs;
 }

}