module computation
    use parameters
    implicit none

    type levels
        real :: T, q, Tv
    end type

    contains

    function Tv_cal(q) result(res)
        implicit none
        real, intent(in) :: q(nl)
        integer :: i

        type(levels) :: res(nl)

        do i = 1, nl
            res(i)%T = T0 - 6.5 * (i - 1)
            res(i)%q = q(i)
            res(i)%Tv = res(i)%T * (1.0 + 0.61 * res(i)%q)
        end do
    end function Tv_cal
end module computation