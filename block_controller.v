`timescale 1ns / 1ps

module block_controller(
	input clk, //this clock must be a slow enough clock to view the changing positions of the objects
	input bright,
	input rst,
	input up, input down, input left, input right,
	input [9:0] hCount, vCount,
	output reg [11:0] rgb,
	output reg [11:0] background
   );
	wire block_fill;
	wire line1_fill;

	
	//these two values dictate the center of the block, incrementing and decrementing them leads the block to move in certain directions
	reg [9:0] xpos, ypos;
	
	parameter RED   = 12'b1111_0000_0000;
	
	/*when outputting the rgb value in an always block like this, make sure to include the if(~bright) statement, as this ensures the monitor 
	will output some data to every pixel and not just the images you are trying to display*/
	always@ (*) begin
    	if(~bright )	//force black if not inside the display area
			rgb = 12'b0000_0000_0000;
		else if (block_fill) 
			rgb = RED; 
		else if (line1_fill)
			rgb = 12'b0000_0000_0000;
		else	
			rgb=background;
	end
		//the +-5 for the positions give the dimension of the block (i.e. it will be 10x10 pixels)


	assign block_fill=vCount>=(ypos-5) && vCount<=(ypos+5) && hCount>=(xpos-5) && hCount<=(xpos+5);

	assign line1_fill=(vCount>=(168) && vCount<=(718) && hCount>=(78) && hCount<=(80))
	|| (vCount>=(168) && vCount<=(171) && hCount>=(79) && hCount<=(118))
	|| (vCount>=(168) && vCount<=(687) && hCount>=(115) && hCount<=(117))
	|| (vCount>=(716) && vCount<=(718) && hCount>=(80) && hCount<=(483))
	|| (vCount>=(685) && vCount<=(687) && hCount>=(117) && hCount<=(447))
	|| (vCount>=(207) && vCount<=(716) && hCount>=(481) && hCount<=(483))
	|| (vCount>=(685) && vCount<=(244) && hCount>=(447) && hCount<=(449))
	|| (vCount>=(206) && vCount<=(208) && hCount>=(154) && hCount<=(483))
	|| (vCount>=(206) && vCount<=(646) && hCount>=(154) && hCount<=(156))
	|| (vCount>=(244) && vCount<=(246) && hCount>=(188) && hCount<=(447))
	|| (vCount>=(244) && vCount<=(610) && hCount>=(190) && hCount<=(192))
	|| (vCount>=(646) && vCount<=(648) && hCount>=(156) && hCount<=(410))
	|| (vCount>=(610) && vCount<=(612) && hCount>=(192) && hCount<=(372))
	|| (vCount>=(648) && vCount<=(279) && hCount>=(408) && hCount<=(410))
	|| (vCount>=(610) && vCount<=(318) && hCount>=(371) && hCount<=(373))
	|| (vCount>=(279) && vCount<=(281) && hCount>=(226) && hCount<=(410))
	|| (vCount>=(280) && vCount<=(574) && hCount>=(225) && hCount<=(227))
	|| (vCount>=(316) && vCount<=(318) && hCount>=(373) && hCount<=(264))
	|| (vCount>=(318) && vCount<=(572) && hCount>=(262) && hCount<=(264))
	|| (vCount>=(572) && vCount<=(574) && hCount>=(225) && hCount<=(262));
    




	
	//line 1: 168 - 718, 78 - 80
	//line 2: 168 - 171, 79 - 118
	//line 3: 168 - 687, 115 - 117
	//line 4: 716 - 718, 80 - 483
	//line 5: 685 - 687, 117 - 447
	//line 6: 207 - 716, 481 - 483
	//line 7: 685 - 244, 447 - 449
	//line 8: 206 - 208, 154 - 483
	//line 9: 206 - 646. 154 - 156
	//line 10: 244 - 246, 188 - 447
	//line 11: 244 - 610, 190 - 192
	//line 12: 646 - 648, 156 - 410
	//line 13: 610 - 612, 192 - 372
	//line 14: 648 - 279, 408 - 410
	//line 15: 610 - 318, 371 - 373
	//line 16: 279 - 281, 226 - 410
	//line 17: 280 - 574, 225 - 227
	//line 18: 316 - 318, 373 - 264
	//line 19: 318 - 572, 262 - 264
	//line 20: 572 - 574, 225 - 262


	always@(posedge clk, posedge rst) 
	begin
		if(rst)
		begin 
			//rough values for center of screen
			xpos<=450;
			ypos<=250;
		end
		else if (clk) begin
		
		/* Note that the top left of the screen does NOT correlate to vCount=0 and hCount=0. The display_controller.v file has the 
			synchronizing pulses for both the horizontal sync and the vertical sync begin at vcount=0 and hcount=0. Recall that after 
			the length of the pulse, there is also a short period called the back porch before the display area begins. So effectively, 
			the top left corner corresponds to (hcount,vcount)~(144,35). Which means with a 640x480 resolution, the bottom right corner 
			corresponds to ~(783,515).  
		*/
			if(right) begin
				 //change the amount you increment to make the speed faster 
				if(xpos < 800) //these are rough values to attempt looping around, you can fine-tune them to make it more accurate- refer to the block comment above
					xpos<=xpos+1;
			end
			if(left) begin
				if(xpos > 150)
					xpos<=xpos-1;
			end
			if(up) begin
				if(ypos>34)
					ypos<=ypos-1;
			end
			if(down) begin
				if(ypos<514)
					ypos<=ypos+1;
			end
		end
	end
	
	//the background color reflects the most recent button press
	always@(posedge clk, posedge rst) begin
		if(rst)
			background <= 12'b1111_1111_1111;
		else 
			if(right)
				background <= 12'b1111_1111_0000;
			else if(left)
				background <= 12'b0000_1111_1111;
			else if(down)
				background <= 12'b0000_1111_0000;
			else if(up)
				background <= 12'b0000_0000_1111;
	end

	
	
endmodule
