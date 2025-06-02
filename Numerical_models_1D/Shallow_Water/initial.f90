program initial
    use parameters
    implicit none
    real :: h0(nx), x(nx)
    real :: xc
    integer :: i

    xc = Lx / 2.
    do i = 1, nx
        x(i) = (i - 1) * dx
    end do
    h0 = H + hmax * exp(-(x - xc) ** 2 / (0.2 * Lx) ** 2)

    open(unit=10, file="results/initial.txt", status="replace", action="write")
    write(10, *) h0
    close(10)
end program initial