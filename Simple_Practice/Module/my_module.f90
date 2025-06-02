module my_module
    contains

    function square(x) result(res)
        implicit none
        integer :: x, res

        res = x ** 2
    end function square

    function factorial(x) result(res)
        implicit none
        integer :: x, res, i

        res = 1
        i = 1
        do while(i <= x)
            res = res * i
            i = i + 1
        end do
    end function factorial
end module my_module