Bug #2
======
_Last edited: Sep 6, 2023 (WYP)_

When using Cray Fortran 15.0.0 or 15.0.1 with an optimization level of `O1` or above
and there is an inner loop in an OpenMP target region,
the array index for the outer loop is limited to (2**24 - 1) = 16777215.

Found when investigating why
[GitLab: `hpctoolkit/minitest`, `wyphan/cray` branch][repo-str]
gives erroneous results for array indices > (2**24 - 1).

Observed on Frontier (OLCF) with Cray PE 22.12 and the following combinations:

  * Cray CCE 15.0.0 + ROCm 5.1.0
  * Cray CCE 15.0.0 + ROCm 5.2.0
  * Cray CCE 15.0.0 + ROCm 5.3.0
  * Cray CCE 15.0.0 + ROCm 5.4.0
  * Cray CCE 15.0.1 + ROCm 5.1.0
  * Cray CCE 15.0.1 + ROCm 5.2.0
  * Cray CCE 15.0.1 + ROCm 5.3.0
  * Cray CCE 15.0.1 + ROCm 5.4.0

With Cray PE 23.05, the same combinations above are still affected, but Cray CCE 16.0.0 + any ROCm version are unaffected.

Use `make` to compile and run the reproducer code.

Note: This harmless compiler warning can be safely ignored:
```
  !$OMP TARGET TEAMS DISTRIBUTE PARALLEL DO &
ftn-7256 ftn: WARNING OMPTGTINDEX, File = src.F90, Line = 37 
   An OpenMP parallel construct in a target region is limited to a single thread.
```

[repo-str]: https://gitlab.com/hpctoolkit/minitest/-/tree/wyphan/cray
