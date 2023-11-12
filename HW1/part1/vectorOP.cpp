#include "PPintrin.h"

#include <iostream>
using namespace std;

// implementation of absSerial(), but it is vectorized using PP intrinsics
void absVector(float *values, float *output, int N)
{
  __pp_vec_float x;
  __pp_vec_float result;
  __pp_vec_float zero = _pp_vset_float(0.f);
  __pp_mask maskAll, maskIsNegative, maskIsNotNegative;

  //  Note: Take a careful look at this loop indexing.  This example
  //  code is not guaranteed to work when (N % VECTOR_WIDTH) != 0.
  //  Why is that the case?
  for (int i = 0; i < N; i += VECTOR_WIDTH)
  {

    // All ones
    maskAll = _pp_init_ones();

    // All zeros
    maskIsNegative = _pp_init_ones(0);

    // Load vector of values from contiguous memory addresses
    _pp_vload_float(x, values + i, maskAll); // x = values[i];

    // Set mask according to predicate
    _pp_vlt_float(maskIsNegative, x, zero, maskAll); // if (x < 0) {

    // Execute instruction using mask ("if" clause)
    _pp_vsub_float(result, zero, x, maskIsNegative); //   output[i] = -x;

    // Inverse maskIsNegative to generate "else" mask
    maskIsNotNegative = _pp_mask_not(maskIsNegative); // } else {

    // Execute instruction ("else" clause)
    _pp_vload_float(result, values + i, maskIsNotNegative); //   output[i] = x; }

    // Write results back to memory
    _pp_vstore_float(output + i, result, maskAll);
  }
}

void clampedExpVector(float *values, int *exponents, float *output, int N)
{
  //
  // PP STUDENTS TODO: Implement your vectorized version of
  // clampedExpSerial() here.
  //
  // Your solution should work for any value of
  // N and VECTOR_WIDTH, not just when VECTOR_WIDTH divides N
  //
  
  __pp_mask allTrueMask = _pp_init_ones();
  __pp_mask mask = _pp_init_ones(0);

  
  __pp_vec_float x;
  __pp_vec_float result = _pp_vset_float(0);
  __pp_vec_float thresholdVec = _pp_vset_float(9.999999f);

  __pp_vec_int y;
  __pp_vec_int onesVec = _pp_vset_int(1);
  __pp_vec_int zerosVec = _pp_vset_int(0);
  __pp_vec_int countVec = _pp_vset_int(0);
  
  for (int i = 0; i < N; i += VECTOR_WIDTH)           // for (int i = 0; i < N; i++)
  {
    _pp_vload_float(x, values+i, allTrueMask);        //  float  x = values[i];

    _pp_vload_int(y, exponents+i, allTrueMask);       //  int y = exponents[i];

    _pp_veq_int(mask, y, zerosVec, allTrueMask);      // if (y == 0)

    _pp_vset_float(result, 1.f, mask);                //  output[i] = 1.f;

    mask = _pp_mask_not(mask);                        // else
    
    _pp_vmove_float(result, x, mask);                 //  float result = x;

    _pp_vsub_int(countVec, y, onesVec, mask);         //  int count = y - 1;

    // mask for the vector which is > 0
    // for while loop to count
    _pp_vgt_int(mask, countVec, zerosVec, allTrueMask);
    while(_pp_cntbits(mask) > 0)                      //    while(count > 0)
    { 
      _pp_vmult_float(result, result, x, mask);       //      result *= x;
      
      _pp_vsub_int(countVec, countVec, onesVec, allTrueMask);//count --; 

      _pp_vgt_int(mask, countVec, zerosVec, allTrueMask);  
    }    
    
    _pp_vgt_float(mask, result, thresholdVec, allTrueMask);
                                                      //    if (result > 9.999999f)

    _pp_vset_float(result, 9.999999f, mask);          //      result = 9.999999f;
  
    // for the remaining vector when 
    // VECTOR_WIDTH can't divides N
    if(i+VECTOR_WIDTH > N)
    {
      __pp_mask remainingMask = _pp_init_ones(N%VECTOR_WIDTH);

      _pp_vstore_float(output + i, result, remainingMask);
    }
    else
    {
      _pp_vstore_float(output + i, result, allTrueMask);//  output[i] = result;
    }
  }
  

}

// returns the sum of all elements in values
// You can assume N is a multiple of VECTOR_WIDTH
// You can assume VECTOR_WIDTH is a power of 2
float arraySumVector(float *values, int N)
{

  //
  // PP STUDENTS TODO: Implement your vectorized version of arraySumSerial here
  //

  __pp_mask allTrueMask = _pp_init_ones();
  __pp_mask mask;

  __pp_vec_float sumVec = _pp_vset_float(0.f);            // float sum = 0;
  __pp_vec_float tempVec = _pp_vset_float(0.f);

  for (int i = 0; i < N; i += VECTOR_WIDTH)               // for (int i = 0; i < N; i++)
  {
    _pp_vload_float(tempVec, values+i, allTrueMask);

    _pp_vadd_float(sumVec, sumVec, tempVec, allTrueMask); // sum += values[i];
  }

  for (int i = 0; i < log2(VECTOR_WIDTH); i++)
  {
    _pp_hadd_float(sumVec, sumVec);
    
    _pp_interleave_float(sumVec, sumVec);
  }
  //  e.g. for VECTOR_WIDTH=4 repeat log2(4)=2 times
  // hadd log2(n) + interleave log2(n)
  //  [0 1 2 3] -> [0+1 0+1 2+3 2+3] -> [1 1 5 5] hadd
  //  [1 1 5 5] -> [1 5 1 5]                      interleave
  //  [1 5 1 5] -> [1+5 1+5 1+5 1+5] -> [6 6 6 6] hadd
  //  [6 6 6 6] -> [6 6 6 6]                      interleave
  
  float result[VECTOR_WIDTH];
  
  mask = _pp_init_ones(1);

  _pp_vstore_float(result, sumVec, mask);                 // return sum;
  
  return result[0];

}