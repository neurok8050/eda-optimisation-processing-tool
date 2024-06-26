% Author : Claudéric DeRoy
% Last date of modification : 26/06/2024

function signalPM2 = signalPM2(signal, samplingRate, butterOrder, cutoffFrequency, ...
    newSamplingRate)
%     This is the second processing method from Privratsky et al. 2020. It
%     does a median filter, a lowpass filter and finally downsample the
%     signal to 10 Hz.
%     @return: the signal filter and downsampled at 10 Hz.
%     @signal ([int array]): the signal values
%     @samplingRate (int): sampling rate of your original signal
%     @butterOrder (int): the order of the Butterwoth lowpass filter
%     @cutoffFrequency (int): the cutoff frequency of your lowpass filter 
%     @newSamplingRate (int): the new sampling rate
    
%     0.1 = 5/(100/2) => cutoff/(samplingRate/2) example with 5% cutoff
    cutoff = cutoffFrequency/(samplingRate/2);
    
    [b,a] = butter(butterOrder, cutoff, "low"); 
    xLowPass = filtfilt(b, a, signal);

%     calculate the correlation between the old signal and the filter
%     signal
%     rho = corr(x.data{1,2}.data, xMedianFilter); 
%     
%     downsampling here
    signalPM2 = resample(xLowPass, newSamplingRate, samplingRate);
%     uncomment to plot original signal and filtered signal
%     figure();plot(signalPM2);title("signal plot after PM2")
end