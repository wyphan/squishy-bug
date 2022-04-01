Bug #1
======
_Last edited: Mar 31, 2022 (WYP)_

Fortran `REPEAT()` intrinsic wouldn't "eat" work with
`CHARACTER(LEN=:), ALLOCATABLE`
variables.

Found when investigating why
[GitLab:`everythingfunctional/iso_varying_string`][repo-str]
wouldn't build. This package is required to build
[GitLab:`everythingfunctional/vegetables`][repo-veg]
testing system.

Observed in:
  * NVHPC `nvfortran` 22.2
  * AOCC `flang` 3.2.0

[repo-str]: https://gitlab.com/everythingfunctional/iso_varying_string/
[repo-veg]: https://gitlab.com/everythingfunctional/vegetables
