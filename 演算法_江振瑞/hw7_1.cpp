#include <iostream>
#include <stdio.h>
#include <vector>

using namespace std;

int main()
{
    int N;
    while(true){
        cin >> N;
        if(N<0) break;
        int M=1,bit;
        vector<int> v;
        while(M*3<N){
            M*=3;
        }
        while(M>0){
            bit=N/M;
            v.push_back(bit);
            N-=bit*M;
            M/=3;
        }
        for(int i=0;i<v.size();i++){
            cout<<v[i];
        }
        cout<<endl;
    }
    return 0;
}