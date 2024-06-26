% Author : Claudéric DeRoy
% Last date of modification : 26/06/2024

function scaledData3 = scalingMaxValue(data, varargin)
%     The third rescalling method from Privratsky et al. 2020. It divide
%     the entire signal by his maximum value.
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
        maximum = max(scaledData);
        
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
%        mean and std of the signal without the points contained in
%        artifact epochs
       maximum = max(scaledData);
    end
        


    for i = 1:length(data)
        data(i) = data(i) / maximum;
    end

    scaledData3 = data;
%     uncomment to plot rescaled signal
%     figure();
%     plot(scaledData3);title("continuous data scaled by maximum recorded value")
end
