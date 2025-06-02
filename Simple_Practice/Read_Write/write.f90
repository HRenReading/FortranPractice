program write_demo
    implicit none
    real, dimension(5) :: data
    integer :: i

    data = [1., 1.1, 1.2, 1.3, 1.4]

    open(unit=10, file='data.txt', status='replace', action='write')
    do i = 1, 5
        write(10, '(F6.2)') data(i)
    end do
    close(10)
end program write_demo