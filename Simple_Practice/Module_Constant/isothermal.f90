program isothermal_approximation
    use parameters
    implicit none
    real :: p, h

    h = 5000.
    p = p0 * exp(-g * M * h / (R * T0))

    write(*,'(A,F8.1,A,F10.2,A)') "At altitude ", h, " meters, the atmospheric pressure is ", p, " Pa."
end program isothermal_approximation