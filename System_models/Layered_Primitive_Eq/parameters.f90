module parameters
    implicit none
    ! ----------------------
    ! Grid Configuration
    ! ----------------------
    integer, parameter :: nx = 250                        ! number of zonal cells
    integer, parameter :: ny = 180                        ! number of meridional cells
    integer, parameter :: nl = 2                          ! number of vertical layers

    real,    parameter :: dx = 200.0                      ! zonal cell width (m)
    real,    parameter :: dy = 200.0                      ! meridional cell width (m)
    real,    parameter :: Lx = dx * (nx + 1)              ! total domain length in x (m)
    real,    parameter :: Ly = dy * (ny + 1)              ! total domain length in y (m)

    ! ----------------------
    ! Time Configuration
    ! ----------------------
    integer, parameter :: nt = 60000                       ! number of time steps
    real,    parameter :: dt = 0.1                         ! time-step size (s)

    ! ----------------------
    ! Layer Properties
    ! ----------------------
    real,    parameter :: H1 = 50.0                       ! upper layer thickness (m)
    real,    parameter :: H2 = 450.0                      ! lower layer thickness (m)

    ! ----------------------
    ! Temperature Properties
    ! ----------------------
    real,    parameter :: dTmax = 25.0                    ! max temp anomaly in upper layer (K)
    real,    parameter :: T0 = 273.15                     ! reference temperature (K)

    ! ----------------------
    ! Density & Gravity
    ! ----------------------
    real,    parameter :: rho1 = 1024.0                   ! upper layer density (kg/m^3)
    real,    parameter :: rho2 = 1028.0                   ! lower layer density (kg/m^3)
    real,    parameter :: g = 9.81                        ! gravitational acceleration (m/s^2)
    real,    parameter :: g_ = g * (rho2 - rho1) / rho2   ! reduced gravity (m/s^2)

    ! ----------------------
    ! Diffusion & Viscosity
    ! ----------------------
    real,    parameter :: kappa = 1e-5                    ! thermal diffusion coefficient (m²/s)
    real,    parameter :: nu = 1000.0                     ! horizontal viscosity (m²/s)

    ! ----------------------
    ! Initial Velocities
    ! ----------------------
    real,    parameter :: u0 = 5.                         ! initial zonal velocity (m/s)
    real,    parameter :: v0 = 1.                         ! initial meridional velocity (m/s)

    ! ----------------------
    ! Utility Subroutine
    ! ----------------------
    contains
    subroutine write_parameters_to_file()
        implicit none
        open(unit=10, file='parameters.txt', status='replace', action='write')
        write(10, '(A, I0)')     "nl = ", nl
        write(10, '(A, I0)')     "nx = ", nx
        write(10, '(A, I0)')     "ny = ", ny
        write(10, '(A, F10.2)')  "dx = ", dx
        write(10, '(A, F10.2)')  "dy = ", dy
        write(10, '(A, F10.2)')  "Lx = ", Lx
        write(10, '(A, F10.2)')  "Ly = ", Ly
        write(10, '(A, F10.2)')  "H1 = ", H1
        write(10, '(A, F10.2)')  "H2 = ", H2
        write(10, '(A, F10.2)')  "dt = ", dt
        write(10, '(A, I0)')     "nt = ", nt
        close(10)
    end subroutine write_parameters_to_file

end module parameters