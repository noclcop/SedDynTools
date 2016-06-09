function [Uw]=u_w(Wheight,Wperiod,depth,ubar,phi)
% function [Uw]=u_w(Wheight,Wperiod,depth,ubar,phi)
% Amplitude of the wave orbital velocity just above the bed

%{
u_w, 1.0 (Matlab 2013b)

Amplitude (maximum) of the wave orbital velocity just above the wave
boundary layer over the bed, from small amplitude linear wave theory 
(Soulsby, 2006).

ubar and phi are used in the calculation of the wavenumber to correct for
combined flow angle.

by D. Lichtman, 2014/09/19

input:
Wheight     wave height, [m]
Wperiod     wave period, [s]
depth       depth,       [m]
ubar        depth mean current, used in the wave number function,  [m/s]   
phi         angle between wave and current direction, where 0 degrees is
            wave and current together and 180 degrees for waves travelling
            opostite to the current, used in the wave number function,
            [degrees]

output:
Uw          wave orbital velocity at the bed, [m/s]

functions called:
waveno      calculate the wave number
               
update history:
2015/05/12 DL: put in a check for nan values
2014/09/23 DL: Wieberg and Sherwood function replaced by Fenton and McKee, 
               so that the wave-current direction can be accounted for.
               When tested the maximum difference between the two was
               0.0027 m/s (at a 1s period, reducing with increasing period) 

References:
Fenton, J.D. and McKee, W.D., 1990. On calculating the lengths of water
waves. Coastal Engineering, 14, pp 499-513.

Soulsby, R., 1997. Dynamics of marine sands: A manual for practical 
applications. London: Thomas Telford. (p 70-73, 88)

Soulsby, R., 2006. Simplified calculation of wave orbital velocities.   
HR Wallingford Report TR 155 Available at: 
http://eprints.hrwallingford.co.uk/692/1/TR155.pdf 
[Accessed 19 September 2014].

Wiberg, P. L. and Sherwood, C. R., 2008. Calculating wave-generated bottom 
orbital velocities from surface-wave parameters.  Computers & Geosciences, 
34, pp. 1243-1262. Available at:
http://www.sciencedirect.com/science/article/pii/S009830040800054X
[Accessed 19 September 2014].
%}

%% Main function

% check inputs and transpose if required
narginchk(3,5)
if ~exist('ubar','var'), ubar=0;end
if ~exist('phi','var'), phi=0;end

if size(Wheight,1)<size(Wheight,2)
    Wheight=Wheight';
    Wperiod=Wperiod';
    depth=depth';
    ubar=ubar';
    phi=phi';
end    

% Quick iterative calculation of kh in dispersion relationship
% (Wieberg and Sherwood, 2008 based on Soulsby, 2006) 
% kh=qkhfs(2*pi/Wperiod,depth);

% Calculate the wave number, k, using the algorithm of 
% Fenton and McKee, 1990
k=zeros(size(Wperiod,1),1);

for ii=1:size(Wperiod,1)
    if Wperiod(ii)~=0    % skip wave number function if T is zero
        k(ii) = waveno(Wperiod(ii),depth(ii),ubar(ii),phi(ii))*depth(ii);
    else
        k(ii) = 0;
    end    
end

% Amplitude of the wave orbital velocity
Uw = pi*Wheight/(Wperiod*sinh(k*depth));

if isnan(Uw), Uw(isnan(Uw))=0; end        % check for nan values