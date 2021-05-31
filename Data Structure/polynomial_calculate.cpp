#include <iostream>
#include <stdlib.h>

using namespace std;
typedef struct poly_node *poly_pointer;
typedef struct poly_node
{
    int coef;
    int expo;
    poly_pointer link;
};
void addc(poly_pointer *top, poly_pointer *rear, int coef)
{
    poly_pointer temp=(poly_pointer)malloc(sizeof(poly_node));
    temp->coef=coef;
    (*rear)->link=temp;
    (*rear)=temp;
}
int compare(int expo_a,int expo_b)
{
    if(expo_a>expo_b)
    {
        return 1;
    }
    else if(expo_a==expo_b)
    {
        return 0;
    }
    else if(expo_a<expo_b)
    {
        return -1;
    }
}
void attach(int coeff,int expon,poly_pointer *ptr)
{
    poly_pointer temp;
    temp=(poly_pointer)malloc(sizeof(poly_node));
    temp->coef=coeff;
    temp->expo=expon;
    (*ptr)->link=temp;
    *ptr=temp;
}
poly_pointer padd(poly_pointer a,poly_pointer b,poly_pointer d)
{
    poly_pointer top,temp;
    int sum;
    d=(poly_pointer)malloc(sizeof(poly_node));
    top=d;
    while(a&&b)
    {
        switch(compare(a->expo,b->expo))
        {
        case -1: //a<b
            attach(b->coef,b->expo,&d);
            b=b->link;
            break;
        case 0: //a=b
            sum=a->coef+b->coef;
            if(sum)
            {
                attach(sum,a->expo,&d);
            }
            a=a->link;
            b=b->link;
            break;
        case 1: //a>b
            attach(a->coef,a->expo,&d);
            a=a->link;
        }
    }
    for(; a; a=a->link)
    {
        attach(a->coef,a->expo,&d);
    }
    for(; b; b=b->link)
    {
        attach(b->coef,b->expo,&d);
    }
    d->link=NULL;
    temp=top;
    top=top->link;
    free(temp);
    return top;
}
void poly_erase(poly_pointer *ptr)
{
    poly_pointer temp;
    while(*ptr)
    {
        temp=*ptr;
        *ptr=(*ptr)->link;
        free(temp);
    }
}
int main()
{
    string poly_a,poly_b;
    char op;
    int x,sum,temp_sum,ct=0;
    int curr;
    bool mi,de,check;

    poly_pointer a,top_a,b,top_b,d,top_d;
    poly_node temp_A,temp_B,temp_D;
    temp_A.coef=0;
    temp_A.expo=0;
    temp_A.link=NULL;
    temp_B.coef=0;
    temp_B.expo=0;
    temp_B.link=NULL;
    temp_D.coef=0;
    temp_D.expo=0;
    temp_D.link=NULL;
    a=&temp_A;
    b=&temp_B;
    d=&temp_D;
    top_a=a;
    top_b=b;
    top_d=d;
    while(cin>>poly_a>>op>>poly_b>>x)
    {
        curr=0;
        mi=false;
        de=false;
        check=false;
        if(op=='-'){
            mi=true;
        }
        while(curr<poly_a.length())
        {
            if(poly_a[curr]>='0'&&poly_a[curr]<='9')
            {
                if(poly_a[curr-1]=='+'||poly_a[curr-1]=='(')
                {
                    if(poly_a[curr+1]==')')
                    {
                        addc(&top_a,&a,(int)(poly_a[curr]-'0'));
                        a->expo=0;
                        a->link=NULL;
                    }
                    else
                    {
                        addc(&top_a,&a,(int)(poly_a[curr]-'0'));
                    }
                }
                else if(poly_a[curr-1]=='-')
                {
                    if(poly_a[curr+1]==')')
                    {
                        addc(&top_a,&a,(int)(poly_a[curr]-'0'));
                        a->coef=a->coef*(-1);
                        a->expo=0;
                        a->link=NULL;
                    }
                    else
                    {
                        addc(&top_a,&a,(int)(poly_a[curr]-'0'));
                        a->coef=a->coef*(-1);
                    }
                }
                else if(poly_a[curr-1]=='^')
                {
                    a->expo=(int)(poly_a[curr]-'0');
                }
            }
            else if(poly_a[curr]=='\''){
                de=true;
            }
            else
            {
                if(poly_a[curr]=='x'&&(poly_a[curr-1]=='('||poly_a[curr-1]=='+'))
                {
                    addc(&top_a,&a,1);
                    if(poly_a[curr+1]!='^')
                    {
                        a->expo=1;
                        if(poly_a[curr+1]==')')
                        {
                            a->link=NULL;
                        }
                    }
                }
                else if(poly_a[curr]=='x'&&poly_a[curr-1]=='-')
                {
                    addc(&top_a,&a,-1);
                    if(poly_a[curr+1]!='^')
                    {
                        a->expo=1;
                        if(poly_a[curr+1]==')')
                        {
                            a->link=NULL;
                        }
                    }
                }
                else if(poly_a[curr]=='x'&&poly_a[curr-1]>='2'&&poly_a[curr-1]<='9'&&poly_a[curr+1]!='^'){
                    a->expo=1;
                }
            }
            curr++;
        }
        if(de){
            a=top_a;
            for(;a;a=a->link){
                a->coef=(a->coef)*(a->expo);
                a->expo--;
                if(a->expo==-1){
                    a->coef=0;
                    a->expo=0;
                }
            }
        }
        curr=0;
        de=false;
        while(curr<poly_b.length())
        {
            if(poly_b[curr]>='0'&&poly_b[curr]<='9')
            {
                if(poly_b[curr-1]=='+'||poly_b[curr-1]=='(')
                {
                    if(poly_b[curr+1]==')')
                    {
                        addc(&top_b,&b,(int)(poly_b[curr]-'0'));
                        b->expo=0;
                        b->link=NULL;
                    }
                    else
                    {
                        addc(&top_b,&b,(int)(poly_b[curr]-'0'));
                    }
                }
                else if(poly_b[curr-1]=='-')
                {
                    if(poly_b[curr+1]==')')
                    {
                        addc(&top_b,&b,(int)(poly_b[curr]-'0'));
                        b->coef=b->coef*(-1);
                        b->expo=0;
                        b->link=NULL;
                    }
                    else
                    {
                        addc(&top_b,&b,(int)(poly_b[curr]-'0'));
                        b->coef=b->coef*(-1);
                    }
                }
                else if(poly_b[curr-1]=='^')
                {
                    b->expo=(int)(poly_b[curr]-'0');
                }
            }
            else if(poly_b[curr]=='\''){
                de=true;
            }
            else
            {
                if(poly_b[curr]=='x'&&(poly_b[curr-1]=='('||poly_b[curr-1]=='+'))
                {
                    addc(&top_b,&b,1);
                    if(poly_b[curr+1]!='^')
                    {
                        b->expo=1;
                        if(poly_b[curr+1]==')')
                        {
                            b->link=NULL;
                        }
                    }
                }
                else if(poly_b[curr]=='x'&&poly_b[curr-1]=='-')
                {
                    addc(&top_b,&b,-1);
                    if(poly_b[curr+1]!='^')
                    {
                        b->expo=1;
                        if(poly_b[curr+1]==')')
                        {
                            b->link=NULL;
                        }
                    }
                }
                else if(poly_b[curr]=='x'&&poly_b[curr-1]>='2'&&poly_b[curr-1]<='9'&&poly_b[curr+1]!='^'){
                    b->expo=1;
                }
            }
            curr++;
        }
        if(mi){
            b=top_b;
            for(;b;b=b->link){
                b->coef=(b->coef)*(-1);
            }
        }
        if(de){
            b=top_b;
            for(;b;b=b->link){
                b->coef=(b->coef)*(b->expo);
                b->expo--;
                if(b->expo==-1){
                    b->coef=0;
                    b->expo=0;
                }
            }
        }
        a=top_a;
        b=top_b;
        d=padd(a,b,d);
        check=false;
        for(;d;d=d->link){
            if(check&&d->coef>0){
                cout << "+";
            }
            if(d->coef){
                if(!d->expo){
                    cout << d->coef;
                }
                else if(d->coef==1){
                    cout << "x";
                }
                else if(d->coef==-1){
                    cout << "-x";
                }
                else{
                    cout << d->coef << "x";
                }
            }
            if(d->expo>=2){
                cout << "^" << d->expo;
            }
            check=true;
        }
        cout << endl;
        d=padd(a,b,d);
        sum=0;
        for(;d;d=d->link){
            temp_sum=1;
            for(int i=0;i<(d->expo);i++){
                temp_sum=temp_sum*x;
            }
            sum=sum+(temp_sum*(d->coef));
        }
        cout << sum << endl;
        ct++;
        if(ct==3){
            break;
        }
    }
    return 0;
}
