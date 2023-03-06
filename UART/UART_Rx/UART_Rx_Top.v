module UART_Rx_Top 
(
	input   wire       RX_IN         ,
	input   wire [4:0] Prescale      ,
	input   wire       PAR_EN        ,
	input   wire       PAR_TYP       ,
	input   wire       CLK           ,
	input   wire       RST           ,

	output  wire [7:0] P_DATA        ,
	output  wire       data_valid    ,
	output  wire       parity_error  ,
	output  wire       framing_error 
);

wire [4:0] edge_cnt    ;
wire [3:0] bit_cnt     ;
wire       strt_glitch ;
wire       dat_samp_en ;
wire       cnt_enable  ;
wire       strt_chk_en ;
wire       par_chk_en  ;
wire       stp_chk_en  ;
wire       deser_en    ;
wire       sampled_bit ;

UART_Rx_FSM U0 (
	.RX_IN       (RX_IN)         ,
	.PAR_EN      (PAR_EN)        ,
	.edge_cnt    (edge_cnt)      ,
	.bit_cnt     (bit_cnt)       ,
	.strt_glitch (strt_glitch)   ,
	.par_err     (parity_error)  ,
	.stp_err     (framing_error) ,
	.Prescale    (Prescale)      ,
	.CLK         (CLK)           ,
	.RST         (RST)           ,

	.dat_samp_en (dat_samp_en)   ,
	.cnt_enable  (cnt_enable)    ,
	.strt_chk_en (strt_chk_en)   ,  
	.par_chk_en  (par_chk_en)    , 
	.stp_chk_en  (stp_chk_en)    , 
	.data_valid  (data_valid)    , 
	.deser_en    (deser_en)  
);
  
UART_Rx_data_sampling U1 (
	.RX_IN       (RX_IN)       ,
	.Prescale    (Prescale)    ,
	.dat_samp_en (dat_samp_en) ,
	.edge_cnt    (edge_cnt)    ,
	.CLK         (CLK)         ,
	.RST         (RST)         ,

	.sampled_bit (sampled_bit)
);

UART_Rx_deserializer U2 (
	.deser_en    (deser_en)    ,
	.sampled_bit (sampled_bit) ,
	.bit_cnt     (bit_cnt)     ,
	.CLK         (CLK)         ,
	.RST         (RST)         ,

	.P_DATA      (P_DATA)
);

UART_Rx_edge_bit_counter U3 (
	.cnt_enable (cnt_enable) ,
	.PAR_EN     (PAR_EN)     ,
	.CLK        (CLK)        ,
	.RST        (RST)        ,

	.edge_cnt   (edge_cnt)   ,
	.bit_cnt    (bit_cnt)
);
  
UART_Rx_parity_check U4 (
	.PAR_TYP     (PAR_TYP)      ,
	.par_chk_en  (par_chk_en)   ,
	.sampled_bit (sampled_bit)  , 
	.bit_cnt     (bit_cnt)      ,
	.edge_cnt    (edge_cnt)     ,
	.Prescale    (Prescale)     ,
	.CLK         (CLK)          ,
	.RST         (RST)          ,

	.par_err     (parity_error)
);

UART_Rx_strt_check U5 (
	.strt_chk_en (strt_chk_en) ,
	.sampled_bit (sampled_bit) ,

	.strt_glitch (strt_glitch)
);

UART_Rx_stop_check U6 (
	.stp_chk_en  (stp_chk_en)    ,
	.sampled_bit (sampled_bit)   ,
	.CLK         (CLK)           ,
	.RST         (RST)           ,

	.stp_err     (framing_error)
);


endmodule