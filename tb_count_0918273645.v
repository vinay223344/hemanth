`include "count_0918273645.v"
module tb_count_0918273645;
reg clk,rst;
wire [3:0]count;
count_0918273645 x2(.clk(clk),.rst(rst),.count(count));
always #5 clk=~clk;
initial begin
//please insert input vectors here....
clk<=0;
rst<=0;
//#5 rst=0;
#5 rst<=1;
	#1000 $finish;
end
initial begin 
	$recordfile("count_0918273645_waves.trn");
	$recordvars();
end
endmodule

