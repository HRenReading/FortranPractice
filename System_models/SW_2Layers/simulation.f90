program simulation
    use parameters
    use numerics
    implicit none
    real, dimension(nl, nx, ny) :: h_old, h_new, u_old, u_new, v_old, v_new
    integer :: i
    character(len=100) :: filename

    call write_parameters_to_file()

    open(unit=10, file='results/initial', form='unformatted', access='stream', status='old', action='read')
    read(10) h_old
    close(10)

    u_old = u0
    v_old = v0

    do i = 1, nt
        call RK4(h_old, u_old, v_old, h_new, u_new, v_new)
        if (mod(i * dt, 1.) < 1E-6) then
            write(filename, '("results/h_", I0, "s")') int(i * dt)
            open(unit=20, file=filename, form="unformatted", access="stream", status="replace", action="write")
            write(20) h_new
            close(20)
        end if
        if (mod(i * dt, 10.) < 1E-6) then
            write(*, '(A,I0)') "Simulation time t=", int(i * dt)
        end if
        h_old = h_new
        u_old = u_new
        v_old = v_new
    end do
end program simulation