# Configure ITM + DWT trace for the current connected core.
#
# Run from GDB with:
#   source trace_config_itm_dwt.gdb
#
# This mirrors the TraceConfigureITM_DWT debug sequence in
# develop_sequence.cbuild-run.yml for the active core only.

echo Begin TraceConfigureITM_DWT sequence\n

set mem inaccessible-by-default off

# Unlock ITM and DWT, if lock access registers are implemented.
set {unsigned int}0xE0000FB0 = 0xC5ACCE55
set {unsigned int}0xE0001FB0 = 0xC5ACCE55

# Enable ITM forwarding of DWT packets over SWO.
# ITM_TRACE_BUS_ID = 1 -> ITM_TCR = 0x0001001F
set {unsigned int}0xE0000E40 = 0x0000000F
set {unsigned int}0xE0000E00 = 0x00000001
set {unsigned int}0xE0000E80 = 0x0001001F

# Enable cycle counting and PC sampling every 4096 cycles.
# CYCTAP = 1 selects the 1024-cycle tap, POSTPRESET = 3 and POSTINIT = 3 give x4.
# DWT_CTRL = CYCCNTENA | (POSTPRESET << 1) | (POSTINIT << 5) | CYCTAP | PCSAMPLENA
#          = 0x00001267
# set {unsigned int}0xE0001004 = 0x00000000
# !!!Enable all easy to enable sources and sync packets for first test
set {unsigned int}0xE0001000 = 0x000FFE67

printf "ITM_TCR  = 0x%08x\n", *(unsigned int *)0xE0000E80
printf "DWT_CTRL = 0x%08x\n", *(unsigned int *)0xE0001000

echo End TraceConfigureITM_DWT sequence\n