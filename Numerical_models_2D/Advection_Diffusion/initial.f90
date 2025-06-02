program initial
    use parameters
    implicit none
    real, dimension(nx, ny) :: T0
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
            T0(i,j) = T_ave + dTmax * exp( -((x(i) - xc)**2 / sigma_x**2 + (y(j) - yc)**2 / sigma_y**2) )
        end do
    end do

    open(unit=10, file="results/initial", form='unformatted', access="stream", status="replace", action="write")
    write(10) T0
    close(10)
end program initial