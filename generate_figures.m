function generate_figures
% Portfolio preparation utility added in October 2026.
% Re-runs the recovered scripts and exports reproducible model figures.
% Coursework scripts clear the MATLAB base workspace and close figures.
root = fileparts(mfilename('fullpath'));
oldVisibility = get(groot, 'defaultFigureVisible');
restoreVisibility = onCleanup(@() set(groot, 'defaultFigureVisible', oldVisibility));
set(groot, 'defaultFigureVisible', 'off');
jobs = {
    'bjt-amplifier/bias_design.m', 'bjt-amplifier', {};
    'bjt-amplifier/frequency_response.m', 'bjt-amplifier', ...
        {'voltage-gain-vs-frequency.png', 'input-resistance-vs-frequency.png'};
    'schmitt-trigger/schmitt_trigger_sweep.m', 'schmitt-trigger', ...
        {'hysteresis-width-vs-resistor-ratio.png', ...
         'switching-midpoint-vs-resistor-ratio.png', ...
         'noninverting-hysteresis-linearity.png', ...
         'hysteresis-width-vs-reference-voltage.png', ...
         'switching-midpoint-vs-reference-voltage.png'};
    'fourier-rlc/fourier_rlc_response.m', 'fourier-rlc', ...
        {'reconstructed-waveform.png', 'filtered-waveforms-by-quality-factor.png'}
};
results = struct('matlab_version', version, 'models', struct());
for k = 1:size(jobs, 1)
    scriptPath = fullfile(root, jobs{k,1});
    evalin('base', ['run(''' strrep(scriptPath, '''', '''''') ''');']);
    resultDir = fullfile(root, jobs{k,2}, 'results');
    if ~isfolder(resultDir), mkdir(resultDir); end
    figs = findall(groot, 'Type', 'figure');
    if ~isempty(figs)
        [~, figureOrder] = sort([figs.Number]);
        figs = figs(figureOrder);
    end
    figureNames = jobs{k,3};
    assert(numel(figs) == numel(figureNames), 'Unexpected figure count for %s', jobs{k,1});
    for j = 1:numel(figs)
        f = figs(j);
        set(f, 'Color', 'w', 'Units', 'pixels', 'Position', [100 100 960 640]);
        set(findall(f, 'Type', 'axes'), 'Color', 'w', 'XColor', 'k', 'YColor', 'k', 'ZColor', 'k', 'GridColor', [.2 .2 .2]);
        set(findall(f, 'Type', 'text'), 'Color', 'k');
        set(findall(f, 'Type', 'legend'), 'Color', 'w', 'TextColor', 'k', 'EdgeColor', [.3 .3 .3]);
        exportgraphics(f, fullfile(resultDir, figureNames{j}), 'Resolution', 160, 'BackgroundColor', 'white');
    end
    if k == 1
        results.models.bjt_bias = evalin('base', ...
            'struct(''input_resistance_ohm'',Rin,''output_resistance_ohm'',Rout,''voltage_gain_V_per_V'',Av_total,''voltage_gain_dB'',Av_dB,''current_A'',I_total,''q1_collector_V'',VC1,''q2_emitter_V'',VE2)');
        assert(results.models.bjt_bias.q1_collector_V > 0 && results.models.bjt_bias.q1_collector_V < 12, 'Bias outside supply range');
        assert(results.models.bjt_bias.q2_emitter_V > 0 && results.models.bjt_bias.q2_emitter_V < 12, 'Bias outside supply range');
    elseif k == 2
        results.models.bjt_frequency = evalin('base', ...
            'struct(''maximum_gain_dB'',maxGain_dB,''lower_cutoff_Hz'',fL,''frequency_checks_Hz'',freq_check,''gain_checks_dB'',gain_check)');
        assert(all(isfinite(evalin('base','Av_dB'))), 'Nonfinite frequency-response values');
    elseif k == 3
        results.models.schmitt_trigger = evalin('base', ...
            'struct(''ratio_samples'',numel(a),''ratio_min'',min(a),''ratio_max'',max(a),''inverting_midpoint_V'',Vinave_inv(1),''noninverting_midpoint_V'',Vinave_non(1))');
        assert(all(diff(evalin('base','dVin_inv')) < 0), 'Inverting width must decrease with ratio');
        assert(all(diff(evalin('base','dVin_non')) > 0), 'Non-inverting width must increase with ratio');
    else
        results.models.fourier_rlc = evalin('base', ...
            'struct(''harmonic_limit'',N,''period_s'',T,''center_angular_frequency_rad_s'',wr,''inductance_H'',L,''capacitance_F'',C,''Q_values'',Qlist)');
        assert(all(isfinite(evalin('base','v'))) && all(isfinite(evalin('base','vo'))), 'Nonfinite reconstructed waveform');
    end
end
f = fopen(fullfile(root, 'model-results.json'), 'w');
assert(f ~= -1, 'Cannot open result file');
clean = onCleanup(@() fclose(f));
fprintf(f, '%s\n', jsonencode(results, PrettyPrint=true));
close all;
disp('All four recovered MATLAB models completed; figures and model-results.json regenerated.');
end
