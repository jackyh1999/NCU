#include <iostream>
#include <stdio.h>

using namespace std;

int main()
{
    int cn,stu,sc[1001],sum,h_stu;
    float avg,ans;
    cin >> cn;
    for(int i=0;i<cn;i++){
        sum=0;h_stu=0;
        cin >> stu;
        for(int j=0;j<stu;j++){
            cin >> sc[j];
            sum+=sc[j];
        }
        avg=sum/stu;
        for(int j=0;j<stu;j++){
            if(sc[j]>avg) h_stu++;
        }
        ans=100*(float)h_stu/stu;
        printf("%.3f%%\n",ans);
    }
    return 0;
}