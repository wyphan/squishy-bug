Bug #2
======
_Last edited: Sep 5, 2023 (WYP)_

When using Cray Fortran 15.0.0 or 15.0.1 with an optimization level of `O1` or above
and there is an inner loop in an OpenMP target region,
the array index for the outer loop is limited to (2**24 - 1) = 16777215.

Found when investigating why
[GitLab:`hpctoolkit/minitest`, `wyphan/cray` branch][repo-str]
gives erroneous results for array indices > (2**24 - 1).

Observed on Frontier (OLCF) with:

  * Cray CCE 15.0.0 + ROCm 5.1.0
  * Cray CCE 15.0.0 + ROCm 5.2.0
  * Cray CCE 15.0.0 + ROCm 5.3.0
  * Cray CCE 15.0.0 + ROCm 5.4.0
  * Cray CCE 15.0.1 + ROCm 5.1.0
  * Cray CCE 15.0.1 + ROCm 5.2.0
  * Cray CCE 15.0.1 + ROCm 5.3.0
  * Cray CCE 15.0.1 + ROCm 5.4.0

These combinations won't compile:

* Cray CCE 15.0.0 + ROCm 5.4.3
  ```
/opt/cray/pe/cce/15.0.0/binutils/x86_64/x86_64-pc-linux-gnu/bin/ld: /opt/rocm-5.4.3/lib/libhsa-runtime64.so.1: undefined reference to `std::condition_variable::wait(std::unique_lock<std::mutex>&)@GLIBCXX_3.4.30'
make: *** [Makefile:18: main.cray.x] Error 1
  ```

* Cray CCE 15.0.0 + ROCm 5.5.1
  ```
/opt/cray/pe/cce/15.0.0/cce-clang/x86_64/bin/llvm-link: /opt/rocm-5.5.1/amdgcn/bitcode/hip.bc: error: Opaque pointers are only supported in -opaque-pointers mode (Producer: 'LLVM16.0.0git' Reader: 'LLVM 15.0.2')
/opt/cray/pe/cce/15.0.0/cce-clang/x86_64/bin/llvm-link: error:  loading file '/opt/rocm-5.5.1/amdgcn/bitcode/hip.bc'
make: *** [Makefile:18: main.cray.x] Error 1
  ```

* Cray CCE 15.0.1 + ROCm 5.4.3
  ```
/opt/cray/pe/cce/15.0.1/binutils/x86_64/x86_64-pc-linux-gnu/bin/ld: /opt/rocm-5.4.3/lib/libhsa-runtime64.so.1: undefined reference to `std::condition_variable::wait(std::unique_lock<std::mutex>&)@GLIBCXX_3.4.30'
make: *** [Makefile:18: main.cray.x] Error 1
  ```

* Cray CCE 15.0.0 + ROCm 5.5.1
  ```
/opt/cray/pe/cce/15.0.1/cce-clang/x86_64/bin/llvm-link: /opt/rocm-5.5.1/amdgcn/bitcode/hip.bc: error: Opaque pointers are only supported in -opaque-pointers mode (Producer: 'LLVM16.0.0git' Reader: 'LLVM 15.0.6')
/opt/cray/pe/cce/15.0.1/cce-clang/x86_64/bin/llvm-link: error:  loading file '/opt/rocm-5.5.1/amdgcn/bitcode/hip.bc'
make: *** [Makefile:18: main.cray.x] Error 1
  ```

* Cray CCE 16.0.0 + any ROCm
  ```
/opt/cray/pe/cce/16.0.0/binutils/x86_64/x86_64-pc-linux-gnu/bin/ld: cannot find -ltcmalloc_minimal: No such file or directory
make: *** [Makefile:18: main.cray.x] Error 1
  ```

Use `make` to compile and run the reproducer code.

Note: This harmless compiler warning can be safely ignored:
```
  !$OMP TARGET TEAMS DISTRIBUTE PARALLEL DO &
ftn-7256 ftn: WARNING OMPTGTINDEX, File = src.F90, Line = 37 
   An OpenMP parallel construct in a target region is limited to a single thread.
```

[repo-str]: https://gitlab.com/hpctoolkit/minitest/-/tree/wyphan/cray
