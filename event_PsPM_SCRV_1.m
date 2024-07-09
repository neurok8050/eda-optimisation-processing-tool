% Author : Claudéric DeRoy
% Last date of modification : 9/07/2024
% Goal : this is another example of what sort of code to write to mark
% event according to an experiment

function events_PsPM_SCRV_1 = event_PsPM_SCRV_1(trialNb, trial, epoch, ...
    triggerFileName, varargin)
%     Function to code trial from the PsPM-SCRV 1 dataset. The experiment was to
%     show aversive and nonaversive picture from the International Affective 
%     Picture System (IAPS) and using three different Inter Stimulus Interval 
%     (ISI) so it was a 2x3 experimental design. Aversive trial were marker as 0
%     and neutral trial as 1. This function is necessary if you use the
%     PsPM-SCRV 1 dataset if not you can ignore it.
%     @trialNb ([int]): vector of the trial number ([1,2, to the nth trial])
%     @trial ([int]): vector of trial encoding, example if 1 : aversive and 0
%     : neutral then you should have a vector looking like this [1,0,0,1,0,1]
%     @epoch (1x1 MATLAB struct) : the output of the epochs function, look
%     above for more information.
%     @triggerFileName (String): path to the file containing the trial
%     information (i.e. cogent from Bach file system). If you do not have a
%     cogent file just pass the file name you would like to save to use
%     later with PsPM, "onsets_" will be written in front of it
%     @return: the epoch pass has argument will be modify. Each trial will
%     be coded and added to the the epoch struct.
   
    artifact = varargin{1};
    fileName = extractAfter(triggerFileName, "Data/");
    fileName = "onsets_" + fileName;
    
    if artifact == "artifact"
        fileName = strcat(extractBefore(triggerFileName, "Data/"), ...
        "Data/"+"artifact_"+fileName);
    else
        fileName = strcat(extractBefore(triggerFileName, "Data/"), ...
        "Data/"+fileName);
    end
    
    names = {};
    onsets = {};
    names{1,1} = 'aversive';
    names{1,2} = 'neutral';
    onsets{1,1} = [];
    onsets{1,2} = [];
    
%     TODO: remove if it work with trialNb and trial as function parameter
%     trialNb = trialInfo.data(:,1); % vector of the number of the trial
%     trial = trialInfo.data(:,7);
    
    for i = 1:length(trialNb)
        if trial(i) == 0
            epoch.data{5,i} = 1; % coding aversive trial as 1
            onsets{1,1} = [onsets{1,1}, trialNb(i)];
        else
            epoch.data{5,i} = 0; % coding neutral trial as 0
            onsets{1,2} = [onsets{1,2}, trialNb(i)];
        end
    end
    save(fileName, 'names', 'onsets');
    events_PsPM_SCRV_1 = epoch;
end
