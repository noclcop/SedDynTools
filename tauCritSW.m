function [tauCr]=tauCritSW(D50,rhoS,rhoW)
% tauCritSW - critical tau for motion
% [tauCr]=tauCritSW(D50,rhoS,rhoW)
%
% input: 
% D50   median grain diameter,[m]
% rhoS  sediment density,     [kg.m^-3]
% rhoW  water density,        [kg.m^-3]
%
% output:
% tauCr critical bed shear stress, [kg.s^-1.m^-1]
%
% user defined functions called:
% thetaCritSW   critcal sheilds parameter
%
% notes

%{
tauCritSW.m, 1.0 (Matlab 2014b)



notes

by D. Lichtman, 2015/07/29


References:
Soulsby, R., 1997. Dynamics of marine sands: A manual for practical 
applications. London: Thomas Telford. (p74)


update history:

%}

%constants
switch nargin
    case 1
    rhoS=rho_s;    %kg.m^-3,     density of quartz
    rhoW=rho_w;
    case 2
    rhoW=rho_w;
end   
%% Main function

tauCr=g*(rhoS-rhoW).*D50.*thetaCritSW(D50);
