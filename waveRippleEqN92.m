function [waveRipple]= ...
       waveRippleEqN92(D50,thetaW,thetaCr,H_w,T_w,depth,ubar,phi,rhoS,rhoW)
% waveRippleEqN92 - wave ripple equilibrium dimensions from Nielsen (1992)
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
waveRippleEqN92, version (Matlab 2014b)

wave ripple equilibrium dimensions from Nielsen (1992)

by D. Lichtman, 2015/08/28


References:
Soulsby, R., 1997. Dynamics of marine sands: A manual for practical 
applications. London: Thomas Telford.


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
%tauCr = tauCritSW(D50,rhoS,rhoW);       % critical shear stress for motion

%thetaWS = shieldsMobilityTau(tauW,D50,rhoS,rhoW); % Sheilds paramter
%thetaCr = shieldsMobilityTau(tauCr,D50,rhoS,rhoW); % critical Shields 

uw = u_w(H_w,T_w,depth,ubar,phi);         % wave orbital amplitude velocity

Aw = uw*T_w/(2*pi);                       % wave amplitude

Psi = uw^2/(g*(rhoS/rhoW-1)*D50);         % wave mobility number


if thetaW <= thetaCr
    waveRipple.height = nan;
    waveRipple.length = nan;
  
elseif Psi < 156
    waveRipple.height = Aw*(0.275 -0.022*Psi^0.5);
    waveRipple.length = nan;
    
    if thetaW < 0.831  
        waveRipple.length = waveRipple.height/(0.182 -0.24*thetaW^1.5);    
    end   
    
elseif  156 < Psi || 0.831 < thetaW   
    waveRipple.height = 0; 
    waveRipple.length = 0;      
    
end



  