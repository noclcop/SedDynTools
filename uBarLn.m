function [uBar]=uBarLn(uz,height,dpth,z0)
% uBarLn - calculate depth mean velocity, using law of the wall
% [uBar]=uBarLn(uz,height,depth,D90,lLim)
%
% input:
% uz           horizontal velocity at a known height,         [m/s]
% height       the height of the velocity measurement,        [m]
% dpth         the depth of water,                            [m]
% z0           roughness length, ks                           [m]
% lLim         lower limit of integration, deafults to 0.001, [m]
%
% output:
% uBar         depth mean velocity,                           [m/s]
%
% user defined  functions called:
% von_karman    von karman constant
% k_s           Nikuradse grain roughness
% uStar_LOTWsp  friction velocity from a single point

%{
uBarLn, v1.2 (Matlab 2013b)

calculate depth mean velocity, u bar, from a single velocity using the 
law of the wall and integration (summation) 

notes:
this assumes a logarithmic flow (law of the wall), height of measurement is
constant and D90 is constant.

by D. Lichtman, 2014/12/10

References:
Soulsby, R., 1997. Dynamics of marine sands: A manual for practical 
applications. London: Thomas Telford.

Wikipedia, 2015. List of integrals.
http://en.wikipedia.org/wiki/Lists_of_integrals

update history:
2015/05/07 DL: z0 is the lower limit, where the velocity is zero
2015/05/01 DL: changed to accept z0 instead of D50 (and then calculate D50)
2014/12/11 DL: replaced descrete sum with ingegral for better results
               (accuracy and running time).
%}

% checks
narginchk(4,4)

%if ~exist('lLim','var'), lLim=0.001; end 
%if lLim==0, lLim=0.001; end               % defaults to 1 mm lower limit
                                          % can't be 0 as log fails
if sum(size(uz)~=size(height))  
    height(1:size(uz,1),1)=height;     % if only a single height, replicate
end    

if sum(size(uz)~=size(dpth))  
    dpth(1:size(uz,1),1)=dpth;         % if only a single depth, replicate
end    
        
%constants


%% Main function

uStar=uStar_LOTWsp(uz,height,z0);

%uBar= ...
%uStar./von_karman./dpth.*(dpth.*log(dpth./z0)-dpth-lLim*log(lLim/z0)+lLim);

uBar=uStar./von_karman./dpth.*(dpth.*log(dpth./z0)-dpth+z0);

%% attempted to do it as a discrete sum, but it took too long
%{
uBar(size(dpth,1),1)=0;

for x=1:size(dpth,1)
    lnTerm(round(depth(x)/res))=0;

    for z=1:round(depth(x)/res)
        lnTerm(z)=log(z*res/z0)*uStar/von_karman*res;
    end    

    uBar(x,1)=sum(lnTerm)/depth(x);
    clear uStar lnTerm
end
%}