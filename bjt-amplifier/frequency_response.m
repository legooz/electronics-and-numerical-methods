% EE A333L, Spring 2026. Final design by Lars Goozen and Destiny DeLara.
% Assignment and lab instruction: Todd Petersen, UAA.
% Recovered from final_lab_freq_tes.m. No transistor parasitic capacitances.

clear; clc; close all;

%% Constants
VCC  = 12;
VBE  = 0.7;
VT   = 0.026;
beta = 100;

%% Chosen resistor values (all standard lab values)
RB1 = 180e3;   % from VCC to base of Q1
RB2 = 22e3;    % from base of Q1 to ground
RC1 = 10e3;    % collector resistor of Q1
RE1 = 1e3;     % emitter resistor of Q1, bypassed by Ce
RE2 = 1.2e3;     % emitter resistor of Q2

%% Capacitors (all fixed at 1 uF)
Cin  = 1e-6;   % input coupling capacitor
Ce   = 1e-6;   % emitter bypass capacitor
Cout = 1e-6;   % output coupling capacitor

%% Source and load assumptions
Rs = 50;       % function generator source resistance
RL = 10e3;     % load resistance

%% ---------------- DC bias calculations ----------------
VB1 = VCC * RB2 / (RB1 + RB2);
VE1 = VB1 - VBE;
IE1 = VE1 / RE1;
IC1 = IE1;     % approximation

VC1 = VCC - IC1 * RC1;

VB2 = VC1;
VE2 = VB2 - VBE;
IE2 = VE2 / RE2;
IC2 = IE2;     % approximation

%% ---------------- Small-signal parameters ----------------
gm1  = IC1 / VT;
rpi1 = beta / gm1;
re1  = VT / IE1;

gm2  = IC2 / VT;
rpi2 = beta / gm2;
re2  = VT / IE2;

%% ---------------- Midband estimates ----------------
Rbias = 1 / (1/RB1 + 1/RB2);
Rin_mid = 1 / (1/Rbias + 1/rpi1);

Av1_mid = -gm1 * RC1;                           % CE stage, ideal bypassed
Av2_mid = (gm2 * RE2) / (1 + gm2 * RE2);       % emitter follower approx
Av_mid  = Av1_mid * Av2_mid;
Av_mid_dB = 20 * log10(abs(Av_mid));

Rout_mid = 1 / (1/RE2 + 1/(re2 + RC1/(beta+1)));

I_divider = VCC / (RB1 + RB2);
I_total = IC1 + IC2 + I_divider;

%% ---------------- Frequency sweep model ----------------
f = logspace(1, 6, 2000);   % 10 Hz to 1 MHz
w = 2*pi*f;
j = 1i;

Vout_over_Vs = zeros(size(f));
Rin_f = zeros(size(f));

for k = 1:length(f)

    % Capacitor impedances
    Zcin  = 1 / (j*w(k)*Cin);
    Zce   = 1 / (j*w(k)*Ce);
    Zcout = 1 / (j*w(k)*Cout);

    % Q1 emitter impedance: RE1 || Ce
    ZE1 = 1 / (1/RE1 + 1/Zce);

    % Input resistance looking into base of Q1
    Rin_base = rpi1 + (beta + 1) * ZE1;
    Rin_amp  = 1 / (1/Rbias + 1/Rin_base);
    Rin_f(k) = abs(Rin_amp);

    % Input division from source through Cin
    Vin_over_Vs = Rin_amp / (Rs + Zcin + Rin_amp);

    % CE stage gain with finite emitter bypass
    Av1 = -(beta * RC1) / (rpi1 + (beta + 1) * ZE1);

    % Output network of emitter follower
    Zload_from_emitter = Zcout + RL;
    ZE2_total = 1 / (1/RE2 + 1/Zload_from_emitter);

    % Emitter follower gain
    Av2 = ((beta + 1) * ZE2_total) / (rpi2 + (beta + 1) * ZE2_total);

    % Total gain from source to load
    Vout_over_Vs(k) = Vin_over_Vs * Av1 * Av2 * (RL / (Zcout + RL));
end

Av_mag = abs(Vout_over_Vs);
Av_dB  = 20 * log10(Av_mag);

%% ---------------- Frequency metrics ----------------
[maxGain_dB, idxMax] = max(Av_dB);
target_dB = maxGain_dB - 3;

idxLow = find(Av_dB(1:idxMax) <= target_dB, 1, 'last');
if isempty(idxLow)
    fL = NaN;
else
    fL = f(idxLow);
end

% Gain at specific frequencies
freq_check = [100 1e3 10e3 20e3 50e3];
gain_check = zeros(size(freq_check));

for n = 1:length(freq_check)
    [~, idx] = min(abs(f - freq_check(n)));
    gain_check(n) = Av_dB(idx);
end

%% ---------------- Results ----------------
fprintf('Q1 bias:\n');
fprintf('VB1 = %.3f V\n', VB1);
fprintf('VE1 = %.3f V\n', VE1);
fprintf('IC1 = %.3f mA\n', IC1*1e3);
fprintf('VC1 = %.3f V\n\n', VC1);

fprintf('Q2 bias:\n');
fprintf('VB2 = %.3f V\n', VB2);
fprintf('VE2 = %.3f V\n', VE2);
fprintf('IC2 = %.3f mA\n\n', IC2*1e3);

fprintf('Midband estimates:\n');
fprintf('Rin(midband approx)   = %.1f ohms\n', Rin_mid);
fprintf('Rout(midband approx)  = %.1f ohms\n', Rout_mid);
fprintf('Av(midband approx)    = %.1f V/V\n', Av_mid);
fprintf('Av_dB(midband approx) = %.2f dB\n', Av_mid_dB);
fprintf('Total current draw    = %.3f mA\n\n', I_total*1e3);

fprintf('Frequency-response estimates:\n');
fprintf('Maximum gain          = %.2f dB\n', maxGain_dB);
if isnan(fL)
    fprintf('Estimated fL (-3 dB)  = not found in sweep range\n');
else
    fprintf('Estimated fL (-3 dB)  = %.1f Hz\n', fL);
end
fprintf('\nGain at check frequencies:\n');
for n = 1:length(freq_check)
    fprintf('%8.0f Hz : %6.2f dB\n', freq_check(n), gain_check(n));
end

%% ---------------- Requirement checks ----------------
fprintf('\nRequirement checks:\n');
fprintf('Gain > 45 dB?        %s\n', ternary(maxGain_dB > 45, 'YES', 'NO'));
fprintf('Rin > 2k ohm?        %s\n', ternary(Rin_mid > 2000, 'YES', 'NO'));
fprintf('Rout < 100 ohm?      %s\n', ternary(Rout_mid < 100, 'YES', 'NO'));
fprintf('Total current < 10mA %s\n', ternary(I_total < 10e-3, 'YES', 'NO'));

%% ---------------- Plots ----------------
figure;
semilogx(f, Av_dB, 'LineWidth', 1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('Gain (dB)');
title('Approximate Frequency Response |Vout/Vs|');

figure;
semilogx(f, Rin_f, 'LineWidth', 1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('Input Resistance (Ohms)');
title('Approximate Input Resistance vs Frequency');

%% ---------------- Local helper function ----------------
function out = ternary(cond, a, b)
    if cond
        out = a;
    else
        out = b;
    end
end
