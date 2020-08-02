#include <iostream>
#include <stdio.h>

using namespace std;

int main()
{
    int N,M;
    cin >> N;
    for(int i=0;i<N;i++){
        cin >> M;
        int A[M];
        bool flag=true;
        for(int j=0;j<M;j++){
            cin >> A[j];
        }
        for(int j=0;j<M-2;j++){
            for(int k=j+1;k<M-1;k++){
                for(int m=k+1;m<M;m++){
                    if(A[j]+A[k]==A[m]){
                        flag=false;
                        break;
                    }
                    else if(A[j]+A[k]<A[m]){
                        break;
                    }
                }
                if(!flag) break;
            }
            if(!flag) break;
        }
        if(flag) cout << "true\n";
        else cout << "false\n";
    }
    return 0;
}