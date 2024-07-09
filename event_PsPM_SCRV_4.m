% Author : Claudéric DeRoy
% Last date of modification : 9/07/2024
% Goal : another example of what code to write to marke event from an
% experiment

% TODO:
% make it more usable, remove complex data structure, use vector instead
function events_PsPM_SCRV_4 = event_PsPM_SCRV_4(trialNb, cs, us, epoch, ...
    triggerFileName, varargin)
%     Function to code trial from the PsPM_SCRV 4 dataset. The experiment is the
%     same as the experiment in the PsPM-HRA_1 except that the US is a 95 dB 
%     white noise. This function is necessary if you use the PsPM-SCRV 4
%     dataset if not you can ignore it.
%     @trialNb ([int]): vector of the trial number ([1,2, to the nth trial])
%     @cs ([int]): vector of trial encoding, example if 1 : aversive and 0
%     : neutral then you should have a vector looking like this [1,0,0,1,0,1] 
%     if the first, fourth and sixth trial are aversive and the rest are neutral
%     @us ([int]): vector indicating weither or not the unconditioned
%     stimulus is present (1 : present, o: absent)
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

%     TODO: remove if trialNb, cs and us work as function parameters
%     trialNb = trialInfo.data(:,1);
%     cs = trialInfo.data(:,2); % vector of the CS- and CS+
%     us = trialInfo.data(:,5); % vector of the presence of US or absence of US
    
    for i = 1:length(trialNb)
        if cs(i) == 2 && us(i) == 0
            epoch.data{5,i} = 1; % coding aversive trial as 1
            onsets{1,1} = [onsets{1,1}, trialNb(i)];
        elseif cs(i) == 1
            epoch.data{5,i} = 0; % coding nonaversive trial as 0
            onsets{1,2} = [onsets{1,2}, trialNb(i)];
        else
            epoch.data{5,i} = 2; % non-interesting stimulus
        end
    end
    save(fileName, 'names', 'onsets')
    events_PsPM_SCRV_4 = epoch;
end
