//////////////////////////////////////////////////////////////////////////////
// Low-Power Configurable Multi-Clock Digital System With UART Transceiver 
// Creator: Yaseen Salah                                                  
// Date   : 10 Oct 2022                                                  
/////////////////////////////////////////////////////////////////////////////

module SYS_TOP 
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////// System Ports ///////////////////////////////
///////////////////////////////////////////////////////////////////////////    
(
	input   wire   RX_IN    ,   //from Host (Master) to UART_Rx

	input   wire   REF_CLK  ,   //from PLL 1 to Clock Domain 1: (SYS_CTRL, ALU, RegFile, BIT_SYNC, DATA_SYNC "U7")
	input   wire   UART_CLK ,   //from PLL 2 to Clock Domain 2: (UART, ClkDiv, DATA_SYNC "U8")
	input   wire   RST      ,   //from POR to Reset Synchronizers


	output  wire   TX_OUT   ,   //from UART_Tx to Host (Master)

	output  wire   PAR_ERR  ,   //from UART_Rx to Host (Master)
	output  wire   STP_ERR      //from UART_Rx to Host (Master)
);


/////////////////////////////////////////////////////////////////////////
//////////////////////////// Internal Wires ////////////////////////////
/////////////////////////////////////////////////////////////////////// 

/*------------------------- Clock Domain 1 -------------------------*/   
wire   [15:0]  ALU_OUT        ;   //from ALU to SYS_CTRL
wire           OUT_Valid      ;   //from ALU to SYS_CTRL

wire           ALU_EN         ;   //from SYS_CTRL to ALU
wire   [3:0]   ALU_FUN        ;   //from SYS_CTRL to ALU
wire           CLK_EN         ;   //from SYS_CTRL to CLK_GATE

wire           GATED_CLK      ;   //from CLK_GATE to ALU

wire   [7:0]   RdData         ;   //from RegFile to SYS_CTRL
wire           RdData_Valid   ;   //from RegFile to SYS_CTRL

wire   [3:0]   Address        ;   //from SYS_CTRL to RegFile
wire           RdEn           ;   //from SYS_CTRL to RegFile
wire           WrEn           ;   //from SYS_CTRL to RegFile
wire   [7:0]   WrData         ;   //from SYS_CTRL to RegFile

wire   [7:0]   REG0           ;   //from RegFile to ALU
wire   [7:0]   REG1           ;   //from RegFile to ALU


/*--------------------- Quasi Static Signals ---------------------*/  
wire   [7:0]   REG2           ;   //from RegFile to UART
wire   [7:0]   REG3           ;   //from RegFile to ClkDiv

wire           clk_div_en     ;   //from SYS_CTRL to ClkDiv


/*------------------------- Clock Domain 2 -------------------------*/   
wire           div_clk        ;   //from ClkDiv to UART_Tx


/*--------------------- Clock Domain Crossing ---------------------*/
wire           Busy           ;   //from UART_Tx to BIT_SYNC

wire           SYNC_Busy      ;   //from BIT_SYNC to SYS_CTRL

wire   [7:0]   RX_P_DATA      ;   //from UART_Rx to DATA_SYNC "U7"
wire           RX_D_VLD       ;   //from UART_Rx to DATA_SYNC "U7"

wire   [7:0]   SYNC_RX_P_DATA ;   //from DATA_SYNC "U7" to SYS_CTRL
wire           SYNC_RX_D_VLD  ;   //from DATA_SYNC "U7" to SYS_CTRL

wire   [7:0]   TX_P_DATA      ;   //from SYS_CTRL to DATA_SYNC "U8"
wire           TX_D_VLD       ;   //from SYS_CTRL to DATA_SYNC "U8"

wire   [7:0]   SYNC_TX_P_DATA ;   //from DATA_SYNC "U8" to UART_Tx
wire           SYNC_TX_D_VLD  ;   //from DATA_SYNC "U8" to UART_Tx


/*---------------------- Reset Synchronizers ----------------------*/   
wire           SYNC_RST_1     ;   //from RST_SYNC "U9"  to Clock Domain 1: (SYS_CTRL, ALU, RegFile, BIT_SYNC, DATA_SYNC "U7")
wire           SYNC_RST_2     ;   //from RST_SYNC "U10" to Clock Domain 2: (UART, ClkDiv, DATA_SYNC "U8")



////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////// Modules Instantiation & Ports Mapping ////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
SYS_CTRL U0 (
	.ALU_OUT      (ALU_OUT)        ,
	.OUT_Valid    (OUT_Valid)      ,
	.RdData       (RdData)         ,
	.RdData_Valid (RdData_Valid)   ,
	.RX_P_DATA    (SYNC_RX_P_DATA) ,
	.RX_D_VLD     (SYNC_RX_D_VLD)  ,	
	.Busy         (SYNC_Busy)      ,
	.CLK          (REF_CLK)        ,
	.RST          (SYNC_RST_1)     ,

	.ALU_EN    	  (ALU_EN)         ,
	.ALU_FUN      (ALU_FUN)        ,
	.CLK_EN       (CLK_EN)         ,
	.Address      (Address)        ,
	.RdEn         (RdEn)           ,
	.WrEn         (WrEn)           ,
	.WrData       (WrData)         ,
	.TX_P_DATA    (TX_P_DATA)      ,
	.TX_D_VLD     (TX_D_VLD)       ,
	.clk_div_en   (clk_div_en)
	);


ALU U1 (
	.A         (REG0)       ,
	.B         (REG1)       ,
	.ALU_FUN   (ALU_FUN)    ,
	.Enable    (ALU_EN)     ,
	.CLK       (GATED_CLK)  ,
	.RST       (SYNC_RST_1) ,

	.ALU_OUT   (ALU_OUT)    ,
	.ALU_VALID (OUT_Valid)  
	);


RegFile U2 (
	.WrData       (WrData)       ,
	.Address      (Address)      ,
	.WrEn         (WrEn)         ,
	.RdEn         (RdEn)         ,
	.CLK          (REF_CLK)      ,
	.RST          (SYNC_RST_1)   ,

	.RdData       (RdData)       ,
	.RdData_Valid (RdData_Valid) ,
	.REG0         (REG0)         ,
	.REG1         (REG1)         ,
	.REG2         (REG2)         ,
	.REG3         (REG3)         
	);


UART U3 (
	.UART_Config   (REG2)            ,
	.RX_IN         (RX_IN)           ,
	.TX_P_DATA     (SYNC_TX_P_DATA)  ,
	.TX_DATA_VALID (SYNC_TX_D_VLD)   ,
	.RX_CLK        (UART_CLK)        ,
	.TX_CLK        (div_clk)         ,
	.RST           (SYNC_RST_2)      ,

	.TX_OUT        (TX_OUT)          ,
	.Busy          (Busy)            ,
	.RX_P_DATA     (RX_P_DATA)       ,
	.RX_DATA_VALID (RX_D_VLD)        ,
	.parity_error  (PAR_ERR)         ,
	.framing_error (STP_ERR)
	);


ClkDiv U4 (
	.i_ref_clk   (UART_CLK)   ,
	.i_rst_n     (SYNC_RST_2) ,
	.i_clk_en    (clk_div_en) ,
	.i_div_ratio (REG3[3:0])  ,

	.o_div_clk   (div_clk)
	);


CLK_GATE U5 (
	.CLK_EN    (CLK_EN)    ,
	.CLK       (REF_CLK)   ,

	.GATED_CLK (GATED_CLK)
	);


BIT_SYNC U6 (
	.ASYNC  (Busy)       ,
	.CLK    (REF_CLK)    , 
	.RST    (SYNC_RST_1) , 

	.SYNC   (SYNC_Busy)
	);


DATA_SYNC U7 (
	.Unsync_bus   (RX_P_DATA)      ,
	.bus_enable   (RX_D_VLD)       ,
	.dest_clk     (REF_CLK)        ,
	.dest_rst     (SYNC_RST_1)     ,

	.sync_bus     (SYNC_RX_P_DATA) ,
	.enable_pulse (SYNC_RX_D_VLD)
	);


DATA_SYNC U8 (
	.Unsync_bus   (TX_P_DATA)      ,
	.bus_enable   (TX_D_VLD)       ,
	.dest_clk     (div_clk)        ,
	.dest_rst     (SYNC_RST_2)     ,

	.sync_bus     (SYNC_TX_P_DATA) ,
	.enable_pulse (SYNC_TX_D_VLD)
	);


RST_SYNC U9 (
	.CLK      (REF_CLK)    ,
	.RST      (RST)        ,

	.SYNC_RST (SYNC_RST_1)
	);


RST_SYNC U10 (
	.CLK      (UART_CLK)   ,
	.RST      (RST)        ,

	.SYNC_RST (SYNC_RST_2) 
	);


endmodule



/////////////////////////////////////////////////////////////////////////
///////////////////////////Design Hierarchy/////////////////////////////
///////////////////////////////////////////////////////////////////////
//	SYS_TOP                                                       
//		SYS_CTRL                                                    
//			SYS_CTRL_Tx                                             
//			SYS_CTRL_Rx                                             
//		ALU                                                         
//		RegFile                                                     
//		UART                                                        
//			UART_Tx                                                 
//				UART_Tx_FSM                                         
//				UART_Tx_Serializer                                  
//				UART_Tx_ParityCalc                                  
//				UART_Tx_MUX                                         
//			UART_Rx                                                 
//				UART_Rx_FSM                                         
//				UART_Rx_data_sampling                               
//				UART_Rx_edge_bit_counter                            
//				UART_Rx_deserializer                           
//				UART_Rx_strt_check                                  
//				UART_Rx_parity_check                               
//				UART_Rx_stop_check                                  
//		ClkDiv                                                      
//		CLK_GATE                                                   
//		BIT_SYNC                                                    
//			D_FF                                                    
//		DATA_SYNC                                                   
//			D_FF                                                    
//			BIT_SYNC                                                
//			Pulse_Gen                                               
//		RST_SYNC                                                    
//			D_FF                                                    
/////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

