#include <iostream>
#include <vector>
using namespace std;

string First(char ch,int ptr);
int Findindex(vector<char> v, char c);
bool isTerminal(char c);
bool isNonterminal(char c);
bool isContain(string s,char c);
void SortFirstSet();
void SortVector();
std::vector<char> vnonterminal;
std::vector<string> vgrammer;
std::vector<string> firstset;
int main()
{
    string nonterminal;
    string grammer;
    while(true){
        cin >> nonterminal;
        if(nonterminal=="END_OF_GRAMMAR") break;
        cin >> grammer;
        vnonterminal.push_back(nonterminal[0]);
        vgrammer.push_back(grammer);
        firstset.push_back("");
    }
    for(int i=0;i<vnonterminal.size();i++) First(vnonterminal[i],i);
    SortFirstSet();
    SortVector();
    for(int i=0;i<vnonterminal.size();i++) cout << vnonterminal[i] << " " << firstset[i] << "\n";
    cout << "END_OF_FIRST\n";
    return 0;
}
string First(char ch,int ptr){
    /* 如果是terminal則直接return */
    if(isTerminal(ch)) return "" + ch;

    /* 尋找當前nonterminal在vector中的index */
    int index = Findindex(vnonterminal,ch);

    for(int i=0;i<vgrammer[index].length();i++){
        int temp = -1;
        /* 如果當前字元為'|'，則跳到下一個字元 */
        if(vgrammer[index][i]=='|') continue;
        /* 尋找當前grammar在vector中的index */
        if(isNonterminal(vgrammer[index][i])) temp = Findindex(vnonterminal,vgrammer[index][i]);
        /* 如果當前grammar的First Set不包含';' */
        if(!isContain( First(vgrammer[index][i],index), ';' )){
            /* 把First Set加到First Set */
            /* temp>=0，當前grammar為nonterminal */
            if(temp>=0){
                /* 避免加入重複字元 */
                for(int j=0;j<firstset[temp].length();j++){
                    if(!isContain(firstset[index],firstset[temp][j])) firstset[index] += firstset[temp][j];
                }
            }
            /* temp<0，當前grammar為terminal */
            else if(!isContain(firstset[index],vgrammer[index][i])) firstset[index] +=  vgrammer[index][i];

            for(int j=i;j<vgrammer[index].size();j++){
                /* 直接跳到'|'的下一字元 */ /* 如果已經讀到最後，則跳出迴圈*/
                if(vgrammer[index][j]=='|' || j==vgrammer[index].size()-1){
                    i=j;
                    break;
                }
            }
        }
        /* 如果當前grammar的First Set包含';' */
        else{
            /* temp>=0，當前grammar為nonterminal */
            if(temp>=0){
                for(int j=0;j<firstset[temp].length();j++){
                    /* 避免加入重複字元 */
                    if(!isContain(firstset[index],firstset[temp][j])) {
                        /* 如果當前是最後字元，或者下一個字元是'|'，則加入';' */
                        if(firstset[temp][j]==';'){
                            if(i==vgrammer[index].length()-1 || vgrammer[index][i+1]=='|') firstset[index] +=  firstset[temp][j];
                        }
                        else{
                            firstset[index] +=  firstset[temp][j];
                        }
                    }
                }
            }
            /* temp<0，當前grammar為terminal */ /* 避免加入重複字元 */
            else if(!isContain(firstset[index],vgrammer[index][i])){
                /* 如果當前是最後字元，或者下一個字元是'|'，則加入';' */
                if(vgrammer[index][i]==';'){
                    if(i==vgrammer[index].length()-1 || vgrammer[index][i+1]=='|') firstset[index] +=  vgrammer[index][i];
                }
                else firstset[index] +=  vgrammer[index][i];
            }
        }
        /* 若讀完所有grammar，return */
        if(i==vgrammer[index].length()-1) return firstset[index];
    }
}
/* 尋找nonterminal在vector中的index */
int Findindex(vector<char> v, char c){
    for(int i=0;i<v.size();i++) if(v[i]==c) return i;
    return -1;
}
/* 判斷字元是否為terminal */
bool isTerminal(char c){
    if( (c>='a' && c<='z') || c==';' || c=='$') return true;
    return false;
}
/* 判斷字元是否為nonterminal */
bool isNonterminal(char c){
    if(c>='A' && c<='Z') return true;
    return false;
}
/* 判斷某個字元是否在字串裡 */
bool isContain(string s,char c){
    for(int i=0;i<s.length();i++) if(s[i]==c) return true;
    return false;
}
/* 排序所有First Set */
void SortFirstSet(){
    for(int i=0;i<firstset.size();i++) for(int j=0;j<firstset[i].length();j++) for(int k=0;k<firstset[i].length()-1;k++)
    if(firstset[i][k]>firstset[i][k+1]){
        char temp = firstset[i][k];
        firstset[i][k] = firstset[i][k+1];
        firstset[i][k+1] = temp;
    }
}
/* 排序所有Vector */
void SortVector(){
    for(int i=0;i<vnonterminal.size();i++) for(int j=0;j<vnonterminal.size()-1;j++)
        if(vnonterminal[j]>vnonterminal[j+1]){
            char temp = vnonterminal[j];
            vnonterminal[j] = vnonterminal[j+1];
            vnonterminal[j+1] = temp;
            string stemp = firstset[j];
            firstset[j] = firstset[j+1];
            firstset[j+1] = stemp;
        }
}
