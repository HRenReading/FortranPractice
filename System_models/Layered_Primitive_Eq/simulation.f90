program simulation
    use parameters
    use initial
    use stepping
    use diagnostics
    implicit none
    real, dimension(nl, nx, ny) :: h_old, T_old, h_new, T_new
    real, dimension(nl, nx+1, ny) :: u_old, u_new
    real, dimension(nl, nx, ny+1) :: v_old, v_new
    character(len=100) :: filename
    integer :: i

    ! Generate the initial condition for h and T
    call set_initial_conditions()

    ! Initialization for h, u, v, T
    open(unit=10, file='results/initial_h', form='unformatted', access='stream', status='old', action='read')
    read(10) h_old
    close(10)
    u_old = u0
    v_old = v0
    open(unit=11, file='results/initial_T', form='unformatted', access='stream', status='old', action='read')
    read(11) T_old
    close(11)

    ! Simulation run
    do i = 1, nt
        call RK4(h_old, u_old, v_old, T_old, h_new, u_new, v_new, T_new)
        call safety_check(h_new, T_new)
        if (mod(i, int(60. / dt)) == 0) then
            ! Timer
            write(*, '(A,I0,A)') "Simulation runtime t=", int(i * dt / 60), "min"
            ! Water depth data file
            write(filename, '("results/h_", I0, "m")') int(i * dt / 60)
            open(unit=20, file=filename, form="unformatted", access="stream", status="replace", action="write")
            write(20) h_new
            close(20)
            ! Temperature profile
            write(filename, '("results/T_", I0, "m")') int(i * dt / 60)
            open(unit=21, file=filename, form="unformatted", access="stream", status="replace", action="write")
            write(21) T_new
            close(21)
            write(*, '(A,F6.2)') "Maximum temperature gradient dT=", maxval(abs(T_new - T_old))
            write(*, '(A,F6.2, F6.2)') "Maximum zonal, meridional velocity", maxval(abs(u_new)), maxval(abs(v_new))
        end if
        ! Update
        h_old = h_new
        u_old = u_new
        v_old = v_new
        T_old = T_new
    end do
end program simulation
