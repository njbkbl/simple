package javaPractice;

public class Main {

	public static void main(String[] args) {
		
		Library lib=new Library();
		Book bk1=new Book(1243,"Java_f","Blanc");
		Book bk2=new Book(1243,"C++","Blanc");
		Book bk3=new Book(1243,"C#","Blanc");
		
		lib.addBook(bk1,bk2,bk3);
		lib.show();
		
	}

}
