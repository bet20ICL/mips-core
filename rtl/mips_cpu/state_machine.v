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
        PC_inc = 1;
        IR_write = 1;
        alu_op = 0;
        mem_read = 0;
        mem_write = 0;
        reg_write = 0;
    end
    
    always @(negedge clk) begin
        state_next=state_next+1;
        if (state_next==4) begin 
            state_next = 0;
        
        end
        
    end

    always_ff @(posedge clk) begin
        state <= state_next;
    end
        

    always_comb begin
        
        
        
    

 
        if(state==0) begin
            PC_inc = 1;
            IR_write = 1;
            alu_op = 0;
            mem_read = 0;
            mem_write = 0;
            reg_write = 0;
        end
        
    

        if (state==1) begin 
            PC_inc = 0;
            IR_write = 0;
            alu_op = 0;
            mem_read = 0;
            mem_write = 0;
            reg_write =0;
        end

        if (state==2) begin 
            PC_inc = 0;
            IR_write = 0;
            alu_op = 1;
            mem_read = 0;
            mem_write = 0;
            reg_write =0;
        end

        if (state==3) begin 
            PC_inc = 0;
            IR_write = 0;
            alu_op = 0;
            //combine these signals with control signals.
            mem_read = 1;
            mem_write = 1;
            reg_write =0;
        end

        if (state==4) begin 
            PC_inc = 0;
            IR_write = 0;
            alu_op = 0;
            mem_read = 0;
            mem_write = 0;
            reg_write = 1;
        end
    end


endmodule