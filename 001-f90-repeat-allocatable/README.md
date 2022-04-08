Bug #1
======
_Last edited: Apr 7, 2022 (WYP)_

Fortran `REPEAT()` intrinsic wouldn't work with
`CHARACTER(LEN=:), ALLOCATABLE`
variables.

Found when investigating why
[GitLab:`everythingfunctional/iso_varying_string`][repo-str]
wouldn't build. This package is required to build
[GitLab:`everythingfunctional/vegetables`][repo-veg]
testing system.

Observed in:
  * NVHPC `nvfortran` 22.2 (fixed in 22.3)
  * AOCC `flang` 3.2.0

These are unaffected:
  * Intel `ifort` 2021.5
  * NAG `nagfor` 7.0

Use `fpm test` to compile the reproducer code.

Note: `gfortran` 9.3.0, 10.3.0, and 11.2.0 emit the following bogus warnings but are otherwise unaffected:
```
src/src.f90:9:0:

    9 |   str_in = 'DeadBeef'
      | 
Warning: ‘.str_in’ may be used uninitialized in this function [-Wmaybe-uninitialized]
src/src.f90:12:0:

   12 |   str_out = REPEAT(str_in, n)
      | 
Warning: ‘.str_out’ may be used uninitialized in this function [-Wmaybe-uninitialized]
```

[repo-str]: https://gitlab.com/everythingfunctional/iso_varying_string/
[repo-veg]: https://gitlab.com/everythingfunctional/vegetables
