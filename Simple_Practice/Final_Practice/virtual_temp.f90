program virtual_temp
    use parameters
    use computation
    implicit none
    real, dimension(nl) :: q = [0.014, 0.010, 0.007, 0.004, 0.0025, 0.0015, 0.0008, 0.0004, 0.0002, 0.0001]
    real :: Tv_normalized(nl)
    integer :: i
    type(levels) :: data(nl)

    data = Tv_cal(q)

    Tv_normalized = normalization([ (data(i)%Tv, i=1, nl) ])
    print *, "Normalized Tv    Temperature (K)"
    do i = 1, nl
        write(*, '(F8.4, 2X, F8.2)') Tv_normalized(i),  data(i)%T
    end do

    contains
    function normalization(Tv) result(res)
        implicit none
        real :: Tv(nl), res(nl)
        real :: Tv_sum
        integer :: i

        Tv_sum = sum(Tv)
        do i = 1, nl
            res(i) = Tv(i) / Tv_sum
        end do
    end function normalization
end program virtual_temp