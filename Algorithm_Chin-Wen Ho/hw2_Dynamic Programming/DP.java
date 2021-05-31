import java.util.Scanner;

public class DP {
	public int len,max_value;
	public String str= new String();
	public int[] num,stack;
	public int[][] max,min,r;
	public char[] op;
	public static void main(String[] args) {
		
		/* initialize variable */
		DP DP = new DP();		
		DP.str = new String(new Scanner(System.in).nextLine());
		DP.len = DP.str.length()/2;
		DP.op = new char[DP.len]; 				// store all operators in string
		DP.num = new int[DP.len+1];				// store all numbers in string
		DP.max = new int[DP.len+1][DP.len+1]; 	// store maximum value
		DP.min = new int[DP.len+1][DP.len+1]; 	// store minimum value
		DP.r = new int[DP.len+1][DP.len+1];		// store cutting point
		DP.stack = new int[DP.len+1]; 			// store the optimal way of cut in stack
		for(int i=0;i<DP.len+1;i++) DP.stack[i] = -10000;
			
		/* build an array of numbers and an array of operators */
		for(int i=0;i<DP.str.length();i++) {
			if(i%2==0) DP.num[i/2]=DP.str.charAt(i)-'0';
			else if(i%2==1) DP.op[i/2]=DP.str.charAt(i);
		}		
				
		/* build 2-d arrays which store maximum value, minimum value, and cutting point */
		for(int i=0;i<DP.len+1;i++) for(int j=0;j<DP.len+1;j++) DP.max[i][j]=-10000;
		for(int i=0;i<DP.len+1;i++) for(int j=0;j<DP.len+1;j++) DP.min[i][j]=10000;
		for(int i=0;i<DP.len+1;i++) for(int j=0;j<DP.len+1;j++) DP.r[i][j]=-10000;
		for(int i=0;i<DP.len+1;i++) DP.max[i][i]=DP.num[i];
		for(int i=0;i<DP.len+1;i++) DP.min[i][i]=DP.num[i];
		for(int i=0;i<DP.len+1;i++) {
			DP.r[i][i]=i;
			if(i!=DP.len) DP.r[i][i+1]=i;
		}
			
		/* Find max value */
		DP.max_value=DP.FindMax(0,DP.len);
				
		/* parenthesize the expression and print result*/
		DP.CuttingPointLeft(0,DP.len,0);
		DP.Parenthesize();	
		System.out.println(DP.str + "=" + DP.max_value + "\n");
			
		/* print arrays */		
		/* print max array */
		/*
		for(int i=0;i<DP.len+1;i++) {
			for(int j=0;j<DP.len+1;j++) System.out.print(String.format("%-8d",DP.max[i][j]) + " ");			
			System.out.println();
		}
		System.out.println(); 
		*/
		
		/* print min array */
		/*
		for(int i=0;i<DP.len+1;i++) {
			for(int j=0;j<DP.len+1;j++) System.out.print(String.format("%-8d",DP.min[i][j]) + " ");			
			System.out.println();
		}
		System.out.println(); 
		*/
		
		/* print cutting point array */
		/*
		for(int i=0;i<DP.len+1;i++) {
			for(int j=0;j<DP.len+1;j++) System.out.print(String.format("%-8d",DP.r[i][j]) + " ");			
			System.out.println();
		}
		System.out.println(); 
		*/
	}
	
	public int FindMax(int m,int n) {	
		if(max[m][n] != -10000) return max[m][n];	// if max array already has value, return
		if(n-m==1) {
			max[m][n]=Calculate(num[m],num[n],m);	// if has only two numbers calculate and return
			return max[m][n];
		}
		int temp_max;
		for(int i=0;i<n-m;i++) {		
			/* if current character is '-' calculate max_value(m:m+i) and min_value(m+i+1:n) by minus operation 
			 * else calculate max_value(m:m+i) and max_value(m+i+1:n) */
			if(op[m+i]=='-') temp_max=Calculate(FindMax(m,m+i),FindMin(m+i+1,n),m+i);			
			else temp_max=Calculate(FindMax(m,m+i),FindMax(m+i+1,n),m+i);
			/* if current value is greater than value in array, then put value and cutting point into arrays */
			if(max[m][n]<=temp_max) {
				max[m][n]=temp_max;
				r[m][n]=m+i;
			}
		}
		return max[m][n];
	}
	public int FindMin(int m,int n) {
		if(min[m][n] != 10000) return min[m][n];	// if min array already has value, return
		if(n-m==1) {
			min[m][n]=Calculate(num[m],num[n],m);	// if has only two numbers calculate and return
			return min[m][n];
		}
		int temp_min;
		for(int i=0;i<n-m;i++) {
			/* if current character is '-' calculate min_value(m:m+i) and max_value(m+i+1:n) by minus operation 
			 * else calculate min_value(m:m+i) and min_value(m+i+1:n) */
			if(op[m+i]=='-') temp_min=Calculate(FindMin(m,m+i),FindMax(m+i+1,n),m+i);			
			else temp_min=Calculate(FindMin(m,m+i),FindMin(m+i+1,n),m+i);
			/* if current value is less than value in array, then put value and cutting point into arrays */
			if(min[m][n]>=temp_min) {
				min[m][n]=temp_min;
				r[m][n]=m+i;
			}
		}
		return min[m][n];
	}
	public int Calculate(int m,int n,int i) {
		/* doing plus, minus, and times operation */
		switch(op[i]) {
		case '+': return m+n;
		case '-': return m-n;
		case '*': return m*n;
		default : return -10000;
		}	
	}
	
	/* to find optimal way of cutting point and put it into a stack */
	public void CuttingPointLeft(int m,int n,int top) {
		if( top==len || n-m==0 || n-m==1 ) return;		// if has only one or two numbers, return
		int cutting_point=r[m][n];		
		while(stack[top]!=-10000 && top!=len) top++;	// find the free space of stack
		stack[top]=cutting_point;		
		CuttingPointLeft(m,cutting_point,top);			// find the cutting point of left side
		CuttingPointRight(cutting_point+1,n,top);		// find the cutting point of right side
	}
	/* same as CuttingPointLeft() */
	public void CuttingPointRight(int m,int n,int top) {
		if( top==len || n-m==0 || n-m==1 ) return;	
		int cutting_point=r[m][n];	
		while(stack[top]!=-10000 && top!=len) top++;
		stack[top]=cutting_point;
		CuttingPointLeft(m,cutting_point,top);
		CuttingPointRight(cutting_point+1,n,top);
	}
	public void Parenthesize() {
		int op_amount=-1,top=0;
		for(int i=0;i<str.length();i++) {
			/* if it's top of stack, break */
			if(stack[top]==-10000) break;
			/* if current character is an operator, op_amount++ */
			if(str.charAt(i)=='+' || str.charAt(i)=='-' || str.charAt(i)=='*') op_amount++;
			/* insert parentheses into original string */
			if(op_amount==stack[top]) {
				if(str.charAt(i)=='*') str=str.substring(0,i-3)+"("+str.substring(i-3,i)+")"+str.substring(i,str.length());					
				top++;
			}				
		}
	}
}
