program simulation
    use parameters
    use numerics
    implicit none
    real, dimension(nx) :: h_old, h_new, u_old, u_new
    integer :: i
    character(100) :: filename

    call write_parameters_to_file()

    open(unit=10, file="results/initial.txt", status='old', action='read')
    read(10, *) h_old
    close(10)

    u_old = u0

    do i = 1, num_steps
        call RK4(h_old, u_old, h_new, u_new)
        if (mod(i * dt, 1.0) < 1.0e-6) then
            write(filename, '("results/h_", I0, "s.txt")') int(i * dt)
            open(unit=30, file=filename, status="replace")
            write(30, *) h_new
            close(30)
            write(*, '(A,F6.2,A)') "Simulation time t=", i * dt, "s"
        end if
        h_old = h_new
        u_old = u_new
    end do
end program simulation