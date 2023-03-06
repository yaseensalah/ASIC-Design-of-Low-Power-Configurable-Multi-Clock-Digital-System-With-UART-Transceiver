onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Clocks -color {Medium Blue} /SYS_TOP_tb/DUT/REF_CLK
add wave -noupdate -expand -group Clocks -color Gold /SYS_TOP_tb/DUT/UART_CLK
add wave -noupdate -expand -group Clocks -color Tan /SYS_TOP_tb/DUT/div_clk
add wave -noupdate -expand -group Resets -color Cyan /SYS_TOP_tb/DUT/RST
add wave -noupdate -expand -group {Rx Signals} -color Sienna /SYS_TOP_tb/DUT/RX_IN
add wave -noupdate -expand -group {Rx Signals} -color Sienna /SYS_TOP_tb/DUT/RX_P_DATA
add wave -noupdate -expand -group {Rx Signals} -color Sienna /SYS_TOP_tb/DUT/RX_D_VLD
add wave -noupdate -expand -group {Rx Signals} -color Sienna /SYS_TOP_tb/DUT/PAR_ERR
add wave -noupdate -expand -group {Rx Signals} -color Sienna /SYS_TOP_tb/DUT/STP_ERR
add wave -noupdate -expand -group {Tx Signals} -color {Pale Green} /SYS_TOP_tb/DUT/TX_OUT
add wave -noupdate -expand -group {Tx Signals} -color {Pale Green} /SYS_TOP_tb/DUT/Busy
add wave -noupdate -expand -group {Tx Signals} -color {Pale Green} /SYS_TOP_tb/DUT/TX_P_DATA
add wave -noupdate -expand -group {Tx Signals} -color {Pale Green} /SYS_TOP_tb/DUT/TX_D_VLD
add wave -noupdate -expand -group {ALU Signals} -color {Sky Blue} /SYS_TOP_tb/DUT/ALU_OUT
add wave -noupdate -expand -group {ALU Signals} -color {Sky Blue} /SYS_TOP_tb/DUT/OUT_Valid
add wave -noupdate -expand -group {ALU Signals} -color {Sky Blue} /SYS_TOP_tb/DUT/ALU_EN
add wave -noupdate -expand -group {ALU Signals} -color {Sky Blue} /SYS_TOP_tb/DUT/ALU_FUN
add wave -noupdate -expand -group {ALU Signals} -expand -group {Clock Gate } -color Blue /SYS_TOP_tb/DUT/CLK_EN
add wave -noupdate -expand -group {ALU Signals} -expand -group {Clock Gate } -color Blue /SYS_TOP_tb/DUT/GATED_CLK
add wave -noupdate -expand -group {RegFile Signals} -color {Dark Orchid} /SYS_TOP_tb/DUT/Address
add wave -noupdate -expand -group {RegFile Signals} -color {Dark Orchid} /SYS_TOP_tb/DUT/RdEn
add wave -noupdate -expand -group {RegFile Signals} -color {Dark Orchid} /SYS_TOP_tb/DUT/RdData
add wave -noupdate -expand -group {RegFile Signals} -color {Dark Orchid} /SYS_TOP_tb/DUT/RdData_Valid
add wave -noupdate -expand -group {RegFile Signals} -color {Dark Orchid} /SYS_TOP_tb/DUT/WrEn
add wave -noupdate -expand -group {RegFile Signals} -color {Dark Orchid} /SYS_TOP_tb/DUT/WrData
add wave -noupdate -expand -group {RegFile Signals} -expand -group {Reserved Registers} -color {Dark Orchid} /SYS_TOP_tb/DUT/REG0
add wave -noupdate -expand -group {RegFile Signals} -expand -group {Reserved Registers} -color {Dark Orchid} /SYS_TOP_tb/DUT/REG1
add wave -noupdate -expand -group {RegFile Signals} -expand -group {Reserved Registers} -color {Dark Orchid} /SYS_TOP_tb/DUT/REG2
add wave -noupdate -expand -group {RegFile Signals} -expand -group {Reserved Registers} -color {Dark Orchid} /SYS_TOP_tb/DUT/REG3
add wave -noupdate -color {Sea Green} /SYS_TOP_tb/DUT/clk_div_en
add wave -noupdate -expand -group {CDC Blocks Outputs} -color Gray60 /SYS_TOP_tb/DUT/SYNC_Busy
add wave -noupdate -expand -group {CDC Blocks Outputs} -color Gray60 /SYS_TOP_tb/DUT/SYNC_RX_P_DATA
add wave -noupdate -expand -group {CDC Blocks Outputs} -color Gray60 /SYS_TOP_tb/DUT/SYNC_RX_D_VLD
add wave -noupdate -expand -group {CDC Blocks Outputs} -color Gray60 /SYS_TOP_tb/DUT/SYNC_TX_P_DATA
add wave -noupdate -expand -group {CDC Blocks Outputs} -color Gray60 /SYS_TOP_tb/DUT/SYNC_TX_D_VLD
add wave -noupdate -expand -group {RDC Blocks Outputs} -color Cyan /SYS_TOP_tb/DUT/SYNC_RST_1
add wave -noupdate -expand -group {RDC Blocks Outputs} -color Cyan /SYS_TOP_tb/DUT/SYNC_RST_2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {100475768721 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {273984585192 ps}
