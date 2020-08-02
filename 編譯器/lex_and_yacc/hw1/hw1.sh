#!/bin/bash
#compile bison
bison -d -o hw1.tab.c hw1.y
gcc -c -g -I.. hw1.tab.c
#compile flex
flex -o hw1.yy.c hw1.l
gcc -c -g -I.. hw1.yy.c
#compile and link bison and flex
gcc -o hw1 hw1.tab.o hw1.yy.o -ll

