module parameters
    implicit none
    integer, parameter :: nx = 251                       ! number of cells in the zonal direction
    integer, parameter :: nl = 2                         ! number of vertical alyers
    real, parameter :: rho1 = 1024.                      ! upper layer water density, kg/m^3
    real, parameter :: rho2 = 1025.                      ! lower layer water density, kg/m^3
    real, parameter :: dx = 20.                          ! spacing between grid points, in meters
    real, parameter :: Lx = dx * nx                      ! domain size, in meters
    real, parameter :: H1 = 10.                          ! upper layer average water depth, in meters
    real, parameter :: H2 = 50.                          ! lower layer average water depth, in meters
    real, parameter :: hmax = 1.                         ! upper layer maximum initial temperature, in meters
    real, parameter :: u0 = 1E-6                         ! initial zonal velocity
    real, parameter :: dt = 0.1                          ! time-step size,second
    integer, parameter :: num_steps = 10000               ! number of time-steps in the simulation period
    real, parameter :: g = 9.81                          ! gravitational acceleration, m/s^2
    real, parameter :: g_ = g * (rho2 - rho1) / rho2     ! reduced gravity, m/s^2

contains

    subroutine write_parameters_to_file()
        implicit none
        open(unit=10, file='parameters.txt', status='replace', action='write')
        write(10, '(A, I0)')   "nx = ", nx
        write(10, '(A, I0)')   "nl = ", nl
        write(10, '(A, F6.2)') "dx = ", dx
        write(10, '(A, F12.2)') "Lx = ", Lx
        write(10, '(A, F6.2)')   "H1 = ", H1
        write(10, '(A, F6.2)')   "H2 = ", H2
        write(10, '(A, F6.2)') "hmax = ", hmax
        write(10, '(A, F6.3)') "dt = ", dt
        write(10, '(A, I0)')   "num_steps = ", num_steps
        close(10)
    end subroutine write_parameters_to_file

end module parameters