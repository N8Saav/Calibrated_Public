!Intakes the data compiled at main to calculate specific stats that the author may want calculated. This includes
!     Customer Acquisition Cost Ratio, Project Turnover Rate, etc.
!Last Updated: 1/7/2023
!     Created subroutine 'groups' to create the output array/.dat cost_g
!Future Updates:
!     Add rev_g to subroutine 'groups'
!     Create Modules for Labor Hour statistics
module keyperformance
    use cost_function, only : read_cost, cost
    use Revenue_Model, only : read_revenue, revenue
    use precisions, only: dp
    contains
    !Takes specified group #s, denoted by the element of an array with suffix g, to organize account information 
    !     into Customer Acquisition Cost Ratio. Marketing Cost / Associated Revenue
subroutine cust_acquisition(cost_g, rev_g)
    implicit none
    real(dp),intent(in),allocatable :: cost_g(:), rev_g(:)
    real :: cac

    !Debugging
    if(rev_g(1) == 0.) then
        write(411,*) "WARNING dividing by 0, try data formatting?"
    end if

    cac = cost_g(3) / (rev_g(1) + rev_g(2))

    write(*,*) "marketing cost=", cost_g(2)
    write(*,*) "cac=", cac

end subroutine
!Takes units of long term accounts retrievable to produce projcet turn over rate for recording projects.
!     Hours Mixed / Hours Recorded
subroutine project_turnover(u, imax_r)
    implicit none
    real :: turnover_coeff, dum1, dum2
    real(dp),allocatable,intent(in) :: u(:,:)
    integer :: j, imax_r
    
    dum1=0.
    dum2=0.

    do j= 1, imax_r
        dum1 = dum1 + u(j,2)
        dum2 = dum2 + u(j,1) + u(j,2) + u(j,3)
    end do 

    if(dum2 == 0.) then
        write(411,*) "WARNING dividing by 0, try data formatting in r_u"
    end if
    write(*,*) "Hours Mixed=", dum1, "Total Hours=", dum2
    turnover_coeff = dum1 / dum2

    write(*,*) "turnover coeff=", turnover_coeff
end subroutine
!Sums over array cost_i_l to reduce it to cost_l and produce a corresponding .dat
subroutine groups(cost_i_l,lmax_c, label_c)
    use cost_function, only: read_cost
    implicit none
    real(dp),allocatable,intent(in) :: cost_i_l(:,:)
    character(len =50),dimension(:,:),allocatable :: label_c
    integer, intent(in) :: lmax_c
    real(dp),allocatable :: cost_l(:), rev_l(:)
    integer :: k
    
    allocate(cost_l(1:lmax_c))

    OPEN(700, file='./outputs/cost_l.dat', status='unknown')

    do k= 1, lmax_c
        cost_l(k) = sum(cost_i_l(:,k))
        write(700,*) k, cost_l(k), label_c(1,k)
    end do

    CLOSE(700)

end subroutine groups
end module