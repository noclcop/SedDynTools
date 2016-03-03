function [duneEq]=duneEqY64(tau,depth,tauCr)
% duneEqVR - calculate the equilibrium dune dimensions (Yalin, 1964)
% [duneEq]=duneEqVR(tau,depth,tauCr)
%
% input:
% tau               skin friction bed shear stress, [N/m]
% depth             depth/height of water, [m]
% tauCr             critical skin friction bed shear stress, [N/m]
%
% output:
% duneEq.height     dune equilibrium height, [m]  
% duneEq.length     dune equilibrium length, [m] 

%{
duneEqY, 1.0 (Matlab 2014b)

Calculate the equilibrium dune dimensions using Yalin's (1964) algorithm

by D. Lichtman, 2015/09/01


References:
Soulsby, R., 1997. Dynamics of marine sands: A manual for practical 
applications. London: Thomas Telford. (p116)



update history:


%}

%constants
%{
switch nargin
    case 4
    rhoS=rho_s;    %kg.m^-3
    rhoW=rho_w;
    case 5
    rhoW=rho_w;
end
%}

%% Main function

% tauCr=tauCritSW(D50,rhoS,rhoW);      % critical shear stress for motion

% dstar = Dstar(D50);

if tau<=tauCr
  duneEq.height=nan;
  duneEq.length=nan;
  
elseif tau<17.6*tauCr
  duneEq.height=depth./6.*(1-(tauCr/tau)); 
  duneEq.length=2*pi*depth;
  
elseif 17.6*tauCr<=tau
  duneEq.height=0;
  duneEq.length=0;
  
end  
duneEq.units='m';