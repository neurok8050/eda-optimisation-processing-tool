% test file
% PASS = compile and execute no error
% WORKING = function exactly like the older code

pathFile_HRA_1 = "/home/clauderic/Maîtrise Psychologie/PsPM-HRA_1 dataset/Data/HRA_1_cogent_01.mat";
cogent_HRA_1 = load(pathFile_HRA_1);
% event_HRA_1 = event_PsPM_HRA_1(cogent_HRA_1.data(:,1), cogent_HRA_1.data(:,2), cogent_HRA_1.data(:,3), pathFile_HRA_1, "normal");
% PASS

pathFile_SCRV_1 = "/home/clauderic/Maîtrise Psychologie/PsPM-SCRV_1 dataset/Data/SCRV_1_cogent_01.mat";
cogent_SCRV_1 = load(pathFile_SCRV_1);
% event_SCRV_1 = event_PsPM_SCRV_1(cogent_SCRV_1.data(:,1), cogent_SCRV_1.data(:,7), pathFile_SCRV_1, "normal");
% PASS

pathFile_SCRV_4 = "/home/clauderic/Maîtrise Psychologie/PsPM-SCRV_4 dataset/Data/SCRV_4_cogent_01.mat";
cogent_SCRV_4 = load(pathFile_SCRV_4);
% event_SCRV_4 = event_PsPM_SCRV_4(cogent_SCRV_4.data(:,1), cogent_SCRV_4.data(:,2), cogent_SCRV_4.data(:,5), pathFile_SCRV_4, "normal");
% PASS

signal = load("/home/clauderic/Maîtrise Psychologie/PsPM-HRA_1 dataset/Data/HRA_1_spike_01.mat");
triggersTimeStamp = signal.data{2,1}.data;
signal_data = signal.data{1,1}.data;
samplingRate = 100;
preTimeStart = 2;
preTimeStop = 0;
postTimeStart = 1;
postTimeStop = 5;

% [SOIs, baselines] = epoch(triggersTimeStamp, samplingRate, preTimeStart, preTimeStop, postTimeStart, postTimeStop, signal_data);
% PASS

% [PSs, AUCs] = metrics(SOIs, baselines);
% PASS

% TODO, test/modified but not sure if to do it because it is a finicky
% function
% motionArtifactRemoval();

% plotSignalEvents(signal_data, triggersTimeStamp, 100, 1);
% PASS

% scaled3 = scalingMaxValue(signal_data);
% PASS

% scaled2 = scalingZScore(signal_data);
% PASS

% [PS_scaled6, AUC_scaled6] = scalingZScoreAllResponses(PSs, AUCs);
% PASS

% [PS_scaled7, AUC_scaled7] = scalingZScoreAllResponsesByMax(PSs, AUCs);
% PASS
