program simulation
    use parameters
    use Numerics
    implicit none
    integer :: i
    real, dimension(nx) :: T0, T_new
    real, dimension(num_steps+1,nx) :: T
    character(len=40) :: filename

    call write_parameters_to_file()

    open(unit=20, file="results/initial.txt", status="old", action="read")
    read(20, *) T0
    close(20)

    T(1,:) = T0
    do i = 1, num_steps
        T(i+1,:) = RK4(T(i,:))
        if (mod(i * dt, 1.0) < 1.0e-6) then
            write(filename, '("results/T_", I0, "s.txt")') int(i * dt)
            open(unit=30, file=filename, status="replace")
            write(30, *) T(i+1,:)
            close(30)
        end if
    end do
end program simulation