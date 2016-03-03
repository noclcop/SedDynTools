 function [rippleEq]=rippleEqSW(D50,rhoS,temp,sal,press)
% rippleEqSW - equilibrium ripple dimensions
% [rippleEq]=rippleEqSW(D50)
%
% input:
% D50               median grain size, (required)           [m]
% rhoS              sediment density, (global value)        [kg.m^-3]
% temp              seawater temperature, (10)              [degrees C]
% sal               seawater salinity (absolute or PSU), (0)[g/kg]or []
% pressure          seawater pressure, (0)                  [dbar]
%
% output:
% rippleEq.eta      ripple height,                          [m]
% rippleEq.lambda   ripple length,                          [m]
%
% user defined functions called:
% Dstar(D50,rhoS,temp,sal,press)    Dimensionless grain size


%{
rippleEqSW.m, 1.0 (Matlab 2014b)

notes

by D. Lichtman, 2015/07/29 
(from ripple Len Predict.m D. Lichtman, 2014/04/25)


References:
Soulsby, R., 1997. Dynamics of marine sands: A manual for practical 
applications. London: Thomas Telford.

Soulsby, R. L. and Whitehouse, R. J. S., 2005a. Prediction of ripple 
properties in shelf seas-Mark 1 Predictor. [pdf] Technical Report TR 150, 
R1.1. Wallingford: HR Wallingford. Available at: 
http://eprints.hrwallingford.co.uk/280/1/TR150.pdf [Accessed 25 April 2014]

Soulsby, R. L. and Whitehouse, R. J. S., 2005b. Prediction of ripple 
properties in shelf seas-Mark 2 Predictor for time evolution. [pdf] 
Technical Report TR 154, R2.0. Wallingford: HR Wallingford. Available at: 
http://eprints.hrwallingford.co.uk/281/1/TR154_-_REPRO_-_Shelf_seas_...
Mark_2_predictor-_rel2_0.pdf [Accessed 25 April 2014].

Soulsby, R. L., Whitehouse, R. J. S. and Marten K. V., 2012.  Prediction of
time-evolving sand ripples in shelf seas.  Continental Shelf Research, 38, 
pp. 47-62.


update history:

%}

switch nargin
    case 1
        rhoS=rho_s;    %kg.m^-3,     density of quartz
        temp=10;       % if temp not given then 10 C
        sal = 0;       % if salinity not given then zero
        press = 0;     % if pressure not given then zero
    case 2
        temp=10;     
        sal = 0;     
        press = 0;     
    case 3
        sal = 0;       
        press = 0;     
    case 4 
        press = 0;
end   


%constants
d_star=Dstar(D50,rhoS,temp,sal,press);

%% Main function
if 1.2>d_star || d_star>16
    rippleEq.eta=nan; rippleEq.lambda=nan; 
else  
    rippleEq.eta=D50*202*d_star^-0.554; 
    rippleEq.lambda=D50*(500+1881*d_star^-1.5);
end

rippleEq.units='m';