PROGRAM omptgtindex

  USE, INTRINSIC :: ISO_FORTRAN_ENV, ONLY: real64, output_unit, error_unit
  IMPLICIT NONE

  ! Intrinsic functions
  INTRINSIC :: COMMAND_ARGUMENT_COUNT, GET_COMMAND_ARGUMENT, REAL

  ! Internal variables
  INTEGER :: N, nerr, kkmax, i, kk
  REAL(KIND=real64), ALLOCATABLE, TARGET :: vecP(:), vecL(:)
  CHARACTER(LEN=32) :: argv1, argv2

  ! Parse command line arguments
  IF (COMMAND_ARGUMENT_COUNT() /= 2) THEN
     CALL usage()
     ERROR STOP 1
  ELSE
     CALL GET_COMMAND_ARGUMENT(1, VALUE=argv1)
     READ(argv1, *) N
     CALL GET_COMMAND_ARGUMENT(2, VALUE=argv2)
     READ(argv2, *) kkmax
  END IF

  WRITE(output_unit, '("Using vector length N = ", I0)') N
  WRITE(output_unit, '("Using inner loop bound kkmax = ", I0)') kkmax

  ! Allocate vector on host
  ALLOCATE(vecL(N))
  ALLOCATE(vecP(N))

  ! Initialize vectors on host
  vecL(:) = 1._real64
  vecP(:) = 1._real64

  ! Perform computation on device
  !$OMP TARGET TEAMS DISTRIBUTE PARALLEL DO &
  !$OMP   MAP(to:N, kkmax) MAP(to:vecL(1:N)) MAP(tofrom:vecP(1:N)) &
  !$OMP   PRIVATE(kk) SHARED(vecP, vecL)
  DO i = 1, N

     DO kk = 1, kkmax
        vecP(i) = vecP(i) + vecL(kk)
     END DO ! kk

  END DO ! i
  !$OMP END TARGET TEAMS DISTRIBUTE PARALLEL DO

  ! Check results
  nerr = 0
  DO i = 1, N
     IF (vecP(i) /= vecP(1)) THEN
        nerr = nerr + 1
        WRITE(error_unit, '("ERROR vec(", I0, ") = ", G18.3)') i, vecP(i)
     END IF
  END DO ! i
  WRITE(output_unit, '("Summary: Error = ", I0, " OK = ", I0)') nerr, N - nerr

  DEALLOCATE(vecL)
  DEALLOCATE(vecP)

CONTAINS

  SUBROUTINE usage
    USE, INTRINSIC :: ISO_FORTRAN_ENV, ONLY: error_unit
    IMPLICIT NONE

    ! Intrinsic functions
    INTRINSIC :: GET_COMMAND_ARGUMENT, TRIM

    ! Internal variables
    CHARACTER(LEN=80) :: argv0

    CALL GET_COMMAND_ARGUMENT(0, VALUE=argv0)
    WRITE(error_unit, '("Usage: ", A, " <N> <kkmax>")') TRIM(argv0)

    RETURN
  END SUBROUTINE usage

END PROGRAM omptgtindex
