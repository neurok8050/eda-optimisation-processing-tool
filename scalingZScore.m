% Author : Claudéric DeRoy
% Last date of modification : 26/06/2024

function scaledData2 = scalingZScore(data, varargin)
%     This is the second rescalling technic from Privratsky et al. 2020. It
%     transforms the signal with score-z. If you want to use it with the
%     artifact detection algorythm you will need to pass more argument than
%     just data (see @varargin). If you do not use the artifact detection
%     algorythm just pass one argument the @data.
%     @return: the signal transformed.
%     @data ([int array]) : the signal values.
%     @varargin : the first optional argument should be the .csv file
%     containing all the artifact epoch time marker. The second argument
%     should be the sampling rate of the signal you pass as the first
%     argument.
    
    nbArgs = length(varargin);
    scaledData = [];
    
%     the case were no artifact algorythm is used
    if nbArgs == 0
        scaledData = data;
        meanSignal = mean(scaledData);
        sd = std(scaledData);
    
%     the case with the artifact detecetion algorythm
    elseif nbArgs > 0
        artifact = varargin{1};
        listArtifact = csvread(artifact);
        samplingRate = varargin{2};
        
       for i = 1:length(data)
           for j = 1:length(listArtifact)
               buffer = 0;
               if i >= (listArtifact(j) * samplingRate)...
                       & i <= ((listArtifact(j) + 5) * samplingRate)
                   buffer = 0;
               elseif i < (listArtifact(j) * samplingRate)...
                       | i > ((listArtifact(j) + 5) * samplingRate)
                   buffer = data(i);
               end
           end
           if ~(buffer == 0)
               scaledData = [scaledData; buffer];
           end
       end
%      mean and std of the signal without the points contained in artifact 
%      epochs
       meanSignal = mean(scaledData);
       sd = std(scaledData);
    end
    
%     z-score on the original signal
    for k = 1:length(data)
        data(k) = (data(k) - meanSignal) / sd;
    end
    
    scaledData2 = data;
%     uncomment to plot rescaled signal
%     figure();plot(scaledData2);title("z-scored continuous data")
end
