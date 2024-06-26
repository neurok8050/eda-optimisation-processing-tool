% Author : Claudéric DeRoy
% Last date of modification : 26/06/2024

% TODO:
% make it more usable, remove complex data structure and use vector instead
function [signal, trig, origNbTrig, removedAver, removedNeut, removedUnint] =...
    motionArtifactRemoval(timeStamp, artifactCSV, trigger, preTime, postTime,...
    artifactEpochWindow, dataset)
%     the function reads the .csv output from the Taylor et al., 2015
%     motion artifact detection algorythm and remove all timeStamp from the
%     Bach signal data so that the epoch isn't taken for the analysis.
%     @return the new timeStamp list with the artifact timeStamp remove
%     (signal) and the new triggers file with removed epoch corresponding
%     to those with motion artifact
%     @timeStamp : [int] the corresponding signal.data{2,1}.data which is
%     the list of all the time stamp of the trigger from the experiement
%     @artifactCSV : (string) the path to the file created by a python
%     function that put all the time marker in second of the epoch
%     containing a motion artifact.
    removedAver = 0;
    removedNeut = 0;
    removedUnint = 0;
    origNbTrig = length(trigger.data);
    listArtifact = csvread(artifactCSV);

    len = length(timeStamp);
%     I use a while for a dynamic for loop because I am removing item for
%     the timeStamp list
    for i = 1:length(listArtifact)
        j = 1;
        while j <= len
%             the super complicated logic to make sure that any epoch
%             containing an motion artifact even if the artifact is during
%             half the time of the epoch
            if ((((timeStamp(j) - preTime) >= (listArtifact(i))) ...
                    & ((timeStamp(j) - preTime) <= (listArtifact(i) + ...
                    artifactEpochWindow))) ...
                    | (((timeStamp(j) + postTime) >= (listArtifact(i))) ...
                    & ((timeStamp(j) + postTime) <= (listArtifact(i) + ...
                    artifactEpochWindow))))
                
                if dataset == "HRA"
                    if trigger.data(j,2) == 2 && trigger.data(j,3) == 0
                        removedAver = removedAver + 1;
                        
                    elseif trigger.data(j,2) == 1
                        removedNeut = removedNeut + 1;
                    else
                        removedUnint = removedUnint + 1;
                    end
                elseif dataset == "SCRV_1"
                    if trigger.data(j, 7) == 0
                        removedAver = removedAver + 1;
                    elseif trigger.data(j,7) == 1
                        removedNeut = removedNeut + 1;
                    else
                        removedUnint = removedUnint + 1;
                    end
                elseif dataset == "SCRV_4"
                    if trigger.data(j,2) == 2 && trigger.data(j,5) == 0
                        removedAver = removedAver + 1;
                    elseif trigger.data(j,2) == 1
                        removedNeut = removedNeut + 1;
                    else
                        removedUnint = removedUnint + 1;
                    end
                end

                
                timeStamp(j) = []; % remove the timeStamp from the timeStamp 
                % list
               
                trigger.data(j,:) = []; % remove the corresponding epoch 
                % information for the triggers file
                
                j = j - 1;
                
                len = len - 1; % reduce the length of the while by one to keep 
                % track of the new length of the timeStamp list
                
            end
            j = j + 1;
        end
    end
    signal = timeStamp; 
    trig = trigger;
end
