% Author : Claudéric DeRoy
% Last date of modification : 26/06/2024

% TO DO :
% take out the @epoch parameter and make it more general. Maybe add vector
% parameter of the aversive, neutral and optionally uninteresting events
function scaledData5 = scalingZScoreMeanResponseByMaximum(epoch)
%     The fifth rescalling method from Privratsky et al. 2020. It is the same as
%     the fourth scaling method except we divided the value by the maximum value
%     between the aversive mean or the neutral mean for each metrics.
%     @return: an array of aversive/neutral and PS/AUC mean divided by their
%     maximum value.
%     @epoch (1x1 MATLAB struct) : the output of the epochs function, look
%     bellow for more information.
    
    trial = [epoch.data{5,:}];
    aversivePS = [];
    aversiveAUC = [];
    neutralPS = [];
    neutralAUC = [];
    uninterestPS = [];
    uninterestAUC = [];
    
    
    for i = 1:length(trial)
        if trial(i) == 0 % neutral trials
            neutralPS = [neutralPS; epoch.data{3,i}];
            neutralAUC = [neutralAUC; epoch.data{4,i}];
        elseif trial(i) == 1 % aversive trials
            aversivePS = [aversivePS; epoch.data{3,i}];
            aversiveAUC = [aversiveAUC; epoch.data{4,i}];
        elseif trial(i) == 2 % uninterest trials
            uninterestPS = [uninterestPS; epoch.data{3,i}];
            uninterestAUC = [uninterestAUC; epoch.data{4,i}];
        end
    end
    
    meanNeutralPS = mean(neutralPS);
    meanNeutralAUC = mean(neutralAUC);
    meanAversivePS = mean(aversivePS);
    meanAversiveAUC = mean(aversiveAUC);
    meanUninterestPS = mean(uninterestPS);
    meanUninterestAUC = mean(uninterestAUC);
    
    maxMeanRespPS = max([meanNeutralPS, meanAversivePS, meanUninterestPS]);
    maxMeanRespAUC = max([meanNeutralAUC, meanAversiveAUC, meanUninterestAUC]);
    
    psNeutral = meanNeutralPS / maxMeanRespPS;
    aucNeutral = meanNeutralAUC / maxMeanRespAUC;
    
    psAversive = meanAversivePS / maxMeanRespPS;
    aucAversive = meanAversiveAUC / maxMeanRespAUC;
    
    psUninterest = meanUninterestPS / maxMeanRespPS;
    aucUninterest = meanUninterestAUC / maxMeanRespAUC;
    
    scaledData5 = [psNeutral, psAversive, psUninterest, aucNeutral, ...
        aucAversive, aucUninterest];
end
