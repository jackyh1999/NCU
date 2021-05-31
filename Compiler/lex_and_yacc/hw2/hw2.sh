#!/bin/bash
#compile bison
bison -d -o hw2.tab.c hw2.y
gcc -c -g -I.. hw2.tab.c
#compile flex
flex -o hw2.yy.c hw2.l
gcc -c -g -I.. hw2.yy.c
#compile and link bison and flex
gcc -o hw2 hw2.tab.o hw2.yy.o -ll
