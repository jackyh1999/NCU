#include <iostream>
#include <stdio.h>

using namespace std;

int main()
{
    int caseNum,n,k;
    cin >> caseNum;
    for(int i=0;i<caseNum;i++){
        cin >> n >> k;
        int tabakko = n;
        int remain = 0;
        while(n>=k){
            remain = n%k;
            tabakko += n/k;
            n = (n/k)+remain;
        }
        cout << tabakko << endl;
    }
}