module diagnostics
    use parameters
    implicit none

    contains
    subroutine safety_check(h, T)
        real, intent(in), dimension(nl, nx, ny) :: h, T

        ! Check for NaNs
        if (any(h /= h)) then
            print *, "NaN detected in h"
            stop "Aborting: NaN in water depth"
        end if

        if (any(T /= T)) then
            print *, "NaN detected in T"
            stop "Aborting: NaN in temperature"
        end if

        ! Check for unrealistic values (e.g., Inf or runaway growth)
        if (any(abs(h) > 1e10)) then
            print *, "Unrealistic values in h"
            stop "Aborting: Inf or unstable values in water depth"
        end if

        if (any(abs(T) > 1e10)) then
            print *, "Unrealistic values in T"
            stop "Aborting: Inf or unstable values in temperature"
        end if
    end subroutine safety_check

end module diagnostics