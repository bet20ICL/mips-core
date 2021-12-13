module state_machine(

    input logic       clk,
    output logic      PC_inc,
    output logic      IR_write,
    output logic      alu_op,
    output logic      mem_read,
    output logic      mem_write,
    output logic      reg_write,
    output logic[2:0] state

);
    logic[2:0]  state_next;

    initial begin
        state=0;
        state_next=0;
    end

    // check that the states are chaning correctly witht the clock
    
    always @(negedge clk) begin
        state_next=state_next+1;
        if (state_next==4) begin 
            state_next = 0;
        
        end
        
    end

    always_ff @(posedge clk) begin
        state <= state_next;
    end
        


endmodule