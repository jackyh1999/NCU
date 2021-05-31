#include <iostream>
#include <algorithm>

using namespace std;

int main()
{
    int n;
    while(cin>>n){
        if(n==0) break;
        int A[n];
        for(int i=0;i<n;i++){
            cin >> A[i];
        }
        sort(A,A+n);
        for(int i=0;i<n;i++){
            cout << A[i];
            if(i<n-1) cout << ' ';
            else cout << '\n';
        }
    }
    return 0;
}