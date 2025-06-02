module numerics
    use parameters
    implicit none

    contains
    function interface_flux(flux) result(dflux)
        implicit none
        real, intent(in) :: flux(0:nx+1)
        real, dimension(nx) :: fluxL, fluxR
        real, dimension(nx) :: dflux

        fluxL = 0.5 * (flux(0:nx-1) + flux(1:nx))
        fluxR = 0.5 * (flux(1:nx) + flux(2:nx+1))
        dflux = (fluxR - fluxL) / dx
    end function interface_flux

    subroutine finite_volume(h, u, dhdx, dhudx)
        implicit none
        real, intent(in), dimension(nx) :: h, u
        real, intent(out), dimension(nx) :: dhdx, dhudx
        real :: h_ext(0:nx+1), u_ext(0:nx+1), hu_ext(0:nx+1), flux(0:nx+1)

        h_ext(1:nx) = h
        h_ext(0) = h(nx)
        h_ext(nx+1) = h(1)
        u_ext(1:nx) = u
        u_ext(0) = u(nx)
        u_ext(nx+1) = u(1)
        hu_ext = h_ext * u_ext
        flux = hu_ext * u_ext + 0.5 * g * h_ext ** 2

        dhdx = -interface_flux(hu_ext)
        dhudx = -interface_flux(flux)
    end subroutine finite_volume

    subroutine RK4(h_pre, u_pre, h_next, u_next)
        implicit none
        real, intent(in), dimension(nx) :: h_pre, u_pre
        real, intent(out), dimension(nx) :: h_next, u_next
        real, dimension(nx) :: h_temp, hu_temp, u_temp, hu_pre, hu_next
        real, dimension(nx) :: k1h, k2h, k3h, k4h, k1hu, k2hu, k3hu, k4hu

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