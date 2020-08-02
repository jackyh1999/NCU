#include <iostream>

using namespace std;
#define MAX_SIZE 101
typedef struct node *tree_pointer;
typedef struct node
{
    int data;
    tree_pointer left_child,right_child;
};
tree_pointer top;
tree_pointer lqueue[MAX_SIZE]= {NULL};
int counter,max_input=0,height,temp_height,leaf;
void addq(int front_,int *rear,tree_pointer ptr)
{
    lqueue[*rear]=ptr;
}
tree_pointer deleteq(int *front_,int rear)
{
    return lqueue[*front_];
}
tree_pointer binsearch(tree_pointer root,int value)
{
    if(!root)
    {
        return NULL;
    }
    if(value==root->data)
    {
        return root;
    }
    if(value<root->data)
    {
        if(root->left_child)
        {
            temp_height++;
            return binsearch(root->left_child, value);
        }
        else
        {
            temp_height++;
            if(temp_height>=height)
            {
                height=temp_height;
            }
            temp_height=1;
            return root;
        }
    }
    if(root->right_child)
    {
        temp_height++;
        return binsearch(root->right_child, value);
    }
    else
    {
        temp_height++;
        if(temp_height>=height)
        {
            height=temp_height;
        }
        temp_height=1;
        return root;
    }
}
void insert_node(tree_pointer *node, int num)
{
    tree_pointer ptr, temp = binsearch(*node, num);
    if(temp||!(*node))
    {
        ptr=(tree_pointer)new tree_pointer;
        ptr->data=num;
        ptr->left_child=ptr->right_child=NULL;
        if(*node)
        {
            if(num<temp->data)
            {
                temp->left_child=ptr;
            }
            else
            {
                temp->right_child=ptr;
            }
        }
        else
        {
            *node=ptr;
            top=ptr;
        }
    }
}
void inorder(tree_pointer ptr)
{
    if(ptr)
    {

        inorder(ptr->left_child);
        cout << (ptr)->data;
        counter++;
        if(counter<max_input){
            cout << " ";
        }
        inorder(ptr->right_child);
    }
}
void preorder(tree_pointer ptr)
{
    if(ptr)
    {

        cout << (ptr)->data;
        counter++;
        if(counter<max_input){
            cout << " ";
        }
        preorder(ptr->left_child);
        preorder(ptr->right_child);
    }
}
void postorder(tree_pointer ptr)
{
    if(ptr)
    {

        postorder(ptr->left_child);
        postorder(ptr->right_child);
        cout << (ptr)->data;
        counter++;
        if(counter<max_input){
            cout << " ";
        }
    }
}
void levelorder(tree_pointer ptr)
{
    int front_=0;
    int rear=-1;
    if(!ptr)
    {
        return;
    }
    rear++;
    addq(front_,&rear,ptr);
    for(;;)
    {
        ptr=deleteq(&front_,rear);
        front_++;
        if(ptr)
        {
            cout << (ptr)->data;
            counter++;
            if(counter<max_input){
                cout << " ";
            }
            if(ptr->left_child)
            {
                rear++;
                addq(front_,&rear,ptr->left_child);
            }
            if(ptr->right_child)
            {
                rear++;
                addq(front_,&rear,ptr->right_child);
            }
        }
        else
        {
            break;
        }
    }
}
void findleaf(tree_pointer ptr)
{
    if(ptr->left_child)
    {
        findleaf(ptr->left_child);
    }
    if(ptr->right_child)
    {
        findleaf(ptr->right_child);
    }
    if(!(ptr->left_child)&&!(ptr->right_child))
    {
        leaf++;
    }
}
int main()
{
    tree_pointer tptr=NULL;
    height=1;
    temp_height=1;
    leaf=0;
    int input;
    while(cin >> input)
    {
        max_input++;
        insert_node(&tptr,input);
    }
    if(tptr)
    {
        tptr=top;
        counter=0;
        preorder(tptr);
        cout << endl;

        tptr=top;
        counter=0;
        inorder(tptr);
        cout << endl;

        tptr=top;
        counter=0;
        postorder(tptr);
        cout << endl;

        tptr=top;
        counter=0;
        levelorder(tptr);
        cout << endl;

        tptr=top;
        findleaf(tptr);
        cout << top->data << endl;
        cout << height << endl;
        cout << leaf;
    }
    else{
        cout << "Tree is empty.";
    }
    return 0;
}
