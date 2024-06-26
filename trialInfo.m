% Author : Claudéric DeRoy
% Last date of modification : 26/04/2024
% Goal : this is an example of a function that you might have to code to
% get trial information about an experiment (i.e. number of aversive trial,
% number of neutral trial, etc.) it really depends on your experiment

% TODO:
% make it more usable, remove complex data structure, use vector instead
function trialInformation = trialInfo(trigger, experiment)
%     small function to get the information about the trial from experiment
%     data. Number of trial, number of CS+ and CS- trials and the number of
%     CS+ with US and CS+ without US trials. If your trigger data is
%     different than the _cogent_.mat file from Bach you might have to
%     lightly or heavlily modify this function. This function is useful for 
%     either the PsPM-HRA 1, PsPM-SCRV 4 or the PsPM-SCRV 1 you can modify it or
%     ignore it.
%     @return : an array with the number of total trial, CS+, CS-, CS+ with US
%     and CS+ without US.
%     @trigger (1x1 MATLAB struct): the structure the of the
%     _cogent_.mat file from the open source dataset from Bach
%     @experimenet (string): the name of the dataset you are using in this
%     function there is three possibility : "HRA_1", "SCRV_4" or "SCRV_1".
    
    CSP_NUS = [2 0]; % trial pattern for either HRA_1 or SCRV_4
    CSN_NUS = [1 0]; % idem
    CSP_PUS = [2 1]; % idem
    count = 0;
    countCSP = 0;
    countCSN = 0;
    countCSPYesUS = 0;
    countCSPNoUS = 0;
    for i = 1:length(trigger.data(:,2))
        if or(experiment == "HRA_1", experiment == "SCRV_4")
            cs = trigger.data(i,2); % for HRA_1
            if(experiment == "HRA_1")
                us = trigger.data(i,3); % for HRA_1
                
            elseif(experiment == "SCRV_4")
                us = trigger.data(i,5); % for SCRV_4
            end
            trial = [cs us]; % trial pattern for HRA_1 or SCRV_4 
        
            if(trial == CSP_NUS | trial == CSN_NUS | trial == CSP_PUS)
                count = count + 1;
            end

%             if statement that calculated the amount of CS+ and CS- in an
%             experiment HRA_1 and SCRV_4, comment if you check for SCRV_1
            if(cs == 2)
                countCSP = countCSP + 1;
            
                if(us == 1)
                    countCSPYesUS = countCSPYesUS + 1;
                
                elseif(us == 0)
                    countCSPNoUS = countCSPNoUS + 1;
                end

            elseif(cs == 1)
                countCSN = countCSN + 1;
            end
            
        elseif(experiment == "SCRV_1")
            count = count + 1;
            us = trigger.data(i,7);
            
            if(us == 0)
                countCSPYesUS = countCSPYesUS + 1;
                
            elseif(us == 1)
                countCSPNoUS = countCSPNoUS + 1;
            end
            
        end
    end
    trialInformation = [count countCSP countCSN countCSPYesUS countCSPNoUS];
end