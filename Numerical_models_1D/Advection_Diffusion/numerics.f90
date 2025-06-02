module numerics
    use parameters
    implicit none

    contains
    function finite_diff(T) result(dTdt)
        implicit none
        real, dimension(nx) :: T, adv, diff, dTdt
        real :: T_ext(0:nx+1)

        T_ext(1:nx) = T
        T_ext(0) = T(nx)
        T_ext(nx+1) = T(1)

        ! advection
        adv = -c * (T_ext(2:nx+1) - T_ext(0:nx-1)) / (2 * dx)
        ! diffusion
        diff = kappa * (T_ext(2:nx+1) - 2 * T_ext(1:nx) + T_ext(0:nx-1)) / dx ** 2
        dTdt = adv + diff
    end function finite_diff

    function RK4(T_pre) result(T_next)
        implicit none
        real, intent(in) :: T_pre(nx)
        real :: T_next(nx)
        real, dimension(nx) :: k1, k2, k3, k4

        k1 = finite_diff(T_pre)
        k2 = finite_diff(T_pre + 0.5 * dt * k1)
        k3 = finite_diff(T_pre + 0.5 * dt * k2)
        k4 = finite_diff(T_pre + dt * k3)
        T_next = T_pre + dt * (k1 + 2 * k2 + 2 * k3 + k4) / 6.
    end function RK4

end module numerics