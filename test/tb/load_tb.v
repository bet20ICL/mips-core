module load_tb(

);
    logic[31:0] address, datafromMem, regword, out_transformed, instr_word;



    


    initial begin
        
        //test load word:

        instr_word[31:26] = 35;
        datafromMem = 32'h12345678;
        #5;
        assert(out_transformed == 32'H78563412); //assert that bytes are converted from big to little endian: only test case
        #5;

        
        
        datafromMem=32'hA2345687;
        instr_word[31:26] = 32; //testing LB;
        address=4;
        #5;
        assert(out_transformed==32'hFFFFFF87)
        
        address=5;
        #5;
        assert(out_transformed==32'h00000056);
        
        address=6;
        #5;
        assert(out_transformed == 32'h00000034);
        
        address=7;
        #5;
        assert(out_transformed == 32'hFFFFFFA2);
        
        
        //testing LBU

        instr_word[31:26] = 36; //testing LB;
        address=4;
        datafromMem = 32'hA2345687;
        #5;
        assert(out_transformed==32'h00000087);
        #5;
        address=5;
        #5;
        assert(out_transformed==32'h00000056);
        #5;
        address=6;
        #5;
        assert(out_transformed == 32'h00000034);
        #5;
        address=7;
        #5;
        assert(out_transformed == 32'h000000A2);
        #5;

        
        //testing LH 

        instr_word[31:26] = 33;
        datafromMem=32'h87658381;
        address=4;
        #5;
        assert(out_transformed==32'hFFFF8765);
        address=2;
        #5;
        assert(out_transformed==32'hFFFF8381);

        datafromMem=32'h37654381;
        address=4;
        #5;
        assert(out_transformed==32'h00003765);
        address=2;
        #5;
        assert(out_transformed==32'h00004381);

        //testing LHU

        instr_word[31:26] = 37;
        datafromMem=32'h87658381;
        address=4;
        #5;
        assert(out_transformed==32'h00008765);
        address=2;
        #5;
        assert(out_transformed==32'h00008381);

        datafromMem=32'h37654381;
        address=4;
        #5;
        assert(out_transformed==32'h00003765);
        address=2;
        #5;
        assert(out_transformed==32'h00004381);

        //testing LUI

        instr_word = 32'h3C123456;  //corresponds to opcode 15 for LUI constant should be 3456
        #5;
        assert(out_transformed == 32'h34560000); //doesn't depend on adress or datafrommem also only zero extends so this should be only test case;

        //testing lwl
        //datafromMem=32'h37654381; still

        instr_word[31:26] = 34;
        regword = 32'h 12345678; //no sign/zero extension so no need to test other values in these datafromMem or regword
        address = 4;
        #5;
        assert(out_transformed == 32'h81436537);
        address=5;
        #5;
        assert(out_transformed == 32'h43653778);
        address=6;
        #5;
        assert(out_transformed == 32'h65375678);
        address=7;
        #5;
        assert(out_transformed == 32'h37345678);

        //testing lwr

        instr_word[31:26] = 38;
        regword = 32'h 12345678;
        address=4;
        #5;
        assert(out_transformed == 32'h12345681);
        address=5;
        #5;
        assert(out_transformed == 32'h12348143);
        address=6;
        #5;
        assert(out_transformed == 32'h12814365);
        address=7;
        #5;
        assert(out_transformed == 32'h81436537);



        


    end





        

    load_block dut(
        .address(address), .instr_word(instr_word), .datafromMem(datafromMem), .regword(regword), 
        .out_transformed(out_transformed)
    );


endmodule