clear ; clc ; close ;

% Define time vector
t = linspace(0, 10, 1000);

% Parameters [amplitude, angular frequency, phase, offset, decay constant]
params = [1, 2*pi, 0, 0, 0.1]; 

% Define the decaying sinusoidal model function
decaying_sinusoidal_model = @(b, x) b(1) * sin(b(2) * x + b(3)) .* exp(-b(5) * x) + b(4);

% Calculate the model output
y = decaying_sinusoidal_model(params, t);

% Plot the model
figure;
plot(t, y);
xlabel('Time');
ylabel('Amplitude');
title('Decaying Sinusoidal Model');
grid on;