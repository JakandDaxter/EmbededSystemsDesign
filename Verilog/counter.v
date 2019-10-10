module counter(
    input clk,
    input reset,
    input enable,
    output flag
    );

    reg [2:0]count;
    
    reg flag;
    
always @ (  posedge clk)
    begin 
        if ( reset == 1'b1 ) 
        begin
            count <= 3'b000;
        end
        else
        begin 
            if ( clk ) 
            begin
                if ( enable == 1'b1 ) 
                begin
                    if ( count > 3'b101 ) 
                    begin
                        count <= 3'b000;
                        flag <= 1'b0;
                    end
                    else
                    begin 
                        count <= ( count + 1'b1 );
                        flag <= 1'b1;
                    end
                end
                else
                begin 
                    flag <= 1'b0;
                end
            end
        end
    end
endmodule 
