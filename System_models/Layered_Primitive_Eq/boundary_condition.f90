module boundary_condition
    use parameters
    implicit none

    contains
    function bc(var, var_name) result(var_ext)
        implicit none
        character(len=*), intent(in) :: var_name
        real, dimension(:, :, :), intent(in) :: var
        real, allocatable, dimension(:, :, :) :: var_ext

        integer :: nx_var, ny_var
        ! Shape of the input array
        nx_var = size(var, 2)
        ny_var = size(var, 3)

        ! Allocate extended array based on input shape
        allocate(var_ext(size(var,1), 0:nx_var+1, 0:ny_var+1))
        var_ext(:,1:nx_var,1:ny_var) = var

        ! --- Periodic E-W boundaries ---
        var_ext(:, 0, :)      = var_ext(:, nx_var, :)
        var_ext(:, nx_var+1, :) = var_ext(:, 1, :)

        ! --- Reflective N-S boundaries ---
        if (var_name == "u") then
            ! u is (nx+1, ny): vertical interfaces, reflect at j=0, ny+1
            var_ext(:, :, 0)      = -var_ext(:, :, 1)
            var_ext(:, :, ny_var+1) = -var_ext(:, :, ny_var)

        else if (var_name == "v") then
            ! v is (nx, ny+1): horizontal interfaces, reflect at j=0, ny+1
            var_ext(:, :, 0)      = -var_ext(:, :, 1)
            var_ext(:, :, ny_var+1) = -var_ext(:, :, ny_var)

        else
            ! Default: scalar fields like h, T — no sign flip
            var_ext(:, :, 0)      = var_ext(:, :, 1)
            var_ext(:, :, ny_var+1) = var_ext(:, :, ny_var)
        end if
    end function bc
end module boundary_condition