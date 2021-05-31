#include <iostream>

using namespace std;

bool program();
bool stmts();
bool exp(bool stmts);
bool primary();
bool primary_tail();

bool ID();
bool STRLIT();
bool LBR();
bool RBR();
bool DOT();

int pptr;          // pointer for parser
bool stmts_call;   // check if exp() is called by stmts()
string input;
string output[10][2];

int main()
{
    while(cin>>input){
        for(int i=0;i<10;i++) for(int j=0;j<2;j++) output[i][j]=""; // initialize array
        int sptr=0;          // pointer for scanner
        bool valid=true;    // check whether input is valid
        bool strlit=false;  // to determine strlit has started to count or not
        bool id=false;      // to determine id has started to count or not
        int str_ptr=0;      // the start position of string's counting
        /* scanner start */
        for(int i=0;i<input.length();i++){
            if(input[i]=='('){
                output[sptr][0]="LBR";
                output[sptr][1]="(";
                sptr++;
            }
            else if(input[i]==')'){
                output[sptr][0]="RBR";
                output[sptr][1]=")";
                sptr++;
            }
            else if(input[i]=='.'){
                output[sptr][0]="DOT";
                output[sptr][1]=".";
                sptr++;
            }
            else if(input[i]=='"'){
                if(strlit){
                    output[sptr][0]="STRLIT";
                    output[sptr][1]=input.substr(str_ptr,i+1-str_ptr);
                    sptr++;
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
                if(id){
                    /* If the next character is lpr,dot. Or it's the last character in input string */
                    if(input.length()==(i+1)||input[i+1]=='('||input[i+1]=='.'){
                        id=false;
                        output[sptr][0]="ID";
                        output[sptr][1]=input.substr(str_ptr,i+1-str_ptr);
                        sptr++;
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
        if(!valid) {
            cout << "invalid input\n";
            continue;
        }
        /* parser start */
        valid = program();
        if(!valid) cout << "invalid input\n";
        else for(int i=0;i<sptr;i++) cout << output[i][0] << " " << output[i][1] << "\n";
    }
    return 0;
}

bool program(){
    pptr=0;
    stmts_call=true;
    return stmts();
}
bool stmts(){
    if(exp(stmts_call)) if(stmts()) return true;
    return true;
}
bool exp(bool stmts){
    if(primary()) return true;
    if(STRLIT()) return true;
    if(stmts) return false;
    return true;
}
bool primary(){
    if(ID()) if(primary_tail()) return true;
    return false;
}
bool primary_tail(){
    if(DOT()) if(ID()) if(primary_tail()) return true;
    if(LBR()) if(exp(!stmts_call)) if(RBR()) if(primary_tail()) return true;
    return true;
}
bool ID(){
    if(output[pptr][0]=="ID"){
        pptr++;
        return true;
    }
    return false;
}
bool STRLIT(){
    if(output[pptr][0]=="STRLIT"){
        pptr++;
        return true;
    }
    return false;
}
bool LBR(){
    if(output[pptr][0]=="LBR"){
        pptr++;
        return true;
    }
    return false;
}
bool RBR(){
    if(output[pptr][0]=="RBR"){
        pptr++;
        return true;
    }
    return false;
}
bool DOT(){
    if(output[pptr][0]=="DOT"){
        pptr++;
        return true;
    }
    return false;
}
