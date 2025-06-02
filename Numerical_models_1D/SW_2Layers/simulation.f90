program simulation
    use parameters
    use numerics
    use, intrinsic :: ieee_arithmetic
    implicit none
    real, dimension(nl, nx) :: h_old, h_new, u_old, u_new
    integer :: i, j
    character(100) :: filename

    call write_parameters_to_file()

    open(unit=10, file="results/initial.txt", status='old', action='read')
    do i = 1, nl
        read(10, *) h_old(i,:)
    end do
    close(10)

    u_old = u0

    do i = 1, num_steps
        call RK4(h_old, u_old, h_new, u_new)
        if (mod(i * dt, 1.0) < 1.0e-6) then
            write(filename, '("results/h_", I0, "s.txt")') int(i * dt)
            open(unit=30, file=filename, status="replace")
            do j = 1, nl
                write(30, *) h_new(j,:)
            end do
            close(30)
        end if
        if (mod(i * dt, 10.0) < 1.0e-6) then
            write(*, '(A,I0)') "Simulation time t=:", int(i * dt)
        end if
        if (any(.not. ieee_is_finite(h_new)) .or. any(h_new < 0)) then
            print *, "Numerical instability detected at step ", i
            stop
        end if
        h_old = h_new
        u_old = u_new
    end do
end program simulation