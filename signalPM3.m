% Author : Claudéric DeRoy
% Last date of modification : 26/06/2024

function signalPM3 = signalPM3(signal, lowCutoffFrequency, highCutoffFrequency, ...
    butterOrder, samplingRate, newSamplingRate)
%     This is the third processing method from Privratsky et al. 2020. It
%     does a median filter, a lowpass filter, a highpass filter and finally
%     downsample the signal to 10 Hz. We did not implemented the median
%     because it was use to filter artifact due to fMRI. We did not use
%     fMRI so we took out the median filter.
%     @return: the signal filtered and downsampled at 10 Hz.
%     @signal ([int array]): the signal values
%     @samplingRate (int): sampling rate of your original signal
%     @butterOrder (int): the order of the Butterwoth lowpass filter
%     @lowCutoffFrequency (int): the cutoff frequency of your lowpass filter 
%     @highCutoffFrequency (int): the cutoff frequency of your highpass filter
%     @newSamplingRate (int):the new sampling rate

    lowCutoff = lowCutoffFrequency/(samplingRate/2);
    [b,a] = butter(butterOrder, lowCutoff, "low");
    xLowPass = filtfilt(b, a, signal);

    highCutoff = highCutoffFrequency/(samplingRate/2);
    [b,a] = butter(butterOrder, highCutoff, "high");
    xHighPass = filtfilt(b,a, xLowPass);

%     downsampling
    signalPM3 = resample(xHighPass, newSamplingRate, samplingRate);
%     uncomment to plot the original signal and the filtered signal
%     figure();plot(signalPM3);title("signal plot after PM3");
end