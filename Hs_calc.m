function [Hs,Hs_std]=Hs_calc(waveheights)
%{
Hs_calc.m

calculate the significant wave height of a wave height record
(mean of 1/3 highest waves)

by D. Lichtman, 27 November 2013

update history

input:
waveheights     array of wave heights

output:
Hs              siginifcant wave height of record
Hs_std          standard deviation of 1/3 highest waves

user defined functions called:

References:
U.S. Army Corps of Engineers, 2002a.  Coastal Engineering Manual: Part 2 
Coastal Hydrodynamics, chapter 1 water wave mechanics, Engineering Manual 
1110-2-1100. [pdf] U.S. Army Corps of Engineers, Washington, D.C. 
Available at: http://140.194.76.129/publications/eng-manuals/
EM_1110-2-1100_vol/PartII/PartII.htm [Accessed 19 July 2013].

%}

%% Main function
%sort wave heights 
s_waveheights = sort(waveheights,'descend');

%determine no. of waves in top 1/3
nwaves = round(length(s_waveheights)/3,0);

%mean 
Hs = mean(s_waveheights(1:nwaves));
Hs_std = std(s_waveheights(1:nwaves));








