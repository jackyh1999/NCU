#include <iostream>
#include <string>

using namespace std;

void perm(string str,int a){
    a++;
    string temp_str=str;
    char temp_ch1,temp_ch2;
    if(a<str.length()-1){
        for(int i=a,j=0;i<str.length();i++,j++){
            str=temp_str;
            temp_ch1=str[a];
            temp_ch2=str[a+j];
            str[a]=temp_ch2;
            str[a+j]=temp_ch1;
            if(a==str.length()-2){
                cout<<str<<" ";
            }
            perm(str,a);
        }

    }
}
int main()
{
    string input;
    while(cin>>input){
        perm(input,-1);
    }
    return 0;
}