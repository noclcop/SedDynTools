function [waveRipple]= ...
       waveRippleEqN09(D50,thetaW,thetaCr,H_w,T_w,depth,ubar,phi,rhoS,rhoW)
% waveRippleEqN92 - wave ripple equilibrium dimensions from Nielsen (2009)
% [waveRipple] = waveRippleEqN92(D50,tauW,H_w,T_w,depth,ubar,phi,rhoS,rhoW)
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
waveRippleEqN09, version (Matlab 2014b)

wave ripple equilibrium dimensions for irregular waves from Nielsen (2009),
p. 243-4

by D. Lichtman, 2015/08/28


References:
Nielsen, P., 2009. Coastal and Estuarine Processes.  Advanced Series on
Ocean Engineering - volume 29. World Scientific: Singapore. p. 343.


update history:

%}

% constants
switch nargin
    case 8
    rhoS=rho_s;    %kg.m^-3
    rhoW=rho_w;
    case 9
    rhoW=rho_w;
end  

%%
%tauCr = tauCritSW(D50,rhoS,rhoW);      % critical shear stress for motion

%thetaW = shieldsMobilityTau(thetaW,D50,rhoS,rhoW); % Sheilds paramter
%thetaCr = shieldsMobilityTau(tauCr,D50,rhoS,rhoW); % critical Shields pram.

uw = u_w(H_w,T_w,depth,ubar,phi);         % wave orbital amplitude velocity

Aw = uw*T_w/(2*pi);                       % wave amplitude

Psi = uw^2/(g*(rhoS/rhoW-1)*D50);         % wave mobility number

if thetaW <= thetaCr
 waveRipple.height = nan;
 waveRipple.length = nan;
elseif 10 < Psi 
 waveRipple.height = Aw*21*Psi^-1.85; 
 waveRipple.length = Aw*exp((693 -3.7*log(Psi)^8)/(1000 +0.75*log(Psi)^7));
                                            
elseif 1 < thetaW   
    waveRipple.height = 0; 
    waveRipple.length = 0;  

else
	waveRipple.height = nan;
    waveRipple.length = nan;
    
end 

if 0.5 < thetaW
  waveRipple.crests = 'sharp';
elseif 1 < thetaW  
  waveRipple.crests = 'flatened';
else
  waveRipple.crests = 'none';  
end    