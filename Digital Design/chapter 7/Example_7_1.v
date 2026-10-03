//Read and write operations of memory
//Memory xize is 64words of four bits each

module memory (Enable, ReadWrite, Address, DataIn, DataOut);
    input [3:0] DataIn; // 4-bit Data input
    input [5:0] Address; // This memory can accommodate 64 words, so we need 6 bits to address them
    output reg [3:0] DataOut; // 4-bit Data output
    reg [3:0] Mem [0:63];
    /*
    A memory in Verilog is declared with a reg keyword, using two-dimensional array. 

    reg [15:0] memword [0:1023];
    The first number determines the word length and second gives memory depth(the number of words)
    */

    always @ (Address, ReadWrite, DataIn)
    if (Enable) begin // Enable = 1, memory is enabled
        if (ReadWrite) DataOut = Mem [Address]; // Read operation when ReadWrite = 1
        else Mem [Address] = DataIn; // Write operation when ReadWrite = 0
    else DataOut = 4'bzzzz; // High impedance state when Enable is low
    end
endmodule