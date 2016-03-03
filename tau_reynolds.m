function[tauReynolds,stdErr]=tau_reynolds(prime,density)

%A program to calculate bed shear stress using the
%Reynolds stress method 
%with a running mean filter
%
%by D. Lichtman, 2012
%
%input:
%prime      velocity fluctuations in xz or xyz, (n*2 or n*3)  [m/s]
%density    water desnsity (1000 for freshwater, about 1025 for sea water) 
%
%Run turb_filter.m to get means of velocity fluctuations. 
%
%output:
%tau        bed shear stress, N/m
%
%updated:
%2015/05/11 DL: changed to accept 3d data as well as 2D

%check number of input arguments
narginchk(1,2);
switch nargin
case 1
    density=1000;   %if the density isn't specified set to 1000
end

% arrange into columns, if required
[a,b]=size(prime); if b>a, prime=prime'; end; clear a b 

if size(prime,2)==2
    tauReynolds=-density*mean(prime(:,1).*prime(:,2));
    
    stdErr=std(tauReynolds)/length(prime);

elseif size(prime,2)==3
    tauReynolds=-density* ...
    sqrt(mean(prime(:,1).*prime(:,3))^2+mean(prime(:,2).*prime(:,3))^2);    
    
    stdErr=std(tauReynolds)/length(prime);
    
else
   tauReynolds=nan;  stdErr=nan;
end

