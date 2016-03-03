function [kolmogorov]=kolmogorov(axis)

%kolmogorov constant
%
%Input:
%axis   1 = parallel to mean flow, 2 or 3 = Transverse to mean flow
%
%output:
%kolmogorov  kolmogorov constant, /m
%
%references:
%Green, M. O., 1992. Spectral estimates of bed shear stress at subcritical
%Reynolds numbers in a tidal boundary layer.  Journal of Physical 
%Oceanography, 22, pp 903-917.
%
%Sreenivasan, K. R., 1995.  On the universality of the Kolmogorov constant.
%Physics of fluids, vol. 7, no. 11, pp. 2778-2784.    


%check number of input arguments
narginchk(0,1)
switch nargin
case 0
    axis=1;
end 


switch axis
    case 1
        kolmogorov=0.51;    %parallel to mean flow
        
    otherwise    
        kolmogorov=0.69;    %transverse to mean flow
end
