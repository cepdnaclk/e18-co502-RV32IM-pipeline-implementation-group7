module ins_memory(
  input clock,
  input read,
  input [27:0] address,
  output reg [127:0] readdata,
  output reg busywait
);

  reg readaccess;

  // Declare memory array 1024x8-bits
  reg [7:0] memory_array [0:1023];

  // Initialize instruction memory
  initial begin
    $readmemh("instr_mem.mem", memory_array);
    busywait = 0;
    readaccess = 0;
  end

  // Detecting an incoming memory access
  always @(read) begin
    busywait = (read) ? 1 : 0;
    readaccess = (read) ? 1 : 0;
  end

  // Reading
  always @(posedge clock) begin
    if (readaccess) begin
      readdata <= {memory_array[address][7:0],
                  memory_array[address][15:8],
                  memory_array[address][23:16],
                  memory_array[address][31:24],
                  memory_array[address][39:32],
                  memory_array[address][47:40],
                  memory_array[address][55:48],
                  memory_array[address][63:56],
                  memory_array[address][71:64],
                  memory_array[address][79:72],
                  memory_array[address][87:80],
                  memory_array[address][95:88],
                  memory_array[address][103:96],
                  memory_array[address][111:104],
                  memory_array[address][119:112],
                  memory_array[address][127:120]};
      busywait = 0;
      readaccess = 0;
    end
  end

endmodule
