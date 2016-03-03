function [thetaM]=modeAngle(theta,Ares)

%{
modeAngle, v 1.0 (Matlab 2013b)

calcluate the mode value from an array of polar directions (the most 
popular direction), at a set resolution.  This is better than a mean as it 
is not affected by extreme values.

Resolution is +/- res.

A check is done for the 360 to zero ambiguity

A uni-modal direction is assumed, if there are multiple modes this function
will give bad results.  This effect can be reduced by using short records.

by D. Lichtman, 2014/10/03

input:
theta       one dimensional array of angles or directions, [degrees]
res         resolution of mode, +/- res,                   [degrees] 

output:
thetaM      mode angle,                                    [degrees]

user defined functions called:


References:

update history:

%}

%constants
if ~exist('res','var'), Ares=2.5; end
res=Ares*2;

%checks
if length(theta)~=sum(size(theta))-1
    error('modeAngle:arrayDim','Array should be single dimension')
end    
    
%% Main function

% mode direction +/- res/2 degrees
thetaM=mode(round(theta/res))*res; 

% check the 360 to zero ambiguity
zct1=length(find(round(theta)<=res/2));           % count zero to res/2
zct2=length(find(round(theta)>=(360-res/2)));     % count 360-res/2 to 360
mct=length(find(round(theta/res)==thetaM/res));   % count mode value

if zct1+zct2>mct
    thetaM=0;                                   
end 