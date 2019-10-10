module top(
    input clk,
    input [1:0]push_button,
    output out_p,
    output out_n
    );
    
wire cyclesflag;
wire reset;
wire push_btn;

reg key0_d1;
reg key0_d2;
reg key0_d3;

subcomponent rising_edge_synchronizer (
  clk, reset, input, edge );
  
subcomponent counter (
    clk, reset, enable, flag );
    
always @ (  posedge clk)
    begin 
        if ( clk == 1'b1 ) 
            begin
                key0_d1 <= push_button[0];
                key0_d2 <= key0_d1;
                key0_d3 <= key0_d2;
        end
    end
    
    assign reset = key0_d3;
    
rising_edge_synchronizer pushbutton1 (
            .clk(clk),
            .edge(push_btn),
            .input(push_button[1]),
            .reset(reset)
        );
        
counter cycleing5 (
            .clk(clk),
            .enable(push_btn),
            .flag(cyclesflag),
            .reset(reset)
        );
        
always @ (  posedge clk)
    
    begin 
        if ( reset == 1'b1 ) 
        begin
            out_p <= 1'b0;
        end
        else
        begin 
            if ( clk ) 
            begin
                if ( cyclesflag == 1'b1 ) 
                begin
                    out_p <= 1'b1;
                end
                else
                begin 
                    out_p <= 1'b0;
                end
            end
        end
    end
      
always @ (  posedge clk)
    begin 
        if ( reset == 1'b1 ) 
        begin
            out_n <= 1'b1;
        end
        else
        begin 
            if ( clk ) 
            begin
                if ( cyclesflag == 1'b1 ) 
                begin
                    out_n <= 1'b0;
                end
                else
                begin 
                    out_n <= 1'b1;
                end
            end
        end
    end
endmodule 
