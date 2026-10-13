% EE A333L, Spring 2026. Final design by Lars Goozen and Destiny DeLara.
% Assignment and lab instruction: Todd Petersen, UAA.
% Recovered from final_lab.m; approximate unloaded bias/small-signal model.

clear; clc;

VCC  = 12;
VBE  = 0.7;
VT   = 0.026;
beta = 100;

RB1 = 180e3;  
RB2 = 22e3;    
RC1 = 10e3;
RE1 = 1.0e3;   
RE2 = 1.2e3;

VB1 = VCC * RB2 / (RB1 + RB2);
VE1 = VB1 - VBE;
IE1 = VE1 / RE1;
IC1 = IE1;    

VC1 = VCC - IC1 * RC1;

gm1   = IC1 / VT;
rpi1  = beta / gm1;
re1   = VT / IE1;

Rbias = 1 / (1/RB1 + 1/RB2);
Rin   = 1 / (1/Rbias + 1/rpi1);

VB2 = VC1;
VE2 = VB2 - VBE;
IE2 = VE2 / RE2;
IC2 = IE2;    

gm2  = IC2 / VT;
rpi2 = beta / gm2;
re2  = VT / IE2;

Av1 = -gm1 * RC1;     
Av2 = (gm2*RE2) / (1 + gm2*RE2);  
Av_total = Av1 * Av2;
Av_dB = 20*log10(abs(Av_total));


Rout = 1 / (1/RE2 + 1/(re2 + RC1/(beta+1)));

I_divider = VCC / (RB1 + RB2);
I_total = IC1 + IC2 + I_divider;

%% Results
fprintf('Q1 bias:\n');
fprintf('VB1 = %.3f V\n', VB1);
fprintf('VE1 = %.3f V\n', VE1);
fprintf('IC1 = %.3f mA\n', IC1*1e3);
fprintf('VC1 = %.3f V\n\n', VC1);

fprintf('Q2 bias:\n');
fprintf('VB2 = %.3f V\n', VB2);
fprintf('VE2 = %.3f V\n', VE2);
fprintf('IC2 = %.3f mA\n\n', IC2*1e3);

fprintf('Performance estimates:\n');
fprintf('Rin   = %.1f ohms\n', Rin);
fprintf('Rout  = %.1f ohms\n', Rout);
fprintf('Av    = %.1f V/V\n', Av_total);
fprintf('Av_dB = %.2f dB\n', Av_dB);
fprintf('Total current draw = %.3f mA\n', I_total*1e3);
