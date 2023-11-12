#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <iostream>
#include <random>
#include <limits.h>

using namespace std;

int32_t number_of_threads;
int64_t number_of_tosses;
int64_t number_in_circle = 0;

#define end number_of_tosses

void MonteCarlo(){
    double x, y, distance_squared;
    // unsigned int seed = 1;
    unsigned int seed = time(0);

    for(int64_t toss = 0; toss < end ; toss+=1){
        x = ((double)rand_r(&seed)/RAND_MAX)*2-1;
        y = ((double)rand_r(&seed)/RAND_MAX)*2-1;
        distance_squared = x*x+y*y;
        if(distance_squared <= 1){
            number_in_circle +=1;
        }
    }
}

// takes two command-line arguments, 
// which indicate 
// the number of threads and the number of tosses, respectively.
int main(int argc, char* argv[]){
    number_of_threads = atoi(argv[1]);
    number_of_tosses =  atol(argv[2]);

    MonteCarlo();

    double pi_estimate = 4 * number_in_circle /(( double ) number_of_tosses);
    printf("%lf\n", pi_estimate);

    
    return 0;
}