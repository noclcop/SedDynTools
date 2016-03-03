function [waveRipple]= ...
                waveRippleEqGM82(D50,thetaW,thetaCr,H_w,T_w,depth,ubar,phi)
% name - description (for help command)
% [output arg]=name(input arg)
%
% input:
% description [units]...
%
% output:
% description [units]...
%
% user defined functions called:
% tauCritSW
% shieldsMobilityTau
% u_w


%{
waveRippleEqGM, version (Matlab 2014b)

wave ripple equilibrium dimensions from Grant and Madsen (1982)

by D. Lichtman, 2015/08/28


References:
Soulsby, R., 1997. Dynamics of marine sands: A manual for practical 
applications. London: Thomas Telford.


update history:

%}

%{
% constants
switch nargin
    case 3
    rhoS=rho_s;    %kg.m^-3
    rhoW=rho_w;
    case 4
    rhoW=rho_w;
end  
%}

%%
%tauCr = tauCritSW(D50,rhoS,rhoW);      % critical shear stress for motion

%thetaWS = shieldsMobilityTau(tauW,D50,rhoS,rhoW); % Shields paramter
%thetaCr = shieldsMobilityTau(tauCr,D50,rhoS,rhoW); % critical Shields 

dstar = Dstar(D50);

thetaB = 1.8*thetaCr*(dstar^1.5/4)^0.6;

uw = u_w(H_w,T_w,depth,ubar,phi);         % wave orbital amplitude velocity

Aw = uw*T_w/(2*pi);                       % wave amplitude

if thetaW <= thetaCr
    waveRipple.height = nan;
    waveRipple.length = nan;
elseif thetaCr < thetaW && thetaW <= thetaB
    waveRipple.height = Aw*0.22*(thetaW/thetaCr)^-0.16;
    waveRipple.length = waveRipple.height/(0.16*(thetaW/thetaCr)^-0.04);
elseif thetaB < thetaW 
    waveRipple.height = Aw*0.48*(dstar^1.5/4)^0.8*(thetaW/thetaCr)^-1.5;
    waveRipple.length = waveRipple.height/(0.28*(dstar^1.5/4)^0.6 ...    
                                                *(thetaW/thetaCr)^-1.0);
elseif 0.8 < thetaW    
    waveRipple.height = 0;  % ripple wash out
    waveRipple.length = 0;    
end    