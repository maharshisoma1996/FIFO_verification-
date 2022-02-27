`include "files.sv"
module tb;

intf vif();
mailbox gen2dri;
mailbox mon2scb;
environment env;
mailbox qu;

syn_fifo_bram s1(vif.rst,vif.clk,vif.wr_en,vif.rd_en,vif.d_wr,vif.d_out,vif.full,vif.empty);

always #5 vif.clk=~vif.clk;

initial begin
gen2dri=new();
mon2scb=new();
qu=new();
env=new(gen2dri,mon2scb,vif,qu);
end

initial begin
#0   vif.rst=1; vif.clk=0; vif.wr_en=0;  vif.rd_en=0;
#10  vif.rst=0;
end

initial begin
repeat(10) begin
	@(negedge vif.clk)
	if(vif.rst==0) begin
	vif.wr_en=1;
	end
	end
vif.wr_en=0;


repeat(8) begin
	@(negedge vif.clk)
	if(vif.rst==0) begin
	vif.rd_en=1;
	end
	end
 vif.rd_en=0;

end





initial begin
fork
env.main();
#210 $finish;
join
end



endmodule
