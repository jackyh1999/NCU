#include <iostream>

using namespace std;

int main()
{
    bool check,invalid;
    string s;
    int top_int,top_ch,top_o,isp,icp; //isp:in-stack priority //icp:incoming priority
    int int_stack[100],out_stack[100];
    char ch_stack[100],out[100];
    while(getline(cin,s)){
        /*check=false;
        for(int i=0; i<s.length(); i++){
            if(i==0&&(s[i]>=' '&&s[i]<='/')&&s[i]!='('){
                cout << "The expression is invalid." << endl;
                invalid=true;
                break;
            }
            else if(i==s.length()-2&&(s[i]>=' '&&s[i]<='/')&&s[i+1]==' '&&s[i]!=')'){
                cout << "The expression is invalid." << endl;
                invalid=true;
                break;
            }
            else if((s[i]>=' '&&s[i]<='/')&&s[i]!=')'){
                if(check==true&&(s[i]>=' '&&s[i]<='/')&&s[i]!='('){
                    cout << "The expression is invalid." << endl;
                    invalid=true;
                    break;
                }
                else if(s[i]==')'&&s[i+1]=='('){
                    cout << "The expression is invalid." << endl;
                    invalid=true;
                    break;
                }
                else check=true;
            }
            else if(s[i]>='0'&&s[i]<='9') check=false;
        }*/
        //invalid==false
        if(1){
            top_int=-1; top_ch=-1; top_o=-1;
            isp=-1; icp=-1;
            for(int i=0; i<s.length(); i++){
                if(s[i]<='9'&&s[i]>='0'){
                    top_int++; top_o++;
                    int_stack[top_int]=s[i]-'0';
                    out[top_o]=int_stack[top_int]+'0';
                    cout << int_stack[top_int];
                }
                else{
                    switch(s[i]){
                    //priority:
                    //' '=0
                    //'+'=1,'-'=1
                    //'*'=2,'/'=2,'%'=2
                    //'('=3,')'=4
                    case'+': icp=1; break;
                    case'-': icp=1; break;
                    case'*': icp=2; break;
                    case'/': icp=2; break;
                    case'%': icp=2; break;
                    case'(': icp=3; break;
                    case')': icp=4; break;
                    case' ': icp=0; break;
                    }
                    if(icp>isp&&s[i]!=')'){
                        top_ch++;
                        ch_stack[top_ch]=s[i];
                        if(s[i]!='(') isp=icp;
                        else if(s[i]=='(') isp=0;
                    }
                    else{
                        while(top_ch>=0){
                            if(s[i]==')'){
                                if(ch_stack[top_ch]=='('){
                                    if(ch_stack[top_ch]!='('){
                                        top_o++;
                                        out[top_o]=ch_stack[top_ch];
                                        cout << ch_stack[top_ch];
                                    }
                                    top_ch--;
                                }
                                else{
                                    if(ch_stack[top_ch]!=')'){
                                        top_o++;
                                        out[top_o]=ch_stack[top_ch];
                                        cout << ch_stack[top_ch];
                                    }
                                    top_ch--;
                                }
                            }
                            else{
                                if(ch_stack[top_ch]=='(') break;
                                else{
                                    if(ch_stack[top_ch]!=')'){
                                        top_o++;
                                        out[top_o]=ch_stack[top_ch];
                                        cout << ch_stack[top_ch];
                                    }
                                    top_ch--;
                                }
                            }
                        }
                        if(s[i]!=')'){
                            top_ch++;
                            ch_stack[top_ch]=s[i];
                            isp=icp;
                        }
                    }
                }
            }
            cout << " = " ;
            top_int=-1;
            for(int j=0; j<=top_o; j++){
                if(out[j]>='0'&&out[j]<='9'){
                    top_int++;
                    out_stack[top_int]=out[j]-'0';
                }
                else{
                    switch(out[j]){
                    case'+': out_stack[top_int-1]=out_stack[top_int]+out_stack[top_int-1]; break;
                    case'-': out_stack[top_int-1]=out_stack[top_int-1]-out_stack[top_int]; break;
                    case'*': out_stack[top_int-1]=out_stack[top_int]*out_stack[top_int-1]; break;
                    case'/': out_stack[top_int-1]=out_stack[top_int-1]/out_stack[top_int]; break;
                    case'%': out_stack[top_int-1]=out_stack[top_int-1]%out_stack[top_int]; break;
                    }
                    top_int--;
                }
            }
            cout << out_stack[top_int] << endl;
        }
        else invalid=false;
    }
    return 0;
}
