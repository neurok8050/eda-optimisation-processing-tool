% Author : Claudéric DeRoy
% Last date of modification : 26/06/2024

function signalPM1 = signalPM1(newSampleRate, oldSampleRate, signal)
%     This is the first processing method from Privratsky et al. 2020. It
%     only do a downsamlping to 10 Hz.
%     @return: the signal downsampled at 10 Hz.
%     @newSampleRate (int): the new sample rate you want
%     @oldSampleRate (int): the old sampling rate your signal had
%     @signal ([int array]): signal you wish to resample

    signalPM1 = resample(signal, newSampleRate, oldSampleRate);
    
%     uncomment to plot filtered signal
%     figure();plot(signalPM1);title("signal graphic after PM1");

%     Theses lines plots the original signal with new sampled signal       
    vector_raw = 0:(1/oldSampleRate):...
        ((size(signal)/oldSampleRate)-(1/oldSampleRate));
    vector_resampled = 0:(1/newSampleRate):((size(signalPM1))/...
        newSampleRate)-(1/newSampleRate);

    
%     figure();
%     plot(vector_raw, signal, '-b', vector_resampled, signalPM1, '-r');
%     legend('original', 'resampled');
%     title("plot of the original signal and the downsampled signal"); 
end
