class environment;

generator gen;
driver dri;

monitor mon;
scoreboard scb;

event sync_mon_scb;
event sync_g_d;

mailbox gen2dri;
mailbox mon2scb;
mailbox qu;

function new(mailbox gen2dri,mailbox mon2scb, virtual intf vif,mailbox qu);
$display($time," [ENV] Env Instance created ");
this.gen2dri=gen2dri;
this.mon2scb=mon2scb;
this.qu=qu;
gen=new(gen2dri,sync_g_d);
dri=new(gen2dri,qu,sync_g_d,vif);

mon=new(mon2scb,vif,sync_mon_scb);
scb=new(mon2scb,qu,sync_mon_scb);
endfunction

task main();
fork
dri.main();
mon.main();
gen.main();
scb.main();
	begin
	@gen.end_of_sim.triggered ;
	#7 scb.summary();
	end
join
endtask

endclass

