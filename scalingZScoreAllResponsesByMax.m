% Author : Claudéric DeRoy
% Last date of modification : 26/06/2024

% TO DO :
% take out the @epoch parameter and make it more general. Maybe add vector
% parameter of the aversive, neutral and optionally uninteresting events
function scaledData7 = scalingZScoreAllResponsesByMax(epoch)
%     The seventh rescalling method from Privratsky et al. 2020. It is the same 
%     as the scalingZScoreAllResponses function except that it divided the 
%     values of the vectors by their maximum value.
%     @return: the new epoch with modify PS and AUC.
%     @epoch (1x1 MATLAB struct) : the output of the epochs function, look
%     bellow for more information.
    
    maxPS = max(vertcat(epoch.data{3,:}));
    maxAUC = max(vertcat(epoch.data{4,:}));
   
    for i = 1:length(epoch.data)
        epoch.data{3,i} = epoch.data{3,i} / maxPS;
        epoch.data{4,i} = epoch.data{4,i} / maxAUC;
    end
    
    scaledData7 = epoch;
end