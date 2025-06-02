module numerics
    use parameters
    implicit none

    contains
    function FD1(var_ext, u, v) result(dvar)
        implicit none
        real, dimension(0:nx+1, 0:ny+1) :: var_ext
        real, dimension(nx, ny) :: u, v
        real, dimension(nx, ny) :: dvar

        dvar = u * (var_ext(2:nx+1, 1:ny) - var_ext(0:nx-1, 1:ny)) / (2 * dx) + &
               v * (var_ext(1:nx, 2:ny+1) - var_ext(1:nx, 0:ny-1)) / (2 * dy)
    end function FD1

    function FD2(var_ext) result(dvar2)
        implicit none
        real, dimension(0:nx+1, 0:ny+1) :: var_ext
        real, dimension(nx, ny) :: dvar2

        dvar2 = (var_ext(2:nx+1, 1:ny) - 2 * var_ext(1:nx, 1:ny) + var_ext(0:nx-1, 1:ny)) / dx ** 2 + &
                (var_ext(1:nx, 2:ny+1) - 2 * var_ext(1:nx, 1:ny) + var_ext(1:nx, 0:ny-1)) / dy ** 2
    end function FD2

    function finite_diff(T, u, v) result(dTdt)
        implicit none
        real, dimension(nx, ny) :: T, dTdt, u, v
        real, dimension(0:nx+1, 0:ny+1) :: T_ext, u_ext, v_ext

        T_ext(1:nx, 1:ny) = T
        T_ext(0, :) = T_ext(nx, :)
        T_ext(nx+1, :) = T_ext(1, :)
        T_ext(:, 0) = T_ext(:, 1)
        T_ext(:, ny+1) = T_ext(:, ny)

        dTdt = -FD1(T_ext, u, v) + kappa * FD2(T_ext)
    end function finite_diff

    function RK4(T_pre, u, v) result(T_next)
        implicit none
        real, dimension(nx, ny) :: T_pre, T_next, u, v
        real, dimension(nx, ny) :: k1, k2, k3, k4

        k1 = finite_diff(T_pre, u, v)
        k2 = finite_diff(T_pre + 0.5 * dt * k1, u, v)
        k3 = finite_diff(T_pre + 0.5 * dt * k2, u, v)
        k4 = finite_diff(T_pre + dt * k3, u, v)

        T_next = T_pre + dt * (k1 + 2 * k2 + 2 * k3 + k4) / 6.
    end function RK4
end module numerics