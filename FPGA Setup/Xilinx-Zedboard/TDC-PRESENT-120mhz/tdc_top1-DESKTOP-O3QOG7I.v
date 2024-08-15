

module tdc_cou #(parameter size =40, parameter delsize=2)
(input clk,
input en,
output[(size*4)-1:0] out1
    );
    
  (* s = "true" *)   wire [size*4-1:0] co1;
  (* s = "true" *)   wire [size*4-1:0] do1;
  //(* s = "true" *)   wire [size*4-1:0] out1;
  (* s = "true" *)   reg [size*4-1:0] regOut;
  (* s = "true" *)   wire [4*delsize-1:0] delLATCH, delLUT;     
  //(* s = "true" *)   wire [4*delsize-1:0] delLATCH, delLUT;     


genvar i; genvar j;
    generate
        for(i = 1; i < 10; i = i+1) 
		  begin:gen_code_label5
		  //wire [40*i-1:0] out;
		  for(j = 0; j < 100*i; j = j+1)  // 25 
		  begin:gen_code_label6
		  
		   //RO_LUT5 ro(co1[i],co1[i-1], co1[i-2], co1[i+1] );
		   RO_Lut ro(co1[i]);
		   //RO1 ro(co1[i], en, out[j]);
		  
		  
		  end
		  //assign out1[i] = & out;
		  
		  end
	   endgenerate 
	  
	  
	  generate
        for(i = 10; i < 20; i = i+1) 
		  begin:gen_code_label7
		  //wire [40*i-1:0] out;
		  for(j = 0; j < 200*i; j = j+1)  // 25 
		  begin:gen_code_label8
		  
		   //RO_LUT5 ro(co1[i],co1[i-1], co1[i-2], co1[i+1] );
		   RO_Lut ro(co1[i]);
		   //RO1 ro(co1[i], en, out[j]);
		  
		  
		  end
		  //assign out1[i] = & out;
		  
		  end
	   endgenerate 




    generate
        for(i = 0; i < size; i = i+1) 
		  begin:gen_code_label1
            
				
				if (i==0) begin
				(* keep = "true" *) (* s = "true" *)    CARRY4 CARRY4_insti (
            .CO(co1[(((i+1)*4)-1):(i*4)]), // 4-bit carry out
            .O(), // 4-bit carry chain XOR data out
            .CI(), // 1-bit carry cascade input
            .CYINIT(delLUT[(delsize*4)-1]), // 1-bit carry initialization  delLUT[i]
            //.CYINIT(delLUT[delsize-1]), // 1-bit carry initialization  delLUT[i]
            .DI(4'h0), // 4-bit carry-MUX data in
            .S(4'hf) // 4-bit carry-MUX select input
            );
				end
				else begin
				
				 (* keep = "true" *) (* s = "true" *)    CARRY4 CARRY4_insti (
            .CO(co1[(((i+1)*4)-1):(i*4)]), // 4-bit carry out
            .O(), // 4-bit carry chain XOR data out
            .CI(co1[(i*4)-1]), // 1-bit carry cascade input
            .CYINIT(1'b0), // 1-bit carry initialization
            .DI(4'h0), // 4-bit carry-MUX data in
            .S(4'hf) // 4-bit carry-MUX select input
            );
				end
       end  
    endgenerate 


   generate
        for(i = 0; i < size*4; i = i+1) 
		  begin:gen_code_label2
			 (* s = "true" *)   LDPE #(
            .INIT(1'b0) // Initial value of latch (1'b0 or 1'b1)
            ) LDPE_insti (
            .Q(out1[i]), // Data output
            .PRE(1'b0), // Asynchronous clear/reset input
            .D(co1[i]), // Data input
            .G(clk), // Gate input
            .GE(1'b1) // Gate enable input
            );
				end
	endgenerate	
 
//INST "tp/gen_code_label2[124].LDPE_insti" AREA_GROUP = "pblock_1";
//LDCE LDCE_inst (
//.Q(Q), // Data output
//.CLR(CLR), // Asynchronous clear/reset input
//.D(D), // Data input
//.G(G), // Gate input
//.GE(GE) // Gate enable input
//);


//	 always @(posedge clk)
//	 begin
//	(* keep = "true" *) (* s = "true" *) Cout<=out1;
	 
//	 end
	 
////////////////////////// delay with LATCH
generate
        for(i = 0; i < delsize*4; i = i+1) 
		  begin:gen_code_label3
   
			if(i==0) begin
	
			 (* keep = "true" *) (* s = "true" *)            LUT5 #(
            .INIT(32'hffff0000) // Specify LUT Contents .INIT(32'h00000000)
                ) LUT1_insti (
                .O(delLUT[i]), // LUT general output
                //.I0(clk) // LUT input
                .I4(delLATCH[i]), // LUT input
                .I3(1'b0), // LUT input
                .I2(1'b0), // LUT input
                .I1(1'b0), // LUT input
                .I0(1'b0) // LUT input
                );
 
 
				 (* keep = "true" *) (* s = "true" *)    LDCE #(
            .INIT(1'b0) // Initial value of latch (1'b0 or 1'b1)
            ) LDCE_Delayi (
            //.Q(delLATCH[i]), // Data output
            .Q(delLATCH[i]), // Data output
            .CLR(1'b0), // Asynchronous clear/reset input
            .D(clk), // Data input
            .G(1'b1), // Gate input
            .GE(en) // Gate enable input
            );
	
			end
			else begin
	
				(* keep = "true" *) (* s = "true" *)  LUT5 #(
            .INIT(32'hffff0000) // Specify LUT Contents
                ) LUT1_insti (
                .O(delLUT[i]), // LUT general output
                .I4(delLATCH[i]), // LUT input
					 .I3(1'b0), // LUT input
                .I2(1'b0), // LUT input
                .I1(1'b0), // LUT input
                .I0(1'b0) // LUT input
                );
				(* keep = "true" *) (* s = "true" *)   LDCE #(
            .INIT(1'b0) // Initial value of latch (1'b0 or 1'b1)
            ) LDCE_Delayi (
            .Q(delLATCH[i]), // Data output
            .CLR(1'b0), // Asynchronous clear/reset input
            .D(delLUT[i-1]), // Data input
            .G(1'b1), // Gate input
            .GE(1'b1) // Gate enable input
            );	 
			end			 
        end
    endgenerate



    
endmodule
