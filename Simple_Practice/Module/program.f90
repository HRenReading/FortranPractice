program demo
    use my_module
    implicit none
    integer :: a, a_sq, a_fact

    a = 6
    a_sq = square(a)
    a_fact = factorial(a)
    write(*, "(A,I0,A,I0)") "The sqare of ", a, " is ", a_sq
    write(*, "(A,I0,A,I0)") "The factorial of ", a, " is ", a_fact

end program demo