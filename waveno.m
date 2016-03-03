function [k]=waveno(Wperiod,depth,ubar,phi)
%{
waveno, 1.0 (Matlab 2013b)

Calculate the wave number using the algorithm of Fenton and McKee (1990; 
p 512), which accounts for the effect of current, and includes the wave to
current angle correction found in Soulsby (1997; p 88).

ubar and phi are used in the calculation to correct for the wave to
current angle of the combined flow.

valid for non-breaking waves of wavelengths less than ten times as long as
the water depth.  Algorithm iterates until the precision is better than 
0.001 m.

doesn't work for arrays of numbers, only one at a time.

by D. Lichtman, 2014/09/22

input:
Wperiod     wave period,             [s]
depth       depth of water,          [m]
ubar        depth mean current,      [m/s]   
phi         angle between wave and current direction, where 0 degrees is
            wave and current together and 180 degrees for waves travelling
            opostite to the current, [degrees]

output:
k           wave number,        [1/m]


References:
Fenton, J.D. and McKee, W.D., 1990. On calculating the lengths of water
waves. Coastal Engineering, 14, pp 499-513.

Soulsby, R., 1997. Dynamics of marine sands: A manual for practical 
applications. London: Thomas Telford. (p 88)

update history:
2014/09/26 DL: error check for number of input values

%}
%% Main function

% check input
narginchk(2,4)
if ~exist('ubar','var'), ubar=0; end
if ~exist('phi','var'), phi=0; end

if sum(size(Wperiod))>2 || sum(size(phi))>2, 
    error('WaveNo:TooManyValues','Function only accepts single values') 
end    

if Wperiod==0  % divide by zero causes problems
    Wperiod=nan; 
end    

% calculate parameters make the algorithm clearer
sigma=2*pi/Wperiod;              % angular frequency
%Fr=ubar/sqrt(g*depth);          % Froude number
Fr=ubar*cosd(phi)/sqrt(g*depth);  % with Soulsby's wave-current angle.
omega=sigma*sqrt(depth/g);

% intitial estimate of k
n=1;    
if Wperiod*sqrt(g/depth)<4
 % Fenton and McKee, 1990, eq 6 (short wave case, Hedges (1987))
 k(n)=(4*sigma^2/g)/((1+sqrt(1+4*ubar*sigma/g))^2);      
else
 % Fenton and McKee, 1990, eq 11 (long wave case)
 den=(1+Fr);
 k(n)=(omega/den+omega^3/(6*den^4)+(11-19*Fr)*omega^5/(360*den^7))/depth;
end    

% iteration of k until the required precision is reached
for n=2:1000
 alpha=tanh(k(n-1)*depth);
 beta=alpha*k(n-1)*depth;
 gamma=sqrt(beta);
 
 % Fenton and McKee, 1990, eq 30 and algorithm p 512.
 k(n)=((2*gamma*omega-beta+(k(n-1)*depth)^2-beta^2)/ ...
      (2*gamma.*Fr+alpha+k(n-1)*depth.*(1-alpha^2)))./depth;
 
 % breaks when converges to better than 0.0001
 if round(k(n)*10^4)==round(k(n-1)*10^4); break; end; 
end    

if round(k(n)*10^4)~=round(k(n-1)*10^4)
    display(['Waveno: iterations did not converge, period = ', ...
                                                         num2str(Wperiod)])
    k=nan;
else    
    k=k(n);
end

%valid for  wavelengths less than ten times as long as the water depth. 
% if 2*pi/k>10*depth, k=nan; end
