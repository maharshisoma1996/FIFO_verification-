class generator;

mailbox mbx;
event next;
event end_of_sim;
transcation t;

integer count;
integer no_of_trans=20;

function new(mailbox mbx,event sync);
this.mbx= mbx;
this.next=sync;
$display($time," [GEN] Gen instance created ");
endfunction

task main();
t=new();
count=0;
while(count<no_of_trans)
	begin
	#0
	t.randomize();
	mbx.put(t);
	$display($time," [GEN] Transcation %0d generated and sent to driver ",count+1);
	@next.triggered;
	count=count+1;
	#1;
	end
->end_of_sim;
endtask


endclass
