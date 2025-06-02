module numerics
    use parameters
    implicit none

    contains
    function boundary_condition(var, var_name) result(var_ext)
        implicit none
        real, dimension(nx, ny) :: var
        real, dimension(0:nx+1, 0:ny+1) :: var_ext
        character(len=*) :: var_name

        var_ext(1:nx, 1:ny) = var
        var_ext(0, :) = var_ext(nx, :)
        var_ext(nx+1, :) = var_ext(1, :)

        if (var_name == "v") then
            var_ext(:, 0) = -var_ext(:, 1)
            var_ext(:, ny+1) = -var_ext(:, ny)
        else
            var_ext(:, 0) = var_ext(:, 1)
            var_ext(:, ny+1) = var_ext(:, ny)
        end if
    end function boundary_condition

    function interface_flux(var_ext, dir) result(dF)
        implicit none
        real, dimension(0:nx+1, 0:ny+1) :: var_ext
        real, dimension(nx, ny) :: fluxL, fluxR, fluxB, fluxT, dF
        character(len=*) :: dir

        if (dir == "zonal") then
            fluxL = 0.5 * (var_ext(0:nx-1, 1:ny) + var_ext(1:nx, 1:ny))
            fluxR = 0.5 * (var_ext(1:nx, 1:ny) + var_ext(2:nx+1, 1:ny))
            dF = (fluxR - fluxL) / dx
        else if (dir == "meridional") then
            fluxB = 0.5 * (var_ext(1:nx, 0:ny-1) + var_ext(1:nx, 1:ny))
            fluxT = 0.5 * (var_ext(1:nx, 1:ny) + var_ext(1:nx, 2:ny+1))
            dF = (fluxT - fluxB) / dy
        else
            stop "Invalid direction in interface_flux"
        end if
    end function interface_flux

    subroutine finite_volume(h, u, v, dh, dhu, dhv)
        implicit none
        real, intent(in), dimension(nx, ny) :: h, u, v
        real, intent(out), dimension(nx, ny) :: dh, dhu, dhv
        real, dimension(0:nx+1, 0:ny+1) :: h_ext, u_ext, v_ext, hu, hv, huv, flux_x, flux_y

        h_ext = boundary_condition(h, "h")
        u_ext = boundary_condition(u, "u")
        v_ext = boundary_condition(v, "v")

        hu = h_ext * u_ext
        hv = h_ext * v_ext
        huv = hu * v_ext
        flux_x = hu * u_ext + 0.5 * g * h_ext ** 2
        flux_y = hv * v_ext + 0.5 * g * h_ext ** 2

        dh = -interface_flux(hu, "zonal") - interface_flux(hv, "meridional")
        dhu = -interface_flux(flux_x, "zonal") - interface_flux(huv, "meridional")
        dhv = - interface_flux(huv, "zonal") - interface_flux(flux_y, "meridional")
    end subroutine finite_volume

    subroutine RK4(h_pre, u_pre, v_pre, h_next, u_next, v_next)
        implicit none
        real, intent(in),  dimension(nx, ny) :: h_pre, u_pre, v_pre
        real, intent(out), dimension(nx, ny) :: h_next, u_next, v_next
        real, dimension(nx, ny) :: k1h, k1hu, k1hv, k2h, k2hu, k2hv, k3h, k3hu, k3hv, k4h, k4hu, k4hv
        real, dimension(nx, ny) :: hu, hv, h_temp, hu_temp, hv_temp, u_temp, v_temp, hu_next, hv_next

        hu = h_pre * u_pre
        hv = h_pre * v_pre

        call finite_volume(h_pre, u_pre, v_pre, k1h, k1hu, k1hv)

        h_temp = h_pre + 0.5 * dt * k1h
        hu_temp = hu + 0.5 * dt * k1hu
        hv_temp = hv + 0.5 * dt * k1hv
        u_temp = hu_temp / h_temp
        v_temp = hv_temp / h_temp
        call finite_volume(h_temp, u_temp, v_temp, k2h, k2hu, k2hv)

        h_temp = h_pre + 0.5 * dt * k2h
        hu_temp = hu + 0.5 * dt * k2hu
        hv_temp = hv + 0.5 * dt * k2hv
        u_temp = hu_temp / h_temp
        v_temp = hv_temp / h_temp
        call finite_volume(h_temp, u_temp, v_temp, k3h, k3hu, k3hv)

        h_temp = h_pre + dt * k3h
        hu_temp = hu + dt * k3hu
        hv_temp = hv + dt * k3hv
        u_temp = hu_temp / h_temp
        v_temp = hv_temp / h_temp
        call finite_volume(h_temp, u_temp, v_temp, k4h, k4hu, k4hv)

        h_next = h_pre + dt * (k1h + 2 * k2h + 2 * k3h + k4h) / 6.
        hu_next = hu + dt * (k1hu + 2 * k2hu + 2 * k3hu + k4hu) / 6.
        hv_next = hv + dt * (k1hv + 2 * k2hv + 2 * k3hv + k4hv) / 6.
        u_next = hu_next / h_next
        v_next = hv_next / h_next
    end subroutine RK4
end module numerics