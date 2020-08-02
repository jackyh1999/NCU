#include <iostream>
#include <stdio.h>

using namespace std;

int main()
{
    int n;
    cin >> n;
    for(int i=0;i<n;i++){
        int page=1,total=0,num;
        cin >> num;
        while(total<=num){
            total+=page;
            page++;
        }
        page--;
        cout << total-num << " " << page << endl;
    }
    return 0;
}