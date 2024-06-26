% Author : Claudéric DeRoy
% Last date of modification : 26/06/2024

% TO DO :
% take out the @epoch parameter and make it more general. Maybe add vector
% parameter of the aversive, neutral and optionally uninteresting events
function scaledData6 = scalingZScoreAllResponses(epoch)
%     The sixth rescalling method from Privratsky et al. 2020. For each
%     trial it calculates the metrics (PS, AUC) it puts it in a vector and z 
%     score those value.
%     @return: the epoch with modify PS and AUC.
%     @epoch (1x1 MATLAB struct) : the output of the epochs function, look
%     bellow for more information.
   
    meanPS = mean([epoch.data{3,:}]);
    meanAUC = mean([epoch.data{4,:}]);
    stdPS = std([epoch.data{3,:}]);
    stdAUC = std([epoch.data{4,:}]);
    
    for i = 1:length(epoch.data)
        epoch.data{3,i} = (epoch.data{3,i} - meanPS) / stdPS;
        epoch.data{4,i} = (epoch.data{4,i} - meanAUC) / stdAUC;
    end
    
    scaledData6 = epoch;
end
