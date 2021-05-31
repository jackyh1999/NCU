#include <iostream>

using namespace std;

void mplus()
{

}

int main()
{
    //int input1[100][100],input2[100][100],input3[100][100];
    //&&(b!='|'||c!='\n')
    int input_value;
    typedef struct
    {
        int row[10001];
        int column[10001];
        int value[10001];
    } matrix;
    matrix m1,m2,m3;
    int v,temp_column,temp_row;
    char a,b,c;
    for(int m=0; m<3; m++)
    {
        v=1,temp_column=0,temp_row=0;
        b='0',c='0';
        for(int i=0; i<100&&b!='|'; i++)
        {
            a='0';
            temp_row++;
            for(int j=0; j<100&&a!='\n'; j++)
            {
                try{
                    cin>>input_value;
                }
                catch(char e){
                    cin.get(b);
                }
                if(i==0)
                {
                    temp_column++;
                }
                if(input_value!=0)
                {

                    if(m==0)
                    {
                        m1.row[v]=i;
                        m1.column[v]=j;
                        m1.value[v]=input_value;
                    }
                    else if(m==1)
                    {
                        m2.row[v]=i;
                        m2.column[v]=j;
                        m2.value[v]=input_value;
                    }
                    else if(m==2)
                    {
                        m3.row[v]=i;
                        m3.column[v]=j;
                        m3.value[v]=input_value;
                    }
                    v++;

                }
                cin.get(a);
            }
            if(m>=1&&b=='\n')
            {
                break;
            }
            /*cin.get(b);

            cin.get(c);*/
        }
        if(m==0)
        {
            m1.column[0]=temp_column;
            m1.row[0]=temp_row;
            m1.value[0]=v;
        }
        else if(m==1)
        {
            m2.column[0]=temp_column;
            m2.row[0]=temp_row;
            m2.value[0]=v;
        }
        else if(m==2)
        {
            m3.column[0]=temp_column;
            m3.row[0]=temp_row;
            m3.value[0]=v;
        }
    }
    cout<<"hello world!";
    for(int i=0; i<10; i++)
    {
        cout<<m1.row[i]<<" "<<m1.column[i]<<" "<<m1.value[i]<<"\n";
    }
    return 0;
}