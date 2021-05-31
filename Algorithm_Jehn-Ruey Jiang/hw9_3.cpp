#include <iostream>
#include <stdio.h>

using namespace std;

int main()
{
    string s,t;
    while(cin >> s >> t){
        int i=0;
        for(int j=0;j<t.length();j++){
            if(s[i]==t[j]) i++;
        }
        if(i==s.length()) cout << "Yes" << endl;
        else cout << "No" << endl;
    }
    return 0;
}