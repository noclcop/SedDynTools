function [ADVout,ADVhd,freq]=  ...
                loadSontekADVocean(filename,startEnd,burstType,lat,despike)
%{
load Sontek ADV ocean hydra data

A function to load Sontek ADV ocean hydra data from ranges of bursts 
(default) or a time range. A correlation limit of 70% (Sontek, 2001) is
used to filter the data.  Option to despike data using Mori et al's
function based on the Goring and Nikora

The header file (.HD*) contains the burst no., time of the first sample in
the burst & no. of samples, and is used to add a time stamp to the data 
in the files(.TS*).

if there are no input arguments the user is prompted to select the file,
burst type and burst range (not time range). if a file name is specified
but no other deatails the first burst is loaded.

If a latitude is give as input then the pressure data is corrected for the
distance to boundary and pressure sensor offset (this assumes the
instrument is downward looking). So you get the pressure at the bed.

by D. Lichtman, NOCL, 11 July 2013

input:
filename            name of Sontek ADV TS and HD data files
start_end           1x2 array of start and end time or burst no.
bursttype           value 1-3 for burst sample type (not needed if there
                    is a file extension on the filename)
lat                 latitude for boundary distance correction
despike             0-replace spikes using Mori's function, nan
                    2-replace spikes using Mori's function, interpolation
                      (default)
                    3-leave spikes

data columns, TS:
1-burst no,2-sample no,3-Vx or Veast,4-Vy or Vnorth,5-Vz or Vup,6-Amp 1,
7-amp 2,8-amp 3,9-corr 1,10-corr 2,11-corr 3,12-heading,13-pitch,14-roll,
15-temp,16-press

data columns, HD:
1-Burst no.,2-y,3-m,4-d,5-h,6-m,7-s,8-sample rate,9-no of samples,
10-recorded data byte (23),11-speed of sound,12-dist 2 bound transducer,
13-dist 2 bound sample vol,14-batt V,15-Vx or Veast,16-Vy or Vnorth,
17-Vz or Vup,18-Amp 1,19-amp 2,20-amp 3,21-corr 1,22-corr 2,23-corr 3,
24-heading,25-pitch,26-roll,27-temp,28-press, + 29-40-not known

output:
ADVout       adv data for selection, velocities in cm/s
ADVhd        adv header data; SoS [m/s], dist to boundary (trans) [cm], 
             dist to boundary (samp vol) [cm] and burst no.
freq         adv sampling frequency
                
data columns, ADVout:
1-timecode,2-serial no,3-burst no,4-Vx or Veast ,5-Vy or Vnorth,
6-Vz or Vup,7-Amp 1,8-amp 2,9-amp 3,10-corr 1,11-corr 2,12-corr 3,
13-heading (deg),14-pitch(deg),15-roll(deg),16-temp (deg),17-press (dBar)
 
data columns, ADVhd:
1-timecode, 2-speed of sound (m/s), 3-distance to boundary from transducer
(cm),4-distance to boundary from sample vol. (cm)  
                
User defined functions:
filterWinSize2                  determine the ideal filter size to
                                remove periodicity
func_despike_phasespace3d_3var  Mori's despiking function
gsw_p_from_z                    calculate pressure from depth (Gibbs
                                seawater toolbox)
velocity_prime                  calculate velocity fluctuations
    

References:
Goring, D. G. And Nikora, V. I., 2002.  Despiking Acoustic Doppler 
Velocimeter Data.  Journal of Hydraulic Engineering, 128, pp 117-126.

Mori, N., Suzuki, T. And Kakuno, S., 2007.  Noise of Acoustic Doppler 
Velocimeter Data in Bubbly Flows.  Journal of Engineering Mechanics, 133, 
pp 122-125.
    
Sontek, 2001. [pdf] SonTek/YSI ADV Field/Hydra Acoustic Doppler 
Velocimeter (Field) technical documentation.  Available at: 
http://cleveland2.ce.ttu.edu/software/instruments/SonTek/ADV_Instruments/
ADVManual.pdf [Accessed 26 June 2013].
    
Wahl, T. L., 2003.  Discussion of “Despiking Acoustic Doppler Velocimeter 
Data” by Derek G. Goring and Vladimir I. Nikora (2002), Journal of 
Hydraulic Engineering, 129, pp. 484-487.    
            
updates:
2014/08/20  DL: When shortening the variable names I didn't do them all, 
                this mean ADVout was overwriting insdtead of concatenating.
                they weren't found as they were hidden in 'text'.Fixed now. 
                
2014/06/30, DL: Skips to next burst if number of good readings is <2400 as
                too few readings messes up the despiking (really it was <3,
                but 2400 is 5 minutes and less than that is not worth it).
                Also function name has been shortened to loadSontekADVocean
                
2014/05/13, DL: Skips to next burst if correlation check rejects all the 
                data    
    
2014/05/12, DL: correlation is now checked burst by burst, before the 
                despiking function is applied   
    
18 September 2013, DL: interpolates/extraolates/nearest neighbour/Nan if a 
                       distance to boundary value is missing (this could 
                       cause errors so only use for tidal range calc)

17 September 2013, DL: corrects pressure data for distance to boundary if
                       latitude is given

16 September 2013, DL: new version created (load_sontekADVocean_data_plus)
                       to output header data for speed of sound and and 
                       distances to boundary from the probe and sampling 
                       volume

10 September 2013, DL: didn't work for bursts now it does

 3 August 2013, DL: correlation limit filter added
%}

%% main function
%constants
corr_lim=70;   %correlation limit 70%

if ~exist('lat','var'), lat=0; end % set latitude to zero if not there

%% check input arguments
if nargin==0    %ask for filename, burst type and start & end burst
[filenamein,PathName,FilterIndex]=uigetfile('*.TS*','Select TS file'); 
   cd(PathName);
   if FilterIndex==0,disp('no file selected');return; end
   filename=filenamein(1,:);   %use first filename if given a list
   prompt={'Enter burst type (1-2):','Start burst no.:','End burst no.:'};
   default={'1','1','1'};
   answer=inputdlg(prompt,'ADV selections',1,default); 
   burstType =str2double(answer{1});
   startEnd(1)=str2double(answer{2});
   startEnd(2)=str2double(answer{3});
   sections=0;         %defaults to bursts
elseif nargin==1
   sections=0;         %defaults to bursts
   startEnd=[1 1];    %a single burst 
   burstType=1;
elseif nargin>1
   if startEnd(1,1)>70000
       sections=1;    %time range
   elseif startEnd(1,2)==0
       startEnd(1,1)=1;
       sections=0;    %burst range
   else    
       sections=0;    %burst range
   end    
end 

if find(filename=='.')>0                        %detects file extension
    burstType=str2double(filename(end));
    filename=filename(1:find(filename=='.')-1); %removes extension
end    

if ~exist('despike','var'), 
    despike=2;    %default is to replace spikes with interpolation
else
    if despike==1, despike=2; end   % option 1 of Mori's function shortens
end                                 % the array, so changes to option 2


%% load header file and determine no.of bursts
try
    adv_hd=dlmread([filename,'.HD',num2str(burstType)]);
catch
    disp('no HD file')
    return
end    

nooofbursts=adv_hd(end,1);       % number of bursts
freq=mode(adv_hd(:,8));          % sampling rate/frequency, Hz

%open data file
try
adv_id=fopen([filename,'.TS',num2str(burstType)]);
catch 
    disp('no TS file')
    return    
end    
fgetl(adv_id); %read in first line (blank) and discard

%check start and end bursts are in range of file
if sections==0
    if startEnd(1,1)>nooofbursts
        startEnd(1,1)=nooofbursts;
        disp('start value out of file range');
    end
    if startEnd(1,2)>nooofbursts
        startEnd(1,2)=nooofbursts;
        disp('end value out of file range');
    end
    start_b=startEnd(1);
    end_b=startEnd(2);
elseif sections==1
    %finds the first and last bursts for time range
    %(if both are out of the burst range the whole file will be returned)
    start_b=find(datenum(adv_hd(:,2:7))<=startEnd(1),1,'last');
    if isempty(start_b),start_b=1; end
    end_b=find(datenum(adv_hd(:,2:7))>=startEnd(2),1,'first');
    if isempty(end_b),end_b=nooofbursts; end
end    

%skip to part of file with required data (to speed things up)
%1 line = 94 bytes  + 1 for CR terminator of first blank line (no LF)
noofsamps=adv_hd(1,9); %no. of samples in burst
fseek(adv_id,(start_b-1)*noofsamps*94+1,'bof');

ADVhd(end_b,4)=0;   %pre-dimension for speed

%loop through bursts
for aa=start_b:end_b   %1:nooofbursts
   noofsamps=adv_hd(adv_hd(:,1)==aa,9); %no. of samples in burst
   adv_in=zeros(noofsamps,17);
   starttime=datenum(adv_hd(adv_hd(:,1)==aa,2:7));
   adv_in(:,1)=datenum(...
   datevec((starttime:1/(24*3600*8):starttime+(noofsamps-1)/(24*3600*8))));
   
   for bb=1:noofsamps
     %read in data line by line
     line_in=fgetl(adv_id);
     if feof(adv_id), break, end  %break for loop if end of file
     adv_in(bb,2:17)= sscanf(line_in,...
        '%u %u %f %f %f %u %u %u %u %u %u %f %f %f %f %f'); 
    
     %correct pressure for boundary distance ------------------------------  
     %39.5 cm is the offset between the pressure sensor and centre
     %transducer face
     if exist('lat','var') && adv_hd(adv_hd(:,1)==aa,12)>0
     %if the values is good    
     adv_in(bb,17)=adv_in(bb,17) ...
                  -gsw_p_from_z((adv_hd(adv_hd(:,1)==aa,12)+39.5)/100,lat);
            
     elseif exist('lat','var') && adv_hd(adv_hd(:,1)==aa,12)<0 ...
                                      && sum(adv_hd(start_b:end_b,12)>0)>1
     %if the velcoity is good but the dist to boundary bad, 
     %do an interpolation or extrapolation
     b_vals=adv_hd(adv_hd(:,1)>=start_b & ...  % find
                                  adv_hd(:,1)<=end_b & adv_hd(:,12)>0,12);
     b_ind=adv_hd(adv_hd(:,1)>=start_b & ...   % find
                                     adv_hd(:,1)<=end_b & adv_hd(:,12)>0);
     b_interp=interp1(b_ind,b_vals,aa,'spline','extrap'); 
     adv_in(bb,17)=adv_in(bb,17) ...
                    -gsw_p_from_z((b_interp+39.5)/100,lat);
                
     elseif exist('lat','var') && adv_hd(adv_hd(:,1)==aa,12)<0 ...
                                      && sum(adv_hd(start_b:end_b,12)<0)>1
     %if the velocity is good but the dist to boundary bad, for all but 1
     %value, nearest neighbour (i.e. just use what is there)
     adv_in(bb,17)=adv_in(bb,17) ...
       -gsw_p_from_z((adv_hd(adv_hd(start_b:end_b,12)>0,12)+39.5)/100,lat);
   
     elseif exist('lat','var') && sum(adv_hd(start_b:end_b,12)>0)==0
     %if a the dist to boundary values in this burst are bad, NaN     
     adv_in(bb,17)=NaN;     
     end %a lot of code just to catch few bad values
     
   end %bb   
   
   % apply correlation limit to x,y and z in turn, to remove bad data -----
   % 10-corr 1,11-corr 2,12-corr 3 (shortens array)
   for cc=10:12
    adv_corr=adv_in(adv_in(:,cc)>corr_lim,:);  % find
    %just to make sure the data doesn't get carried over
    clear adv_in
    adv_in=adv_corr;
   end
   
   % if the data is bad skip to next burst
   if isempty(adv_in), continue; end 
   if size(adv_in,1)<2400, continue; end 
   
   % de-spike data  -------------------------------------------------------
   if despike<3
       
    %determine array dimensions 
    %(depends on how many lines are removed by the correlation limit)
    reclen=size(adv_in,1);

    % high pass filter to remove trend
    % determine filter size
    FiltWin(3)=0;
    for cc=1:3
        FiltWin(cc)=filterWinSize2(adv_in(:,3+cc),freq,1);
    end

    % apply filter
    velprime(reclen,3)=0;
    for cc=1:3
        velprime(:,cc)=velocity_prime(adv_in(:,3+cc),FiltWin(cc),reclen);
    end

    % replace spikes 
    [vxc, vyc, vzc, ~]= ...
    func_despike_phasespace3d_3var(velprime(:,1), ...
                                      velprime(:,2),velprime(:,3),despike); 

    % remove velocity fluctuations and add back despiked fluctuation data
    adv_in(:,4:6)=adv_in(:,4:6)-velprime+[vxc, vyc, vzc];  
    
    clear velprime FiltWin vxc vyc vzc
   end
   
% concatenate data into a single file as a time or burst range ------------  
   switch sections
       case 1   %time range
         ind1=find(datenum(adv_in(:,1))>=startEnd(1),1,'first');
         ind2=find(datenum(adv_in(:,1))<=startEnd(2),1,'last');
         if isempty(ind1)||isempty(ind2),continue, end
         
         if exist('ADVout','var')
            ADVout=cat(1,ADVout,adv_in(ind1:ind2,:));
         else
            ADVout=adv_in(ind1:ind2,:);
         end    
   
       case 0   %burst range
         if exist('ADVout','var')
            ADVout=cat(1,ADVout,adv_in(:,:));
         else
            ADVout=adv_in(:,:);
         end 
   end
      
   % output header file data of SoS & boundardy distances -----------------
   % & burst number (just as a check not really needed
   ADVhd(aa,1)=starttime;
   ADVhd(aa,2:4)=adv_hd(adv_hd(:,1)==aa,11:13);
   ADVhd(aa,5)=adv_hd(adv_hd(:,1)==aa,1);
   
   clear noofsamps adv_in starttime fileout
end %aa


fclose(adv_id);
