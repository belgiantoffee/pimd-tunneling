module mcmod_mass
  implicit none
  double precision::               V0, eps2=1.0d-5
  integer::              atom1, atom2, atom3
  character, allocatable::         label(:)
  integer::                        n, ndim, ndof, natom, xunit, totdof
  logical::                        potforcepresent
  character(len=20)::              basename

contains

  subroutine V_init(iproc)
    integer, intent(in):: iproc
    potforcepresent=.true.
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
    call mbpolenergy(2, V, xtemp)
    V= V*1.59362d-3 - V0
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
    call mbpolenergygradient(2, dummy1, xtemp, gradtemp)
    do i= 1,ndim
       do j=1,natom
          grad(i,j)= gradtemp(ndim*(j-1)+i)*1.59362d-3*0.529177d0
       end do
    end do
    deallocate(gradtemp, xtemp)
    return
  end subroutine Vprime
  !---------------------------------------------------------------------
  subroutine potforce(x, grad,energy)
    implicit none
    integer::              i,j
    double precision::     grad(:,:), x(:,:), dummy1, energy
    double precision, allocatable:: gradtemp(:), xtemp(:)

    allocate(gradtemp(ndof), xtemp(natom*ndim))
    do i=1,ndim
       do j=1,natom
          xtemp((j-1)*ndim +i)= x(i,j)*0.529177d0
       end do
    end do
    call mbpolenergygradient(2, energy, xtemp, gradtemp)
    do i= 1,ndim
       do j=1,natom
          grad(i,j)= gradtemp(ndim*(j-1)+i)*1.59362d-3*0.529177d0
       end do
    end do
    energy= energy*1.59362d-3 - V0
    deallocate(gradtemp, xtemp)
    return
  end subroutine Potforce
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
