#include <iostream>
#include <stdio.h>

using namespace std;

int main()
{
    int caseNum;
    cin>>caseNum;
    int order=0;
    for(int i=0;i<caseNum;i++){
        int down,up;
        cin>>down>>up;
        if(down%2==0){
            down++;
        }
        if(up%2==0){
            up--;
        }
        int n = (up-down)/2+1;
        order++;
        cout<<"Case "<<order<<": "<<n*(2*down+(n-1)*2)/2<<endl;
    }
}