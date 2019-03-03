clear all
dbstop if error
restorePath=path
global OMEoutput DRNLoutput ANprobRateOutput savedBFlist 
global inputSignal sampleRate
clear title
% access to relevant folders
addpath (['..' filesep 'MAP'],    ['..' filesep 'wavFileStore'], ...
    ['..' filesep 'utilities']);
warning('off','MATLAB:audiovideo:wavread:functionToBeRemoved')

%%  #1 parameter file name
MAPparamsName='Normal';


%% #2 probability (fast)
AN_spikesOrProbability='probability';


%% #3  wav file speech input
% fileName='/Users/mac/Documents/biohack/ah/m01ah.wav';
class = "iy"
fileNames = dir ('/Users/mac/Documents/biohack/' + string(class));
fileNames = fileNames(4:end);

%% #4 rms level
leveldBSPL=60;        % dB SPL


%% #5 number of channels in the model
%   61-channel model (log spacing)
numChannels=41;
lowestBF=250; 	highestBF= 8000;
BFlist=round(logspace(log10(lowestBF), log10(highestBF), numChannels));


%% #6  change to model parameters
% use defaults in parameter file
% paramChanges={};  % paramChanges must be present

% use only one fiber type for simplicity
fiberType='HSR';
paramChanges={...
    'IHCpreSynapseParams.tauCa= 200e-6;'
    };

%% Generate stimuli
for i=1:length(fileNames)
    fileName = string(fileNames(i).folder) + "/" + string(fileNames(i).name);
    [inputSignal, sampleRate]=audioread(fileName);

    dt=1/sampleRate;
    inputSignal(:,1);
    targetRMS=20e-6*10^(leveldBSPL/20);
    rms=(mean(inputSignal.^2))^0.5;
    amp=targetRMS/rms;
    inputSignal=inputSignal*amp;


    %% run the model
    tic

    fprintf('\n')
    disp(['Signal duration= ' num2str(length(inputSignal)/sampleRate)])
    disp([num2str(numChannels) ' channel model'])
    disp('Computing ...')

    MAP1_14(inputSignal, sampleRate, BFlist, ...
        MAPparamsName, AN_spikesOrProbability, paramChanges, ...
        "tables/" + string(class) + "_" + i);

    toc
    path(restorePath);
end
%% the model run is finished. Now display the results
figure(99), clf

plotMethod.displaydt= 1/sampleRate;
plotMethod.figureNo=99;
plotMethod.numPlots= 6;

% show input signal
plotMethod.subPlotNo= 1;
plotMethod.yLabel= 'Pascals'; 
plotMethod.xLabel= '';
plotMethod.title= ['signal (pa) at level= ' num2str(leveldBSPL), ' dB'];
plotMethod.defaultFontSize= 14;
UTIL_plotMatrix(inputSignal, plotMethod)

% show stapes
plotMethod.subPlotNo= 2;
plotMethod.title= 'stapes displacement (m)';
plotMethod.yLabel= 'meters'; 
UTIL_plotMatrix(OMEoutput, plotMethod)

% show BM displacement
plotMethod.subPlotNo= 3;
plotMethod.title= ['basilar membrane displacement (m), ' num2str(numChannels) ' channels']; 
plotMethod.yLabel= 'BF (Hz)'; 
UTIL_plotMatrix(log(abs(DRNLoutput)), plotMethod)
set(gca, 'yticklabel', num2str(BFlist(get(gca, 'ytick'))'))

% surface plot auditory nerve response
% First, reduce the plotting effort by averaging adjacent values
PSTHbinWidth=0.001;
PSTHbinWidth=0.0005;
PSTH= UTIL_shrinkBins(...
    ANprobRateOutput(end-length(savedBFlist)+1:end,:), ...
    dt, PSTHbinWidth);
[~, nX]=size(PSTH);
time=PSTHbinWidth*(1:nX);
subplot(2,1,2)
surf(time, savedBFlist, PSTH)

caxis([0 500])
shading interp
set(gca, 'yScale','log')
xlim([0 max(time)])
ylim([0 max(savedBFlist)])
myFontSize=plotMethod.defaultFontSize;
xlabel('time (s)', 'fontsize',myFontSize)
ylabel('BF (Hz)', 'fontsize',myFontSize)
zlabel('spike rate')
set(gca,'ytick',[500 1000 2000 8000],'fontSize',myFontSize)
title (['AN - spiking probability. Fiber type: ' fiberType]);

view([0 90])

% use this for angled view
% view([14 47])

% save as demoTwisterProbability.eps
UTIL_printFigure(mfilename,gcf)

% All done. Now sweep the path clean!
path(restorePath);

