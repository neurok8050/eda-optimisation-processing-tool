% Author : Claudéric DeRoy
% Last date of modification : 17/07/2024
% Goal : compute metrics, might be different if you want to compute
% different metrics or compute PS and AUC differently


function [PSs, AUCs] = metrics(SOIs, baselines)
%     This function calculates the metrics of the epochs and store those
%     values in the epoch pass as an argument.
%     @return: the function will modify the epoch pass as en argument by
%     adding the values calculated for each epochs.
%     @epoch (1x1 MATLAB struct) : the output of the epochs function, look
%     above for more information.
%     
%     PS
%     The PS is calculated by substracting the minimum value from the baseline
%     of an epoch to the maximum value of the SOI of an epoch. This is how PS
%     is calculated in Privratsky et al. 2020
% 
%     AUC
%     from the article (Bach et al., 2010) the AUC is calculated like in the
%     pspm_sf_auc.m function from : 
%     https://github.com/bachlab/PsPM/blob/develop/src/pspm_sf_auc.m

    PSs = [];
    AUCs = [];
    for i = 1:length(SOIs)
        minimum = min(baselines{i});
        maximum = max(SOIs{i});
        minAUC = min(SOIs{i});

        ps = maximum - minimum;

        auc = SOIs{i} - minAUC; 
        auc = mean(auc);

       PSs = [PSs; ps];
       AUCs = [AUCs; auc];
    end
end
