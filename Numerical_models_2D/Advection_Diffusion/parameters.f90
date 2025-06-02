module parameters
    implicit none
    real,    parameter :: kappa = 20.               ! diffusion coefficient, J/(kg*K)
    integer, parameter :: nx = 256                  ! number of grid points in zonal direction
    integer, parameter :: ny = 188                  ! number of grid points in meridional direction
    real,    parameter :: dx = 10.                  ! zonal grid spacing, in meters
    real,    parameter :: dy = 10.                  ! meridional grid spacing, in meters
    real,    parameter :: Lx = dx * nx              ! zonal domain, in meters
    real,    parameter :: Ly = dy * ny              ! meridional domain, in meters
    real,    parameter :: u0 = 0.5                  ! zonal initial wind velocity, m/s
    real,    parameter :: v0 = 0.1                  ! meridional initial wind velocity, m/s
    real,    parameter :: dTmax = 298.15            ! maximum initial temperature perturbation, in Kelvin
    real,    parameter :: T_ave = 283.15            ! initial average temperature, in Kelvin
    real,    parameter :: dt = 1.                   ! time-step size, in seconds
    integer, parameter :: nt = 5000                 ! number of time steps in the simulation period

    contains
    subroutine write_parameters_to_file()
        implicit none
        open(unit=10, file='parameters.txt', status='replace', action='write')
        write(10, '(A, I0)')   "nx = ", nx
        write(10, '(A, I0)')   "ny = ", ny
        write(10, '(A, F6.2)') "dx = ", dx
        write(10, '(A, F6.2)') "dy = ", dy
        write(10, '(A, F12.2)') "Lx = ", Lx
        write(10, '(A, F12.2)') "Ly = ", Ly
        write(10, '(A, F6.2)')   "T_ave = ", T_ave
        write(10, '(A, F6.2)') "hmax = ", dTmax
        write(10, '(A, F6.3)') "dt = ", dt
        write(10, '(A, I0)')   "nt = ", nt
        close(10)
    end subroutine write_parameters_to_file
end module parameters