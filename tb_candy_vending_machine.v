`include "candy_vending_with_CNCL_BUY.v"
module tb_candy_vending_with_CNCL_BUY;
reg clk,rst;
reg n,d,q;
reg BUY,CNCL;
wire dispense;
wire rN,rD,rQ;
candy_vending_with_CNCL_BUY x1(.clk(clk),.rst(rst),.n(n),.d(d),.q(q),.BUY(BUY),.CNCL(CNCL),.dispense(dispense),.rN(rN),.rD(rD),.rQ(rQ));
initial begin
	$recordfile("database.trn");
	$recordvars();
end
always #5 clk=~clk;
initial begin
    rst <= 0;//asseting rst
	clk<=0;
    n<=0;
	d<=0;
	q<=0;
	CNCL<=0;
	BUY<=0;
    #35 rst <= 1; // deasserting rst...

  repeat(5) @(posedge clk);
     
  insert_nickel;
  insert_nickel;
  insert_nickel;
  insert_nickel;
  insert_nickel;
  press_buy; //buying 
  repeat(10) @(posedge clk); 
  insert_quarter;
  press_buy; //buying
  repeat(10) @(posedge clk);

  insert_nickel;
  insert_dime;
  insert_quarter;
  press_cancel; //canceling
  repeat(10) @(posedge clk); 

  
  insert_dime;
  insert_dime;
  insert_quarter;
  press_cancel; //canceling
  repeat(10) @(posedge clk);
  insert_dime;
  insert_dime;
  insert_dime;
  press_buy; //buying
  repeat(10) @(posedge clk);
  
  insert_dime;
  insert_nickel;
  insert_nickel;
  insert_quarter;
  press_cancel; //canceling
  repeat(10) @(posedge clk);

  insert_nickel;
  insert_quarter;
  press_cancel;
  repeat(10) @(posedge clk); 

  insert_dime;
  insert_quarter;
  press_buy;
  repeat(10) @(posedge clk); // delay...

  insert_dime;
  insert_nickel;
  insert_dime;
  press_cancel;
  repeat(10) @(posedge clk); // delay...
  insert_dime;
  insert_dime;
  insert_dime;
  press_cancel;
  #100 $finish;
end

task insert_nickel;
  begin
      @(posedge clk) n <= 1'b1;
      repeat(3) @(posedge clk);
      @(posedge clk) n <= 1'b0;
	end
endtask
///////////////
task insert_dime;
  begin
      @(posedge clk) d <= 1'b1;
      repeat(3) @(posedge clk) ;
      @(posedge clk) d <= 1'b0;
  end
endtask
///////////////
task insert_quarter;
  begin
      @(posedge clk) q <= 1'b1;
      repeat(4) @(posedge clk) ;
      @(posedge clk) q <= 1'b0;
  end
endtask
/////////////
task press_cancel;
	begin
		@(posedge clk) CNCL<=1'b1;
		repeat(3) @(posedge clk);
		@(posedge clk) CNCL<=1'b0;
	end
endtask
///////////
task press_buy;
	begin
		@(posedge clk) BUY<=1;
		repeat(3) @(posedge clk);
		@(posedge clk) BUY<=0;
	end
endtask
endmodule

