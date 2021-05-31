#include <iostream>
#include <vector>

using namespace std;

bool program();
bool stmts();
bool stmt();
bool exp();
bool primary();
bool primary_tail(bool lambda);

bool ID();
bool STRLIT();
bool LBR();
bool RBR();
bool DOT();
bool SEMICOLON();

int pptr;          // pointer for parser

string input;
vector <string> type;
vector <string> output;

int main()
{
    bool valid=true;    // check whether input is valid
    while(cin>>input){
        bool strlit=false;  // to determine strlit has started to count or not
        bool id=false;      // to determine id has started to count or not
        int str_ptr=0;      // the start position of string's counting
        type.clear();
        output.clear();
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
        valid = program();
    }
    if(!valid) cout << "Invalid\n";
    else cout << "Valid\n";
    return 0;
}

bool program(){
    pptr=0;
    return stmts();
}
bool stmts(){
    //cout << "stmts ";
    if(pptr == output.size()) return true;
    if(stmt()) if(stmts()) return true;
    return false;
}
bool stmt(){
    //cout << "stmt ";
    if(exp()) if(SEMICOLON()) return true;
    return false;
}
bool exp(){
    //cout << "exp ";
    if(primary()) return true;
    if(STRLIT())  return true;
    return false;
}
bool primary(){
    //cout << "primary ";
    if(ID()) if(primary_tail(false)) return true;
    return false;
}
bool primary_tail(bool lambda){
    //cout << "tail ";
    if(DOT()) {
        if(ID()) {
            if(primary_tail(false)) return true;
        }
        else pptr--;
    }
    if(LBR()) {
        if(exp()) {
            if(RBR()) {
                if(primary_tail(false)) return true;
            }
        }
        else pptr--;
    }
    if(lambda==false){
        return true;
    }
    return false;
}
bool ID(){
    //cout << "ID ";
    if(type[pptr]=="ID"){
        pptr++;
        return true;
    }
    return false;
}
bool STRLIT(){
    //cout << "STRLIT ";
    if(type[pptr]=="STRLIT"){
        pptr++;
        return true;
    }
    return false;
}
bool LBR(){
    //cout << "LBR ";
    if(type[pptr]=="LBR"){
        pptr++;
        return true;
    }
    return false;
}
bool RBR(){
    //cout << "RBR ";
    if(type[pptr]=="RBR"){
        pptr++;
        return true;
    }
    return false;
}
bool DOT(){
    //cout << "DOT ";
    if(type[pptr]=="DOT"){
        pptr++;
        return true;
    }
    return false;
}
bool SEMICOLON(){
    //cout << "SEMICOLON ";
    if(type[pptr]=="SEMICOLON"){
        pptr++;
        return true;
    }
    return false;
}
