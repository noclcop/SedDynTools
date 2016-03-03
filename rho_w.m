function [rhoW]=rho_w()

%{
rho_w, 1.0 (Matlab 2013b)

density of seawater (global constant for other functions).

Usually 1027 kg.m^-3 for full seawater, but will vary. The use of CTD data 
to calculate the water density or at least to inform your choice of global 
constant is advised.

by D. Lichtman, 2014/09/15

input:
none

output:
rhoW        the density of seawater, [kg/m^3]


References:
Soulsby, R., 1997. Dynamics of marine sands: A manual for practical 
applications. London: Thomas Telford.

update history:

%}

rhoW=1023;     % COHBED fieldwork


