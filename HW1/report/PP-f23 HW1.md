# PP-f23 HW1 
資工科碩 312551080 紀軒宇

## Q1-1
**Q1-1: Does the vector utilization increase, decrease or stay the same as VECTOR_WIDTH changes? Why?**
**Ans:**
執行結果分別如下

Vector Width = 2
```bash
CLAMPED EXPONENT (required) 
Results matched with answer!
****************** Printing Vector Unit Statistics *******************
Vector Width:              2
Total Vector Instructions: 162729
Vector Utilization:        89.5%
Utilized Vector Lanes:     291365
Total Vector Lanes:        325458
************************ Result Verification *************************
ClampedExp Passed!!!
```
Vector Width = 4
```bash
CLAMPED EXPONENT (required) 
Results matched with answer!
****************** Printing Vector Unit Statistics *******************
Vector Width:              4
Total Vector Instructions: 94577
Vector Utilization:        87.5%
Utilized Vector Lanes:     331005
Total Vector Lanes:        378308
************************ Result Verification *************************
ClampedExp Passed!!!
```
Vector Width = 8
```bash
CLAMPED EXPONENT (required) 
Results matched with answer!
****************** Printing Vector Unit Statistics *******************
Vector Width:              8
Total Vector Instructions: 51629
Vector Utilization:        86.4%
Utilized Vector Lanes:     357053
Total Vector Lanes:        413032
************************ Result Verification *************************
ClampedExp Passed!!!
```
Vector Width = 16
```bash
CLAMPED EXPONENT (required) 
Results matched with answer!
****************** Printing Vector Unit Statistics *******************
Vector Width:              16
Total Vector Instructions: 26969
Vector Utilization:        86.0%
Utilized Vector Lanes:     370917
Total Vector Lanes:        431504
************************ Result Verification *************************
ClampedExp Passed!!!
```

執行結果整理如下
|VECTOR_WIDTH|2|4|8|16|
|:-:|:-:|:-:|:-:|:-:|
|Vector Utilization|89.5%|87.5%|86.4%|86.0%|


Vector utilization 隨著 VECTOR_WIDTH 的增加而降低, 因為 Vector utilization 是根據每次運算 mask 中為 True 的元素數量除以 mask 的總元素數量做計算的，而當程式在執行 exponential 的部分（如下方程式部分所示）時，隨迴圈的進行，`_pp_vgt_int` 會使 mask 中為 True 的數量會越來越少（countVec 中大於 zerosVec 的越來越少，mask 中為 True 的數量也會越來越少），需要等待 mask 中的值都為 False，才會進行下一組 vector 的計算，這段等待的時間中那些為 mask 為 False 的 lane 都被浪費掉了，而 VECTOR_WIDTH 越大就會有越多的浪費

```cpp=
// code from clampedExpVector() in vectorOP.cpp
_pp_vgt_int(mask, countVec, zerosVec, allTrueMask);
while(_pp_cntbits(mask) > 0)                      //    while(count > 0)
{ 
    _pp_vmult_float(result, result, x, mask);       //      result *= x;
      
    _pp_vsub_int(countVec, countVec, onesVec, allTrueMask);//      count --; 

    _pp_vgt_int(mask, countVec, zerosVec, allTrueMask);  
}   
```

舉一個極端例子，考慮以下參數

|index|0|1|2|3|4|5|6|7|
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
|values|1|1|1|1|1|1|1|1|
|exponents|0|0|0|0|0|0|0|9|

使用 VECTOR_WIDTH=2 時，當處理 index (0, 1), (2, 3), (4, 5) 時遇到 exponential 部分都會直接進行下一步，直到處理 index(6, 7) 時，第 1 個 lane 會需要等待第 2 個 lane 中的 exponents 扣至 0 才會進行下一步，當中每執行一次 `_pp_vmult_float` 就會浪費 1 個 lane，迴圈執行 9 次，共浪費 9 個 lane

而使用 VECTOR_WIDTH=8 時，當處理 index (0, 1, ... 7) 時遇到 exponential 部分，第 1 到第 7 個 lane 都需要等待第 8 個 lane 中的 exponents 扣至 0 才會進行下一步，當中每執行一次 `_pp_vmult_float` 都會浪費 7 個 lane，迴圈執行 9 次，共浪費 63 個 lane

從上述例子可以印證當 VECTOR_WIDTH 越大時，Vector utilization 會越來越低


## Q2-1
**Q2-1: Fix the code to make sure it uses aligned moves for the best performance.**

Hint: we want to see vmovaps rather than vmovups.

**Ans:** 
從 [Intel® 64 and IA-32 Architectures Software Developer's Manual Volume 1: Basic Architecture](https://www.intel.com/content/www/us/en/content-details/789574/intel-64-and-ia-32-architectures-software-developer-s-manual-volume-1-basic-architecture.html) p.377 中可以看到 `vmovaps` 需要 32-byte alignment
所以更改 `__builtin_assume_aligned` 的第二個參數至 32，程式碼如下

```cpp=
#include <iostream>
#include "test.h"
#include "fasttime.h"

void test1(float* __restrict a, float* __restrict b, float* __restrict c, int N) {
  __builtin_assume(N == 1024);
  // modify the second argument from 16 to 32 to make it aligned to AVX2 
  a = (float*)__builtin_assume_aligned(a, 32);
  b = (float*)__builtin_assume_aligned(b, 32);
  c = (float*)__builtin_assume_aligned(c, 32);

  fasttime_t time1 = gettime();
  for (int i=0; i<I; i++) {
    for (int j=0; j<N; j++) {
      c[j] = a[j] + b[j];
    }
  }
  fasttime_t time2 = gettime();

  double elapsedf = tdiff(time1, time2);
  std::cout << "Elapsed execution time of the loop in test1():\n" 
    << elapsedf << "sec (N: " << N << ", I: " << I << ")\n";
}
```

重新 make 後使用 diff 比較更改前後產生的 `test1.vec.restr.align.avx2.s` （<為更改前，>為更改後），可以發現 `vmovups` 都變成 `vmovaps` 了
```
50,53c50,53
<       vmovups (%rbx,%rcx,4), %ymm0
<       vmovups 32(%rbx,%rcx,4), %ymm1
<       vmovups 64(%rbx,%rcx,4), %ymm2
<       vmovups 96(%rbx,%rcx,4), %ymm3
---
>       vmovaps (%rbx,%rcx,4), %ymm0
>       vmovaps 32(%rbx,%rcx,4), %ymm1
>       vmovaps 64(%rbx,%rcx,4), %ymm2
>       vmovaps 96(%rbx,%rcx,4), %ymm3
58,61c58,61
<       vmovups %ymm0, (%r14,%rcx,4)
<       vmovups %ymm1, 32(%r14,%rcx,4)
<       vmovups %ymm2, 64(%r14,%rcx,4)
<       vmovups %ymm3, 96(%r14,%rcx,4)
---
>       vmovaps %ymm0, (%r14,%rcx,4)
>       vmovaps %ymm1, 32(%r14,%rcx,4)
>       vmovaps %ymm2, 64(%r14,%rcx,4)
>       vmovaps %ymm3, 96(%r14,%rcx,4)
```


## Q2-2
**Q2-2: What speedup does the vectorized code achieve over the unvectorized code? What additional speedup does using -mavx2 give (AVX2=1 in the Makefile)? You may wish to run this experiment several times and take median elapsed times; you can report answers to the nearest 100% (e.g., 2×, 3×, etc). What can you infer about the bit width of the default vector registers on the PP machines? What about the bit width of the AVX2 vector registers.**

Hint: Aside from speedup and the vectorization report, the most relevant information is that the data type for each array is float.

**Ans:**
執行結果分別如下
case1
```
Running test1()...
Elapsed execution time of the loop in test1():
8.58496sec (N: 1024, I: 20000000)
```
case2
```
Running test1()...
Elapsed execution time of the loop in test1():
2.72975sec (N: 1024, I: 20000000)
```
- **Q: What speedup does the vectorized code achieve over the unvectorized code?**
    **Ans:** 
    - 從 case1 跟 case2 的結果可以看出，vectorized code 比 unvectorized code 帶來了約 3 倍的加速 ($\frac{8.58496} {2.72975} \approx 3$)
    
case3
```
Running test1()...
Elapsed execution time of the loop in test1():
1.47827sec (N: 1024, I: 20000000)
```

- **Q: What additional speedup does using -mavx2 give (AVX2=1 in the Makefile)?**
    **Ans:** 
    - 從 case2 跟 case3 的結果可以看出， 使用 -mavx2 相較沒使用帶來了額外約 2 倍的加速  ($\frac{2.72975} {1.47827} \approx 2$)

- **Q: What can you infer about the bit width of the default vector registers on the PP machines? What about the bit width of the AVX2 vector registers.**
    **Ans:**
    - 因為 case 1 跟 case 2 的速度差了 3 倍，但考量 register 的長度通常是 2 的次方，所以推估 vector width 為 4，加上在 case2 的 make 過程中可以看到由 `-Rpass=loop-vectorize` 輸出的這行資訊 
    `test1.cpp:14:5: remark: vectorized loop (vectorization width: 4, interleaved count: 2) [-Rpass=loop-vectorize]`
    可以確認 vector width 為 4，且已知我們在操作的陣列為一個 float (32bit) 的陣列，所以可知 PP machines 上一個 default vector registers 的 bit width 為 $32\times 4=128$ bits
    - 因為 case 2 跟 case 3 的速度差了 2 倍，所以推估 vector width 為 case 2 的 2 倍，即為 8，加上從 case3 的 make 過程中可以看到由 `-Rpass=loop-vectorize` 輸出的這行資訊 
    `test1.cpp:14:5: remark: vectorized loop (vectorization width: 8, interleaved count: 4) [-Rpass=loop-vectorize]`
    可以確認 vector width 為 8，且已知我們在操作的陣列為一個 float (32bit) 陣列，所以可知 AVX2 vector registers 上一個 default vector registers 的 bit width 為 $32\times 8=256$ bits
    
### Q2-3
**Q2-3: Provide a theory for why the compiler is generating dramatically different assembly.**
**Ans:** 
雖然效果同樣是將陣列 a, b 中各元素較大者放入陣列 c，但在程式中的表達不同，
- patch 前的行為是「先將 a[i] 放入 c[i] 後，之後比較 b[i], a[j]，如果 b[i]>a[i]，再將 b[i] 放入 a[i]」
- patch 後的行為是「比較 a[i], b[i]，如果 b[i]>a[i]，就將 b[i] 放入 c[i] 中，反之則將 a[i] 放入 c[i]」

對 compiler 來說，前者無法第一時間看出是要做什麼，而後者，因為將所有操作都寫在同個 if-else block 中，也沒有第三種情況，所以可以直觀的看出要放入 c[i] 的會是 if 語句中的 a[i] 或 b[i] 中較大者，所以在 assembly 中可以直接使用使用 `movaps` 將 `%rsi`(b[i]) 的部分數據搬入 `%xmm0` 暫存器，之後後直接使用 `maxps` 比較 `%xmm0` 與 `%rdi`(a[i]) 的大小，將較大值存回`%xmm0` 暫存器中，最後直接將 `%xmm0` 暫存器的值存入 `rdx`(c[i]) 中，所以可以推測出 compiler compile 時會根據 programmer 描述的方式及結構的差異，試圖做不同的最佳化，所以才會有這樣的差別