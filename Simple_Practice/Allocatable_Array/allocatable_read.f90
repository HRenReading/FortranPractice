program allocatable_read
    implicit none
    real, allocatable :: data(:,:)
    integer :: i, j

    allocate(data(3, 3))

    open(unit=20, file='data.txt', status='old', action='read')
    read(20, *) data
    close(20)

    i = 1
    j = 1

    print *, "The data from file is:"
    do i = 1, 3
        do j = 1, 3
            write(*, '(F6.2)', advance='no') data(i, j)
            write(*, '(A)', advance='no') '  '
        end do
        print *  ! new line
    end do

    deallocate(data)
end program allocatable_read