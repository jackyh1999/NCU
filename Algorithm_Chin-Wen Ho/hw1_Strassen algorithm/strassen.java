import java.util.Scanner;

public class strassen {
	/*宣告變數*/
	public int N,temp,pow,row,column;
	public long time_before_strassen,time_after_strassen;
	public int[][] arrA,arrB,arrC;
	public Scanner input = new Scanner(System.in);
	
	public static void main(String[] args) {
		strassen s = new strassen();
		s.pow = 0;
		
		System.out.print("n: "); 	   // 決定要輸入的矩陣大小
		s.N = s.input.nextInt();
		s.arrC = new int[s.N][s.N];    // 存結果的矩陣
		s.FillWithZero(); 			   // 建立A、B矩陣，並將維度不到2^n的行列補零
		s.time_before_strassen = System.currentTimeMillis();		// 讀取矩陣運算前的系統時間
		s.arrC = s.DivideAndConquer(s.arrA,s.arrB,s.row,s.column);	// 開始使用Strassen's Algorithm
		s.time_after_strassen = System.currentTimeMillis();			// 讀取矩陣運算後的系統時間
		/*印出結果矩陣C，並顯示矩陣運算的時間(秒)*/
		for(int i=0;i<s.N;i++) {
			for(int j=0;j<s.N;j++) {
				System.out.print(s.arrC[i][j] + " ");
			}
			System.out.println();
		}
		System.out.println((double)(s.time_after_strassen - s.time_before_strassen)/1000 + "s");
	}
	public void FillWithZero() {
		/*將矩陣A、B的大小設為temp(最接近input N的2^n整數)*/
		temp = N;
		while(temp>0) {
			pow++;
			temp/=2;
		}
		temp = 1; 
		for(int i=0;i<pow;i++) temp*=2;
		row = temp; column = temp;
		arrA = new int[row][column]; arrB = new int[row][column];
		/*讀取測資A、B矩陣，並將維度不到2^n的行列補零*/
		System.out.println("array_A:");
		for(int i=0;i<row;i++) {
			for(int j=0;j<column;j++) {
				arrA[i][j] = 0;
			}
		}
		for(int i=0;i<N;i++) {
			for(int j=0;j<N;j++) {
				//arrA[i][j] = input.nextInt();		// 自行輸入矩陣A
				arrA[i][j] = 1;						// 自動產生全為1的矩陣A
				arrA[i][j] %= 101;
			}
		}		
		System.out.println("array_B:");
		for(int i=0;i<row;i++) {
			for(int j=0;j<column;j++) {
				arrB[i][j] = 0;
			}
		}
		for(int i=0;i<N;i++) {
			for(int j=0;j<N;j++) {
				//arrB[i][j] = input.nextInt();		// 自行輸入矩陣B
				arrB[i][j] = 1;				     	// 自動產生全為1的矩陣B
				arrB[i][j] %= 101;
			}
		}
	}
	/*利用Strassen's Algorithm進行矩陣運算*/
	public int[][] DivideAndConquer(int[][] A,int[][] B,int m,int n) {	
		return Divide(A,B,m/2,n/2);	
	}
	/*將A、B矩陣切4等分*/
	public int[][] Divide(int[][] A,int[][] B,int m,int n) {
		int[][] A11 = new int[m][n]; int[][] A12 = new int[m][n]; int[][] A21 = new int[m][n]; int[][] A22 = new int[m][n];
		int[][] B11 = new int[m][n]; int[][] B12 = new int[m][n]; int[][] B21 = new int[m][n]; int[][] B22 = new int[m][n];
		for(int i=0;i<m;i++) {
			for(int j=0;j<n;j++) {
				A11[i][j] = A[i][j]; A12[i][j] = A[i][n+j]; A21[i][j] = A[m+i][j]; A22[i][j] = A[m+i][n+j];
				B11[i][j] = B[i][j]; B12[i][j] = B[i][n+j];	B21[i][j] = B[m+i][j]; B22[i][j] = B[m+i][n+j];
			}
		}
		return StrassenAlgorithm(A11,A12,A21,A22,B11,B12,B21,B22,m,n);
	}
	public int[][] StrassenAlgorithm(int[][] a11,int[][] a12,int[][] a21,int[][] a22,
								     int[][] b11,int[][] b12,int[][] b21,int[][] b22,int m,int n) {
		/*宣告一堆矩陣*/
		int[][] M1 = new int[m][n]; int[][] M2 = new int[m][n];	int[][] M3 = new int[m][n]; 
		int[][] M4 = new int[m][n];	int[][] M5 = new int[m][n]; int[][] M6 = new int[m][n];	
		int[][] M7 = new int[m][n]; int[][] C00 = new int[m][n]; int[][] C = new int[m*2][n*2];
		int[][] C11 = new int[m][n]; int[][] C12 = new int[m][n]; int[][] C21 = new int[m][n]; int[][] C22 = new int[m][n];
		/*Strassen's Algorithm*/
		if(m>64 && n>64) { 
			M1 = DivideAndConquer(ArrayPlus(a11,a22,m,n),ArrayPlus(b11,b22,m,n),m,n);	// M1=(a11+a22)(b11+b22)	
			M2 = DivideAndConquer(ArrayPlus(a21,a22,m,n),b11,m,n);						// M2=(a21+a22)b11
			M3 = DivideAndConquer(a11,ArrayMinus(b12,b22,m,n),m,n);						// M3=a11(b12-b22)
			M4 = DivideAndConquer(a22,ArrayMinus(b21,b11,m,n),m,n);						// M4=a22(b21-b11)
			M5 = DivideAndConquer(ArrayPlus(a11,a12,m,n),b22,m,n);						// M5=(a11+a12)b22
			M6 = DivideAndConquer(ArrayMinus(a21,a11,m,n),ArrayPlus(b11,b12,m,n),m,n);	// M6=(a21-a11)(b11+b12)
			M7 = DivideAndConquer(ArrayMinus(a12,a22,m,n),ArrayPlus(b21,b22,m,n),m,n);	// M7=(a12-a22)(b21+b22)
			C11 = ArrayPlus(ArrayMinus(ArrayPlus(M1,M4,m,n),M5,m,n),M7,m,n);			// C11=M1+M4-M5+M7
			C12 = ArrayPlus(M3,M5,m,n);													// C12=M3+M5
			C21 = ArrayPlus(M2,M4,m,n);													// C21=M2+M4
			C22 = ArrayPlus(ArrayMinus(ArrayPlus(M1,M3,m,n),M2,m,n),M6,m,n);			// C22=M1+M3-M2+M6
			/*合併結果矩陣*/
			for(int i=0;i<m;i++) {
				for(int j=0;j<n;j++) {
					C[i][j] = C11[i][j];
					C[i][n+j] = C12[i][j];
					C[m+i][j] = C21[i][j];
					C[m+i][n+j] = C22[i][j];
				}
			}
			return C;
		}
		/*若遞迴小到一定程度，則執行傳統矩陣乘法*/
		else {
			return TraditionalArrayOperation(a11,a12,a21,a22,b11,b12,b21,b22,m,n);		
		} 		
	}
	/*矩陣加法*/
	public int[][] ArrayPlus(int[][] A,int[][] B,int m,int n) {
		int[][] temp = new int[m][n]; 
		for(int i=0;i<m;i++) {
			for(int j=0;j<n;j++) {
				temp[i][j] = A[i][j] + B[i][j];
			}
		}
		return temp;
	}
	/*矩陣減法*/
	public int[][] ArrayMinus(int[][] A,int[][] B,int m,int n) {
		int[][] temp = new int[m][n]; 
		for(int i=0;i<m;i++) {
			for(int j=0;j<n;j++) {
				temp[i][j] = A[i][j] - B[i][j];
			}
		}
		return temp;
	}
	/*傳統矩陣乘法*/
	public int[][] TraditionalArrayOperation(int[][] a11,int[][] a12,int[][] a21,int[][] a22,
									 	     int[][] b11,int[][] b12,int[][] b21,int[][] b22,int m,int n) {
		int[][] A = new int[2*m][2*n]; int[][] B = new int[2*m][2*n]; int[][] C = new int[2*m][2*n]; 
		int sum = 0;
		for(int i=0;i<m;i++) {
			for(int j=0;j<n;j++) {
				A[i][j] = a11[i][j];
				A[i][n+j] = a12[i][j];
				A[m+i][j] = a21[i][j];
				A[m+i][n+j] = a22[i][j];
				B[i][j] = b11[i][j];
				B[i][n+j] = b12[i][j];
				B[m+i][j] = b21[i][j];
				B[m+i][n+j] = b22[i][j];
			}			
		}
		for(int k=0;k<m+n;k++) {
			for(int i=0;i<m+n;i++) {
				for(int j=0;j<m+n;j++) {
					sum += A[k][j]*B[j][i];
				}
				C[k][i] = sum;
				sum = 0;
			}
		}
		return C;
	}
}
