#include <iostream>

using namespace std;
int output=0;
void dimi(string str){
    string temp_str=str;
    char temp_ch;
    int start,a=1,b=-1; //a紀錄開始去除的位置
    bool button=false;
    for(int i=0;i<str.length();i++){
        temp_ch=str[i];
        if(button==false&&temp_ch==str[i-1]){
            start=i-1;
            button=true;
        }
        else{
            b++;
        }
        if(button==true&&temp_ch==str[i-1]){
            a++;
        }
        if((button==true&&temp_ch!=str[i-1])||(i+1)>=str.length()){
            if(b!=i){
            button=false;
            str.erase(start,a);
            if(str.length()==0){
                output=1;
                break;
            }
            dimi(str);
            str=temp_str;
            a=1;
            }
        }
    }
}
int main()
{
    int input_int;
    string input;
    cin>>input_int;
    for(int i=0;i<input_int;i++){
        cin>>input;
        dimi(input);
        cout<<output<<"\n";
        output=0;
    }
    return 0;
}