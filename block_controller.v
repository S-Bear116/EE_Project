`timescale 1ns / 1ps

module block_controller(
	input clk, //this clock must be a slow enough clock to view the changing positions of the objects
	input bright,
	input rst,
	input up, input down, input left, input right,
	input [9:0] hCount, vCount,
	output reg [11:0] rgb,
	output reg [11:0] background,
	output q_I, q_PLAY, q_WIN, q_LOSS
   );
	wire block_fill;
	wire line1_fill;
	wire obst_fill;
	reg[1:0] dir1, dir2, dir3, dir4, dir5, dir6, dir7, dir8;
	
	reg[3:0] state; // the state variable
	assign {q_LOSS, q_WIN, q_PLAY, qI} = state;
	
	//these two values dictate the center of the block, incrementing and decrementing them leads the block to move in certain directions
	reg [9:0] xpos, ypos;
	reg [9:0] o1xpos, o1ypos;
	reg [9:0] o2xpos, o2ypos;
	reg [9:0] o3xpos, o3ypos;
	reg [9:0] o4xpos, o4ypos;
	reg [9:0] o5xpos, o5ypos;
	reg [9:0] o6xpos, o6ypos;
	reg [9:0] o7xpos, o7ypos;
	reg [9:0] o8xpos, o8ypos;
	
	parameter RED   = 12'b1111_0000_0000;
	parameter BLUE  = 12'b0000_0000_1111;
	parameter GREEN   = 12'b0000_1111_0000;

	
	localparam 	
	I = 4'b0001, PLAY = 4'b0010, WIN = 4'b0100, LOSS = 4'b1000, UNK = 4'bXXXX;
	
	/*when outputting the rgb value in an always block like this, make sure to include the if(~bright) statement, as this ensures the monitor 
	will output some data to every pixel and not just the images you are trying to display*/
	always@ (*) begin
    	if(~bright )	//force black if not inside the display area
			rgb = 12'b0000_0000_0000;
		if (goal_fill)
			rgb = GREEN;
		else if (obst_fill)
			rgb = BLUE;
		else if (block_fill) 
			rgb = RED; 
		else if (line1_fill)
			rgb = 12'b0000_0000_0000;
		else	
			rgb=background;
	end
		//the +-5 for the positions give the dimension of the block (i.e. it will be 10x10 pixels)


	assign block_fill= 
		vCount>=(ypos-5) && 
		vCount<=(ypos+5) && 
		hCount>=(xpos-5) && 
		hCount<=(xpos+5);



	assign obst_fill=
			(((hCount-o1xpos)*(hCount-o1xpos)+(vCount-o1ypos)*(vCount-o1ypos))<= 256)
		|| (((hCount-o2xpos)*(hCount-o2xpos)+(vCount-o2ypos)*(vCount-o2ypos))<= 256)
		|| (((hCount-o3xpos)*(hCount-o3xpos)+(vCount-o3ypos)*(vCount-o3ypos))<= 256)
		|| (((hCount-o4xpos)*(hCount-o4xpos)+(vCount-o4ypos)*(vCount-o4ypos))<= 256)
		|| (((hCount-o5xpos)*(hCount-o5xpos)+(vCount-o5ypos)*(vCount-o5ypos))<= 256)
		|| (((hCount-o6xpos)*(hCount-o6xpos)+(vCount-o6ypos)*(vCount-o6ypos))<= 256)
		|| (((hCount-o7xpos)*(hCount-o7xpos)+(vCount-o7ypos)*(vCount-o7ypos))<= 256)
		|| (((hCount-o8xpos)*(hCount-o8xpos)+(vCount-o8ypos)*(vCount-o8ypos))<= 256);

	


	assign line1_fill=
			(hCount>=(168) && hCount<=(718) && vCount>=(78) && vCount<=(80))
	    || (hCount>=(168) && hCount<=(171) && vCount>=(79) && vCount<=(118))
	    || (hCount>=(168) && hCount<=(687) && vCount>=(115) && vCount<=(117))
	    || (hCount>=(716) && hCount<=(718) && vCount>=(80) && vCount<=(483))
	    || (hCount>=(685) && hCount<=(687) && vCount>=(117) && vCount<=(447))
	    || (hCount>=(207) && hCount<=(716) && vCount>=(481) && vCount<=(483))
	    || (hCount>=(244) && hCount<=(685) && vCount>=(447) && vCount<=(449))
	    || (hCount>=(206) && hCount<=(208) && vCount>=(154) && vCount<=(483))
	    || (hCount>=(206) && hCount<=(646) && vCount>=(154) && vCount<=(156))
	    || (hCount>=(244) && hCount<=(246) && vCount>=(188) && vCount<=(447))
	    || (hCount>=(244) && hCount<=(610) && vCount>=(190) && vCount<=(192))
	    || (hCount>=(646) && hCount<=(648) && vCount>=(156) && vCount<=(410))
	    || (hCount>=(610) && hCount<=(612) && vCount>=(192) && vCount<=(372))
	    || (hCount>=(279) && hCount<=(648) && vCount>=(408) && vCount<=(410))
	    || (hCount>=(318) && hCount<=(610) && vCount>=(371) && vCount<=(373))
	    || (hCount>=(279) && hCount<=(281) && vCount>=(226) && vCount<=(410))
	    || (hCount>=(280) && hCount<=(574) && vCount>=(225) && vCount<=(227))
	    || (hCount>=(316) && hCount<=(318) && vCount>=(264) && vCount<=(373))
	    || (hCount>=(318) && hCount<=(572) && vCount>=(262) && vCount<=(264))
	    || (hCount>=(572) && hCount<=(574) && vCount>=(225) && vCount<=(262));

	assign goal_fill = ( hCount >= (536) && hCount <= (570) && vCount >= (227) && vCount <= (256));

	
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
			//avoiding recirculating mux on x position
			xpos<=10'bXXXXXXXXXX;
			ypos<=10'bXXXXXXXXXX;
			
			//obstacle 1
			o1xpos<=10'bXXXXXXXXXX;
			o1ypos<=10'bXXXXXXXXXX;
			dir1<=2'bXX;

			//obstacle 2
			o2xpos<=10'bXXXXXXXXXX;
			o2ypos<=10'bXXXXXXXXXX;
			dir2<=2'bXX;

			//obstacle 3
			o3xpos<=10'bXXXXXXXXXX;
			o3ypos<=10'bXXXXXXXXXX;
			dir3<=2'bXX;

			//obstacle 4
			o4xpos<=10'bXXXXXXXXXX;
			o4ypos<=10'bXXXXXXXXXX;
			dir4<=2'bXX;

			//obstacle 5
			o5xpos<=10'bXXXXXXXXXX;
			o5ypos<=10'bXXXXXXXXXX;
			dir5<=2'bXX;

			//obstacle 6
			o6xpos<=10'bXXXXXXXXXX;
			o6ypos<=10'bXXXXXXXXXX;
			dir6<=2'bXX;

			//obstacle 7
			o7xpos<=10'bXXXXXXXXXX;
			o7ypos<=10'bXXXXXXXXXX;
			dir7<=2'bXX;

			//obstacle 8
			o8xpos<=10'bXXXXXXXXXX;
			o8ypos<=10'bXXXXXXXXXX;
			dir8<=2'bXX;
			
			//start in initial state 
			state <= I;
		end
		else 
		begin
			case(state)
			
				I:
				begin
					//rough values for center of screen
					xpos<=187;
					ypos<=99;
					
					//stop at x=226
					o1xpos<=334;
					o1ypos<=98;
					dir1<=0;

					//stop at x=226
					o2xpos<=482;
					o2ypos<=98;
					dir2<=0;

					//stop at y=465
					o3xpos<=626;
					o3ypos<=98;
					dir3<=0;

					//stop at y=465
					o4xpos<=703;
					o4ypos<=169;
					dir4<=0;

					//stops at x=703
					o5xpos<=480;
					o5ypos<=465;
					dir5<=1;

					//stops at y=98
					o6xpos<=338;
					o6ypos<=465;
					dir6<=1;

					//stops at y=98
					o7xpos<=226;
					o7ypos<=430;
					dir7<=1;

					//stops at y=98
					o8xpos<=226;
					o8ypos<=281;
					dir8<=1;
					
					//start game automatically?
					state <= PLAY;
				end
				
				PLAY:
				begin
					if (clk) begin //move the ciurcle :)
						if(dir1 == 1)
						begin
							o1xpos<=o1xpos + 1;
							o1ypos<=o1ypos - 1;
							if(o1xpos >= 334)
								dir1<=0;
						end
						else
						begin
							o1xpos<=o1xpos - 1;
							o1ypos<=o1ypos + 1;
							if(o1xpos <= 226)
								dir1<=1;
						end

						if(dir2 == 1)
						begin
							o2xpos<=o2xpos + 1;
							o2ypos<=o2ypos - 1;
							if(o2xpos >= 482)
								dir2<=0;
						end
						else
						begin
							o2xpos<=o2xpos - 1;
							o2ypos<=o2ypos + 1;
							if(o2xpos <= 226)
								dir2<=1;
						end

						if(dir3 == 1)
						begin
							o3xpos<=o3xpos + 1;
							o3ypos<=o3ypos - 1;
							if(o3ypos <= 98)
								dir3<=0;
						end
						else
						begin
							o3xpos<=o3xpos - 1;
							o3ypos<=o3ypos + 1;
							if(o3ypos >= 465)
								dir3<=1;
						end

						if(dir4 == 1)
						begin
							o4xpos<=o4xpos + 1;
							o4ypos<=o4ypos - 1;
							if(o4ypos <= 169)
								dir4<=0;
						end
						else
						begin
							o4xpos<=o4xpos - 1;
							o4ypos<=o4ypos + 1;
							if(o4ypos >= 465)
								dir4<=1;
						end

						if(dir5 == 1)
						begin
							o5xpos<=o5xpos + 1;
							o5ypos<=o5ypos - 1;
							if(o5xpos >= 703)
								dir5<=0;
						end
						else
						begin
							o5xpos<=o5xpos - 1;
							o5ypos<=o5ypos + 1;
							if(o5xpos <= 465)
								dir5<=1;
						end

						if(dir6 == 1)
						begin
							o6xpos<=o6xpos + 1;
							o6ypos<=o6ypos - 1;
							if(o6ypos <= 98)
								dir6<=0;
						end
						else
						begin
							o6xpos<=o6xpos - 1;
							o6ypos<=o6ypos + 1;
							if(o6ypos >= 465)
								dir6<=1;
						end

						if(dir7 == 1)
						begin
							o7xpos<=o7xpos + 1;
							o7ypos<=o7ypos - 1;
							if(o7ypos <= 98)
								dir7<=0;
						end
						else
						begin
							o7xpos<=o7xpos - 1;
							o7ypos<=o7ypos + 1;
							if(o7ypos >= 430)
								dir7<=1;
						end

						if(dir8 == 1)
						begin
							o8xpos<=o8xpos + 1;
							o8ypos<=o8ypos - 1;
							if(o8ypos <= 98)
								dir8<=0;
						end
						else
						begin
							o8xpos<=o8xpos - 1;
							o8ypos<=o8ypos + 1;
							if(o8ypos >= 281)
								dir8<=1;
						end
					
						//moving the block
						
						if(right) begin
						 //change the amount you increment to make the speed faster 
						if(xpos < 800) //these are rough values to attempt looping around, you can fine-tune them to make it more accurate- refer to the block comment above
							xpos<=xpos+1;
							
							if( ((ypos > 78)  &&  (ypos < 80) && (xpos == 163)) ||
								((ypos > 79)  &&  (ypos < 118) && (xpos == 163)) ||
								((ypos > 115)  &&  (ypos < 117) && (xpos == 163)) ||
								((ypos > 80)  &&  (ypos < 483) && (xpos == 711)) ||
								((ypos > 117)  &&  (ypos < 447) && (xpos == 680)) ||
								((ypos > 481)  &&  (ypos < 483) && (xpos == 202)) ||
								((ypos > 447)  &&  (ypos < 449) && (xpos == 239)) ||
								((ypos > 154)  &&  (ypos < 483) && (xpos == 201)) ||
								((ypos > 154)  &&  (ypos < 156) && (xpos == 201)) ||
								((ypos > 188)  &&  (ypos < 447) && (xpos == 239)) ||
								((ypos > 190)  &&  (ypos < 192) && (xpos == 239)) ||
								((ypos > 156)  &&  (ypos < 410) && (xpos == 641)) ||
								((ypos > 192)  &&  (ypos < 372) && (xpos == 605)) ||
								((ypos > 408)  &&  (ypos < 410) && (xpos == 274)) ||
								((ypos > 371)  &&  (ypos < 373) && (xpos == 313)) ||
								((ypos > 226)  &&  (ypos < 410) && (xpos == 274)) ||
								((ypos > 225)  &&  (ypos < 227) && (xpos == 275)) ||
								((ypos > 264)  &&  (ypos < 373) && (xpos == 311)) ||
								((ypos > 262)  &&  (ypos < 264) && (xpos == 313)) ||
								((ypos > 225)  &&  (ypos < 262) && (xpos == 567)) )
							begin
								xpos <= xpos;
							end
						end
						
						if(left) begin
							if(xpos > 150)
								xpos<=xpos-1;
								
							if( ((ypos > 78)  &&  (ypos < 80) && (xpos == 723)) ||
								((ypos > 79)  &&  (ypos < 118) && (xpos == 176)) ||
								((ypos > 115)  &&  (ypos < 117) && (xpos == 692)) ||
								((ypos > 80)  &&  (ypos < 483) && (xpos == 723)) ||
								((ypos > 117)  &&  (ypos < 447) && (xpos == 692)) ||
								((ypos > 481)  &&  (ypos < 483) && (xpos == 721)) ||
								((ypos > 447)  &&  (ypos < 449) && (xpos == 690)) ||
								((ypos > 154)  &&  (ypos < 483) && (xpos == 213)) ||
								((ypos > 154)  &&  (ypos < 156) && (xpos == 651)) ||
								((ypos > 188)  &&  (ypos < 447) && (xpos == 251)) ||
								((ypos > 190)  &&  (ypos < 192) && (xpos == 615)) ||
								((ypos > 156)  &&  (ypos < 410) && (xpos == 653)) ||
								((ypos > 192)  &&  (ypos < 372) && (xpos == 617)) ||
								((ypos > 408)  &&  (ypos < 410) && (xpos == 653)) ||
								((ypos > 371)  &&  (ypos < 373) && (xpos == 615)) ||
								((ypos > 226)  &&  (ypos < 410) && (xpos == 286)) ||
								((ypos > 225)  &&  (ypos < 227) && (xpos == 579)) ||
								((ypos > 264)  &&  (ypos < 373) && (xpos == 323)) ||
								((ypos > 262)  &&  (ypos < 264) && (xpos == 577)) ||
								((ypos > 225)  &&  (ypos < 262) && (xpos == 579))  )
							begin
								xpos <= xpos;
							end
						end
						
						if(up) begin
							if(ypos>34)
								ypos<=ypos-1;
								
							if( ((xpos > 168)  &&  (xpos < 718) && (ypos == 85)) ||
								((xpos > 168)  &&  (xpos < 171) && (ypos == 123)) ||
								((xpos > 168)  &&  (xpos < 687) && (ypos == 122)) ||
								((xpos > 716)  &&  (xpos < 718) && (ypos == 488)) ||
								((xpos > 685)  &&  (xpos < 687) && (ypos == 452)) ||
								((xpos > 207)  &&  (xpos < 716) && (ypos == 488)) ||
								((xpos > 244)  &&  (xpos < 685) && (ypos == 454)) ||
								((xpos > 206)  &&  (xpos < 208) && (ypos == 488)) ||
								((xpos > 206)  &&  (xpos < 646) && (ypos == 161)) ||
								((xpos > 244)  &&  (xpos < 246) && (ypos == 452)) ||
								((xpos > 244)  &&  (xpos < 610) && (ypos == 197)) ||
								((xpos > 646)  &&  (xpos < 648) && (ypos == 415)) ||
								((xpos > 610)  &&  (xpos < 612) && (ypos == 377)) ||
								((xpos > 279)  &&  (xpos < 648) && (ypos == 415)) ||
								((xpos > 318)  &&  (xpos < 610) && (ypos == 378)) ||
								((xpos > 279)  &&  (xpos < 281) && (ypos == 415)) ||
								((xpos > 280)  &&  (xpos < 574) && (ypos == 232)) ||
								((xpos > 316)  &&  (xpos < 318) && (ypos == 378)) ||
								((xpos > 318)  &&  (xpos < 572) && (ypos == 269)) ||
								((xpos > 572)  &&  (xpos < 574) && (ypos == 267)) )
								begin
									ypos <= ypos;
								end
						end
						
						if(down) begin
							if(ypos<514)
								ypos<=ypos+1;
							
							if (((xpos > 168)  &&  (xpos < 718) && (ypos == 73)) ||
								((xpos > 168)  &&  (xpos < 171) && (ypos == 74)) ||
								((xpos > 168)  &&  (xpos < 687) && (ypos == 110)) ||
								((xpos > 716)  &&  (xpos < 718) && (ypos == 75)) ||
								((xpos > 685)  &&  (xpos < 687) && (ypos == 112)) ||
								((xpos > 207)  &&  (xpos < 716) && (ypos == 476)) ||
								((xpos > 244)  &&  (xpos < 685) && (ypos == 442)) ||
								((xpos > 206)  &&  (xpos < 208) && (ypos == 149)) ||
								((xpos > 206)  &&  (xpos < 646) && (ypos == 149)) ||
								((xpos > 244)  &&  (xpos < 246) && (ypos == 183)) ||
								((xpos > 244)  &&  (xpos < 610) && (ypos == 185)) ||
								((xpos > 646)  &&  (xpos < 648) && (ypos == 151)) ||
								((xpos > 610)  &&  (xpos < 612) && (ypos == 187)) ||
								((xpos > 279)  &&  (xpos < 648) && (ypos == 403)) ||
								((xpos > 318)  &&  (xpos < 610) && (ypos == 366)) ||
								((xpos > 279)  &&  (xpos < 281) && (ypos == 221)) ||
								((xpos > 280)  &&  (xpos < 574) && (ypos == 220)) ||
								((xpos > 316)  &&  (xpos < 318) && (ypos == 259)) ||
								((xpos > 318)  &&  (xpos < 572) && (ypos == 257)) ||
								((xpos > 572)  &&  (xpos < 574) && (ypos == 220)) )
							begin
								ypos <= ypos;
							end
						end
						
						//now check for goal zone
						if(goal_fill && block_fill)
							state <= WIN;
							
						//now check for collisions with obstacles
						if(block_fill && obst_fill)
							state <= LOSS;
							
					end
				end
				
				WIN:
				begin
					//background <= GREEN;
					
					//use the left button as ACk
					if(left)
						state <= I;
				end
				
				LOSS: 
				begin
					//background <= RED;
					
					//use the left button as ACk
					if(left) 
						state <= I;
				end
			endcase
        end
	end
	
	//the background color reflects the most recent button press
	
	always@(posedge clk, posedge rst) begin
		if(rst)
			background <= 12'b1111_1111_1111;
	end
    
	
	
endmodule
