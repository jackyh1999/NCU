#include <iostream>

using namespace std;
typedef struct list_node *list_pointer;
typedef struct list_node
{
    char data;
    list_pointer link;
};
list_pointer ptr,top;
list_pointer search_node(list_pointer ptr,char target)
{
    //ptr=top;
    list_pointer temp=ptr;
    if(temp->data!=target)
    {
        //cout << temp->data;
        search_node(temp->link,target);
    }
    else
    {
        return temp;
    }
}
list_pointer search_trail(list_pointer ptr,char target)
{
    //ptr=top;
    list_pointer temp=ptr;
    if(temp->data==target){
        cout << temp->data;
        return NULL;
    }
    else if(temp->link->data==target)
    {
        cout << temp->link->data;
        return temp;
    }
    else
    {
        search_trail(temp->link,target);
    }
}
void create(string input,list_pointer ptr)
{
    list_pointer temp;
    temp = new list_node;
    for(int i=0; i<input.length(); i++)
    {
        if(input[i]=='-'&&input[i+1]=='>')
        {
            //cout <<"->";
            temp->link = new list_node;
            temp=temp->link;
            ptr=temp;
            i++;
        }
        else
        {
            temp->data=input[i];
            temp->link=NULL;
            ptr=temp;
            if(i==0)
            {
                top=ptr;
            }
            //cout << ptr->data;
        }
    }
}
void insert_node(list_pointer *ptr,char target,list_pointer node)
{
    *ptr=search_node(*ptr,target);
    if(*ptr)
    {
        //cout << (*ptr)->data;
        node->link=(*ptr)->link;
        (*ptr)->link=node;

    }
    else
    {
        node->link=NULL;
        *ptr=node;
    }
}
void delete_node(list_pointer *ptr,char target,list_pointer node)
{
    *ptr=search_trail(*ptr,target);
    if(*ptr)
    {
        cout << (*ptr)->data;
        node=(*ptr)->link;
        (*ptr)->link=node->link;
    }
    else
    {
        *ptr=top->link;
        top=*ptr;
        cout << (*ptr)->data;
    }
}
void invert(list_pointer ptr,list_pointer lead,list_pointer last,char target1,char target2)
{
    list_pointer middle,trail;
    middle=NULL;
    lead=search_node(ptr,target1);
    last=search_node(ptr,target2);
    while(lead&&lead->link!=last->link)
    {
        cout << lead->link->data << last->data;
        cout << 'a';
        trail=middle;
        middle=lead;
        lead=lead->link;
        middle->link=trail;
    }
    //return middle;
}
int main()
{
    string str,content;
    ptr=NULL;
    while(cin >> str)
    {
        if(str=="List:")
        {
            cin >> content;
            create(content,ptr);

        }
        else if(str=="Insert:")
        {
            char ch1,ch2;
            cin >> ch1 >> ch2;
            list_pointer new_node=new list_node;
            new_node->data=ch2;
            new_node->link=NULL;
            insert_node(&ptr,ch1,new_node);
        }
        else if(str=="Delete:"){
            char ch3;
            cin >> ch3;
            list_pointer delete_ptr=new list_node;
            delete_ptr->data=ch3;
            delete_ptr->link=NULL;
            delete_node(&ptr,ch3,delete_ptr);
        }
        else if(str=="Invert:"){
            char ch4,ch5;
            cin >> ch4 >> ch5;
            list_pointer invert_node1=new list_node;
            list_pointer invert_node2=new list_node;
            invert_node1->data=ch4;
            invert_node2->data=ch5;
            invert_node1->link=NULL;
            invert_node2->link=NULL;
            invert(ptr,invert_node1,invert_node2,ch4,ch5);
        }
        else if(str=="end")
        {
            cout << "List 1:" << endl;
            ptr=top;
            for(; ptr; ptr=(ptr)->link)
            {
                cout << (ptr)->data;
                if((ptr)->link!=NULL)
                {
                    cout << "->";
                }
            }
            cout << endl;
        }
        ptr=top;
    }
    return 0;
}
