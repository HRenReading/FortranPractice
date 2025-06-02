module numerics
    use parameters
    implicit none

    contains
    function interface_flux(flux) result(dF)
        implicit none
        real, dimension(0:nx+1) :: flux
        real, dimension(nx) :: fluxL, fluxR, dF

        fluxL = 0.5 * (flux(0:nx-1) + flux(1:nx))
        fluxR = 0.5 * (flux(2:nx+1) + flux(1:nx))
        dF = (fluxR - fluxL) / dx
    end function interface_flux

    subroutine finite_volume(h, u, dhdx, dhudx)
        implicit none
        real, intent(in), dimension(nl, nx) :: h, u
        real, intent(out), dimension(nl, nx) :: dhdx, dhudx
        real, dimension(nl, 0:nx+1) :: h_ext, u_ext, hu_ext
        real, dimension(0:nx+1) :: flux_upper, flux_lower

        call write_parameters_to_file()

        h_ext(:, 1:nx) = h
        h_ext(:, 0) = h(:, nx)
        h_ext(:, nx+1) = h(:, 1)
        u_ext(:, 1:nx) = u
        u_ext(:, 0) = u(:, nx)
        u_ext(:, nx+1) = u(:, 1)

        hu_ext = h_ext * u_ext
        flux_upper = hu_ext(1,:) * u_ext(1,:) + 0.5 * g * h_ext(1,:) ** 2
        flux_lower = hu_ext(2,:) * u_ext(2,:) + 0.5 * g * h_ext(2,:) ** 2 + g_ * h_ext(1,:) * h_ext(2,:)

        ! upper level
        dhdx(1,:) = -interface_flux(hu_ext(1,:))
        dhudx(1,:) = -interface_flux(flux_upper)
        ! lower level
        dhdx(2,:) = -interface_flux(hu_ext(2,:))
        dhudx(2,:) = -interface_flux(flux_lower)
    end subroutine finite_volume

    subroutine RK4(h_pre, u_pre, h_next, u_next)
        implicit none
        real, intent(in), dimension(nl, nx) :: h_pre, u_pre
        real, intent(out), dimension(nl, nx) :: h_next, u_next
        real, dimension(nl, nx) :: h_temp, hu_temp, u_temp, hu_pre, hu_next
        real, dimension(nl, nx) :: k1h, k2h, k3h, k4h, k1hu, k2hu, k3hu, k4hu

        hu_pre = h_pre * u_pre

        call finite_volume(h_pre, u_pre, k1h, k1hu)
        h_temp = h_pre + 0.5 * dt * k1h
        hu_temp = hu_pre + 0.5 * dt * k1hu
        u_temp = hu_temp / h_temp

        call finite_volume(h_temp, u_temp, k2h, k2hu)
        h_temp = h_pre + 0.5 * dt * k2h
        hu_temp = hu_pre + 0.5 * dt * k2hu
        u_temp = hu_temp / h_temp

        call finite_volume(h_temp, u_temp, k3h, k3hu)
        h_temp = h_pre + dt * k3h
        hu_temp = hu_pre + dt * k3hu
        u_temp = hu_temp / h_temp

        call finite_volume(h_temp, u_temp, k4h, k4hu)

        h_next = h_pre + dt * (k1h + 2 * k2h + 2 * k3h + k4h) / 6.
        hu_next = hu_pre + dt * (k1hu + 2 * k2hu + 2 * k3hu + k4hu) / 6.
        u_next = hu_next / h_next
    end subroutine RK4
end module numerics