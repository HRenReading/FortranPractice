program if_else_demo
    implicit none
    integer :: num

    num = 5

    if (num < 3) then
        print *, "Number is smaller than 3."
    else if (num >= 3 .and. num <= 5) then
        print *, "Number is between 3 and 5."
    else
        print *, "Number is larger than 5."
    end if
end program if_else_demo