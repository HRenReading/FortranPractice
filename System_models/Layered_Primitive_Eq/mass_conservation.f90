module mass_conservation
    use parameters
    use boundary_condition
    implicit none

    contains
    subroutine interpolation_h(h, u, v, hu, hv)
        implicit none
        real, intent(in), dimension(nl, nx, ny) :: h
        real, intent(in), dimension(nl, nx+1, ny) :: u
        real, intent(in), dimension(nl, nx, ny+1) :: v
        real, intent(out), dimension(nl, nx+1, ny) :: hu
        real, intent(out), dimension(nl, nx, ny+1) :: hv

        real, dimension(nl, 0:nx+1, 0:ny+1) :: h_ext

        ! Apply boundary condition to the water depth field
        h_ext = bc(h, 'h')

        ! Interpolate h with ghost points with velocity (mass fluxes at interfaces)
        hu = 0.5 * (h_ext(:, 0:nx, 1:ny) + h_ext(:, 1:nx+1, 1:ny)) * u
        hv = 0.5 * (h_ext(:, 1:nx, 0:ny) + h_ext(:, 1:nx, 1:ny+1)) * v

    end subroutine interpolation_h

    subroutine interface_flux(flux_x, flux_y, dFx, dFy)
        implicit none
        real, intent(in), dimension(nl, nx+1, ny) :: flux_x
        real, intent(in), dimension(nl, nx, ny+1) :: flux_y
        real, intent(out), dimension(nl, nx, ny) :: dFx, dFy

        ! Zonal interface
        dFx = (flux_x(:, 2:nx+1, :) - flux_x(:, 1:nx, :)) / dx
        ! Meridional interface flux
        dFy = (flux_y(:, :, 2:ny+1) - flux_y(:, :, 1:ny)) / dy

    end subroutine interface_flux

    subroutine mass_tendency(h, u, v, dhdt)
        implicit none
        real, intent(in), dimension(nl, nx, ny) :: h
        real, intent(in), dimension(nl, nx+1, ny) :: u
        real, intent(in), dimension(nl, nx, ny+1) :: v
        real, dimension(nl, nx, ny), intent(out) :: dhdt

        real, dimension(nl, nx+1, ny) :: hu
        real, dimension(nl, nx, ny+1) :: hv
        real, dimension(nl, nx, ny) :: dFx, dFy

        call interpolation_h(h, u, v, hu, hv)
        call interface_flux(hu, hv, dFx, dFy)
        dhdt = -(dFx + dFy)
    end subroutine mass_tendency
end module mass_conservation