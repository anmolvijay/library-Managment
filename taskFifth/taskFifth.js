import { LightningElement, track, api, wire } from 'lwc';

export default class TaskFifth extends LightningElement {
  
    @api bookrecID;
    @track tabvalue;
    @api issueName ;
    
    secondvalueid(event){
        this.bookrecID = event.detail ;
        console.log('Check for bookid--> ',this.bookrecID);
        if(this.tabvalue!="3"){
        this.tabvalue = "3" ;
        }

    }
    
    handelactive(event){
        if(event.target.label == 'Search Books'){
            this.tabvalue = '' ;
        }
    }


    thirdissue(event){
        this.issueName = event.detail ;
        console.log('Line number 24 ---> ', this.issueName);
        this.tabvalue = "4";
    }


    sixthreturn(event){
this.bookrecID = event.detail;
this.tabvalue = "3";
    }
   
   
}