module Saat(CLOCK_50,HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,enable,saat_ayar,dakika_ayar,reset);

input CLOCK_50,enable,saat_ayar,dakika_ayar,reset;
output  [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
reg d_en=1'b0;
reg s_en=1'b0;

reg [3:0] saniye=4'd0;
reg [3:0] saniye2=4'd0;
reg [3:0] dakika=4'd0;
reg [3:0] dakika2=4'd0;
reg [3:0] saat=4'd0;
reg [3:0] saat2=4'd0;
reg [31:0] count=32'd0;

parameter BLANK = 7'h7f;
assign HEX6 = BLANK;
assign HEX7 = BLANK;
assign HEX0 = BLANK;
assign HEX1 = BLANK;

always @(posedge CLOCK_50,negedge reset)
begin
	
	if(~reset)
	begin
		saat=4'd0;
		saat2=4'd0;
		dakika=4'd0;
		dakika2=4'd0;
		saniye=4'd0;
		saniye2=4'd0;
	end
	else if(enable)
	begin
	count=count+1;
		if(count==50_000_000)
		begin
		count=0;
			if(saniye2==4'd5&saniye==4'd9)
			begin
				dakika=dakika+1;
				if(dakika==4'd10)
				begin
					dakika2=dakika2+1;
					dakika=4'd0;
				end
				saniye2=4'd0;
				saniye=4'd0;
			end
			else
			begin
				saniye=saniye+1;
				if(saniye==4'd10)
				begin
					saniye2=saniye2+1;
					saniye=4'd0;
				end
			end
			if(dakika2==4'd6)
			begin
				dakika2=4'd0;
				saat=saat+1;
			end
			if(saat==4'd10)
			begin
				saat2=saat2+1;
				saat=4'd0;
			end
			if(saat2==4'd2&saat==4'd4)
			begin
				saat=4'd0;
				saat2=4'd0;
			end
		end
	end
	else if( ~dakika_ayar)
	begin
		if(~dakika_ayar&d_en)
		begin
			if(dakika==4'd9)
			begin
				dakika=4'd0;
				if(dakika2==4'd5)
				begin
					dakika2=4'd0;
				end
				else
					dakika2=dakika2+1;
			end
			else
			begin
				dakika=dakika+1;
				d_en=1'd0;
			end
		end
	end
	else if (~saat_ayar)
	begin
	if(~saat_ayar&s_en)
	begin
		if(saat==4'd9)
		begin
			saat2=saat2+1;
			saat=4'd0;
		end
		else
		begin
			saat=saat+1;
			s_en=1'd0;
		end
		if(saat==4'd4&saat2==4'd2)
		begin
			saat=4'd0;
			saat2=4'd0;
		end
	end
end
	else if(dakika_ayar&saat_ayar)
	begin
		s_en=1'b1;
		d_en=1'b1;
	end
end

/*
always @ (negedge dakika_ayar,negedge saat_ayar)
begin

end
*/
/*
hex_7seg h0(saniye[3:0] ,HEX0);
hex_7seg h1(saniye2[3:0],HEX1);
*/
hex_7seg h2(dakika[3:0] ,HEX2);
hex_7seg h3(dakika2[3:0],HEX3);
hex_7seg h4(saat	[3:0] ,HEX4);
hex_7seg h5(saat2	[3:0] ,HEX5);

endmodule