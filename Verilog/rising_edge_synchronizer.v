module rising_edge_synchronizer(
    input clk,
    input reset,
    input input,
    output edge
    );
    
    reg input_z;
    reg input_zz;
    reg input_zzz;
    
always @ (  negedge reset or  posedge clk or  negedge input)
    begin 
        if ( reset == 1'b1 ) 
        begin
            input_z <= 1'b1;
            input_zz <= 1'b1;
        end
        else
        begin 
            if ( clk == 1'b1 ) 
            begin
                input_z <= input;
                input_zz <= input_z;
            end
        end
    end
    
always @ (  negedge reset or  posedge clk or  negedge input_zz)
    begin : rising_edge_detector
        if ( reset == 1'b1 ) 
        begin
            edge <= 1'b0;
            input_zzz <= 1'b1;
        end
        else
        begin 
            if ( clk == 1'b1 ) 
            begin
                input_zzz <= input_zz;
                edge <= ( ( input_zz ^ input_zzz ) & input_zz );
            end
        end
    end
    
endmodule 
