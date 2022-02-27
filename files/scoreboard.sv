class scoreboard;
mailbox comp;
mailbox mbx;
event start;
transcation t;


integer total_test_count;
integer pass_count;
integer fail_count;
logic [31:0]temp;


function new(mailbox mbx,mailbox comp, event sync_mon);
this.mbx=mbx;
this.comp=comp;
this.start=sync_mon;
$display($time,"[SCO] ScoreBoard Instance created");
endfunction

task main();


t=new();
total_test_count=0;
pass_count=0;
fail_count=0;
forever begin
@(start.triggered);
mbx.get(t);
compare(t);
#1;
end
endtask


task compare(transcation t1);
total_test_count=total_test_count+1;

if(t1.rst==1 || !(t1.wr_en==0 || t1.rd_en==0))begin
	if(t1.d_out==0) begin
		$display($time," [SCO] ############### Test PASS ###############");
		$display("\n");	
		pass_count=pass_count+1;
		end
	else begin
		$display($time," [SCO] ############### Test Fail ###############");
		$display("hiii\n");
		$display($time,"[SCB] expecting Result:D_out: %0b , Actutal Result: D_o:%0b, wr:%ob, rd:%0b, full=%0b, empty=%0b, d_wr=%0h",temp,t1.d_out,t1.wr_en,t1.rd_en,t1.full,t1.empty,t1.d_wr);

		fail_count=fail_count+1;
		end
end

else begin
	if(t1.wr_en==1 && t1.rd_en==0 ) begin
		
		$display($time," [SCO] fifo  write case, Passing the test by default");
		$display($time," [SCO] ###############1 Test PASS ###############");	
		$display("\n");
		pass_count=pass_count+1;
	end

	if(t1.wr_en==1 && t1.rd_en==1) begin
		comp.get(temp);
		$display($time," [SCO] fifo  write case, Passing the write test by default checking read test.......");
		if(t1.d_out==temp) begin
			$display($time," [SCO] ############### Test PASS ###############");
			$display("\n");
			pass_count=pass_count+1;
			end
		else begin
			$display($time," [SCO] ############### Test Fail ###############");
			fail_count=fail_count+1;
			$display($time,"[SCB] expecting Result:D_out: %0b , Actutal Result: D_o:%0b, wr:%ob, rd:%0b, full=%0b, empty=%0b, d_wr=%0h",temp,t1.d_out,t1.wr_en,t1.rd_en,t1.full,t1.empty,t1.d_wr);
			$display("\n");
			end
	end

	if(t1.wr_en==0 && t1.rd_en==1) begin
		comp.get(temp);
		if(t1.d_out==temp) begin
			$display($time," [SCO]  ############### Test PASS ###############");
			$display("\n");
			pass_count=pass_count+1;
		end
		else begin
			$display($time," [SCO]  ############### Test Fail ###############");
			fail_count=fail_count+1;
			$display($time,"[SCB] expecting Result:D_out: %0b , Actutal Result: D_o:%0b, wr:%ob, rd:%0b, full=%0b, empty=%0b, d_wr=%0h",temp,t1.d_out,t1.wr_en,t1.rd_en,t1.full,t1.empty,t1.d_wr);
			$display("\n");
			end
	end



end

endtask


task summary();
$display($time,"************************************** TEST RESULTS SUMMARY ***********************************************");
$display("\n");
$display("TOTAL TEST COUNT  :%0d ",total_test_count);
$display("PASS TEST COUNT   :%0d ",pass_count);
$display("FAIL TEST COUNT   :%0d ",fail_count);
endtask

endclass

