program simulation
    use parameters
    use numerics
    implicit none
    real, dimension(nx) :: T_old, T_next
    integer :: i
    character(len=100) :: filename

    call write_parameters_to_file()

    open(unit=10, file='results/initial.txt', status='old', action='read')
    read(10, *) T_old
    close(10)

    do i = 1, num_steps
        T_next = RK4(T_old)
        if (mod(i * dt, 1.0) < 1.0e-6) then
            write(filename, '("results/T_", I0, "s.txt")') int(i * dt)
            open(unit=30, file=filename, status="replace")
            write(30, *) T_next
            close(30)
            write(*, '(A,F6.1,A)') "Simulation time t=", i*dt, "s"
        end if
        T_old = T_next
    end do
end program simulation