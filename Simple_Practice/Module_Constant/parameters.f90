module parameters
    implicit none

    real, parameter :: g = 9.81                 ! gravity, m/s^2
    real, parameter :: p0 = 101325.             ! sea-lever pressure, Pa
    real, parameter :: M = 0.0289644            ! molar mass of air, kg/mol
    real, parameter :: R = 8.3144598            ! universal gas constant, J/mol·K
    real, parameter :: T0 = 288.15              ! assumed isothermal temperature, K
end module parameters