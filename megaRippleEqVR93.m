function [mrEq]=megaRippleEqVR93(tau,depth,tauCr)
% megaRippleEqVR - calculate the equilibrium dune dimensions (van Rijn, 1993)
% [duneEq]=megaRippleEqVR(D50,tau,depth,tauCr)
%
% input:
% tau               skin friction bed shear stress, [N/m]
% depth             depth/height of water, [m]
% tauCr             critical skin friction bed shear stress, [N/m]
%
% output (structure):
% mrEq.height       dune equilibrium height, [m]  
% mrEq.length       dune equilibrium length, [m] 
% mrEq.umits        m (metres),              []
%


%{
megaRippleEqVR, 1.0 (Matlab 2014b)

Calculate the equilibrium dune dimensions using van Rijn's (1993) algorithm

by D. Lichtman, 2015/09/04


References:
Soulsby, R., 1997. Dynamics of marine sands: A manual for practical 
applications. London: Thomas Telford. (p116)

van Rijn, L.C., 1993. Principles of sediment transport in rivers, estuaries
 and coastal seas. Aqua Publications, Amsterdam, The Netherlands

update history:
2015/11/24 DL: Finished writing it.
2015/08/28 DL: if the shear stress is below critical then the bedforms are
               relics of previous conditions (set to nan).

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

Ts=(tau-tauCr)/tauCr;

% dstar = Dstar(D50);

% Hr = 0.02*(1 - exp(-0.1*tau))*(10 - tau)*h and L = 0.5*h

if tau<=tauCr
  mrEq.height=nan;
  mrEq.length=nan;
  
else  %if tau<26*tauCr  at what point do we get dunes?
  mrEq.height = 0.02*(1 - exp(-0.1*Ts))*(10 - Ts)*depth; 
  mrEq.length = 0.5*depth; 
  
%else
%  duneEq.height=0;
%  duneEq.length=0;  

end    
mrEq.units='m';