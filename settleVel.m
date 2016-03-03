function [Ws]=settleVel(D50,rhoS,form,temp,sal,press,Cs)
% Ws - settling velocity of sediment 
% [output arg]=name(input arg)
%
% input:
% D50              median sediment diameter,               [m]
% rhoS             sediment density,                       [kg.m^-3]
% form             formula to use, 1 - Soulsby (default), 2 - van Rijn,
%                                   3 - Hallermeier.
% temp             seawater temperature,                   [degrees C]
% sal              seawater salinity (absolute or PSU),    [g/kg]or []
% pressure         seawater pressure,                      [dbar]
% Cs               volume concentration of suspended sand  [] 
%
%
% output:
% Ws               settling velocity,                      [m/s]
%
% user defined functions called:
% Dstar            dimensionless grain size
% SW_Kviscosity    kinematic viscosity from the seawater toolbox (optional)
%
% notes
% the volume concentration allows a correction for hindered settling in 
% Souldby's equation

%{
settleVel, 1.0 (Matlab 2014b)

notes

by D. Lichtman, 2015/10/30


References:



update history:
References:
Soulsby, R., 1997. Dynamics of marine sands: A manual for practical 
applications. London: Thomas Telford.

%}

% constants

% main function


D_star = Dstar(D50,rhoS,temp,sal,press);

if exist('sal','var')
    nu = SW_Kviscosity(temp,'C',sal,'ppt'); 
else
    nu = kin_visc; %1.36*10^-6;% m^2.s^-1, kinematic viscostiy at 10C, 35 S
end 

if ~exist('Cs','var'), Cs = 0; end

if Cs>=1
error('settleVel:concentration', ...
                         'volume concentration cannot be 1 or greater')
end    

switch form
    case 1
        % Soulsby (1997?)
        Ws = nu*((10.36^2 +1.049*(1 -Cs)^4.7 *D_star^3)^0.5 -10.36)/D50;
        
    case 2
        % van Rijn (1984)
        if D_star^3 <= 16.187
            Ws = nu*D_star^3/(18*D50);   
        elseif 16.187 < D_star^3 && D_star^3 <= 16187
            Ws = 10*nu*((1 +0.01*D_star^3)^0.5 -1)/D50;
            
        elseif 16187 < D_star^3    
            Ws = 1.1*nu*D_star^1.5/D50;
            
        end    
        
    case 3
        % Hallermeier (1981)
        if D_star^3 <= 39
            Ws = nu*D_star^3/(18*D50);  

        elseif 39 < D_star^3 && D_star^3 < 10^4
            Ws = nu*D_star^2.1/(6*D50);

        elseif 10^4 <= D_star^3 && D_star^3 < 3*10^6    
            Ws = 1.05*nu*D_star^1.5/D50;
            
        elseif 3*10^6 < D_star^3 
            Ws = nan; 
            
        end    
end

