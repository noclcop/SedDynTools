function alphaW = sound_abs_seawaterFG(freq,depth,temp,sal,pH,lat)
% sound_abs_seawaterFG - sound absorption in seawater
% alphaW = sound_abs_seawaterFG(freq,depth,temp,sal,pH,lat)
%
% single points only, not arrays
%
% input:
% freq      acoustic frequency, [Hz]
% depth     depth of water,     [m]
% temp      water temperature,  [degrees C]
% sal       salinity,           [PSU/ppt]
% pH        pH,                 []
% lat       latitude (optional) [decimal degrees]
%
% output:
% alphaW    sound absorption in seawater, [dB/m]
%
% user defined functions called:
% gsw_p_from_z              pressure from depth
% gsw_sound_speed_CT_exact  speed of sound (Gibbs)
% (these TEOS-10 functions are optional to give better accuracy)

%{
sound_abs_seawaterFG, 1.0 (Matlab 2014b)

Calculate the absorption of sound on seawater using Francois & Garrison 
(1982) method.

Going over Francois & Garrison (1982a) they make an approximation for P3, 
an option has been added to calculate this more exactly. Also they use 273
in stead of 273.15 to calculate the absolute temperature.

notes:
Neppers = deciBels * ln (10) / 20


by D. Lichtman, 2015/08/10


References:
Fisher F. H. & Simmons V. P., 1977. Sound absorption in seawater. Journal 
of the Acoustical Society of America, 62, pp. 558-564.

Francois R. E. & Garrison G. R., 1982a. Sound absorption based on ocean 
measurements, Part I: Pure water and magnesium sulfate contributions. 
Journal of the Acoustical Society of America, 72(3), pp. 896-907.

Francois R. E., Garrison G. R., 1982b. Sound absorption based on ocean 
measurements, Part II: Boric acid contribution and equation for total 
absorption. Journal of the Acoustical Society of America, 72(6), 
pp. 1879-1890.

McDougall, T.J. and P.M. Barker, 2011. Getting started with TEOS-10 and the
Gibbs Seawater (GSW) Oceanographic Toolbox, SCOR/IAPSO WG127, 
http://www.teos-10.org/pubs/Getting_Started.pdf [Accessed 2 June 2015], 
p 28.

Robinson, S., Calculation of absorption of sound in seawater. [web page]
Available at: http://resource.npl.co.uk/acoustics/techguides/seaabsorption/
[Accessed 10 August 2015]

update history:

%}
narginchk(4,6)  % check the inputs, pH and latitude are not essential

if ~exist('pH','var')
    if sal==0, pH=7; end   % pure water
    if sal>0,  pH=8; end   % seawater (approximate)
end

freq=freq*10^-3;   % convert frequency to kHz from Hz, for calculations

theta = 273.15 + temp; % absolute temperature, [K]

% check the input data is valid for the method
if  freq>= 10 && freq<=500  
    if temp < -2 || temp > 22    % -2 <= temp  <=    22 
        error('soundAbsSea:temp','temperature out of range of method')
    end    
    if sal < 30 || sal > 35      % 30 <= sal   <=    35
        error('soundAbsSea:sal','salinity out of range of method')      
    end
    if depth > 3500              % 0 <= depth <=  3500
        error('soundAbsSea:depth','depth out of range of method')
    end
elseif freq>500 && freq<=66*10^3        
    if temp < 0 || temp > 30     % 0 <= temp  <=    30 
        error('soundAbsSea:temp','temperature out of range of method')
    end    
    if sal > 40                  % 0 <= sal   <=    40
        error('soundAbsSea:sal','salinity out of range of method')      
    end
    if depth > 10000             % 0 <= depth <= 10000
        error('soundAbsSea:depth','depth out of range of method')
    end      
else
    % alphaW=nan;
    error('soundAbsSea:freq','Acoustic frequency out of range of method')
end    

%% Pressure dependence factors (eqn.s 23, 24 & 25)

%press=press/10*0.98692;   % convert pressure from dBar to atm

P1 = 1;
P2 = 1 - 1.37*10^-4*depth + 6.2*10^-9*depth^2;
P3 = 1 - 3.83*10^-5*depth + 4.9*10^-10*depth^2;   % approximation
% P3 =  1 - 3.83*10^-4*press + 4.9*10^-8*press^2; % actual (used below)

%% c, speed of sound in water,[m/s]
try    % try TEOS-10 
	press = gsw_p_from_z(-depth,lat);             % water pressure,[kg/m^2]
    c = gsw_sound_speed_CT_exact(sal,temp,press);
    P3 =  1 - 3.83*10^-4*press + 4.9*10^-8*press^2;  % P3 from pressure 
catch  % default to approximation (Francois & Garrison, 1982)
    c = 1412 + 3.21*temp + 1.19*sal + 0.0167*depth;
end

%% Boric acid absorption term
A1 = 8.86/c*10^(0.78*pH-5);                                % [dB/km/kHz]

f1 = 2.8*(sal/35)^0.5*10^(4 -1245/theta);                  % [kHz]

%% Magnesium Sulphate absorption term
A2 = 21.44*(sal/c)*(1 + 0.025*temp);                       % [dB/km/kHz]

f2 = 8.17*10^(8 - 1990/theta) / (1 + 0.0018*(sal - 35));   % [kHz]

%% Pure water absorption term, [dB/km/kHz^2]
if temp<=20
    A3 = 4.937*10^-4 - 2.59*10^-5*temp + 9.11*10^-7*temp^2  ...
                                                       - 1.50*10^-8*temp^3;     
elseif temp>20    
    A3 = 3.964*10^-4 - 1.146*10^-5*temp + 1.45*10^-7*temp^2 ...
                                                       - 6.5*10^-10*temp^3;
end

%% Total sound absorption in seawater 

alphaW=A1*P1*f1*freq^2 / (freq^2+f1^2) +A2*P2*f2*freq^2 / (freq^2+f2^2) ...
                                                   +A3*P3*freq^2; % [dB/km]

alphaW=alphaW/1000;     % [dB/m]