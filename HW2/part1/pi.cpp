#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <iostream>
#include <random>
#include <limits.h>
#include "shishua/shishua.h"

using namespace std;

int32_t number_of_threads;
int64_t number_of_tosses;
int64_t number_in_circle = 0;
pthread_mutex_t mutex;



typedef struct{
    int64_t thread_id;
    int64_t number_of_tosses_my;
} thread_arg;



void* MonteCarlo(void* args){
    // variables from thread_arg
    thread_arg* arg = (thread_arg*) args;
    int64_t end = arg->number_of_tosses_my;
    
    // variables for Monte Carlo
    double x, y, distance_squared;
    int64_t local_number_in_circle = 0;
    
    // variables for PRNG
    uint8_t buf[256] = {0};
    // 128/4 = 32
    prng_state state;
    // init seed using thread_id
    uint64_t seed[4] = {0};
    for(int i = 0 ; i < 4 ; i+=1){
        seed[i] = i*arg->thread_id;
    }
    prng_init(&state, seed);

    // variables for reading buf
    uint32_t rx, ry;
    int batch = 16;
    for(int64_t toss = 0; toss < end ; toss+=batch){
        prng_gen(&state, buf, sizeof(buf));
        for(int64_t i = 0 ; i < batch /*&& toss+i < end*/ ; i+=1)
        {
            rx = *(uint32_t*)(buf+i*8);
            x = ((double)rx/UINT_MAX)*2-1;
            ry = *(uint32_t*)(buf+i*8+8);
            y = ((double)ry/UINT_MAX)*2-1;
            
            distance_squared = x*x+y*y;
            if(distance_squared <= 1){
                local_number_in_circle +=1;
            }
        }
    }

    pthread_mutex_lock(&mutex);
    number_in_circle += local_number_in_circle;
    pthread_mutex_unlock(&mutex);
   
    pthread_exit(NULL);
}

// takes two command-line arguments, 
// which indicate 
// the number of threads and the number of tosses, respectively.
int main(int argc, char* argv[]){
    number_of_threads = atoi(argv[1]);
    number_of_tosses =  atol(argv[2]);

    long thread;

    pthread_t* thread_handles = (pthread_t*) malloc (number_of_threads*sizeof(pthread_t)); 
    thread_arg* thread_args = (thread_arg*) malloc (number_of_threads*sizeof(thread_arg));

    pthread_mutex_init(&mutex, NULL);

    int64_t tosses_per_thread = number_of_tosses/number_of_threads;
    number_in_circle = 0;
    for(thread = 0; thread < number_of_threads; thread+=1){
        thread_args[thread].thread_id = thread;
        thread_args[thread].number_of_tosses_my = tosses_per_thread;
        if(thread == number_of_threads-1){
            thread_args[thread].number_of_tosses_my = number_of_tosses - (number_of_threads-1)*tosses_per_thread;
        }
        pthread_create(&thread_handles[thread], NULL, &MonteCarlo, (void*) &thread_args[thread]);
    }


    for(thread = 0; thread < number_of_threads; thread+=1){
        pthread_join(thread_handles[thread], NULL);
    }

    pthread_mutex_destroy(&mutex);

    double pi_estimate = ((double)4 * number_in_circle / number_of_tosses);
    
    printf("%lf\n", pi_estimate);

    free(thread_handles);
    free(thread_args);
    
    return 0;
}