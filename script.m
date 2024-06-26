% Author : Claudéric DeRoy
% Last date of modification : 26/06/2024
% Goal : this is a script I wrote for my three different anakysis on HRA-1,
% SCRV-1 and SCRV-4 dataset

% TODO:
% make it more usable, more for redundant code and simplify it
results = [];
epochs_results = [];
for i = 1:7
    mr = [3.5, 4, 4.5, 5];
    for j = 1:length(mr)
        pm = 3;
        dataset = "SCRV_4"; % change for the name of dataset 
        high_cutoff = 0.1;

        [stats,epochs_final] = preprocessing(pm, i, 1, mr(j), dataset, high_cutoff);
        
        [aic_PS_artifact, t_PS_artifact, df_PS_artifact] = ...
            pspm_predval([stats{:,2}, stats{:,1}]);

        [aic_PS, t_PS, df_PS] = ...
            pspm_predval([stats{:,12}, stats{:,11}]);

        [aic_AUC_artifact, t_AUC_artifact, df_AUC_artifact] = ...
            pspm_predval([stats{:,5}, stats{:,4}]);

        [aic_AUC, t_AUC, df_AUC] = ...
            pspm_predval([stats{:,15}, stats{:,14}]);
        
        if isnan(high_cutoff)
            method = "PM"+pm+"_rsm"+i+"_mr"+mr(j);
            method = replace(method, ".", "_");
        else
            method = "PM"+pm+"_"+high_cutoff+"_rsm"+i+"_mr"+mr(j);
            method = replace(method, ".", "_");
        end
        
        rescaling = i;
        max_range = mr(j);
        result = table(method, rescaling, max_range, aic_PS_artifact, ...
            aic_PS, aic_AUC_artifact, aic_AUC);

        results = [results; result];
        
        epochs_results = [epochs_results; epochs_final];
        
    end
end

path = "/home/clauderic/Maîtrise Psychologie/PsPM-SCRV_4 dataset/stats/PM3_0_1/";
fileName = path+"results_"+dataset+"_"+extractBefore(method, "_rsm")+".csv";
writetable(results, fileName);

function [results, epoch_result] = preprocessing(filter, rescaling, preTime, postTime, dataset, varargin)

    if length(varargin) >= 1
        cutoff = varargin{1};
    else
        cutoff = NaN;
    end
    
    if dataset == "HRA_1"
        signal = dir(fullfile("/home/clauderic/Maîtrise Psychologie/PsPM-HRA_1 dataset/Data/HRA_1_spike*.mat"));
        trigger = dir(fullfile("/home/clauderic/Maîtrise Psychologie/PsPM-HRA_1 dataset/Data/HRA_1_cogent*.mat"));
        artifact = dir(fullfile("/home/clauderic/Maîtrise Psychologie/PsPM-HRA_1 dataset/Data/*artifactTimeMarker*.csv"));

    elseif dataset == "SCRV_1"
        signal = dir(fullfile("/home/clauderic/Maîtrise Psychologie/PsPM-SCRV_1 dataset/Data/SCRV_1_spike*.mat"));
        trigger = dir(fullfile("/home/clauderic/Maîtrise Psychologie/PsPM-SCRV_1 dataset/Data/SCRV_1_cogent*.mat"));
        artifact = dir(fullfile("/home/clauderic/Maîtrise Psychologie/PsPM-SCRV_1 dataset/Data/*artifactTimeMarker*.csv"));
    
    elseif dataset == "SCRV_4"
        signal = dir(fullfile("/home/clauderic/Maîtrise Psychologie/PsPM-SCRV_4 dataset/Data/SCRV_4_spike*.mat"));
        trigger = dir(fullfile("/home/clauderic/Maîtrise Psychologie/PsPM-SCRV_4 dataset/Data/SCRV_4_cogent*.mat"));
        artifact = dir(fullfile("/home/clauderic/Maîtrise Psychologie/PsPM-SCRV_4 dataset/Data/*artifactTimeMarker*.csv"));

    end
    
    statistics = [];
    epoch_results = [];

    % for loop to automate the preprocessing
    for i = 1:length(signal)

        signals = load(strcat(signal(i).folder, strcat("/", signal(i).name)));
        triggers = load(strcat(trigger(i).folder, strcat("/", trigger(i).name)));
        artifacts = load(strcat(artifact(i).folder, strcat("/", artifact(i).name)));
       

        signalFileName = strcat(signal(i).folder, strcat("/", signal(i).name));
        triggerFileName = strcat(trigger(i).folder, strcat("/", trigger(i).name));
        artifactFileName = strcat(artifact(i).folder,strcat("/", artifact(i).name));
        
        % plot the events
%         plotSignalEvents(signals.data{1,1}.data, signals.data{2,1}.data, 100, 1);

        % Filtering
        if filter == 1
            filtered = PM1(10, 100, signals.data{1,1}.data);
        elseif filter == 2
            filtered = PM2(signals.data{1,1}.data, 100, 1, 5, 10);
        elseif filter == 3
            filtered = PM3(signals.data{1,1}.data, 5, cutoff, 1, 100, 10);
        end

        % Motion artifact removal
        signalsArtifact = signals;
        
        if dataset == "HRA_1"
            [signalsArtifact.data{2,1}.data, triggersArtifact, origNbTrial, ...
                rmAver, rmNeut, rmUnint] = ...
            motionArtifactRemoval(signalsArtifact.data{2,1}.data, ...
            artifactFileName, triggers, preTime, postTime, 5, "HRA");
        
        elseif dataset == "SCRV_1"
            [signalsArtifact.data{2,1}.data, triggersArtifact, origNbTrial, ...
                rmAver, rmNeut, rmUnint] = ...
            motionArtifactRemoval(signalsArtifact.data{2,1}.data, ...
            artifactFileName, triggers, preTime, postTime, 5, "SCRV_1");
        
        elseif dataset == "SCRV_4"
            [signalsArtifact.data{2,1}.data, triggersArtifact, origNbTrial, ...
                rmAver, rmNeut, rmUnint] = ...
            motionArtifactRemoval(signalsArtifact.data{2,1}.data, ...
            artifactFileName, triggers, preTime, postTime, 5, "SCRV_4");
        end

        % Rescaling
        rescaled = 0;

        if rescaling == 1
            % unscaled first rescaling method
            scaledArtifact = filtered;
            scaled = filtered;

        elseif rescaling == 2
            % z-scored continuous data second rescaling method
            scaledArtifact = scalingZScore(filtered, artifactFileName, 10);
            scaled = scalingZScore(filtered);

        elseif rescaling == 3
            % continuous data scaled by maximum recorded value third rescaling
            % method
            scaledArtifact = scalingMaxValue(filtered, artifactFileName, 10);
            scaled = scalingMaxValue(filtered);
        end


        % Epoching
        if rescaling == 1 | rescaling == 2 | rescaling == 3
            epochsArtifact = epoch(signalsArtifact.data{2,1}.data, 10, 2, 0, ...
                preTime, postTime, scaledArtifact);
            epochs = epoch(signals.data{2,1}.data, 10, 2, 0, preTime, ...
                postTime, scaled);
            
        
        elseif rescaling == 4 | rescaling == 5 | rescaling == 6 | rescaling == 7
            epochsArtifact = epoch(signalsArtifact.data{2,1}.data, 10, 2, 0, ...
            preTime, postTime, filtered);
        epochs = epoch(signals.data{2,1}.data, 10, 2, 0, preTime, postTime, ...
            filtered);
        end
        

        % Events markers
        if dataset == "HRA_1"
            epochsArtifact = event_PsPM_HRA_1(triggersArtifact, ...
                epochsArtifact, triggerFileName, "artifact");
            epochs = event_PsPM_HRA_1(triggers, epochs, ...
                triggerFileName, "no artifact");
            
        elseif dataset == "SCRV_1"
            epochsArtifact = event_PsPM_SCRV_1(triggersArtifact, ...
                epochsArtifact, triggerFileName, "artifact");
            epochs = event_PsPM_SCRV_1(triggers, epochs, triggerFileName,...
                "no artifact");
        elseif dataset == "SCRV_4"
            epochsArtifact = event_PsPM_SCRV_4(triggersArtifact, ...
                epochsArtifact, triggerFileName, "artifact");
            epochs = event_PsPM_SCRV_4(triggers, epochs, triggerFileName, ...
                "no artifact");
        end


        % Metrics
        epochsArtifact = metrics(epochsArtifact);
        epochs = metrics(epochs);


        % Rescaling method that use epochs
        if rescaling == 4
            % z-scored mean responses by stimulus fourth rescaling method
            scaledArtifact = scalingZScoreMeanResponse(epochsArtifact);
            scaled = scalingZScoreMeanResponse(epochs);
            rescaled = 4;
            
        elseif rescaling == 5
            % mean responses scaled by the maximum mean response fifth rescaling
            % method
            scaledArtifact = scalingZScoreMeanResponseByMaximum(epochsArtifact);
            scaled = scalingZScoreMeanResponseByMaximum(epochs);
            rescaled = 5;

        elseif rescaling == 6
            % all responses z-scored sixth rescaling method 
            scaledArtifact = scalingZScoreAllResponses(epochsArtifact);
            scaled = scalingZScoreAllResponses(epochs);

        elseif rescaling == 7
            % all responses scaled by maximum seventh rescaling method
            epochsArtifact = scalingZScoreAllResponsesByMax(epochsArtifact);
            epochs = scalingZScoreAllResponsesByMax(epochs);
        end

        epoch_results = [epoch_results; epochs];

        % Statistics
        
        
        % special case if the rescaling method is the fourth or the fifth
        if rescaled == 4 | rescaled == 5

            meanNeutPS_artifact = scaledArtifact(1);
            meanAverPS_artifact = scaledArtifact(2);
            meanUnintPS_artifact = scaledArtifact(3);
            meanNeutAUC_artifact = scaledArtifact(4);
            meanAverAUC_artifact = scaledArtifact(5);
            meanUnintAUC_artifact = scaledArtifact(6);
            originalNbTrial_artifact = origNbTrial;
            nbRmAver_artifact = rmAver;
            nbRmNeut_artifact = rmNeut;
            nbRmUnint_artifact = rmUnint;

            meanNeutPS = scaled(1);
            meanAverPS = scaled(2);
            meanUnintPS = scaled(3);
            meanNeutAUC = scaled(4);
            meanAverAUC = scaled(5);
            meanUnintAUC = scaled(6);
            originalNbTrial = origNbTrial;
            nbRmAver = NaN;
            nbRmNeut = NaN;
            nbRmUnint = NaN;

            stats = table(meanNeutPS_artifact, meanAverPS_artifact, ...
                meanUnintPS_artifact, meanNeutAUC_artifact, meanAverAUC_artifact,...
                meanUnintAUC_artifact, originalNbTrial_artifact, ...
                nbRmAver_artifact, nbRmNeut_artifact, nbRmUnint_artifact, ...
                meanNeutPS, meanAverPS, meanUnintPS, meanNeutAUC, meanAverAUC, ...
                meanUnintAUC, originalNbTrial, nbRmAver, nbRmNeut, nbRmUnint);

            statistics = [statistics; stats];

        % the rest of the rescaling methods
        elseif rescaled == 0
                stats = [statistic(epochsArtifact, origNbTrial, "artifact", ... 
                    rmAver, rmNeut, rmUnint), statistic(epochs, origNbTrial, ...
                    "no artifact", rmAver, rmNeut, rmUnint)];
                statistics = [statistics; stats];
        end
    end
    
    if postTime == 3.5
        postTime = "3_5";
        
    elseif postTime == 4.5
        postTime = "4_5";
        
    end
        
    if ~isnan(cutoff)
        filter = filter + "_" + extractBefore(string(cutoff), ".")+...
            "_"+extractAfter(string(cutoff), ".");
    end
    
    writetable(statistics, extractBefore(signal(1).folder, "/Data")...
        +"/stats/PM"+filter+"/statistics_"+dataset+"_PM"...
        +filter+"_rsm"+rescaling+"_mr"...
        +postTime+".csv");
    
    close all
    
    results = statistics;
    epoch_result = epoch_results;
end