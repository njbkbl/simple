package javaPractice;

public class Library {
	//Book book1, book2, book3;
	
	Book[] Book_list;
	
	public Library(){
	Book_list=new Book[3];		
	}
	public void addBook(Book book1,Book book2, Book book3){
		//this.book1=book1;
		//this.book2=book2;
		//this.book3=book3;
		
	

		Book_list[0]=book1;
		Book_list[1]=book2;
		Book_list[2]=book3;
	}
	
	public void show() {
		book1.show_Data();
		book2.show_Data();
		book3.show_Data();
	}
	
}
