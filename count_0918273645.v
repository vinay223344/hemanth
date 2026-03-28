module count_0918273645(
output reg [3:0]count,
input clk,
input rst);
reg [4:0]cs,ns;
wire en,r;// en is to make count increment or decrement and r is to reset count;
parameter s0=0,
	s1=1,
	s2=2,
	s3=3,
	s4=4,
	s5=5,
	s6=6,
	s7=7,
	s8=8,
	s9=9,
	s10=10,
	s11=11,
	s12=12,
	s13=13,
	s14=14,
	s15=15,
	s16=16,
	s17=17;
always@(posedge clk or negedge rst) begin
	if(!rst) begin
		count<=0;
		cs<=0;
		end
	else begin
		cs<=ns;
		if(en) count<=count-1;
		else count<=count+1;
	end
end
always@* begin
	ns=cs;
	case(cs)
		s0:begin//0,up
			if(count==9) ns=1;
		end
		s1:begin//9,down
			if(count==1) ns=2;
		end
		s2:begin//1,up
			if(count==8) ns=3;
		end
		s3:begin //8,down
			if(count==2) ns=s4;
		end
		s4:begin //2,up
			if(count==7) ns=s5;
		end
		s5:begin //7,down
			if(count==3) ns=s6;
		end
		s6:begin //3,up
			if(count==6) ns=s7;
		end
		s7:begin//6,down
			if(count==4) ns=s8;
		end
		s8:begin //4,up
			if(count==5) ns=s9; //en=1 
		end
		//after 5 needs to decrement and go to 4 and then go to 5 again then 6 
		s9:begin//5,down,4,up
			if(count==4) ns=s10; //en=0;
		end
		s10:begin//6,down
			if(count==6) ns=s11; //en=1;
		end
		s11:begin//3,
			if(count==3) ns=s12; //en=0;
		end
		s12:begin//7
			if(count==7) ns=s13; //en=1;
		end
		s13:begin//2
			if(count==2) ns=s14; //en=0;
		end
		s14:begin
			if(count==8) ns=s15; //en=1;
		end
		s15:begin
			if(count==1) ns=s16; //en=0;
		end
		s16:begin
			if(count==9) ns=s17; //en=1;
		end
		s17:begin
			if(count==0) ns=s0; //en=0;
		end
	endcase
end
assign en= (cs==s0 && count==9   ||
			cs==s1 && count!=1  ||
			cs==s2 && count==8  ||
			cs==s3 && count!=2  ||
			cs==s4 && count==7  ||
			cs==s5 && count!=3  || 
			cs==s6 && count==6  || 
			cs==s7 && count!=4  ||
			cs==s8 && count==5  || 
			cs==s9 && count!=4  || 
			cs==s10 && count==6 ||
			cs==s11 && count!=3 ||
			cs==s12 && count==7 ||
			cs==s13 && count!=2 ||
			cs==s14 && count==8 ||
			cs==s15 && count!=1 ||
			cs==s16 && count==9 ||
			cs==s17 && count!=0);
//assign r=(cs==s8 && count==5);
endmodule


