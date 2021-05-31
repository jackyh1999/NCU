#include <iostream>
#include <stdio.h>
#include <map>

using namespace std;

int main()
{
    int m=0,n;
    string s;
    while(cin >> n){
        int coolnum = 0;
        for(int i=0;i<n;i++){
            cin >> s;
            map<char,int> cool;
            map<int,char> cool_rev;
            map<char,int>::iterator it;
            for(int j=0;j<s.length();j++){
                cool[s[j]]++;
            }
            if(cool.size()<2) continue;
            for(it=cool.begin();it!=cool.end();it++){
                cool_rev[it->second]=it->first;
            }
            if(cool.size()!=cool_rev.size()) continue;
            coolnum++;
        }
        m++;
        cout << "Case " << m << ": " << coolnum << endl;
    }
}