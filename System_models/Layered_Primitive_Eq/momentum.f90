module momentum
    use parameters
    use boundary_condition
    implicit none

    contains
    function v_to_ulocation(v_ext) result(v_u)
        implicit none
        real, dimension(nl, 0:nx+1, 0:ny+2) :: v_ext
        real, dimension(nl, nx+1, ny) :: v_u

        real, dimension(nl, 0:nx+1, ny) :: v_c

        ! v in cell center
        v_c = 0.5 * (v_ext(:, :, 1:ny) + v_ext(:, :, 2:ny+1))
        ! v at u-location
        v_u = 0.5 * (v_c(:, 0:nx, :) + v_c(:, 1:nx+1, :))

    end function v_to_ulocation

    function u_to_vlocation(u_ext) result(u_v)
        implicit none
        real, dimension(nl, 0:nx+2, 0:ny+1) :: u_ext
        real, dimension(nl, nx, ny+1) :: u_v

        real, dimension(nl, nx, 0:ny+1) :: u_c

        ! u in cell center
        u_c = 0.5 * (u_ext(:, 1:nx, :) + u_ext(:, 2:nx+1, :))
        ! u at v-location
        u_v = 0.5 * (u_c(:, :, 0:ny) + u_c(:, :, 1:ny+1))

    end function u_to_vlocation

    function laplacian_x(u_ext) result(lap_x)
        implicit none
        real, dimension(nl, 0:nx+2, 0:ny+1) :: u_ext
        real, dimension(nl, nx+1, ny) :: lap_x

        ! Compute the Laplacian term
        lap_x = (u_ext(:, 2:nx+2, 1:ny) - 2 * u_ext(:, 1:nx+1, 1:ny) + u_ext(:, 0:nx, 1:ny)) / dx ** 2 + &
                (u_ext(:, 1:nx+1, 2:ny+1) - 2 * u_ext(:, 1:nx+1, 1:ny) + u_ext(:, 1:nx+1, 0:ny-1)) / dy ** 2

    end function laplacian_x

    function laplacian_y(v_ext) result(lap_y)
        implicit none
        real, dimension(nl, 0:nx+1, 0:ny+2) :: v_ext
        real, dimension(nl, nx, ny+1) :: lap_y

        ! Compute the Laplacian term
        lap_y = (v_ext(:, 2:nx+1, 1:ny+1) - 2 * v_ext(:, 1:nx, 1:ny+1) + v_ext(:, 0:nx-1, 1:ny+1)) / dx ** 2 + &
                (v_ext(:, 1:nx, 2:ny+2) - 2 * v_ext(:, 1:nx, 1:ny+1) + v_ext(:, 1:nx, 0:ny)) / dy ** 2

    end function laplacian_y

    subroutine zonal_momentum(h, u, v, dudt)
        implicit none
        real, intent(in), dimension(nl, nx, ny) :: h
        real, intent(in), dimension(nl, nx+1, ny) :: u
        real, intent(in), dimension(nl, nx, ny+1) :: v
        real, intent(out), dimension(nl, nx+1, ny) :: dudt

        real, dimension(nl, 0:nx+1, 0:ny+1) :: h_ext
        real, dimension(nl, 0:nx+2, 0:ny+1) :: u_ext
        real, dimension(nl, 0:nx+1, 0:ny+2) :: v_ext
        real, dimension(nl, nx+1, ny) :: ududx, vdudy, lap_x

        ! Apply boundary condition to state variables
        h_ext = bc(h, 'h')
        u_ext = bc(u, 'u')
        v_ext = bc(v, 'v')

        ! Advection term
        ududx = u * (u_ext(:, 2:nx+2, 1:ny) - u_ext(:, 0:nx, 1:ny)) / (2 * dx)
        vdudy = v_to_ulocation(v_ext) * (u_ext(:, 1:nx+1, 2:ny+1) - u_ext(:, 1:nx+1, 0:ny-1)) / (2 * dy)

        ! Diffusion term
        lap_x = laplacian_x(u_ext)

        ! Zonal momentum tendency
        dudt(1, :, :) = -(ududx(1, :, :) + vdudy(1, :, :)) - &
                        g_ * (h_ext(1, 1:nx+1, 1:ny) - h_ext(1, 0:nx, 1:ny)) / dx + &
                        nu * lap_x(1, :, :)
        dudt(2, :, :) = -(ududx(2, :, :) + vdudy(2, :, :)) - &
                        g * ((h_ext(1, 1:nx+1, 1:ny) + h_ext(2, 1:nx+1, 1:ny)) - &
                             (h_ext(1, 0:nx, 1:ny) + h_ext(2, 0:nx, 1:ny))) / dx + &
                        nu * lap_x(2, :, :)

    end subroutine zonal_momentum

    subroutine meridional_momentum(h, u, v, dvdt)
        implicit none
        real, intent(in), dimension(nl, nx, ny) :: h
        real, intent(in), dimension(nl, nx+1, ny) :: u
        real, intent(in), dimension(nl, nx, ny+1) :: v
        real, intent(out), dimension(nl, nx, ny+1) :: dvdt

        real, dimension(nl, 0:nx+1, 0:ny+1) :: h_ext
        real, dimension(nl, 0:nx+2, 0:ny+1) :: u_ext
        real, dimension(nl, 0:nx+1, 0:ny+2) :: v_ext
        real, dimension(nl, nx, ny+1) :: udvdx, vdvdy, lap_y

        ! Apply boundary condition to state variables
        h_ext = bc(h, 'h')
        u_ext = bc(u, 'u')
        v_ext = bc(v, 'v')

        ! Advection term
        udvdx = u_to_vlocation(u_ext) * (v_ext(:, 2:nx+1, 1:ny+1) - v_ext(:, 0:nx-1, 1:ny+1)) / (2 * dx)
        vdvdy = v * (v_ext(:, 1:nx, 2:ny+2) - v_ext(:, 1:nx, 0:ny)) / (2 * dy)
        ! Diffusion term
        lap_y = laplacian_y(v_ext)

        ! Meridional momentum tendency
        dvdt(1, :, :) = -(udvdx(1, :, :) + vdvdy(1, :, :)) - &
                        g_ * (h_ext(1, 1:nx, 1:ny+1) - h_ext(1, 1:nx, 0:ny)) / dy + &
                        nu * lap_y(1, :, :)
        dvdt(2, :, :) = -(udvdx(2, :, :) + vdvdy(2, :, :)) - &
                        g * ((h_ext(1, 1:nx, 1:ny+1) + h_ext(2, 1:nx, 1:ny+1)) - &
                             (h_ext(1, 1:nx, 0:ny) + h_ext(2, 1:nx, 0:ny))) / dy + &
                        nu * lap_y(2, :, :)

    end subroutine meridional_momentum

    subroutine momentum_eq(h, u, v, dudt, dvdt)
        implicit none
        real, intent(in), dimension(nl, nx, ny) :: h
        real, intent(in), dimension(nl, nx+1, ny) :: u
        real, intent(in), dimension(nl, nx, ny+1) :: v
        real, intent(out), dimension(nl, nx+1, ny) :: dudt
        real, intent(out), dimension(nl, nx, ny+1) :: dvdt

        call zonal_momentum(h, u, v, dudt)
        call meridional_momentum(h, u, v, dvdt)
    end subroutine momentum_eq
end module momentum