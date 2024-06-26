% Author : Claudéric DeRoy
% Last date of modification : 26/06/2024
% Goal : this is a good example of how to write a code that will marker
% event based on the experiment

% TODO:
% make more usable, remove complex data structure and use vector instead
function events_PsPM_HRA_1 = event_PsPM_HRA_1(trialInfo,epoch, ....
    triggerFileName, varargin)
%     Function to code trial from the PsPM-HRA 1 dataset. The experiment from 
%     this dataset is a classic pavlovien fear experiment where CS were orange 
%     or blue filled circle and US was an uncomfortable electric shock. CS+ is 
%     coded as 2, CS- as 1 and the presence of US as 1 and the absence of US as 
%     0. So there's 2 interesting conditions, the one which is suppose to 
%     elicit an EDA response is CS+ without US. This function is
%     necessary if you use the PsPM-HRA 1 dataset if not you can ignore it.
%     @return: the epoch pass has argument will be modify. Each trial will
%     be coded and added to the the epoch struct.
%     @trialInfo (1x1 MATLAB struct): the structure the of the
%     _cogent_.mat file from the open source dataset from Bach.
%     @epoch (1x1 MATLAB struct) : the output of the epochs function, look
%     above for more information.
    
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

    trialNb = trialInfo.data(:,1); % vector of the number of the trial
    cs = trialInfo.data(:,2); % vector of the CS- and CS+
    us = trialInfo.data(:,3); % vector of the present US and absent US
    
    for i = 1:length(trialNb)
        if cs(i) == 2 && us(i) == 0
            epoch.data{5,i} = 1; % coding aversive trial as 1
            onsets{1,1} = [onsets{1,1}, trialNb(i)];
        elseif cs(i) == 1
            epoch.data{5,i} = 0; % coding nonaversive trial as 0
            onsets{1,2} = [onsets{1,2}, trialNb(i)];
        else
            epoch.data{5,i} = 2; % coding for non-interesting stimulus
        end
    end
    save(fileName, 'names', 'onsets');
    events_PsPM_HRA_1 = epoch;
end
