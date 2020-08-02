#include <iostream>
#include <stdio.h>

using namespace std;

int main()
{
    int n;
    cin >> n;
    for(int i=0;i<n;i++){
        int len,k,sum=0,row,col,step;
        bool finish=false;
        cin >> len >> k;
        // odd -> col2row, even -> row2col
        for(int j=1;j<=len;j++){
            sum += j;
            if(sum>=k){
                step = k-(sum-j);
                if(j%2==1){
                    row = step;
                    col = j-step+1;
                }
                else{
                    row = j-step+1;
                    col = step;
                }
                finish=true;
                break;
            }
        }
        // odd -> row2col, even -> col2row
        if(!finish){
            for(int j=len-1;j>=1;j--){
                sum += j;
                if(sum>=k){
                    step = k-(sum-j);
                    if(j%2==1){
                        row = j-step+1;
                        col = step;
                    }
                    else{
                        row = step;
                        col = j-step+1;
                    }
                    break;
                }
            }
        }
        if(row>(len+1)/2) row=len-row+1;
        if(col>(len+1)/2) col=len-col+1;
        cout << min(row,col) << endl;
    }
    return 0;
}