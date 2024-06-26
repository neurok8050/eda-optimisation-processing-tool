% Author : Claudéric DeRoy
% Last date of modification : 26/06/2024

function plotSignalEvents(signal, events, srSignal, srEvents)
    % simple function to plot signal and it's events
    % @signal ([int array]): variable containing the values of the signal
    % @events ([int array]): variable containing the values of the events
    % @srSignal (int): sampling rate of the signal
    % @srEvents (int): sampling rate of the events
    
    rsEvents = (events * srSignal) / srEvents;
    
    figure();
    plot(signal);
    for i = 1:length(events)
        pl = line([rsEvents(i) rsEvents(i)], [0 signal(round(rsEvents(i)))]);
        pl.Color = "Red";
        pl.set("Marker", "o");
    end
end
