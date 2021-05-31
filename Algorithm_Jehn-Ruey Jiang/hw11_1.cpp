#include <iostream>
#include <stdio.h>

using namespace std;

int main()
{
    int N,num1,num2;
    cin >> N;
    for(int i=0;i<N;i++){
        cin >> num1 >> num2;
        if(num1>num2) cout << '>' << endl;
        else if(num1<num2) cout << '<' << endl;
        else cout << '=' << endl;
    }
}