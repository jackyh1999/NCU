#include <iostream>
#include <stdio.h>

using namespace std;

int main()
{
    int caseNum,N;
    cin >> caseNum;
    for(int i=0;i<caseNum;i++){
        cin >> N;
        if(N==0) cout << "0\n";
        else if(N==1) cout << "1\n";
        else{
            int num = 9;
            int Q[10] = {0,0,0,0,0,0,0,0,0,0};
            while(num>1){
                if(N%num!=0){
                    num--;
                }
                else{
                    N/=num;
                    Q[num]++;
                }
            }
            num = 2;
            if(N>1) cout << "-1";
            else{
                while(num<10){
                if(Q[num]>0){
                    cout << num;
                    Q[num]--;
                }
                else num++;
                }
            }
            cout << endl;
        }
    }
}