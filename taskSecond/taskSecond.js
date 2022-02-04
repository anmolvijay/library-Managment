import { LightningElement, track, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getBookBySearch from '@salesforce/apex/handlerBookClass.getBookBySearch' ;
import bookSearch from '@salesforce/apex/handlerBookClass.bookSearch' ;

export default class TaskSecond extends LightningElement {
    @api bookRecordId;
  @track readerVisible = false;
    @track bookRecord;
    @track getRecord;
    @track BookList;
   @track renderTable = true ;
   @track page = 1;
@track startingRecord = 1;
@track endingRecord = 0;
@track pageSize;
@track totalRecountCount = 0;
@track totalPage = 0;
@track item = [];
    searchValue = '';
    labelName ;
    
    
  
    
   


   
   
  connectedCallback() {
    getBookBySearch()
         .then(result=>{
            console.log('Result:',result);
            this.BookList=result;
            console.log('BookList:',this.BookList);
         })

} 

handelSearch(event)
    {
        this.labelName = event.target.label ;
    }
    search(event)
    {
        this.key = event.target.value ;
        bookSearch({searchKey : this.key  , bookLabel : this.labelName})
        .then(result => {
            this.item = result;
            console.log('Line number 48 result --->', this.item);
            this.totalRecountCount = result.length; 
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);

            this.BookList = this.item.slice(0,this.pageSize); 
            this.endingRecord = this.page
             this.BookList = result ;
             
             
             console.log('Line number 57__>', BookList);
            console.log(result);
        })
        .catch(error => {
            console.log(error);

        });
    }
 
   /* // update searchValue var when input field value change
    searchKeyword(event) {
        this.searchValue = event.target.value;
    }
 
    // call apex method on button click 
    handleSearchKeyword(event) {
        this.getRecord = event.target.value ;
        fetchData({searchKey : this.getRecord, sObjectApiName: this.bookRecord})
        .then(result=> {

            this.item = result;
this.totalRecountCount = result.length;
this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);

this.BookList = this.item.slice(0,this.pageSize);
this.endingRecord = this.pageSize;

        })
    }*/

    //handle Button Event 
  handleClick(event) {
    this.labelName = event.target.label;
    }


    get options() {
        return [
        { label: '5', value: '5' },
        { label: '10', value: '10' },
        { label: '15', value: '15' },
        ];
        }
        
        comboChange(event) {
        this.value = event.detail.value;
        this.pageSize=event.detail.value;
        console.log('page size:',this.pageSize);
        }

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
        
        this.BookList = this.item.slice(this.startingRecord, this.endingRecord);
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

      
        showReaderComponent(event) {
            this.readerVisible = true;
            console.log('Access Key:',event.target.accessKey);
            console.log('RecordId:',event.currentTarget.dataset.recid);
            this.bookRecordId = event.currentTarget.dataset.recid;
            console.log('Book Record Id:',this.bookRecordId);
            const selectedEvent = new CustomEvent("progressvaluechange", {
              detail: this.bookRecordId
              });
              
              this.dispatchEvent(selectedEvent);
    
          }

        
    
 }