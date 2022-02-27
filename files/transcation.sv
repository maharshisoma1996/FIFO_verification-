

class transcation;

// control signals
bit wr_en;
bit rd_en;
bit rst;

//data_signals
rand bit[`data_width-1:0]d_wr;

//output signals
bit [`d_out_width-1:0]d_out;
bit full;
bit empty;


//constraint wr_en_const{wr_en dist{1:=80,0:=35};};
//constraint rd_en_const{rd_en dist{0:=80,1:=20};};

endclass

