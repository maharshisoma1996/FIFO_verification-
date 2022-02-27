
interface intf;

// control signals
logic wr_en;
logic rd_en;

//data_signals
logic [`data_width-1:0]d_wr;

// global signals
logic rst;
logic clk;

//output signals
logic [`d_out_width-1:0]d_out;
logic full;
logic empty;

endinterface
