% Schmitt-trigger switching-threshold and hysteresis sweeps.
% EE A333L, Spring 2026. Lab work by Lars Goozen and Destiny DeLara.
% Threshold equations and circuit assignment: Todd Petersen, UAA.
% Recovered from lab2.m; model body retained, sampling comment corrected.

clear; clc; close all;

% Recovered sampling: 20 points spanning two decades from 0.1 to 10
a = logspace(-1, 1, 20);   % 0.1 -> 10, 20 points

%% Inverting ST (given equations)
Vdc = 12;
VinH_inv = Vdc .* (1 + a) ./ (1 + 2*a);
VinL_inv = Vdc .* a       ./ (1 + 2*a);

dVin_inv   = VinH_inv - VinL_inv;          % = Vdc./(1+2*a), decreasing
Vinave_inv = 0.5*(VinH_inv + VinL_inv);    % = Vdc/2 (constant)

%% Non-inverting ST (Vref=2.5, VoutH=5)
Vref  = 2.5;
VoutH = 5;

VinH_non = (1 + a).*Vref;
VinL_non = (1 + a).*Vref - a.*VoutH;

dVin_non   = VinH_non - VinL_non;          % = a*VoutH = 5a, linear in a
Vinave_non = 0.5*(VinH_non + VinL_non);

%% Hysteresis width versus resistor ratio (logarithmic x-axis)
figure;
semilogx(a, dVin_inv, 'LineWidth', 2); hold on;
semilogx(a, dVin_non, 'LineWidth', 2);
grid on;
xlabel('a (log scale)');
ylabel('\DeltaV_{in} = V_{inH} - V_{inL} (V)');
legend('Inverting ST','Non-inverting ST','Location','best');
title('\DeltaV_{in} vs a');

%% Switching midpoint versus resistor ratio (logarithmic x-axis)
figure;
semilogx(a, Vinave_inv, 'LineWidth', 2); hold on;
semilogx(a, Vinave_non, 'LineWidth', 2);
grid on;
xlabel('a (log scale)');
ylabel('V_{in,ave} = (V_{inH}+V_{inL})/2 (V)');
legend('Inverting ST','Non-inverting ST','Location','best');
title('V_{in,ave} vs a');

%% Extra check: linear-axis plot to confirm non-inverting linearity
figure;
plot(a, dVin_non, 'o-', 'LineWidth', 2);
grid on;
xlabel('a');
ylabel('\DeltaV_{in,non} (V)');
title('Non-inverting \DeltaV_{in} on linear axes (linear check)');

%% Non-inverting ST: sweep Vref from 0 to 5 V, with a fixed at 1
a_fix  = 1;
VoutH  = 5;
Vref_sweep = linspace(0, 5, 200);

VinH_non_vref = (1 + a_fix).*Vref_sweep;
VinL_non_vref = (1 + a_fix).*Vref_sweep - a_fix.*VoutH;

dVin_non_vref   = VinH_non_vref - VinL_non_vref;
Vinave_non_vref = 0.5*(VinH_non_vref + VinL_non_vref);

%% Plot ΔVin vs Vref
figure;
plot(Vref_sweep, dVin_non_vref, 'LineWidth', 2);
grid on;
xlabel('V_{ref} (V)');
ylabel('\DeltaV_{in} = V_{inH}-V_{inL} (V)');
title('Non-inverting ST: \DeltaV_{in} vs V_{ref} (a=1)');

%% Plot Vin,ave vs Vref
figure;
plot(Vref_sweep, Vinave_non_vref, 'LineWidth', 2);
grid on;
xlabel('V_{ref} (V)');
ylabel('V_{in,ave} = (V_{inH}+V_{inL})/2 (V)');
title('Non-inverting ST: V_{in,ave} vs V_{ref} (a=1)');
