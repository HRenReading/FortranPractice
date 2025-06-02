program read_demo
    implicit none
    real, dimension(5) :: data
    integer :: i

    open(unit=20, file='data.txt', status='old', action='read')
    do i = 1, 5
        read(20, '(F6.2)') data(i)
    end do
    print *, "The data in file is:"
    do i = 1, 5
        write(*, '(F6.2)') data(i)
    end do
    close(20)
end program read_demo