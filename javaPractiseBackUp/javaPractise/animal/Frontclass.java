package animal;

public class Frontclass {

	public static void main(String[] args) {

		Animal an = new Animal(12,"Caty","Black", 4);
		int i;
		i=an.getId();
		i=i+5;

		an.setId(i);
		System.out.println(an.getId());

		an.setId(an.getId() + 5);
		System.out.println(an.getId());
	}

}
