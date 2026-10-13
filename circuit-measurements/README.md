# KCL/KVL resistor-network measurements

**EE A203L, Fall 2025.** The September 15, 2025 lab compared calculated node voltages and branch currents with multimeter readings from a 5 V resistor network. It also compared a 2.7 kΩ + 1 kΩ series pair with an available replacement resistor.

`kcl-kvl-measurements.json` transcribes the numeric comparison table from the recovered team workbook and completed report. Units are explicit; `absolute_relative_difference` is `abs(calculated-measured)/abs(calculated)`. The workbook's nominal 3.7 kΩ replacement calculation was compared with a physically available 3.6 kΩ resistor, according to the report, which matters when interpreting that row's larger deviation.

The data is a small record of bench analysis rather than a full simulation project. Circuit diagrams, assignment instructions, and the original report template are omitted. The original workbook's displayed values were inspected; the JSON data recalculates the relative differences directly and does not rely on Excel's stored formula cache.

See [collaborator attribution and course context](../NOTICE.md).
