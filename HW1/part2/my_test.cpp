#include <bits/stdc++.h>

using namespace std;

int add1(int* a, int* b)
{
    *a = 10;
    *b = 12;
    return *a + *b;
}

int add2(int* __restrict  a, int* __restrict b) 
{
    *a = 10;
    *b = 12;
    *a = 13;
    return *a + *b ;
}

int main(){
    int a = 1;
    int b = 2;
    cout << add2(&a, &a) << endl;
    return 0;
}

