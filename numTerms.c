//
//  main.c
//  TestC
//
//  Created by Artem Lobanov on 21/09/15.
//  Copyright (c) 2015 Artem Lobanov. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>

int* arr;
int lastNotNullIndex;
int curMinTerm;

void getTerms(int x)
{
    for (int i = curMinTerm; i <= x; i++) {
        arr[lastNotNullIndex] = i;
        lastNotNullIndex++;
        
        int tempMinTerm = curMinTerm;
        curMinTerm = i;
        
        int next = x - i;
        if (next != 0) {
            getTerms(next);
        } else {
            for (int i = 0; i < lastNotNullIndex; i++) {
                printf("%d%s", arr[i], (i != lastNotNullIndex - 1 ? "+" : ""));
            }
            printf("\n");
        }
        
        lastNotNullIndex--;
        curMinTerm = tempMinTerm;
    }
}

int main(int argc, const char * argv[])
{
    int x = 50;
    
    arr = (int*)malloc(sizeof(int) * x);
    lastNotNullIndex = 0;
    curMinTerm = 1;
    
    getTerms(x);    
    
    return 0;
}







































