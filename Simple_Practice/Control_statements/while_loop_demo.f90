program while_loop
    implicit none
    integer :: i

    i = 1

    do while(i <= 5)
        print *, "Iteration", i
        i = i + 1
    end do
end program while_loop