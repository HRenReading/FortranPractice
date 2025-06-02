module parameters
    implicit none
    integer, parameter :: nl = 2                            ! number of vertical layers
    integer, parameter :: nx = 256                          ! number of grid points in zonal direction
    integer, parameter :: ny = 188                          ! number of grid points in meridional direction
    real,    parameter :: dx = 20.                          ! zonal grid spacing, in meters
    real,    parameter :: dy = 20.                          ! meridional grid spacing, in meters
    real,    parameter :: Lx = dx * nx                      ! zonal domain, in meters
    real,    parameter :: Ly = dy * ny                      ! meridional domain, in meters
    real,    parameter :: u0 = 1E-6                         ! zonal initial wind velocity, m/s
    real,    parameter :: v0 = 1E-6                         ! meridional initial wind velocity, m/s
    real,    parameter :: dhmax = 3.                        ! maximum initial surface elevation, in meters
    real,    parameter :: H1 = 50.                          ! initial upper layer water depth, in meters
    real,    parameter :: H2 = 100.                         ! initial lower layer water depth, in meters
    real,    parameter :: rho1 = 1024.                      ! upper layer water density, kg/m^3
    real,    parameter :: rho2 = 1026.                      ! lower layer water density, kg/m^3
    real,    parameter :: dt = 0.1                          ! time-step size, in seconds
    integer, parameter :: nt = 10000                        ! number of time steps in the simulation period
    real,    parameter :: g = 9.81                          ! gravitational acceleration, m/s
    real,    parameter :: g_ = g * (rho2 - rho1) / rho2     ! reduced gravity, m/s^2

    contains
    subroutine write_parameters_to_file()
        implicit none
        open(unit=10, file='parameters.txt', status='replace', action='write')
        write(10, '(A, I0)')   "nl = ", nl
        write(10, '(A, I0)')   "nx = ", nx
        write(10, '(A, I0)')   "ny = ", ny
        write(10, '(A, F6.2)') "dx = ", dx
        write(10, '(A, F6.2)') "dy = ", dy
        write(10, '(A, F12.2)') "Lx = ", Lx
        write(10, '(A, F12.2)') "Ly = ", Ly
        write(10, '(A, F6.2)')   "H1 = ", H1
        write(10, '(A, F6.2)')   "H2 = ", H2
        write(10, '(A, F6.3)') "dt = ", dt
        write(10, '(A, I0)')   "nt = ", nt
        close(10)
    end subroutine write_parameters_to_file
end module parameters