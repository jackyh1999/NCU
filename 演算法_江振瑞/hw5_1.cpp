#include <iostream>
#include <stdio.h>

using namespace std;

int main()
{
    int N;
    cin >> N;
    float a[N];
    float box[N];
    for(int i=0;i<N;i++){
        cin >> a[i];
        box[i] = 1;
    }
    int box_num = 0;
    for(int i=0;i<N;i++){
        for(int j=0;j<N;j++){
            if(box[j]>=a[i]){
                box[j]-=a[i];
                if(j>box_num) box_num=j;
                break;
            }
        }
    }
    cout << box_num+1;
    return 0;
}