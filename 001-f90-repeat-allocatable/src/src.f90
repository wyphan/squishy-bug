PROGRAM allocatablechar
  IMPLICIT NONE

  INTRINSIC :: REPEAT, LEN

  INTEGER, PARAMETER :: n = 2
  CHARACTER(LEN=:), ALLOCATABLE :: str_in, str_out

  str_in = 'DeadBeef'
  PRINT *, 'str_in = ', str_in

  str_out = REPEAT(str_in, n)
  PRINT *, 'str_out = ', str_out

END PROGRAM allocatablechar
