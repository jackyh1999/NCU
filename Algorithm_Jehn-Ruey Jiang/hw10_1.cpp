#include <iostream>
#include <stdio.h>

using namespace std;

int main()
{
    int N;
    cin >> N;
    for(int i=0;i<N;i++){
        string X,Y;
        cin >> X >> Y;
        int m = X.length();
        int n = Y.length();
        int c[m+1][n+1];
        for(int j=0;j<=m;j++){
            for(int k=0;k<=n;k++){
                c[j][k] = 0;
            }
        }
        for(int j=1;j<=m;j++){
            for(int k=1;k<=n;k++){
                if(X[j-1]==Y[k-1]){
                    c[j][k] = c[j-1][k-1]+1;
                }
                else if(c[j-1][k]>=c[j][k-1]){
                    c[j][k] = c[j-1][k];
                }
                else{
                    c[j][k] = c[j][k-1];
                }
            }
        }
        int max_len = -1;
        for(int j=0;j<=m;j++){
            for(int k=0;k<=n;k++){
                if(c[j][k]>max_len) max_len = c[j][k];
            }
        }
        cout << max_len << endl;
    }
    return 0;
}