!*==intfaces.f90  created by SPAG 6.53Rc at 11:53 on 28 Jun 2004
MODULE S_MTU12
   INTERFACE
SUBROUTINE MTU12(KF,KC,M,Q,X,F1R,D1R,F2R,D2R)
USE F77KINDS                        
IMPLICIT NONE
REAL(R8KIND) :: D1R , D2R , F1R , F2R , Q , X
INTEGER :: KC , KF , M
INTENT (IN) KC , KF , X
INTENT (INOUT) D1R , D2R , F1R , F2R
      END SUBROUTINE MTU12
   END INTERFACE
END MODULE S_MTU12
!*==intfaces.f90  created by SPAG 6.53Rc at 11:53 on 28 Jun 2004
MODULE S_FCOEF
   INTERFACE
SUBROUTINE FCOEF(KD,M,Q,A,FC)
USE F77KINDS                        
IMPLICIT NONE
REAL(R8KIND) :: A , Q
INTEGER :: KD , M
REAL(R8KIND) , DIMENSION(251) :: FC
INTENT (IN) A , KD , M , Q
INTENT (INOUT) FC
      END SUBROUTINE FCOEF
   END INTERFACE
END MODULE S_FCOEF
!*==intfaces.f90  created by SPAG 6.53Rc at 11:53 on 28 Jun 2004
MODULE S_CVA2
   INTERFACE
SUBROUTINE CVA2(KD,M,Q,A)
USE F77KINDS                        
IMPLICIT NONE
REAL(R8KIND) :: A , Q
INTEGER :: KD , M
INTENT (INOUT) A
      END SUBROUTINE CVA2
   END INTERFACE
END MODULE S_CVA2
!*==intfaces.f90  created by SPAG 6.53Rc at 11:53 on 28 Jun 2004
MODULE S_REFINE
   INTERFACE
SUBROUTINE REFINE(KD,M,Q,A,IFLAG)
USE F77KINDS                        
IMPLICIT NONE
REAL(R8KIND) :: A , Q
INTEGER :: IFLAG , KD , M
INTENT (INOUT) A
      END SUBROUTINE REFINE
   END INTERFACE
END MODULE S_REFINE
!*==intfaces.f90  created by SPAG 6.53Rc at 11:53 on 28 Jun 2004
MODULE S_CVF
   INTERFACE
SUBROUTINE CVF(KD,M,Q,A,MJ,F)
USE F77KINDS                        
IMPLICIT NONE
REAL(R8KIND) :: A , F , Q
INTEGER :: KD , M , MJ
INTENT (IN) A , KD , M , MJ , Q
INTENT (OUT) F
      END SUBROUTINE CVF
   END INTERFACE
END MODULE S_CVF
!*==intfaces.f90  created by SPAG 6.53Rc at 11:53 on 28 Jun 2004
MODULE S_CV0
   INTERFACE
SUBROUTINE CV0(KD,M,Q,A0)
USE F77KINDS                        
IMPLICIT NONE
REAL(R8KIND) :: A0 , Q
INTEGER :: KD , M
      END SUBROUTINE CV0
   END INTERFACE
END MODULE S_CV0
!*==intfaces.f90  created by SPAG 6.53Rc at 11:53 on 28 Jun 2004
MODULE S_CVQL
   INTERFACE
SUBROUTINE CVQL(KD,M,Q,A0)
USE F77KINDS                        
IMPLICIT NONE
REAL(R8KIND) :: A0 , Q
INTEGER :: KD , M
INTENT (IN) KD , M , Q
INTENT (OUT) A0
      END SUBROUTINE CVQL
   END INTERFACE
END MODULE S_CVQL
!*==intfaces.f90  created by SPAG 6.53Rc at 11:53 on 28 Jun 2004
MODULE S_CVQM
   INTERFACE
SUBROUTINE CVQM(M,Q,A0)
USE F77KINDS                        
IMPLICIT NONE
REAL(R8KIND) :: A0 , Q
INTEGER :: M
INTENT (IN) M , Q
INTENT (OUT) A0
      END SUBROUTINE CVQM
   END INTERFACE
END MODULE S_CVQM
!*==intfaces.f90  created by SPAG 6.53Rc at 11:53 on 28 Jun 2004
MODULE S_JYNB
   INTERFACE
SUBROUTINE JYNB(N,X,NM,BJ,DJ,BY,DY)
USE F77KINDS                        
IMPLICIT NONE
INTEGER :: N , NM
REAL(R8KIND) :: X
REAL(R8KIND) , DIMENSION(0:N) :: BJ , BY , DJ , DY
INTENT (IN) N
INTENT (OUT) DJ , DY
INTENT (INOUT) BJ , BY , NM
      END SUBROUTINE JYNB
   END INTERFACE
END MODULE S_JYNB
!*==intfaces.f90  created by SPAG 6.53Rc at 11:53 on 28 Jun 2004
MODULE S_MSTA1
   INTERFACE
FUNCTION MSTA1(X,MP)
USE F77KINDS                        
IMPLICIT NONE
INTEGER :: MP
REAL(R8KIND) :: X
INTEGER :: MSTA1
INTENT (IN) MP , X
      END FUNCTION MSTA1
   END INTERFACE
END MODULE S_MSTA1
!*==intfaces.f90  created by SPAG 6.53Rc at 11:53 on 28 Jun 2004
MODULE S_MSTA2
   INTERFACE
FUNCTION MSTA2(X,N,MP)
USE F77KINDS                        
IMPLICIT NONE
INTEGER :: MP , N
REAL(R8KIND) :: X
INTEGER :: MSTA2
INTENT (IN) MP , X
      END FUNCTION MSTA2
   END INTERFACE
END MODULE S_MSTA2
!*==intfaces.f90  created by SPAG 6.53Rc at 11:53 on 28 Jun 2004
MODULE S_ENVJ
   INTERFACE
FUNCTION ENVJ(N,X)
USE F77KINDS                        
IMPLICIT NONE
INTEGER :: N
REAL(R8KIND) :: X
REAL(R8KIND) :: ENVJ
INTENT (IN) N , X
      END FUNCTION ENVJ
   END INTERFACE
END MODULE S_ENVJ