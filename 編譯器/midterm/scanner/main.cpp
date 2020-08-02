#include <iostream>
#include <vector>

using namespace std;

//string output[10][2];
int main()
{
    string input;
    vector <string> type;
    vector <string> output;
    bool valid=true;    // check whether input is valid
    while(cin>>input){
        bool strlit=false;  // to determine strlit has started to count or not
        bool id=false;      // to determine id has started to count or not
        int str_ptr=0;      // the start position of string's counting
        /* scanner start */
        for(int i=0;i<input.length();i++){
            if(input[i]=='('){
                if(!strlit){
                    type.push_back("LBR");
                    output.push_back("(");
                }
            }
            else if(input[i]==')'){
                if(!strlit){
                    type.push_back("RBR");
                    output.push_back(")");
                }
            }
            else if(input[i]=='.'){
                if(!strlit){
                    type.push_back("DOT");
                    output.push_back(".");
                }
            }
            else if(input[i]==';'){
               if(!strlit){
                    type.push_back("SEMICOLON");
                    output.push_back(";");
                }
            }
            else if(input[i]=='"'){
                if(strlit){
                    type.push_back("STRLIT");
                    output.push_back(input.substr(str_ptr,i+1-str_ptr));
                    strlit=false;
                    id=false;
                }
                else{
                    strlit=true;
                    str_ptr=i;
                }
            }
            else if((input[i]>='0'&&input[i]<='9')||((input[i]>='a')&&(input[i]<='z'))||
                   ((input[i]>='A')&&(input[i]<='Z'))||input[i]=='_'){
                if(!id&&!strlit){
                    /* the first character cannot be a number */
                    if(input[i]>='0'&&input[i]<='9'){
                        valid=false;
                        break;
                    }
                    id=true;
                    str_ptr=i;
                }
                if(!id && strlit){
                    id=true;
                }
                if(id){
                    /* If the next character is lpr,dot. Or it's the last character in input string */
                    if(input.length()==(i+1)||input[i+1]=='('||input[i+1]=='.'||input[i+1]==';'){
                        id=false;
                        type.push_back("ID");
                        output.push_back(input.substr(str_ptr,i+1-str_ptr));
                    }
                }
            }
            /* invalid input */
            else{
                valid=false;
                break;
            }
        }
        /* scanner end */
        if(strlit) valid=false;
    }
    if(!valid) cout << "invalid input\n";
    else for(int i=0;i<output.size();i++) cout << type[i] << " " << output[i] << "\n";
    return 0;
}
