//package class_basics;

import java.util.*;
public class Employee{

	int Emp_code;
	String Emp_Name;
	float Salary;

	void read_Data(){
	Scanner rd=new Scanner(System.in);

	System.out.println("Enter the values for Emp_Name");
	Emp_Name=rd.nextLine();

	System.out.println("Enter the values for Emp_code: ");
	Emp_code=rd.nextInt();

	

	System.out.println("Enter the values for Salary");
	Salary=rd.nextFloat();
	}

	void show_Data(){
	System.out.println("The Emp_code: "+Emp_code);
	System.out.println("The Emp_Name: "+Emp_Name);
	System.out.println("The Salary: "+Salary);
	}
}
