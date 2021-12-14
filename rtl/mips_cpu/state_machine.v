module state_machine(

    input logic clk,
    //implement reset
    input logic reset,
    output logic[2:0] state

);
    logic[2:0]  state_next;

    initial begin
        state=0;
        state_next=0;
    end

    always @(negedge clk) begin
        state_next=state_next+1;
        if (state_next==4 || (state!=0 && state!=1 && state!=2 && state!=3 && state!=4)) begin 
            state_next = 0;
        end
    end

    always_ff @(posedge clk) begin
        state <= state_next;
        //maybe put negedge stuff after over here instead
    end
        


endmodule