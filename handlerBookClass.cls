            public with sharing class handlerBookClass {
            @AuraEnabled
            //get List of book from database
            public static List<Book__c> getAllbook(String isbnnumber ){
                try {
                    String key = '%' +  isbnnumber + '%';
                    List<Book__c> BookList=[Select Name,ISBN_Number__c,Author__c,Price__c from Book__c where 
                    ISBN_Number__c LIKE: key];
                    return BookList;
                    
                } catch (Exception e) {
                    throw new AuraHandledException(e.getMessage());
                }
            }

            @AuraEnabled
            public static list<Book__c> bookSearch(String searchKey , String bookLabel){
                try
                 {
                    
                   
        
                    List<Book__c> bkList = new List<Book__c>();
        
                    // If Label is name Search Book by Name .
                    if (bookLabel == 'Book Name' &&  searchKey != null) {
                        String key =  '%'+ searchKey + '%' ; 
                        bkList =  [Select Name , ISBN_Number__c , Author__c ,
                         Number_Of_Free_Book__c, 
                         Number_of_Issued_Books__c from Book__c where Name like : key];
                         System.debug('For Name __>' +bkList);
                    }
        
                    // Search Book by ISBN Number .
                    else if (bookLabel == 'ISBN Number' &&  searchKey != null) {
                        String key =  '%'+ searchKey + '%' ;
        
                        bkList =  [Select Name , ISBN_Number__c , Author__c , Number_Of_Free_Book__c, 
                        Number_of_Issued_Books__c from Book__c where ISBN_Number__c like : key];
                        System.debug('For ISBN __>' +bkList);
                      
                    }
        
                    // Search Book by Author .
                    else if (bookLabel == 'Author' &&  searchKey != null) {
                        String key =  '%'+ searchKey + '%' ;
                        bkList =  [Select Name , ISBN_Number__c , Author__c ,Number_Of_Free_Book__c, 
                        Number_of_Issued_Books__c from Book__c where Author__c like : key];
                        System.debug('For Author __>' +bkList);
                        
                    }
        
                    return bkList ;
        
                } 
                catch (Exception ex)
                {
                    throw new AuraHandledException(ex.getMessage());
                }
            }
        
        //  Display All Book in tabel.
            @AuraEnabled
            public static list<Book__c> getBookBySearch(){
                try {
                    List<Book__c> allBook = new List<Book__c>();
                    allBook = [Select Name , ISBN_Number__c , Author__c , Number_of_Books__c ,
                    Number_Of_Free_Book__c, Number_of_Issued_Books__c from Book__c];
        
                    return allBook ;
                } catch (Exception e) {
                    throw new AuraHandledException(e.getMessage());
                }
            }



          @AuraEnabled
            //save new record of book
            public static List<Book__c> saveBookRecord(Book__c  bookRecord, String isbnnumber ,Integer numberOfCopies){
                try{
                    if(Book__c.SObjectType.getDescribe().isAccessible()){
                        List<Book__c> isbnlist= new List<Book__c>();
                        isbnlist= [Select ISBN_Number__c from Book__c where ISBN_Number__c =: isbnnumber];
                        if(isbnlist.isEmpty()){
                            insert bookRecord;
                        }
                        
                        Book__c idset =[Select ID from Book__c where ISBN_Number__c =: isbnnumber ];
                        List<Book__c> bookId=[Select ID,ISBN_Number__c, Name from Book__c where
                         ISBN_Number__c =: isbnnumber ];
                        
                        List<Book_Copy__c> copiesbook =new List<Book_Copy__c>();
                        for(Integer i=0;i<numberOfCopies;i++){
                            Book_Copy__c copy=new Book_Copy__c();
                            copy.Book__c=idset.Id;
                            copiesbook.add(copy);
                        }
                        insert copiesbook;
                    }
                    List<Book__c> BookList=[Select Name,ISBN_Number__c,Price__c,Author__c from Book__c];
                    return BookList;
                    
                    
                } catch (Exception e) {
                    throw new AuraHandledException(e.getMessage());
                }
            }

  @AuraEnabled
            public static List<Issue__c> getIssueBook(Id issueId){
                try {
                    List<Issue__c> issueBooks = new List<Issue__c>();
        
                    issueBooks = [Select Id ,Name, Reader__r.Name ,Reader__c,  From_Date__c , To_Date__c , Book__r.Number_Of_Free_Book__c ,
                    Book__r.Number_of_Issued_Books__c , Book__r.ISBN_Number__c 
                    from Issue__c 
                     where Book__c =: issueId];
                     
        
                    return issueBooks ; 
                    
                } catch (Exception e) {
                    throw new AuraHandledException(e.getMessage());
                }
            }
        

             //it display book record in 3rd component 
            @AuraEnabled 
            public static Book__c getreturnSelectedBook(ID bookRecordId){
                try {
                    Book__c getBook = new Book__c ();
                    if(bookRecordId != null){
                        getBook=[Select id, Name, ISBN_Number__c, Author__c, Number_of_Books__c, 
                        Number_of_Issued_Books__c, Number_Of_Free_Book__c from Book__c where Id =: bookRecordId];
                       // system.debug('getReturnSelectedBook-->' + getBook);
                    }

                    return getBook;
                } catch (Exception e) {
                    throw new AuraHandledException(e.getMessage());
                }
            }


            

             //reader Name and rest of detail to show in table 
            @AuraEnabled 
            public static List<Issue__c> readerDetail (ID bookRecordId){
try{
    List<Issue__c> issuedobjBook = [Select Id, Book__c, Book_Copy__c, Reader__r.Name, 
                   Book_Copy__r.Id, To_Date__c, From_Date__c from Issue__c 
                   where Book__c =: bookRecordId];
                    
                   
                    return issuedobjBook;
                    }
                
                   
                /*Select Id, Book__r.Name, Book__r.Price__c, Reader__r.Name, Tentative_Date_of_Return__c,
                   Book__r.Number_of_Issued_Books__c , Book__r.ISBN_Number__c, Book__r.Number_Of_Free_Book__c, status__c,
                   From_Date__c,To_Date__c , Book__c//lookup with book
                   from Issue__c*/
                    
                 catch (Exception e) {
                    throw new AuraHandledException(e.getMessage());
                }
            }



            @AuraEnabled
    public static Issue__c returnDateUpdate( Date todate, ID copyRecordId, ID issueRecordId){
        try {
            List<Book_Copy__c> updateChecked =new List<Book_Copy__c>();
            //For To Date
            List<Issue__c> updateList =new List<Issue__c>();
            if(issueRecordId != null){
            List<Issue__c> issuedBook= [Select Id, To_Date__c, From_Date__c from Issue__c where ID=:issueRecordId];
            for(Issue__c  issue:issuedBook){
                issue.To_Date__c=todate;
                updateList.add(issue);
            }
            update updateList;
           
            }

            //For unchecked Issue box in BooK Copies

           
            if(copyRecordId!=null){
            List<Book_Copy__c> checkedBook= [Select Id, Issued__c from Book_Copy__c where ID=:copyRecordId];
            for(Book_Copy__c  c:checkedBook){
                if(c.Issued__c==True){
               c.Issued__c=False;

                updateChecked.add(c);
                }
            }
            update updateChecked;
           
            
           
            }




            Issue__c newRecord=[Select Id,Book__c,Book_Copy__c,Reader__r.Name, Book_Copy__r.Id, 
            To_Date__c, From_Date__c from Issue__c where ID=:issueRecordId];
            
            return newRecord;
        

            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }




            

            @AuraEnabled
            public static Issue__c returnDate( Date todate,ID copyRecordId, ID issueRecordId){
                try {
                    List<Book_Copy__c> updateChecked =new List<Book_Copy__c>();
                    //For To Date
                    List<Issue__c> updateList =new List<Issue__c>();
                    if(issueRecordId!=null){
                    List<Issue__c> issuedBook= [Select Id, To_Date__c, From_Date__c from Issue__c where ID=:issueRecordId];
                    for(Issue__c  issue:issuedBook){
                        issue.To_Date__c=todate;
                        updateList.add(issue);
                    }
                    update updateList;
                   
                    }
        
                    //For unchecked Issue box in BooK Copies
        
                   
                    if(copyRecordId!=null){
                    List<Book_Copy__c> checkedBook= [Select Id, Issued__c from Book_Copy__c where ID=:copyRecordId];
                    for(Book_Copy__c  c:checkedBook){
                        if(c.Issued__c==True){
                       c.Issued__c=False;
        
                        updateChecked.add(c);
                        }
                    }
                    update updateChecked;
                   
                    
                   
                    }
        
        
        
        
                    Issue__c newRecord=[Select Id,Book__c,Book_Copy__c,Reader__r.Name, Book_Copy__r.Id, 
                    To_Date__c, From_Date__c from Issue__c where ID=:issueRecordId];
                    
                    return newRecord;
                
        
                    
                } catch (Exception e) {
                    throw new AuraHandledException(e.getMessage());
                }
            }
        
        
           



            //Update when reader return book 
            @AuraEnabled
            public static Book__c updateReturn(Id bookRecordId){
                try {
                    Book__c returnBook = new Book__c ();
                    if(bookRecordId != null){
                        returnBook = [Select id, Name, ISBN_Number__c, Author__c, Number_of_Books__c, 
                        Number_of_Issued_Books__c from Book__c where ID =:  bookRecordId] ;
                        System.debug('return book Details is--->' + returnBook );
                    }
                    return returnBook;
                    
                } catch (Exception e) {
                    throw new AuraHandledException(e.getMessage());
                }
            }



//New Issue Book  4th Component 
            @AuraEnabled
            public static List<Issue__c> newIssue(Id bookId, date tendate, id rname){
                try {
                    List<Issue__c> issueList = new List<Issue__c> ();
                   
                        List<Book_Copy__c> copybook = new List<Book_Copy__c> ();   
                        copybook = [Select id, Issued__c, Book__c from Book_Copy__c where Issued__c = false 
                        AND Book__c =: bookId];
                    System.debug('New Issue Method Line no 342 book copy-->'+copybook[0].id);
                       
                        Issue__c issueObj = new Issue__c ();
                        issueObj.Book__c = bookId ;
                        issueObj.Reader__c = rname; 
                        issueObj.Book_Copy__c = copybook[0].id ;
                        issueObj.Tentative_Date_of_Return__c = tendate;
                        issueObj.From_Date__c = system.today() ;
                         issueList.add(issueObj); 
                         system.debug('new book issue list  line number 351-->'+issueList);
                    
                    
                         insert issueList;
                    
                   
         
                List<Book_Copy__c> bookCopyUpdate = new List<Book_Copy__c> ();
         for(Book_Copy__c bookC : [Select id, Issued__c from Book_Copy__c where  Id =:copybook[0].id]){
         if(bookC.Issued__c == false ){
         bookC.Issued__c = true ;
         bookCopyUpdate.add(bookC);
         system.debug('new book issue update list  line number 359-->'+bookCopyUpdate);
         }
         
         }
         
         update bookCopyUpdate ;
         
                    
         return issueList ;
         
         
                } catch (Exception e) {
                    throw new AuraHandledException(e.getMessage());
                }
            }



        /*    @AuraEnabled
            public static List<Issue__c> issueBookwithReader(){
                try {
                    List<Issue__c> issueList = new List<Issue__c> ();
                    issueList = [Select id, Book__r.Name, Book_Copy__r.Name,
                     Book_Copy__r.Issued__c, Tentative_Date_of_Return__c,
                    From_Date__c from Issue__c where  
                    Book_Copy__r.Issued__c = true];
                    
                    
                    return issueList ;
                    
                } catch (Exception e) {
                    throw new AuraHandledException(e.getMessage());
                }
            }*/




             //List of Reader with details Used in Component seven

             @AuraEnabled 
             public static List<Contact>  readerCompleteDetail(){
                 try {
                     List<Contact> conList = [Select Name, Total_Issued_Book__c,
                     (Select id, Book__c, Tentative_Date_of_Return__c, Book__r.Name , Book__r.id ,
                      To_Date__c, From_Date__c from Issues__r) 
                     from Contact where Total_Issued_Book__c != 0 ];
                    
                     
                 System.debug('ConList is--->'+conList);
                    
                   
 
                     return conList ;
                 } catch (Exception e) {
                     throw new AuraHandledException(e.getMessage());
                 }
             }

              //for 6th component 

             @AuraEnabled
             public static List<Issue__c> issueBookwithReaderDetail (){
                 try {
                     List<Issue__c> issueListWithReader = [Select   Reader__r.Name, Book__r.Name, Book_Charges__c, From_Date__c, To_Date__c,
                     Tentative_Date_of_Return__c, Book__r.Id,Book_Copy__r.Id
                       From Issue__c where Reader__r.Total_Issued_Book__c != 0 Order By CreatedDate DESC];
                     
                     return issueListWithReader;
                 } catch (Exception e) {
                     throw new AuraHandledException(e.getMessage());
                 }
             }
          
         
        }

