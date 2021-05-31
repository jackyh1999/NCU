#include <iostream>
#include <algorithm>

using namespace std;

int main()
{
int N,k;
cin >> N;
for(int i=0;i<N;i++){
int score[20];
for(int j=0;j<20;j++){
cin >> score[j];
}
sort(score,score+20);
cin >> k;
cout << score[k-1] << endl;
}
return 0;
}