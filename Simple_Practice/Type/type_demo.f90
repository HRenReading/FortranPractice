program type_demo
    implicit none
    integer :: i

    type gridpoints
        real :: T, p, rho
    end type gridpoints

    type(gridpoints), dimension(3) :: points

    do i = 1, 3
        points(i)%T = 288. - (i - 1) * 6.5
        points(i)%p = 100000. - (i - 1) * 60.
        points(i)%rho = 1.025 - (i - 1) * 0.01
    end do

    print *, "T (K)    P (Pa)       rho (kg/m^3)"
    do i = 1, 3
        write(*,'(F7.2, 1X, F10.2, 1X, F8.3)') points(i)%T, points(i)%p, points(i)%rho
    end do
end program type_demo