program variable_demo
    implicit none
    integer :: year
    real :: pi
    logical :: is_true
    character(len=20) :: message

    year = 2025
    pi = 3.1415926
    is_true = .true.
    message = "Fortran is Ready!"

    print *, "Year:", year
    print *, "Pi:", pi
    print *, "Is Fortran Ready?:", is_true
    print *, "Message:", message
end program variable_demo