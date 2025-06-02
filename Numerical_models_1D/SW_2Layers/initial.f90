program initial
    use parameters
    implicit none
    real, dimension(nx) :: x(nx), eta(nx)
    real, dimension(nl, nx) :: h0
    real :: xc
    integer :: i

    xc = Lx / 2.
    do i = 1, nx
        x(i) = (i - 1) * dx
    end do
    eta = hmax * exp(-(x - xc) ** 2 / (0.2 * Lx) ** 2)
    h0(1,:) = H1 + eta
    h0(2,:) = H2 + 0.1 * eta

    open(unit=10, file="results/initial.txt", status="replace", action="write")
    do i = 1, nl
        write(10, *) h0(i,:)
    end do
    close(10)
end program initial