module mcmod_mass
  implicit none
  double precision::               V0, eps2=1.0d-6
  integer,parameter::              atom1=1, atom2=4, atom3=7
  character, allocatable::         label(:)
  integer::                        n, ndim, ndof, natom, xunit, totdof

contains

  subroutine V_init()
    V0=0.0d0
    return
  end subroutine V_init
  !---------------------------------------------------------------------
  function V(x)
    implicit none
    double precision::     v, x(:,:)
    double precision, allocatable:: dummy1(:),dummy2(:), xtemp(:)
    integer::              i,j

    allocate(xtemp(natom*ndim))
    do i=1,ndim
       do j=1,natom
          xtemp((j-1)*ndim +i)= x(i,j)*0.529177d0
       end do
    end do
    call mbpolenergy(3, V, xtemp)
    V= V*1.59362d-3 - V0
    ! if (V0 .ne. 0.0 .and. (V .lt. -0.5 .or. V.gt. 5.0)) then
    !    write(*,*) "Possible hole detected"
    !    do i=1, natom
    !       write(*,*) label(i), (x(j,i)*0.529177d0, j=1,ndim)
    !    end do
    !    stop
    ! end if
    deallocate(xtemp)
    return
  end function V

  !---------------------------------------------------------------------
  subroutine Vprime(x, grad)
    implicit none
    integer::              i,j
    double precision::     grad(:,:), x(:,:), dummy1
    double precision, allocatable:: gradtemp(:), xtemp(:)

    allocate(gradtemp(ndof), xtemp(natom*ndim))
    do i=1,ndim
       do j=1,natom
          xtemp((j-1)*ndim +i)= x(i,j)*0.529177d0
       end do
    end do
    call mbpolenergygradient(3, dummy1, xtemp, gradtemp)
    do i= 1,ndim
       do j=1,natom
          grad(i,j)= gradtemp(ndim*(j-1)+i)*1.59362d-3*0.529177d0
       end do
    end do
    deallocate(gradtemp, xtemp)
    return
  end subroutine Vprime
  !---------------------------------------------------------------------
  subroutine  Vdoubleprime(x,hess)
    implicit none
    double precision::     hess(:,:,:,:), x(:,:), dummy1, eps
    integer::              i, j
    double precision, allocatable::     gradplus(:, :), gradminus(:, :)

    eps=1d-4
    allocate(gradplus(ndim, natom), gradminus(ndim, natom))
    do i= 1, ndim
       do j= 1, natom
          x(i,j)= x(i,j) + eps
          call Vprime(x, gradplus)
          x(i,j)= x(i,j) - 2.0d0*eps
          call Vprime(x, gradminus)
          x(i,j)= x(i,j) + eps
          hess(i,j,:,:)= (gradplus(:,:)-gradminus(:,:))/(2.0d0*eps)          
       end do
    end do
    deallocate(gradplus, gradminus)
    return
  end subroutine Vdoubleprime

end module mcmod_mass
