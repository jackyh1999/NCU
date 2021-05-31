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
    /* �p�G�Oterminal�h����return */
    if(isTerminal(ch)) return "" + ch;

    /* �M���enonterminal�bvector����index */
    int index = Findindex(vnonterminal,ch);

    for(int i=0;i<vgrammer[index].length();i++){
        int temp = -1;
        /* �p�G��e�r����'|'�A�h����U�@�Ӧr�� */
        if(vgrammer[index][i]=='|') continue;
        /* �M���egrammar�bvector����index */
        if(isNonterminal(vgrammer[index][i])) temp = Findindex(vnonterminal,vgrammer[index][i]);
        /* �p�G��egrammar��First Set���]�t';' */
        if(!isContain( First(vgrammer[index][i],index), ';' )){
            /* ��First Set�[��First Set */
            /* temp>=0�A��egrammar��nonterminal */
            if(temp>=0){
                /* �קK�[�J���Ʀr�� */
                for(int j=0;j<firstset[temp].length();j++){
                    if(!isContain(firstset[index],firstset[temp][j])) firstset[index] += firstset[temp][j];
                }
            }
            /* temp<0�A��egrammar��terminal */
            else if(!isContain(firstset[index],vgrammer[index][i])) firstset[index] +=  vgrammer[index][i];

            for(int j=i;j<vgrammer[index].size();j++){
                /* ��������'|'���U�@�r�� */ /* �p�G�w�gŪ��̫�A�h���X�j��*/
                if(vgrammer[index][j]=='|' || j==vgrammer[index].size()-1){
                    i=j;
                    break;
                }
            }
        }
        /* �p�G��egrammar��First Set�]�t';' */
        else{
            /* temp>=0�A��egrammar��nonterminal */
            if(temp>=0){
                for(int j=0;j<firstset[temp].length();j++){
                    /* �קK�[�J���Ʀr�� */
                    if(!isContain(firstset[index],firstset[temp][j])) {
                        /* �p�G��e�O�̫�r���A�Ϊ̤U�@�Ӧr���O'|'�A�h�[�J';' */
                        if(firstset[temp][j]==';'){
                            if(i==vgrammer[index].length()-1 || vgrammer[index][i+1]=='|') firstset[index] +=  firstset[temp][j];
                        }
                        else{
                            firstset[index] +=  firstset[temp][j];
                        }
                    }
                }
            }
            /* temp<0�A��egrammar��terminal */ /* �קK�[�J���Ʀr�� */
            else if(!isContain(firstset[index],vgrammer[index][i])){
                /* �p�G��e�O�̫�r���A�Ϊ̤U�@�Ӧr���O'|'�A�h�[�J';' */
                if(vgrammer[index][i]==';'){
                    if(i==vgrammer[index].length()-1 || vgrammer[index][i+1]=='|') firstset[index] +=  vgrammer[index][i];
                }
                else firstset[index] +=  vgrammer[index][i];
            }
        }
        /* �YŪ���Ҧ�grammar�Areturn */
        if(i==vgrammer[index].length()-1) return firstset[index];
    }
}
/* �M��nonterminal�bvector����index */
int Findindex(vector<char> v, char c){
    for(int i=0;i<v.size();i++) if(v[i]==c) return i;
    return -1;
}
/* �P�_�r���O�_��terminal */
bool isTerminal(char c){
    if( (c>='a' && c<='z') || c==';' || c=='$') return true;
    return false;
}
/* �P�_�r���O�_��nonterminal */
bool isNonterminal(char c){
    if(c>='A' && c<='Z') return true;
    return false;
}
/* �P�_�Y�Ӧr���O�_�b�r��� */
bool isContain(string s,char c){
    for(int i=0;i<s.length();i++) if(s[i]==c) return true;
    return false;
}
/* �ƧǩҦ�First Set */
void SortFirstSet(){
    for(int i=0;i<firstset.size();i++) for(int j=0;j<firstset[i].length();j++) for(int k=0;k<firstset[i].length()-1;k++)
    if(firstset[i][k]>firstset[i][k+1]){
        char temp = firstset[i][k];
        firstset[i][k] = firstset[i][k+1];
        firstset[i][k+1] = temp;
    }
}
/* �ƧǩҦ�Vector */
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
