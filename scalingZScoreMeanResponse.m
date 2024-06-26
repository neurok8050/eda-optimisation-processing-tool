% Author : Claudéric DeRoy
% Last date of modification : 26/06/2024

% TO DO :
% take out the @epoch parameter and make it more general. Maybe add vector
% parameter of the aversive, neutral and optionally uninteresting events
function scaledData4 = scalingZScoreMeanResponse(epoch)
%     The fourth rescalling method from Privratsky et al. 2020. For each
%     interesting stimulus (in our case, CS- and CS+ without US) we z-score
%     the signal with the mean of the stimulus in question, so either CS-
%     or CS+ without US
%     @return: an array with the mean of each aversive/neutral and PS/AUC
%     combinaison.
%     @epoch (1x1 MATLAB struct) : the output of the epochs function, look
%     bellow for more information
    
    trial = [epoch.data{5,:}];
    neutralPS = [];
    neutralAUC = [];
    aversivePS = [];
    aversiveAUC = [];
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
    
    if ~isempty(uninterestPS) && ~isempty(uninterestAUC)
        meanTotalPS = mean([meanNeutralPS, meanAversivePS, meanUninterestPS]);
        meanTotalAUC = mean([meanNeutralAUC, meanAversiveAUC, meanUninterestAUC]);
        stdTotalPS = std([meanNeutralPS, meanAversivePS, meanUninterestPS]);
        stdTotalAUC = std([meanNeutralAUC, meanAversiveAUC, meanUninterestAUC]);
    else
        meanTotalPS = mean([meanNeutralPS, meanAversivePS]);
        meanTotalAUC = mean([meanNeutralAUC, meanAversiveAUC]);
        stdTotalPS = std([meanNeutralPS, meanAversivePS]);
        stdTotalAUC = std([meanNeutralAUC, meanAversiveAUC]);
    end
    
    psNeutral = (meanNeutralPS - meanTotalPS) / stdTotalPS;
    aucNeutral = (meanNeutralAUC - meanTotalAUC) / stdTotalAUC;
    
    psAversive = (meanAversivePS - meanTotalPS) / stdTotalPS;
    aucAversive = (meanAversiveAUC - meanTotalAUC) / stdTotalAUC;
    
    psUninterest = (meanUninterestPS - meanTotalPS) / stdTotalPS;
    aucUninterest = (meanUninterestAUC - meanTotalAUC) / stdTotalAUC;
    
    scaledData4 = [psNeutral, psAversive, psUninterest, aucNeutral, ...
        aucAversive, aucUninterest];
end
