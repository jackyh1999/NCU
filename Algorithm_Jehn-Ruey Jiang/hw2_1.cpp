#include <iostream>

using namespace std;

int main()
{
    int n;
    while(cin>>n){
        int sum=1;
        for(int i=3;i<=n;i+=2){
            sum+=i*2;
        }
        sum=sum*3-6;
        cout << sum << endl;
    }
    return 0;
}