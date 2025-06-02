module parameters
    implicit none
    integer, parameter :: nx = 250                   ! number of cells in the zonal direction
    real, parameter :: dx = 20.                      ! spacing between grid points, in meters
    real, parameter :: Lx = dx * nx                  ! domain size, in meters
    real, parameter :: H = 50.                       ! total average water depth, in meters
    real, parameter :: hmax = 3.                     ! maximum initial temperature, in meters
    real, parameter :: u0 = 1E-6                     ! initial zonal velocity
    real, parameter :: dt = 0.1                      ! time-step size,second
    integer, parameter :: num_steps = 5000           ! number of time-steps in the simulation period
    real, parameter :: g = 9.81                      ! gravitational acceleration, m/s^2

contains

    subroutine write_parameters_to_file()
        implicit none
        open(unit=10, file='parameters.txt', status='replace', action='write')
        write(10, '(A, I0)')   "nx = ", nx
        write(10, '(A, F6.2)') "dx = ", dx
        write(10, '(A, F12.2)') "Lx = ", Lx
        write(10, '(A, F6.2)')   "H = ", H
        write(10, '(A, F6.2)') "hmax = ", hmax
        write(10, '(A, F6.3)') "dt = ", dt
        write(10, '(A, I0)')   "num_steps = ", num_steps
        close(10)
    end subroutine write_parameters_to_file

end module parameters