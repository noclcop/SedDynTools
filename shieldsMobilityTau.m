function [theta]=shieldsMobilityTau(tau,D50,rhoS,rhoW)
%{
mobility, version 1.0 (Matlab 2013b)

Shield's mobility parameter, theta prime

by D. Lichtman, 2014/08/26

input:
tau         bed shear stress,    [kg/m.s^2]
D50         median grain size,   [m]
rhoS        density of sediment, [kg/m^3]
rhoW        density of water,    [kg/m^3]


output:
theta       mobility parameter, [dimensionless]


References:
Liu, Z., 2001. Sediment Transport. [e-book/pdf] Aalborg: Laboratoriet for 
Hydraulik og Havnebygning Instituttet for Vand, Jord og Miljøteknik Aalborg
 Universitet. Available at: <http://lvov.weizmann.ac.il/lvov/
Literature-Online/Literature/Books/2001_Sediment_Transport.pdf> 
[accessed 16 September 2013].

Soulsby, R., 1997. Dynamics of marine sands: A manual for practical 
applications. London: Thomas Telford.

update history:


%}

%constants

if ~exist('rhoW','var'), rhoW=1025; end
if ~exist('rhoS','var'), rhoS=2650; end
if ~exist('g','var'), g=9.81;  end                  % gravity, m/s^2 

%% Main function

theta=tau./((rhoS-rhoW)*g*D50);