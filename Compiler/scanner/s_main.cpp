#include <iostream>

using namespace std;

int main()
{
    int num=0;
    int op=0;
    int lpr=0;
    int rpr=0;
    int ptr=0;
    int str_ptr;
    bool id=false;
    string input;
    string output[1001];
    while(cin >> input){
        for(int i=0;i<input.length();i++){
            if(input[i]=='('){
                lpr++;
                output[ptr]="LPR";
                ptr++;
            }
            else if(input[i]==')'){
                rpr++;
                output[ptr]="RPR";
                ptr++;
            }
            else if(input[i]=='+'){
                op++;
                output[ptr]="PLUS";
                ptr++;
            }
            else if(input[i]=='-'){
                op++;
                output[ptr]="MINUS";
                ptr++;
            }
            else if(input[i]=='*'){
                op++;
                output[ptr]="MUL";
                ptr++;
            }
            else if(input[i]=='/'){
                op++;
                output[ptr]="DIV";
                ptr++;
            }
            else if(input[i]>='0'&&input[i]<='9'){
                if(!id){
                    id=true;
                    str_ptr=i;
                }
                if(id){
                    if(i+1==input.length()||input[i+1]=='+'||input[i+1]=='-'||input[i+1]=='*'||input[i+1]=='/'||input[i+1]=='('||input[i+1]==')'){
                        output[ptr]="NUM ";
                        output[ptr]+=input.substr(str_ptr,i+1-str_ptr);
                        num++;
                        ptr++;
                        id=false;
                    }
                }
            }
        }
    }
    for(int i=0;i<ptr;i++){
        cout << output[i] << "\n";
    }
    return 0;
}
