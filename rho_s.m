function [rhoS]=rho_s()

%{
rho_s, 1.0 (Matlab 2013b)

density of sediment (global constant for other functions).

Usually 2650 kg.m^-3 for quartz or similar materials (Soulsby, 1997).


by D. Lichtman, 2014/09/15

input:
none

output:
rhoS        the density of sediment, [kg/m^3]


References:
Soulsby, R., 1997. Dynamics of marine sands: A manual for practical 
applications. London: Thomas Telford. (p 15)

update history:

%}

rhoS=2650;     % COHBED fieldwork


