module thermodynamics
    use parameters
    use boundary_condition
    implicit none

    contains
    subroutine thermal_tendency(T, u, v, dTdt)
        implicit none
        real, intent(in), dimension(nl, nx, ny) :: T
        real, intent(in), dimension(nl, nx+1, ny) :: u
        real, intent(in), dimension(nl, nx, ny+1) :: v
        real, intent(out), dimension(nl, nx, ny) :: dTdt

        real, dimension(nl, 0:nx+1, 0:ny+1) :: T_ext
        real, dimension(nl, 0:nx+2, 0:ny+1) :: u_ext
        real, dimension(nl, 0:nx+1, 0:ny+2) :: v_ext
        real, dimension(nl, nx, ny) :: udTdx, vdTdy, diff

        ! Apply boundary condition to T
        T_ext = bc(T, 'T')
        u_ext = bc(u, 'u')
        v_ext = bc(v, 'v')

        ! Addvection term
        udTdx = 0.5 * (u_ext(:, 1:nx, 1:ny) + u_ext(:, 2:nx+1, 1:ny)) * &
                (T_ext(:, 2:nx+1, 1:ny) - T_ext(:, 0:nx-1, 1:ny)) / (2 * dx)
        vdTdy = 0.5 * (v_ext(:, 1:nx, 1:ny) + v_ext(:, 1:nx, 2:ny+1)) * &
                (T_ext(:, 1:nx, 2:ny+1) - T_ext(:, 1:nx, 0:ny-1)) / (2 * dy)

        ! Diffusion term
        diff = kappa * ((T_ext(:, 2:nx+1, 1:ny) - 2 * T_ext(:, 1:nx, 1:ny) + T_ext(:, 0:nx-1, 1:ny)) / dx ** 2 + &
                        (T_ext(:, 1:nx, 2:ny+1) - 2 * T_ext(:, 1:nx, 1:ny) + T_ext(:, 1:nx, 0:ny-1)) / dy ** 2)

        ! Compute the thermal tendency
        dTdt = -(udTdx + vdTdy) + diff
    end subroutine thermal_tendency
end module thermodynamics