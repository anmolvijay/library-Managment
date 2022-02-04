import { LightningElement, track, api, wire } from 'lwc';
import readerCompleteDetail from '@salesforce/apex/handlerBookClass.readerCompleteDetail';

 
export default class TaskSeven extends LightningElement {

    @track readerInfo = [];
    @track issueList = [];


    @track overDueBook ;

    todaydate ;
    tentativeDate ;


    @track page = 1;
    @track startingRecord = 1; 
    @track endingRecord = 0; 
    @track pageSize =5; 
    @track totalRecountCount = 0; 
    @track totalPage = 0;
    @track item = [];

    @track modalContainer = false;
    @track recordRow={};

    @wire(readerCompleteDetail) wireDetails;
    handleRowAction(event){
        const dataRow = event.detail.row;
        window.console.log('dataRow@@ ' + dataRow);
        this.recordtRow=dataRow;
        this.modalContainer=true;
    }


    connectedCallback()
    {
        readerCompleteDetail()
        .then(result => {
            this.readerInfo =this.processData(result); 
            console.log(this.readerInfo , "book records");
        })

       
    }




    processData(data){
        let newData = [];
        this.currentDate();
        data.forEach(currentItem => {

            currentItem.Issues__r.forEach(issueItem => {
               

                if (issueItem.Tentative_Date_of_Return__c < this.todaydate && issueItem.To_Date__c == null ) {
                
                    
                    issueItem.overDueBook = true ;
    
                   
    
                    console.log(issueItem.Book__r.Name , 'Book Name');
                }

            });
            


            newData.push(currentItem);


         


        });
        return newData;

    }


   





    currentDate()
    {
        let rightNow = new Date();

        rightNow.setMinutes(
            new Date().getMinutes() - new Date().getTimezoneOffset()
        );
        let yyyyMmDd = rightNow.toISOString().slice(0,10);
        this.todaydate=yyyyMmDd;
        console.log(yyyyMmDd);
        console.log('this.todaydate:',this.todaydate);
    }




 //For pagination start

 previousHandler() {
    if (this.page > 1) {
        this.page = this.page - 1; //decrease page by 1
        this.displayRecordPerPage(this.page);
    }
}


nextHandler() {
    if((this.page<this.totalPage) && this.page !== this.totalPage){
        this.page = this.page + 1; //increase page by 1
        this.displayRecordPerPage(this.page);            
    }             
}

displayRecordPerPage(page){
        
    this.startingRecord = ((page -1) * this.pageSize) ;
    this.endingRecord = (this.pageSize * page);

    this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                        ? this.totalRecountCount : this.endingRecord; 

    this.issuebook = this.item.slice(this.startingRecord, this.endingRecord);
    this.startingRecord = this.startingRecord + 1;
    

}
get disablePrev(){
    if(this.page===1){
return true;
    }else{
    return false;
    }
}


get disableNext(){
    if(this.page===this.totalPage||this.totalPage===0){
    return true;

    }
    else{
    return false;
    }

}



}

  