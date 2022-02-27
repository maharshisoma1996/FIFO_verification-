class driver;

mailbox comp;
mailbox mbx;

virtual intf vif;
transcation t;
event start_gen;
integer trans_count;


function new(mailbox mbx,mailbox comp,event sync_gen,virtual intf vif);
this.mbx=mbx;
this.comp=comp;
this.start_gen=sync_gen;

this.vif=vif;
$display($time," [DRI] Driver instance created ");
endfunction

task main();
t=new();
trans_count=0;
forever begin
@(negedge vif.clk);
#1
mbx.get(t);
driv_to_dut(t);
$display($time," [DRI] Transcation %0d received and sent to DUT ",trans_count+1);
trans_count=trans_count+1;
->start_gen;
#1;
end
endtask

task driv_to_dut(transcation t1);
if(vif.rst==1) begin
vif.d_wr=0;
end

else begin 
if(vif.wr_en==1 && vif.rd_en==1 && vif.full==0 && vif.empty==0) begin
vif.d_wr=t1.d_wr;
comp.put(t.d_wr);
end

else if(vif.wr_en==1 && vif.rd_en==0 && vif.full==0) begin
vif.d_wr=t.d_wr;
comp.put(t.d_wr);
end

else if(vif.wr_en==0 && vif.rd_en==1 && vif.empty==0) begin
vif.d_wr=0;
end


else begin
vif.d_wr=0;
end

end
endtask

endclass

