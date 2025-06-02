program function_demo
    implicit none
    integer :: a, frac

    a = 5
    frac = factorial(a)
    write(*,'(A,I0,A,I0)') "Factorial of ", a, " is ", frac
contains
    function factorial(x) result(res)
        implicit none
        integer, intent(in) :: x
        integer :: i, res

        i = 1
        res = 1

        do while(i <= x)
            res = i * res
            i = i + 1
        end do
    end function factorial
end program function_demo