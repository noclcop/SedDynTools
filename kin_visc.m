function [nu]=kin_visc()

%{
rho_w, 1.0 (Matlab 2013b)

kinematic viscosity of seawater (global constant for other functions).
at 10 C, 35 Sal


by D. Lichtman, 2014/09/15

input:
none

output:
nu        kinematic viscosity of seawater, [m^2.s^-1]


References:
Soulsby, R., 1997. Dynamics of marine sands: A manual for practical 
applications. London: Thomas Telford.

update history:

%}

nu=1.36*10^-6;     % COHBED fieldwork


