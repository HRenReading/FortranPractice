program initial
    use parameters
    implicit none
    real :: T0(nx), x(nx)
    real :: xc
    integer :: i

    xc = Lx / 2.
    do i = 1, nx
        x(i) = (i - 1) * dx
    end do
    T0 = T_ave + (Tmax - T_ave) * exp(-(x - xc) ** 2 / (0.2 * Lx) ** 2)

    open(unit=10, file="initial.txt", status="replace", action="write")
    write(10, *) T0
    close(10)
end program initial