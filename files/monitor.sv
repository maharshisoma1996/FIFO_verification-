class monitor;

virtual intf vif;
event done;
mailbox mbx;
transcation t;
integer mon_count;

function new(mailbox mbx,virtual intf vif,event next);
$display($time," [MON] MON instance created ");
this.mbx=mbx;
this.vif=vif;
this.done=next;
endfunction

task main();
t=new();
mon_count=0;
forever begin
	@(posedge vif.clk);
	#1
	t.wr_en=vif.wr_en;
	t.rd_en=vif.rd_en;
	t.rst=vif.rst;
	t.full=vif.full;
	t.empty=vif.empty;
	t.d_wr=vif.d_wr;
	t.d_out=vif.d_out;
//	if((vif.rd_en==1 || vif.wr_en==1) && vif.rst==0) begin
	mbx.put(t);
	$display($time," [MON] DUT interface sampled and sent to scoreboard");
	->done;
//	end
	#1;

	end
	
endtask

endclass