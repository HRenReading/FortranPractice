program write_demo
    implicit none
    real, dimension(3, 3) :: data

    data = reshape([1., 2., 3., 4., 5., 6., 7., 8., 9.], [3, 3])

    open(unit=10, file='data.txt', status='replace', action='write')
    write(10, *) data
    close(10)
end program write_demo