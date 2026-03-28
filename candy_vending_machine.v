module candy_vending_with_CNCL_BUY(
input clk,
input rst,
input n,
input d,
input q,
input BUY,
input CNCL,
output dispense,
output rN,
output rD,
output rQ);
reg [4:0]cs,ns;//present state and next state for main fsm...
reg [1:0] n_cs, d_cs, q_cs; //present states for n,d,q 
reg [1:0] n_ns, d_ns, q_ns; //next state for n,d,q fsms
wire n_out,d_out,q_out; //outputs of the corresponding fsms...
wire cancel,buy;
reg [1:0]CNCL_cs,BUY_cs;//presetn state for cncl,buy
reg [1:0]CNCL_ns,BUY_ns;//next state for cncl and buy
//////////////////n_fsm//////////////////////
always @(posedge clk or negedge rst)
	if (!rst)
		n_cs <= 'b0;
	else 
		n_cs <= n_ns;

always @(*) begin
	n_ns = n_cs;
	case(n_cs)
		2'b00: if (n) n_ns = 2'b01;
		2'b01: n_ns = 2'b10;
		2'b10: if (!n) n_ns = 2'b00;
  endcase
end
assign n_out = (n_cs==2'b01);
//////////////////d_fsm//////////////////////
always @(posedge clk or negedge rst)
	if (!rst)
		d_cs <= 'b0;
	else 
		d_cs <= d_ns;

always @(*) begin
	d_ns = d_cs;
	case(d_cs)
		2'b00: if (d) d_ns = 2'b01;
		2'b01: d_ns = 2'b10;
		2'b10: if (!d) d_ns = 2'b00;
  endcase
end
assign d_out = (d_cs==2'b01);
///////////////////q_fsm/////////////////////
always @(posedge clk or negedge rst)
	if (!rst)
		q_cs <= 'b0;
	else 
		q_cs <= q_ns;

always @(*) begin
	q_ns = q_cs;
	case(q_cs)
		2'b00: if (q) q_ns = 2'b01;
		2'b01: q_ns = 2'b10;
		2'b10: if (!q) q_ns = 2'b00;
  endcase
end
assign q_out = (q_cs==2'b01);
/////////////Cancel//////////
always@(posedge clk,negedge rst) begin
	if(!rst)
		CNCL_cs<=0;
	else 
		CNCL_cs<=CNCL_ns;
end
always@* begin
	CNCL_ns=CNCL_cs;
	case(CNCL_cs)
		2'b00: if(CNCL) CNCL_ns=2'b01;
		2'b01: CNCL_ns=2'b10;
		2'b10: if(!CNCL) CNCL_ns=2'b00;
	endcase
end
assign cancel=(CNCL_cs==2'b01);
/////////////buy fsm/////////////
always@(posedge clk or negedge rst) begin
	if(!rst) 
		BUY_cs<=0;
	else
		BUY_cs<=BUY_ns;
end
always@* begin
	BUY_ns=BUY_cs;
	case(BUY_cs)
		2'b00: if(BUY) BUY_ns=2'b01;
		2'b01: BUY_ns=2'b10;
		2'b10: if(!BUY) BUY_ns=2'b00;
	endcase
end
assign buy=(BUY_cs==2'b01);
//////////////////////////MAIN FSM ////////////////
//change should be return in highest denomination...;
localparam s0=0,
	s5=1, //money 5
	s10=2, //money 10
	s15=3, //money 15
	s20=4, //money 20
	swait=5, //wait state
	sbuy=6, //candy =1
	scancel=7, //cancel state
	sn=8, //return 5
	sd=9, //return 10
	sqn=10, //return 30
	snd=11, //return 15
	snd2=12, //return 20
	dum0=13, //rn=0;
	dum1=14, //rd=0;
	sddn=15, //return 25
	sqd=16, //return 35
	sqnd=17, //return 40
	sqdnn=18; //return 45
reg n1,d1,q1,r;//to increment count values;
///moore machine////
reg [5:0]tt;
reg [2:0]ncount,dcount,qcount;
always@(posedge clk or negedge rst) begin
	if(!rst) begin
		cs<=0;
		ncount<=0;
		dcount<=0;
		qcount<=0;
	end
	else begin
		cs<=ns;
		if(n1) ncount<=ncount+1;
		if(d1) dcount<=dcount+1;
		if(q1) qcount<=qcount+1;
		if(r) begin
				ncount<=0;
				dcount<=0;
				qcount<=0;
		end
	end
end
always@* begin
	ns=cs;
	n1=0;
	d1=0;
	q1=0;
	r=0;
	tt=qcount*25+dcount*10+ncount*5;
	case(cs)
		0: begin
			if(n_out) begin
				ns=s5;
				n1=1;
			end
			else if(d_out) begin
				ns=s10;
				d1=1;
			end
			else if(q_out) begin 
				ns=swait;
				q1=1;
			end
			else if(cancel) ns=scancel;
		end
		s5:begin
			if(n_out) begin 
				ns=s10;
				n1=1;
			end
			else if(d_out) begin
				ns=s15;
				d1=1;
			end
			else if(q_out) begin 
				ns=swait;
				q1=1;
			end
			else if(cancel) ns=scancel;
		end
		s10: begin
			if(n_out) begin
				ns=s15;
				n1=1;
			end
			else if(d_out) begin
				ns=s20;
				d1=1;
			end
			else if(q_out) begin 
				ns=swait;
				q1=1;
			end
			else if(cancel) ns=scancel;
		end
		s15:begin
			if(n_out) begin
				ns=s20;
				n1=1;
			end
			else if(d_out) begin
					ns=swait;
					d1=1;
				end
			else if(q_out) begin 
				ns=swait;
				q1=1;
			end
			else if(cancel) ns=scancel;
		end
		s20:begin
			if(n_out) begin
				ns=swait;
				n1=1;
			end
			else if(d_out) begin
					ns=swait;
					d1=1;
				end
			else if(q_out) begin 
				ns=swait;
				q1=1;
			end
			else if(cancel) ns=scancel;
		end
		swait:begin
			if(buy) ns=sbuy;
			else if(cancel) ns=scancel;
		end
		scancel: begin
			case(tt)
				5:ns=sn;//rn=1;
				10:ns=sd;//rd=1;
				15:ns=snd;//rd,rn;
				20:begin 
					ns=snd2;//15 +5;
				end
				25:begin
					ns=sddn; //10+10+5
				end
				30:ns=sqn;//25+5
				35:ns=sqd;//25+10
				40:ns=sqnd;//25+10+5
				45:ns=sqdnn;//25+10+5+5;
			endcase
		end
		sn: begin 
			ns=s0;
			r=1;
		end
		sd:begin//rd=1;10
			ns=s0;
			r=1;
		end
		snd:begin//rd=1;rn=1;15
			ns=s0;
			r=1;
		end
		snd2:begin//rd=1,rn=1;15+5=20
			ns=dum0;
		end
		dum0: begin //dummy state for rn=0;
			ns=sn; //goes to return 5 state;
		end
		sddn:begin//rd=1,rn=1 //15+10=25
			ns=dum1;
		end
		dum1:begin//dummy state for rd=0;
			ns=sd; //goes back to return 10 state;
		end

		sqn:begin//rq=1,rn=1;30
				ns=s0;
				r=1;
		end
		sqd:begin//rq=1,rd=1;35
			ns=s0;
			r=1;
		end
		sqnd:begin//rq=1,rd=1,rn=1;40
			ns=s0;
			r=1;
		end
		sqdnn:begin//rq=1,rd=1,rn=1;40+5=45
			ns=dum0; //goest rn=0 and then to return 5 state;
		end
		sbuy:begin
		//candy=1;
			case(tt)
				25:begin
					ns=s0;
					r=1;
				end
				30:begin//return 5
					ns=sn;
				end
				35:begin//return 10
					ns=sd;
				end
				40:begin//return 15
					ns=snd;
				end
				45:begin//return 20
					ns=snd2;
				end
				default: ns=s0;
			endcase
		end
	endcase
end
assign dispense=(cs==sbuy);
assign rN= ((cs==sn)||
			(cs==snd)||
			(cs==snd2)||
			(cs==sddn)||
			(cs==sqn)||
			(cs==sqnd)||
			(cs==sqdnn));
assign rD= ((cs==sd)||
			(cs==snd)||
			(cs==snd2)||
			(cs==sddn)||
			(cs==sqd)||
			(cs==sqnd)||
			(cs==sqdnn));
assign rQ= ((cs==sqn)||
			(cs==sqd)||
			(cs==sqnd)||
			(cs==sqdnn));
endmodule



