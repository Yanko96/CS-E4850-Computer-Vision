import numpy as np

# R,Q = vgg_rq(S)  Just like qr but the other way around.
#
# If R,Q = vgg_rq(X), then R is upper-triangular, Q is orthogonal, and X==R*Q.
# Moreover, if S is a real matrix, then det(Q)>0.

# By awf

def vgg_rq(S):
    
    S = S.T
    Q, U = np.linalg.qr(np.fliplr(np.flipud(S)))
    Q = np.fliplr(np.flipud(Q.T))
    U = np.fliplr(np.flipud(U.T))
    
    if np.linalg.det(Q) < 0:
        t[:,0] = -t[:,0]
        
    return U, Q
    
def camcalibDLT(Xworld, Xim):
    N = Xworld.shape[0]
    A = np.zeros((1,12))
    for i in range(N):
        tmp = np.hstack((np.zeros((4)), Xworld[i,:], -Xim[i,1]*Xworld[i,:]))
        tmp2 = np.hstack((Xworld[i,:], np.zeros(4), -Xim[i,0]*Xworld[i,:]))
        A = np.vstack((A,tmp,tmp2))
    A = np.delete(A,0,0)
        
    M = np.dot(A.T, A)
    
    u,s,v = np.linalg.svd(M)
    idmin = np.argmin(s)
    ev = v[idmin]
    P = np.reshape(ev, (3,4))
    
    return P
    
#VGG_KR_FROM_P Extract K, R from camera matrix.
#
#    [K,R,t] = VGG_KR_FROM_P(P [,noscale]) finds K, R, t such that P = K*R*[eye(3) -t].
#    It is det(R)==1.
#    K is scaled so that K[2,2] == 1 and K[0,0 ] > 0. Optional parameter noscale prevents this.
#
#    Works also generally for any P of size N-by-(N+1).
#    Works also for P of size N-by-N, then t is not computed.


# Author: Andrew Fitzgibbon <awf@robots.ox.ac.uk>
# Modified by werner.
# Date: 15 May 98

def vgg_KR_from_P(P, noscale=False):
    
    N = P.shape[0]
    H = P[:, :N]
    
    K, R = vgg_rq(H)
    
    if not noscale:
        K = K / K[N-1, N-1]
        if K[0,0] < 0:
            D = np.diag(np.hstack((np.array([-1,-1]), np.ones(N-2))))
            K = np.dot(K, D)
            R = np.dot(D, R)
    
    t = np.linalg.lstsq(-P[:,0:N], P[:, -1])[0]
    
    return K, R, t
