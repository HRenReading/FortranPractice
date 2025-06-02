program do_loop
    implicit none
    integer :: i

    i = 1

    do i = 1, 5
        print *, "Iteration ", i
    end do
end program do_loop