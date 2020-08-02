#include <iostream>
#include <stdio.h>

using namespace std;

int main()
{
    int N,W;
    cin >> N;
    for(int i=0;i<N;i++){
        int w[6];
        int v[6];

        cin >> W;
        for(int j=1;j<6;j++){
            cin >> w[j];
        }
        for(int j=1;j<6;j++){
            cin >> v[j];
        }

        int dp[6][W+1];
        for(int m=0;m<6;m++){
            for(int n=0;n<W+1;n++){
                dp[m][n]=0;
            }
        }

        for(int m=1;m<6;m++){
            for(int n=0;n<W+1;n++){
                if(w[m]<=n){
                    dp[m][n]=max(dp[m-1][n],v[m]+dp[m-1][n-w[m]]);
                }
                else{
                    dp[m][n]=dp[m-1][n];
                }
            }
        }

        cout << dp[5][W] << endl;
    }
    return 0;
}