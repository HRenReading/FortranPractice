module parameters
    implicit none
    real, parameter :: alpha = 2.2E-1               ! diffusivity coefficient of air, m^2/s
    integer, parameter :: nx = 51                   ! grid points in zonal direction
    real, parameter :: dx = 1.                    ! spacing between grid points, in meters
    real, parameter :: Lx = dx * (nx - 1)           ! domain size, in meters
    real, parameter :: Tmax = 298.15                ! maximum initial temperature, in Kelvin
    real, parameter :: T_ave = 278.15               ! averaged initial temperature, in Kelvin
    real, parameter :: dt = 1.                     ! time-step size,second
    integer, parameter :: num_steps = 500         ! number of time-steps in the simulation period

contains

    subroutine write_parameters_to_file()
        implicit none
        open(unit=10, file='parameters.txt', status='replace', action='write')
        write(10, '(A, I0)')   "nx = ", nx
        write(10, '(A, F6.2)') "dx = ", dx
        write(10, '(A, F12.2)') "Lx = ", Lx
        write(10, '(A, F6.2)') "Tmax = ", Tmax
        write(10, '(A, F6.3)') "dt = ", dt
        write(10, '(A, I0)')   "num_steps = ", num_steps
        close(10)
    end subroutine write_parameters_to_file

end module parameters