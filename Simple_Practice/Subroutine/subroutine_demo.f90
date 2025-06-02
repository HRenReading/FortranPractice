program subroutine_demo
    implicit none
    integer :: i
    real, dimension(10) :: x

    x = [1., 2., 3., 4., 5., 6., 7., 8., 9., 10.]
    call normalization(x)
    print *, "List after normalization:"
    do i = 1, 10
        write(*,'(F8.6)') x(i)
    end do
contains
    subroutine normalization(list)
        implicit none
        integer :: n, i
        real :: a
        real, dimension(:), intent(inout) :: list

        n = size(list)
        a = sum(list)

        do i = 1, n
            list(i) = list(i) / a
        end do
    end subroutine normalization
end program subroutine_demo