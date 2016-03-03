function [duneEq]=duneEqVR(D50,tau,depth,tauCr)
% duneEqVR - calculate the equilibrium dune dimensions (van Rijn, 1984)
% [duneEq]=duneEqVR(D50,tau,depth,rhoS,rhoW)
%
% input:
% D50               median grain diamter, [m]
% tau               skin friction bed shear stress, [N/m]
% depth             depth/height of water, [m]
% tauCr             critical skin friction bed shear stress, [N/m]
%
% output:
% duneEq.height     dune equilibrium height, [m]  
% duneEq.length     dune equilibrium length, [m] 
%
% user defined functions called:
% tauCritSW         critical shear stress for motion


%{
duneEqVR, 1.0 (Matlab 2014b)

Calculate the equilibrium dune dimensions using van Rijn's (1984) algorithm

by D. Lichtman, 2015/07/29


References:
Soulsby, R., 1997. Dynamics of marine sands: A manual for practical 
applications. London: Thomas Telford. (p116)

van Rijn, L.C., 1984, Sediment transport, Part III: Bed forms and alluvial 
roughness: Journal of Hydraulic Engineering, v. 110, p. 1733–1754,

update history:
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

%tauCr=tauCritSW(D50,rhoS,rhoW);      % critical shear stress for motion
Ts=(tau-tauCr)/tauCr;

% dstar = Dstar(D50);

if tau<=tauCr
  duneEq.height=nan;
  duneEq.length=nan;
  
elseif tau<26*tauCr
  duneEq.height=0.11.*depth.*(D50./depth).^0.3.*(1-exp(-0.5.*Ts)).*(25-Ts); 
  duneEq.length=7.3*depth; 
  
else
  duneEq.height=0;
  duneEq.length=0;  

end    
duneEq.units='m';