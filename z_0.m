function [z0]=z_0(Dn)

%{
z_0, v1.0 (Matlab 2013b)

bed roughness length for a rough flow (skin friction only)

notes

full formula would use u*, nu and ks to work out if the flow is
hydrodynamically smooth, transitional or rough.

by D. Lichtman, 2014/09/06

input:
arg              description


output:
arg              description

user defined functions called:
k_s           bed roughness length, representing the grain roughness.

References:
Liu, Z., 2001. Sediment Transport. [e-book/pdf] Aalborg: Laboratoriet for 
Hydraulik og Havnebygning Instituttet for Vand, Jord og Miljøteknik Aalborg
 Universitet. Available at: <http://lvov.weizmann.ac.il/lvov/
Literature-Online/Literature/Books/2001_Sediment_Transport.pdf> 
[accessed 16 September 2013].

Soulsby, R., 1997. Dynamics of marine sands: A manual for practical 
applications. London: Thomas Telford.

van den Berg, J.H., 1987. Bedform migration and bed-load transport in some 
rivers and tidal environments. Sedimentology, 34, pp. 681-698.

update history:

%}

%constants


%% Main function


z0=k_s(Dn)/30;

