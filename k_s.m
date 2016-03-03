function [ks]=k_s(Dn,code)

%{
k_s.m, v1.0 (Matlab 2013b)

bed roughness (Nikuradse grain roughness).

2.5*D50 is usual (Soulsby, 1997)
3*D90  (van Rijn, van den Berg)

by D. Lichtman, 2014/09/06

input:
Dn             quantile grain size, e.g. D90, [m] 
code           1-D50, 2-D90 (D50 is default)

output:
ks             Nikuradse grain roughness, [m] 

user defined functions called:


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
if ~exist('code','var'), code=1; end   % default to D50

%% Main function
switch code
    case 1
    ks=2.5*Dn;  % 2.5*D50 (Soulsby, 1997)
    
    case 2
    ks=3*Dn;    % 3*D90  (van Rijn, van den Berg 1987)
    
end