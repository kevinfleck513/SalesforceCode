import { LightningElement, api } from 'lwc';

export default class RedditPost extends LightningElement {

 @api post;
 downs;

 connectedCallback(){
    console.log('connectedCallback() redditPost.js');
    console.log('post: ' + JSON.stringify(this.post));
    // this.downs = this.post.downs = null ? 0 : this.post.downs;
 }

//  get downs(){
//      return this.post.downs = undefined ? 0 : this.post.downs;
//  }

}