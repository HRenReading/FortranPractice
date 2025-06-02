module initial
    use parameters
    implicit none
    real, dimension(nl, nx, ny) :: h, T

contains

    subroutine set_initial_conditions()
        implicit none
        real, dimension(nx) :: x
        real, dimension(ny) :: y
        real :: xc, yc, sigma
        integer :: i, j

        call write_parameters_to_file()

        ! Define grid
        do i = 1, nx
            x(i) = (i - 0.5) * dx
        end do
        do j = 1, ny
            y(j) = (j - 0.5) * dy
        end do

        ! Gaussian bump parameters
        xc = 0.5 * Lx
        yc = 0.5 * Ly
        sigma = 0.15 * Lx

        ! Initialize h and T
        do j = 1, ny
            do i = 1, nx
                h(1, i, j) = H1 + 0.1 * H1 * exp(-((x(i) - xc)**2 / sigma**2 + (y(j) - yc)**2 / sigma**2))
                h(2, i, j) = H2 - (h(1, i, j) - H1)
                T(1, i, j) = T0 + dTmax * exp(-((x(i) - xc)**2 / sigma**2 + (y(j) - yc)**2 / sigma**2))
                T(2, i, j) = T0 + 0.1 * dTmax * exp(-((x(i) - xc)**2 / sigma**2 + (y(j) - yc)**2 / sigma**2))
            end do
        end do

        ! Save to files
        open(unit=10, file="results/initial_h", form="unformatted", access="stream", status="replace", action="write")
        write(10) h
        close(10)

        open(unit=11, file="results/initial_T", form="unformatted", access="stream", status="replace", action="write")
        write(11) T
        close(11)
    end subroutine set_initial_conditions

end module initial