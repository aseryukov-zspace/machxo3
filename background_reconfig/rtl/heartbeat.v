module heartbeat #(parameter clk_freq=27'd12000000) (
    input   wire        clk,
    input   wire        rstn,

    output  reg         heartbeat
);

localparam [17:0] DIVIDER = (clk_freq / 27'd1000 - 1);  // per 1ms

reg [17:0] ms_c; // millisecond counter
reg        ms_p; // mllisecond pulse
always @(posedge clk or negedge rstn)
    if (!rstn)
        ms_c <= 0;
    else if (ms_p)
        ms_c <= 0;
    else
        ms_c <= ms_c + 18'd1;

always @(*)
    ms_p = (ms_c == DIVIDER);

///////////////////////////////////////////////////////////////////////////////
// RAM contains 2048 16 bit words. Each word is initialized with value = addr

reg  [10:0] ram_addr;   // count of milliseconds
wire [15:0] ram_data;
reg        s_p;         // one second pulse

ram_dpt_16x2k ram (
    .ClockA     (clk),
    .ClockEnA   (1'b1),
    .ResetA     (!rstn),
    .WrA        (1'b0),
    .AddressA   (ram_addr),
    .DataInA    (16'd0),
    .QA         (ram_data),

    // not using port B for now
    .ClockB     (clk),
    .ClockEnB   (1'b1),
    .ResetB     (!rstn),
    .WrB        (1'b0),
    .AddressB   (11'd0),
    .DataInB    (16'd0),
    .QB         ()
);

always @(posedge clk or negedge rstn)
    if (!rstn)
        ram_addr <= 0;
    else if (ms_p)
        ram_addr <= ram_addr + 11'd1;

always @(*)
    s_p = (ram_addr == 11'd1000);

always @(posedge clk or negedge rstn)
    if (!rstn)
        heartbeat <= 0;
    else
        heartbeat <= &ram_data[9:8];

endmodule
