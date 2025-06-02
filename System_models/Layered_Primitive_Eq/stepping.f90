module stepping
    use parameters
    use mass_conservation
    use momentum
    use thermodynamics

    contains
    subroutine numerics(h, u, v, T, dh, du, dv, dT)
        implicit none
        real, intent(in), dimension(nl, nx, ny) :: h, T
        real, intent(in), dimension(nl, nx+1, ny) :: u
        real, intent(in), dimension(nl, nx, ny+1) :: v
        real, intent(out), dimension(nl, nx, ny) :: dh, dT
        real, intent(out), dimension(nl, nx+1, ny) :: du
        real, intent(out), dimension(nl, nx, ny+1) :: dv

        call mass_tendency(h, u, v, dh)
        call momentum_eq(h, u, v, du, dv)
        call thermal_tendency(T, u, v, dT)
    end subroutine numerics

    subroutine RK4(h_pre, u_pre, v_pre, T_pre, h_next, u_next, v_next, T_next)
        implicit none
        real, intent(in), dimension(nl, nx, ny) :: h_pre, T_pre
        real, intent(in), dimension(nl, nx+1, ny) :: u_pre
        real, intent(in), dimension(nl, nx, ny+1) :: v_pre
        real, intent(out), dimension(nl, nx, ny) :: h_next, T_next
        real, intent(out), dimension(nl, nx+1, ny) :: u_next
        real, intent(out), dimension(nl, nx, ny+1) :: v_next

        real, dimension(nl, nx, ny) :: k1h, k2h, k3h, k4h
        real, dimension(nl, nx, ny) :: k1T, k2T, k3T, k4T
        real, dimension(nl, nx+1, ny) :: k1u, k2u, k3u, k4u
        real, dimension(nl, nx, ny+1) :: k1v, k2v, k3v, k4v

        ! Compute 1st slope
        call numerics(h_pre, u_pre, v_pre, T_pre, k1h, k1u, k1v, k1T)
        ! Compute 2nd slope
        call numerics(h_pre + 0.5 * dt * k1h, u_pre + 0.5 * dt * k1u, v_pre + 0.5 * dt * k1v, T_pre + 0.5 * dt * k1T,&
                      k2h, k2u, k2v, k2T)
        ! Compute 3rd slope
        call numerics(h_pre + 0.5 * dt * k2h, u_pre + 0.5 * dt * k2u, v_pre + 0.5 * dt * k2v, T_pre + 0.5 * dt * k2T,&
                      k3h, k3u, k3v, k3T)
        ! Compute 4th slope
        call numerics(h_pre + dt * k3h, u_pre + dt * k3u, v_pre + dt * k3v, T_pre + dt * k3T, k4h, k4u, k4v, k4T)
        ! Final update
        h_next = h_pre + dt * (k1h + 2 * k2h + 2 * k3h + k4h) / 6.
        u_next = u_pre + dt * (k1u + 2 * k2u + 2 * k3u + k4u) / 6.
        v_next = v_pre + dt * (k1v + 2 * k2v + 2 * k3v + k4v) / 6.
        T_next = T_pre + dt * (k1T + 2 * k2T + 2 * k3T + k4T) / 6.
    end subroutine RK4
end module stepping