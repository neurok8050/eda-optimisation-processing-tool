% Author : Claudéric DeRoy
% Last date of modification : 17/07/2024


function [PSs, AUCs] = scalingZScoreAllResponses(PS, AUC)
%     The sixth rescalling method from Privratsky et al. 2020. For each
%     trial it calculates the metrics (PS, AUC) it puts it in a vector and z 
%     score those value.
%     @return: the epoch with modify PS and AUC.
%     @epoch (1x1 MATLAB struct) : the output of the epochs function, look
%     bellow for more information.
   
    meanPS = mean(PS);
    meanAUC = mean(AUC);
    stdPS = std(PS);
    stdAUC = std(AUC);
    
    for i = 1:length(PS)
        PS(i) = (PS(i) - meanPS) / stdPS;
        AUC(i) = (AUC(i) - meanAUC) / stdAUC;
    end
    PSs = PS;
    AUCs = AUC;
end
