% Author : Claudéric DeRoy
% Last date of modification : 17/07/2024

% TO DO :
% take out the @epoch parameter and make it more general. Maybe add vector
% parameter of the aversive, neutral and optionally uninteresting events
function [PSs, AUCs] = scalingZScoreAllResponsesByMax(PS, AUC)
%     The seventh rescalling method from Privratsky et al. 2020. It is the same 
%     as the scalingZScoreAllResponses function except that it divided the 
%     values of the vectors by their maximum value.
%     @return: the new epoch with modify PS and AUC.
%     @epoch (1x1 MATLAB struct) : the output of the epochs function, look
%     bellow for more information.
    
    maxPS = max(PS);
    maxAUC = max(AUC);
   
    for i = 1:length(PS)
        PS(i) = PS(i) / maxPS;
        AUC(i) = AUC(i) / maxAUC;
    end
    
    PSs = PS;
    AUCs = AUC;
end