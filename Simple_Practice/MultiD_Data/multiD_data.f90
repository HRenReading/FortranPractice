program multiD_data_demo
    implicit none
    real, dimension(3, 4) :: a
    integer :: i, j

    a = reshape([3., 6., 9., 12., 15., 18., 21., 24., 27., 30., 33., 36.], [3, 4])
    print *, "2D array before row-wise normalization: "
    do i = 1, 3
        do j = 1, 4
            write(*,'(F8.2)', advance='no') a(i, j)
        end do
        print *   ! move to next line
    end do

    call normalize(a(1, 1:))
    call normalize(a(2, 1:))
    call normalize(a(3, 1:))
    print *, "2D array after row-wise normalization: "
    do i = 1, 3
        do j = 1, 4
            write(*,'(F8.2)', advance='no') a(i, j)
        end do
        print *   ! move to next line
    end do

contains
    subroutine normalize(list)
        implicit none
        real, dimension(:), intent(inout) :: list
        integer :: i, n
        real :: s

        s = sum(list)
        n = size(list)

        do i = 1, n
            list(i) = list(i) / s
        end do
    end subroutine normalize

end program multiD_data_demo