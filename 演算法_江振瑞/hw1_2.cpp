#include <iostream>
#include <stdio.h>
#include <set>
using namespace std;

int main()
{
    int cn,a,b,sum;
    int p[]={3,5,7,11,13,
             17,19,23,29,31,
             37,41,43,47,53,
             59,61,67,71,73,
             79,83,89,97};
    set<int> pset(p,p+24);
    cin >> cn;
    for(int i=0;i<cn;i++){
        sum=0;
        cin >> a >> b;
        for(int j=a;j<=b;j++){
            if(j%2==1 && pset.find(j)==pset.end()) sum+=j;
        }
        cout << sum << endl;
    }
    return 0;
}