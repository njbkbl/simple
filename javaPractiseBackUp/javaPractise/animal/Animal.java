package animal;

public class Animal {

	int id;
	String name;
	String color;
	float weight;



	Animal(int id,String name, String color,float weight){
		this.id = id;
		this.name = name;
		this.color = color;
		this.weight = weight;
	}

	void showData(){
		System.out.println("Id of the Cat: "+id);
		System.out.println("Name of the Cat: "+name);
		System.out.println("Color of the Cat: "+color);
		System.out.println("Weight of the Cat: "+weight);
	}

	public void setId(int id){
			this.id=id;
	}

	public int getId(){
		return id;
	}

	public void setName(String name){
		this.name=name;
	}

	public String getName(){
		return name;
	}
}
