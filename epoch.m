% Author : Claudéric DeRoy
% Last date of modification : 17/07/2024

function [SOIs, baselines] = epoch(triggersTimeStamp, samplingRate, preTimeStart, ...
    preTimeStop, postTimeStart, postTimeStop, signal)
%     The function creates the epochs base on the pre stimulus window you
%     want and the post stimulus window you want.
%     @triggersTimeStamp ([int array]) : an array with all the time stamp in
%     seconds of the triggers of your experiment.
%     @samplingRate (int): the sampling of the signal you have.
%     @preTimeStart (int): the start time in second of the window before
%     the stimulus. Example, a preTimeStart of 2 means the pre stimulus
%     window will start 2 secondes before the stimulus.
%     @preTimeStop (int): the end in second of the window before the
%     stimulus. Example, a preTimeStop of 0 means the pre stimulus window
%     will end directly at the time the stimulus appears.
%     @postTimeStart (int): the start time in second of the window after
%     the stimulus. Example, a postTimeStart of 1 second means the post
%     stimulus window will start 1 second after the stimulus appears.
%     @postTimeStop (int): the stop time in second of the window after the
%     stimulus. Example, a postTimeStop of 5 means the post stimulus window
%     will stop 5 seconds after the stimulus appears.
%     @signal ([int array]): the signal that you wish to epoch.
%     @return :
%      @SOIs ([[int]]): list of list containing the different epochs
%      @baselines ([[int]]): list of list containing the differents
%      baselines
    
%     the first for loop creates the startTrigger (the starting time of the 
%     trigger) which is multipled by the sampling rate so we get the exact index
%     of the epoch then we create an empty space for the data of the epoch. The 
%     second for loop puts all the values for the starting window time to the 
%     length of the epoch in the initialize empty space for the epoch.

    SOI = {};
    baseline = {};

    for i = 1:length(triggersTimeStamp)
        
%         the epoch starts at postTimeStart second after the stimilus
        startTrigger = (triggersTimeStamp(i) + postTimeStart) * samplingRate;
        endTrigger = (triggersTimeStamp(i) + postTimeStop) * samplingRate;
     
%         the baseline start at preTimeStart seconds before the apparition of 
%         the stimulus
        baselineStart = (triggersTimeStamp(i) - preTimeStart) * samplingRate;
        baselineStop = (triggersTimeStamp(i) - preTimeStop) * samplingRate;
        
        SOI{i} = []; % where the Signal Of Interest (SOI) is stored
        baseline{i} = []; % where the baseline is stored
   
%         the for loop who gets all the value of the SOI
        for j = startTrigger:endTrigger - 1
            SOI{i} = [SOI{i}; signal(floor(j))];
        end

%         the for loop who gets all the value of the baseline
        for k = baselineStart:baselineStop - 1
            baseline{i} = [baseline{i}; signal(floor(k))];
        end
    end
    SOIs = SOI;
    baselines = baseline;
    return
end
