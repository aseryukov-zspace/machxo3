module top_br (
    input   wire        clk_x1,     // 12M clock from FTDI/X1 crystal
    input   wire        rstn,       // from SW1 pushbutton
    input   wire  [3:0] DIPSW,      // from SW2 DIP switches

    output  wire  [7:0] LED         // to LEDs (D2-D9)
);

wire osc_clk;
defparam OSCH_inst.NOM_FREQ = "12.09";  
OSCH OSCH_inst( 
    .STDBY(1'b0), // 0=Enabled, 1=Disabled
    .OSC(osc_clk),
    .SEDSTDBY()
);

wire clk_12 = DIPSW[3] ? osc_clk : clk_x1;    // select clock source int/ext

heartbeat #(.clk_freq (12000000)) heartbeat_inst (
    .clk        (clk_12),
    .rstn       (rstn),
    .heartbeat  (heartbeat)
);

reg [7:0] LED_i;
always @ (*)
    case (DIPSW[2:0])
    3'b001 : LED_i <= heartbeat ? 8'b01010101 : 8'b10101010 ;
    3'b011 : LED_i <= heartbeat ? 8'b11110000 : 8'b00001111 ;
    3'b111 : LED_i <= heartbeat ? 8'b11111111 : 8'b00000000 ;
    default: LED_i <= heartbeat ? 8'b10000001 : 8'b00000000 ;
    endcase

assign LED = ~LED_i;

endmodule
