function [params_fit, sine_fit, time_fit] = fitSineWave(dataPoints, initialGuess, timeRange)
    % dataPoints: A Nx2 matrix where column 1 is the y values (stress, etc.)
    %             and column 2 is the x values (time, etc.)
    % initialGuess: Initial guess for the parameters [Amplitude, Frequency, Phase, Offset]
    % timeRange: Time range for generating the fitted sine wave (e.g., [minTime, maxTime])
    

    % Define the sine wave function
    sine_wave = @(params, t) params(1) * sin(params(2) * t + params(3)) + params(4);

    % Fit the sine wave to the data using lsqcurvefit
    options = optimset('Display', 'off');
    params_fit = lsqcurvefit(sine_wave, initialGuess, dataPoints(:,2), dataPoints(:,1), [], [], options);

    % Generate fitted sine wave for plotting
    time_fit = linspace(timeRange(1), timeRange(2), 1000);
    sine_fit = sine_wave(params_fit, time_fit);
end
