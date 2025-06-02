module Numerics
    use parameters
    implicit none

    contains
    function finite_diff(T_pre) result(dTdt)
        implicit none
        real, intent(in)  :: T_pre(nx)
        real              :: dTdt(nx)
        real              :: T_ext(0:nx+1)
        integer           :: i

        T_ext(1:nx) = T_pre
        T_ext(0) = T_pre(1)        ! Left boundary: copy value
        T_ext(nx+1) = T_pre(nx)    ! Right boundary

        dTdt = alpha * (T_ext(2:nx+1) - 2 * T_ext(1:nx) + T_ext(0:nx-1)) / dx ** 2

        print *, "max(T_pre):", maxval(T_pre), "min(T_pre):", minval(T_pre)
        print *, "max(T_ext):", maxval(T_ext), "min(T_ext):", minval(T_ext)
        print *, "sum(dTdt):", sum(dTdt)
        print *, "max(dTdt):", maxval(dTdt)
        print *, "min(dTdt):", minval(dTdt)
    end function finite_diff

    function RK4(T_pre) result(T_next)
        implicit none
        real, intent(in) :: T_pre(nx)
        real, dimension(nx) :: T_k2, T_k3, T_k4
        real :: k1(nx), k2(nx), k3(nx), k4(nx), T_next(nx)

        k1 = finite_diff(T_pre)
        k2 = finite_diff(T_pre + 0.5 * dt * k1)
        k3 = finite_diff(T_pre + 0.5 * dt * k2)
        k4 = finite_diff(T_pre + dt * k3)
        T_next = T_pre + dt * (k1 + 2 * k2 + 2 * k3 + k4) / 6.
    end function RK4
end module Numerics