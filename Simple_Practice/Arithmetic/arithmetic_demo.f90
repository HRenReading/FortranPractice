program arithmetic
    implicit none
    integer :: a, b, int_result
    real :: x, y, real_result

    a = 5
    b = 2
    x = 5.0
    y = 2.0

    int_result = a / b
    real_result = x / y

    print *, "Integer division:", int_result
    print *, "Real division", real_result
end program arithmetic