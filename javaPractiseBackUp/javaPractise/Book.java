package javaPractice;



public class Book {         //start of the class Book

	long Book_code;		//Instance veriables
	String Book_Title;
	String Author_Name;
	
	Book(long Book_code1,String Book_Title1,String Author_Name1) {		//constructor Book
		Book_code=Book_code1;
		Book_Title=Book_Title1;
		Author_Name=Author_Name1;
		
	}
	
	void show_Data() {
		System.out.println("Book_Code"+Book_code);
		System.out.println("Book_Title"+Book_Title);
		System.out.println("Author_Name"+Author_Name);
	}
 
}


