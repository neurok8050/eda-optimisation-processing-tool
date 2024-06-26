% Author : Claudéric DeRoy
% Last date of modification : 26/06/2024

% TODO:
% make it more usable, remove complex data structure, use vector instead
function stat = statistic(epoch, originalNbTrial, artifact, varargin)
%     Function to compute statistics based on computed metrics to save in a
%     file for later statistical analysis
%     @return (table) : a table containing all the computed statistics
%     (1x1 MATLAB struct) : the output of the epochs function, look
%     above for more information.
%     @originalNbTrial (int) : number of trial in total in the experiment
%     @artifact (string) : if you need to compute statistic from data which used 
%     the artifact removal tool, the parameter should be "artifact", anything 
%     string otherwise
    
    
    nbRmAver = varargin{1};
    nbRmNeut = varargin{2};
    nbRmUnint = varargin{3};
    neutralPS = [];
    aversivePS = [];
    uninterestPS = [];
    neutralAUC = [];
    aversiveAUC = [];
    uninterestAUC = [];
    
    for i = 1:length(epoch.data)
        if epoch.data{5,i} == 0 % neutral trials
            neutralPS = [neutralPS; epoch.data{3,i}];
            neutralAUC = [neutralAUC; epoch.data{4,i}];
        elseif epoch.data{5,i} == 1 % aversive trials
            aversivePS = [aversivePS; epoch.data{3,i}];
            aversiveAUC = [aversiveAUC; epoch.data{4,i}];
        elseif epoch.data{5,i} == 2 % uninteresting trials
            uninterestPS = [uninterestPS; epoch.data{3,i}];
            uninterestAUC = [uninterestAUC; epoch.data{4,i}];
        end
    end
   
    meanNeutPS = mean(neutralPS);
    meanAverPS = mean(aversivePS);
    meanUnintPS = mean(uninterestPS);
    
    meanNeutAUC = mean(neutralAUC);
    meanAverAUC = mean(aversiveAUC);
    meanUnintAUC = mean(uninterestAUC);
    
    if artifact == "artifact"
        meanNeutPS_artifact = meanNeutPS;
        meanAverPS_artifact = meanAverPS;
        meanUnintPS_artifact = meanUnintPS;
        meanNeutAUC_artifact = meanNeutAUC;
        meanAverAUC_artifact = meanAverAUC;
        meanUnintAUC_artifact = meanUnintAUC;
        originalNbTrial_artifact = originalNbTrial;
        nbRmAver_artifact = nbRmAver;
        nbRmNeut_artifact = nbRmNeut;
        nbRmUnint_artifact = nbRmUnint;
        
        clear('meanNeutPS', 'meanAverPS', 'meanUnintPS', 'meanNeutAUC', ...
            'meanAverAUC', 'meanUnintAUC', 'originalNbTrial', 'nbRmAver', ...
            'nbRmNeut', 'nbRmUnint');
        stat = table(meanNeutPS_artifact, meanAverPS_artifact, ...
            meanUnintPS_artifact, meanNeutAUC_artifact, meanAverAUC_artifact,...
            meanUnintAUC_artifact, originalNbTrial_artifact, ...
            nbRmAver_artifact, nbRmNeut_artifact, nbRmUnint_artifact);
    else
        nbRmAver = NaN;
        nbRmNeut = NaN;
        nbRmUnint = NaN;
        stat = table(meanNeutPS, meanAverPS, meanUnintPS, meanNeutAUC, ...
            meanAverAUC, meanUnintAUC, originalNbTrial, nbRmAver, nbRmNeut, ...
            nbRmUnint);
    end
end