% Fourier reconstruction and RLC harmonic filtering.
% Circuit Theory coursework, Spring 2026, recovered from finalpart12.m.
% Student-specific Fourier coefficients and RLC response study.
% Fourier summation/plotting approach follows Jens Munk's UAA
% Fseries_ex2.m teaching example. This is a course-derived study.
% Exact submission/assessment context was not recovered.

clear; clc; close all;

% Given data
Vm = 100;
T  = 2*pi*1e-3;
w0 = 2*pi/T;          % 1000 rad/s
wr = 3*w0;            % center at 3rd harmonic

% Chosen filter values
L = 0.10;
C = 1/(wr^2 * L);

% Time vector
t = linspace(-T, T, 4000);

% Fourier coefficients
N = 80;
n = -N:N;
cn = zeros(size(n));

for k = 1:length(n)
    nn = n(k);
    if nn ~= 0
        cn(k) = -1j*(4*Vm/(pi^2*nn^2)) * ...
                (2*sin(nn*pi/4) - sin(nn*pi/2));
    else
        cn(k) = 0;
    end
end

% Reconstruct original signal
v = zeros(size(t));
for k = 1:length(n)
    v = v + cn(k)*exp(1j*n(k)*w0*t);
end
v = real(v);

figure;
plot(t*1e3, v, 'LineWidth', 1.5);
grid on;
xlabel('t (ms)');
ylabel('v(t) (V)');
title('Original waveform reconstructed from Fourier series');

% Output plots for different Q
Qlist = [2 10 100];

figure;
for qIndex = 1:length(Qlist)
    Q = Qlist(qIndex);

    H = zeros(size(n));
    for k = 1:length(n)
        nn = n(k);
        if nn ~= 0
            H(k) = 1 / (1 + 1j*Q*(nn/3 - 3/nn));
        else
            H(k) = 0;
        end
    end

    vo = zeros(size(t));
    for k = 1:length(n)
        vo = vo + cn(k)*H(k)*exp(1j*n(k)*w0*t);
    end
    vo = real(vo);

    subplot(3,1,qIndex);
    plot(t*1e3, vo, 'LineWidth', 1.5);
    grid on;
    xlabel('t (ms)');
    ylabel('v_o(t) (V)');
    title(['Output for Q = ', num2str(Q)]);
end
