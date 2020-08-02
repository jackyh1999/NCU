#include <iostream>
#include <stdio.h>

using namespace std;

int main()
{
    int N,n;
    cin >> N;
    for(int i=0;i<N;i++){
        cin >> n;
        int brick[n],sum=0,avg,Count=0;
        for(int j=0;j<n;j++){
            cin >> brick[j];
            sum += brick[j];
        }
        avg = sum/n;
        for(int j=0;j<n;j++){
            if(brick[j]>avg) Count += brick[j]-avg;
        }
        cout << Count << endl;
    }
    return 0;
}