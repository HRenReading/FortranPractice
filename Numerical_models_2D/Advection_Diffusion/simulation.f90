program simulation
    use parameters
    use numerics
    implicit none
    real, dimension(nx, ny) :: T_old, T_new, u, v
    character(100) :: filename
    integer :: i

    call write_parameters_to_file()

    open(unit=10, file="results/initial", form="unformatted", access="stream", status='old', action='read')
    read(10) T_old
    close(10)

    u = u0
    v = v0
    v(:, 1) = -v0
    v(:, ny) = -v0
    do i = 1, nt
        T_new = RK4(T_old, u, v)
        if (mod(i * dt, 10.) < 1E-6) then
            write(filename, '("results/T_", I0, "s")') int(i * dt)
            open(unit=20, file=filename, form="unformatted", access="stream", status="replace", action="write")
            write(20) T_new
            close(20)
            write(*, '(A,I0)') "Simulation time t=", int(i * dt)
        end if
        T_old = T_new
    end do
end program simulation