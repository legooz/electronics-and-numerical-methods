# Electronics and Numerical Methods

MATLAB circuit models and measurements from electrical-engineering coursework at the University of Alaska Anchorage.

| Study | What is included | Course context |
| --- | --- | --- |
| [Two-stage BJT amplifier](bjt-amplifier/) | DC bias, small-signal estimates, frequency sweep, and lab comparison | EE A333L, Spring 2026 |
| [Schmitt-trigger thresholds](schmitt-trigger/) | Inverting/non-inverting threshold sweeps and measured switching levels | EE A333L, Spring 2026 |
| [Fourier series and RLC response](fourier-rlc/) | Complex Fourier reconstruction and third-harmonic filtering for three Q values | Circuit Theory, Spring 2026; exact submission context not recovered |
| [KCL/KVL measurements](circuit-measurements/) | A compact measured/calculated resistor-network dataset | EE A203L, Fall 2025 |

The MATLAB files preserve the recovered calculations. Project notes distinguish approximate model output from values recorded during the labs. These are educational models with the limitations listed in each study.

## Run

Open a study folder in MATLAB and run its `.m` file. To regenerate all model plots and the numerical result snapshot from the repository root:

```matlab
generate_figures
```

The scripts require base MATLAB. They were executed with MATLAB R2025b during portfolio preparation; no additional toolboxes were used. The scripts clear the base workspace and close figures, so save other MATLAB work before running them.

## Attribution

Circuit requirements and threshold equations came from the courses. The Fourier study follows the EE A353 `Fseries_ex2.m` teaching example, with recovered coursework coefficients and an added filter response. Collaborator credits and source context are consolidated through [NOTICE.md](NOTICE.md); [provenance.json](provenance.json) records the source files.

Original worksheets, instructor solutions, assessment PDFs, and duplicate drafts are retained in the personal recovery archive rather than redistributed here. Public notes were newly written from the recovered project evidence; measurement values are historical, not newly collected.

[Browse the engineering portfolio by subject](https://github.com/legooz/engineering-portfolio).
