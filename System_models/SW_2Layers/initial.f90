program initial
    use parameters
    implicit none
    real, dimension(nl, nx, ny) :: h0
    real, dimension(nx, ny) :: eta
    real :: x(nx), y(ny)
    integer :: i, j
    real :: xc, yc
    real :: sigma_x, sigma_y

    do i = 1, nx
        x(i) = (i - 1) * dx
    end do
    do i = 1, ny
        y(i) = (i - 1) * dy
    end do

    xc = Lx / 2.0
    yc = Ly / 2.0

    sigma_x = 0.2 * Lx
    sigma_y = 0.2 * Ly

    do j = 1, ny
        do i = 1, nx
            eta(i,j) = dhmax * exp( -((x(i) - xc)**2 / sigma_x**2 + (y(j) - yc)**2 / sigma_y**2) )
        end do
    end do

    h0(1, :, :) = H1 + eta
    h0(2, :, :) = H2 + 0.2 * eta

    open(unit=10, file="results/initial", form='unformatted', access="stream", status="replace", action="write")
    write(10) h0
    close(10)
end program initial