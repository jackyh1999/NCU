import java.math.BigInteger;
import java.util.Scanner;

public class Main {

	public static void main(String[] args) {
		Scanner input = new Scanner(System.in);
		int caseNum = input.nextInt();
		BigInteger num1,num2;
		for(int i=0;i<caseNum;i++) {
			num1 = new BigInteger(input.next());
			num2 = new BigInteger(input.next());
			System.out.println(num1.gcd(num2));
		}
	}
}
