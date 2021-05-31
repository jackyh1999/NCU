#include <iostream>

using namespace std;

int main()
{
    int m,p,pass_row,pass_col; //input的變數
    cin >> m >> p >> pass_row >> pass_col;
    int maze[m+2][p+2],marked[m+2][p+2];

    typedef struct
    {
        short int vert;
        short int hori;
    } offsets;

    offsets mov[8]; //mov[0]~mov[7]表示一單位的八個方位
    mov[0].vert=-1;
    mov[0].hori=0;
    mov[1].vert=-1;
    mov[1].hori=1;
    mov[2].vert=0;
    mov[2].hori=1;
    mov[3].vert=1;
    mov[3].hori=1;
    mov[4].vert=1;
    mov[4].hori=0;
    mov[5].vert=1;
    mov[5].hori=-1;
    mov[6].vert=0;
    mov[6].hori=-1;
    mov[7].vert=-1;
    mov[7].hori=-1;

    typedef struct
    {
        short int row;
        short int col;
        short int dir;
    } element;

    int max_size=100;
    element position;
    element maze_stack[max_size]; //maze_stack 表示現在位置

    int next_row,next_col,top;
    bool found_pass,found_des = false;

    for(int i=0; i<m+2; i++)
    {
        for(int j=0; j<p+2; j++)
        {
            maze[i][j]=1;
            marked[i][j]=0;
        }
    }

    int temp;

    for(int i=1; i<m+1; i++)
    {
        for(int j=1; j<p+1; j++)
        {
            cin >> temp;
            maze[i][j]=temp;
        }
    }

    marked[1][1]=1,top=0;
    maze_stack[0].row=1;
    maze_stack[0].col=1;
    maze_stack[0].dir=1;

    int row,col,dir;

    while(top>-1&&found_des==false)
    {
        position=maze_stack[top];
        row=position.row;
        col=position.col;
        dir=position.dir;
        top--;
        while(dir<8&&found_des==false)
        {
            next_row = row + mov[dir].vert;
            next_col = col + mov[dir].hori;
            if(next_row==pass_row&&next_col==pass_col)
            {
                found_pass=true;
            }
            else if(next_row==m+1&&next_col==p+1)
            {
                found_des=true;
                position.row=row;
                position.col=col;
                dir++;
                position.dir=dir;
                top++;
                maze_stack[top]=position;
                cout<<"d";
            }
            else if(maze[next_row][next_col]==0&&marked[next_row][next_col]==0)
            {
                marked[next_row][next_col]=1;
                position.row=row;
                position.col=col;
                dir++;
                position.dir=dir;
                top++;
                maze_stack[top]=position;
                row=next_row;
                col=next_col;
                dir=0;
            }
            else
            {
                dir++;
            }
        }
    }
    if(found_des==true)
    {
        for(int i=0; i<=top; i++)
        {
            cout<<maze_stack[i].row<<" "<<maze_stack[i].col<<"\n";
        }
    }
    return 0;
}