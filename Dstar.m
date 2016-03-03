function [D_star]=Dstar(D50,rhoS,temp,sal,press)
% Dstar - calculate the non-dimensional grain size
% [D_star]=Dstar(D50,rhoS,temp,sal,press)
%
% input: 
% D50       median sediment diameter,               [m]
% rhoS      sediment density,                       [kg.m^-3]
% temp      seawater temperature,                   [degrees C]
% sal       seawater salinity (absolute or PSU),    [g/kg]or []
% pressure  seawater pressure,                      [dbar]
%
% output:
% D_* (the non-dimensional grain size) [no units]
%
% if only the D50 is given: 
% sediment density = 2650, seawater desnity = 1023,  nu = 1.36*10^-6


%{
Dstar, 1.0 (matlab 2013b)

a function to calculate D*, the non-dimensional grain size

notes

by D. Lichtman, 2014/04/24

input:
D50              D50, [m]
rhoS             density of sediment, [kg.m^-3]
temp             seawater temperature,[degrees C]
sal              seawater salinity (absolute), [g/kg]
press            seawater pressure (air pressure corrected, [dbar]


output:
D_star           D*, the non-dimensional grain size

functions called:
SW_Kviscosity       kinematic viscostiy of seawater (seawater toolbox)
gsw_rho             density of seawater (Gibbs seawater toolbox)

update history:
2014/09/16 DL: can now calculate water density from the temperature and
               salinity

References:
Soulsby, R., 1997. Dynamics of marine sands: A manual for practical 
applications. London: Thomas Telford.
%}

narginchk(1,5)

%constants
%nu=1.36*10^-6; % m^2.s^-1, kinematic viscostiy of seawater (10 C, 35 Sal)


g=9.81;          %m.s^-2,      the acceleration due to gravity

switch nargin
    case 1
    rhoS=rho_s;    %kg.m^-3,     density of quartz
    rhoW=rho_w;
    nu=kin_visc;   %1.36*10^-6;% m^2.s^-1, kinematic viscostiy at 10C, 35 S
    case 2
    rhoW=gsw_rho(0,10,0);         % if temp not given then 10 C
    nu = SW_Kviscosity(10,'C',0,'ppt'); 
    case 3
    rhoW=gsw_rho(0,temp,0);       % if salinity not given then zero
    nu = SW_Kviscosity(temp,'C',0,'ppt'); 
    case 4 
    rhoW=gsw_rho(sal,temp,0);     % if pressure not given then zero
    nu = SW_Kviscosity(temp,'C',0,'ppt'); 
    case 5
    rhoW=gsw_rho(sal,temp,press);
    nu = SW_Kviscosity(temp,'C',sal,'ppt'); 
end    



s=rhoS/rhoW;      %ratio of densities of sediment grain to water

%% Main function

D_star=D50*(g*(s-1)/nu^2)^(1/3);