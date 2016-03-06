function ProcPhoPhiles()
%% Global declarations
global rtlist;
global rtname;
global newsegs;
global newlimits;
global pholist;
global fs;


[filename,folder]  = uigetfile({'*.wav';'*.mp3';'*.flac'},'u got a file fr me or u call me 4 nothin');
file = strcat(folder, filename);
[a,fs] = audioread(file);
fprintf(1,'%s loaded \n',filename);

%% 
%Make lists of speech sounds for UI
pholist = struct();

pholist.cv = {'gI','ge','gae','ga','go','gu',
    'kI','ke','kae','ka','ko','ku',
    'pI','pe','pae','pa','po','pu',
    'bI','be','bae','ba','bo','bu',
    'tI','te','tae','ta','to','tu',
    'dI','de','dae','da','do','du'};

pholist.vc = {'Ig','eg','aeg','ag','og','ug'
    'Ik','ek','aek','ak','ok','uk',
    'Ip','ep','aep','ap','op','up',
    'Ib','eb','aeb','ab','ob','ub',
    'It','et','aet','at','ot','ut',
    'Id','ed','aed','ad','od','ud'};

pholist.cvc = {'bId','bed','baed','bad','bod','bud',
    'dIb','deb','daeb','dab','dob','dub',
    'tIp','tep','taep','tap','top','tup',
    'pIt','pet','paet','pat','pot','put',
    'kIg','keg','kaeg','kag','kog','kug',
    'gIk','gek','gaek','gak','gok','guk'};

pholist.glide = {'rI','re','rae','ra','ro','ru',
    'lI','le','lae','la','lo','lu'};

pholist.c = {'g','k','p','b','t','d'};

pholist.v = {'I','e','ae','a','o','u'};

pholist.words = {'given','kicking','cooking','dimple','getting','pebble','token','cobra','batter','potable','talking','donut','booming','talcum'};

pholist.allcv = vertcat(pholist.cv,pholist.vc,pholist.cvc,pholist.glide);
pholist.allindiv = vertcat(pholist.c,pholist.v);
pholist.alldiag = horzcat(pholist.allindiv(1,:),pholist.allindiv(2,:),pholist.words);


%%
%denoise w/ stationary wavelets in 1D
%adn = cmddenoise(a(1:fs*5,1), 'coif5', 5);
fprintf(1,'denoising %s \n',filename);
tic
adn = wden(a(:,1),'modwtsqtwolog','s','mln',7,'db2');
fprintf(1,'finished denoising in %.1f seconds \n',toc);
denfile = strcat(file(1:end-4),'_denoise',file(end-3:end));
audiowrite(denfile,adn,fs);
fprintf(1,'wrote denoised file to %s \n',denfile);

%%
%Lowpass filter - maximally flat IIR
%fpass = 15000;
%fstop = 18000;
%apass = 0.3;
%astop = 50;
%lpfilt = designfilt('lowpassfir','PassbandFrequency',fpass,'StopbandFrequency',fstop,'PassbandRipple',apass,'StopbandAttenuation',astop,'DesignMethod','butter','SampleRate',fs);
%afilt = filter(lpfilt,a(:,1));

%LP filter - least-squares linear-phase FIR
%t = (0:length(a(:,1))-1)/fs;
%lpfilt = fir1(18,0.25,chebwin(19,30));
%afilt = filter(lpfilt,1,adn(:,1));

%view filter
%fvtool(lpfilt)
%% See some of the file eh?
%spectrogram(aps,1200,400,15000,fs,'yaxis');
%shading interp
%colormap bone

%% Hear it too eh?
%soundsc(adn(1:(fs*10)),fs)

%% Pitch Shifting & Decimation
%
shiftratio = 10; %Parameter to set shift multiplier
fprintf(1,'Pitch shifting by %.1fx \n',shiftratio);
tic 
lendn = size(adn,2);
[sig, fs] = PShift(denfile,fs,shiftratio,0,lendn);
fprintf(1,'Decimating...\n');
aps = decimate(sig,shiftratio); %Decimate file to return to original sampling rate
fprintf(1,'Pitch shifting and decimation completed in %.1f seconds \n',toc);
psfile = strcat(file(1:end-4),'_pshift',file(end-3:end));
audiowrite(psfile,aps,fs);
fprintf(1,'Pitch shifted file written to %s \n',psfile);

%% Lets get segmentin
%Settings for window size, etc. are in detectVoiced and 
fprintf(1,'Segmenting file by spectral centroid...\n');
tic
[seg, limits] = detectVoiced(aps,fs);
fprintf('Segmented into %d pieces in %.1f seconds.\n',size(seg,2),toc);

%% Name, Debug, and Save the Segments
type = input('What type of sound file is this? \n 1)All C,V Combinations, 2)All Diagnostics \n 3)Only CV, 4)Only VC, 5)Only CVC, 6)Only Glides, \n 7)Only Individual C/V, 8)Only Words \n');
switch type
    case 1
        rtlist = pholist.allcv';
        rtname = 'pholist.allcv';
    case 2
        rtlist = pholist.alldiag';
        rtname = 'pholist.alldiag';
    case 3
        rtlist = pholist.cv';
        rtname = 'pholist.cv';
    case 4
        rtlist = pholist.vc';
        rtname = 'pholist.vc';
    case 5
        rtlist = pholist.cvc';
        rtname = 'pholist.cvc';
    case 6
        rtlist = pholist.glide';
        rtname = 'pholist.glide';
    case 7
        rtlist = pholist.allindiv';
        rtname = 'pholist.allindiv';
    case 8
        rtlist = pholist.words';
        rtname = 'pholist.words';
end


fprintf('List set to %s \n',rtname);
ntimes = input('and how many repetitions does it have? \n');
rtlist = repmat(rtlist,1,ntimes);

nseg = numel(seg);
nlist = numel(rtlist);
fprintf('\n They dont think it be like it is to have %d segments, but it do have %d \n',nlist,nseg);
segcheck = input('Enter segment debugging? [y/n]','s');
if segcheck == 'y'
    DebugSegs(aps,fs,seg,limits,adn);
    seg = newsegs;
    limits = newlimits;
elseif segcheck == 'n'
    savecheck = input('\n Brave, you want to save them as is? [y/n]');
    if savecheck =='y'
        savesegs(seg);
    end
else
    fprintf(1,'Who do you think you are? You fill out the form like everyone else pal or you get the hell out of my restaurant.\n');
end



    

