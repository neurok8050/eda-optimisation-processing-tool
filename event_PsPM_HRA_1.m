% Author : Claudéric DeRoy
% Last date of modification : 9/07/2024
% Goal : this is a good example of how to write a code that will marker
% event based on the experiment

function events_PsPM_HRA_1 = event_PsPM_HRA_1(trialNb, cs, us, ....
    triggerFileName, varargin)
%     Function to code trial from the PsPM-HRA 1 dataset. The experiment from 
%     this dataset is a classic pavlovien fear experiment where CS were orange 
%     or blue filled circle and US was an uncomfortable electric shock. CS+ is 
%     coded as 2, CS- as 1 and the presence of US as 1 and the absence of US as 
%     0. So there's 2 interesting conditions, the one which is suppose to 
%     elicit an EDA response is CS+ without US. This function is
%     necessary if you use the PsPM-HRA 1 dataset if not you can ignore it.
%     @trialNb ([int]): vector of the trial number ([1,2, to the nth trial])
%     @cs ([int]): vector of trial encoding, example if 1 : aversive and 0
%     : neutral then you should have a vector looking like this [1,0,0,1,0,1] 
%     if the first, fourth and sixth trial are aversive and the rest are neutral
%     @us ([int]): vector indicating weither or not the unconditioned
%     stimulus is present (1 : present, o: absent)
%     @triggerFileName (String): path to the file containing the trial
%     information (i.e. cogent from Bach file system). If you do not have a
%     cogent file just pass the file name you would like to save to use
%     later with PsPM, "onsets_" will be written in front of it
%     @return ([int]): vector containing the encoding for each trial coded
%     as shown in the code.
    
    [filepath, name, ext] = fileparts(triggerFileName);
    artifact = varargin{1};
    
    if artifact == "artifact"
        fileName = filepath + "/artifact_" + "onsets_" + name + ext;
    else
        fileName = filepath + "/onsets_" + name + ext;
    end
    
    names = {};
    onsets = {};
    names{1,1} = 'aversive';
    names{1,2} = 'neutral';
    onsets{1,1} = [];
    onsets{1,2} = [];
    epoch = [];

%     TODO: remove so if the trialNb, cs and us function parameters work
%     trialNb = trialInfo.data(:,1); % vector of the number of the trial
%     cs = trialInfo.data(:,2); % vector of the CS- and CS+
%     us = trialInfo.data(:,3); % vector of the present US and absent US
    
    for i = 1:length(trialNb)
        if cs(i) == 2 && us(i) == 0
            epoch{i} = 1; % coding aversive trial as 1
            onsets{1,1} = [onsets{1,1}, trialNb(i)];
        elseif cs(i) == 1
            epoch{i} = 0; % coding nonaversive trial as 0
            onsets{1,2} = [onsets{1,2}, trialNb(i)];
        else
            epoch{i} = 2; % coding for non-interesting stimulus
        end
    end
    save(fileName, 'names', 'onsets');
    events_PsPM_HRA_1 = epoch;
end
