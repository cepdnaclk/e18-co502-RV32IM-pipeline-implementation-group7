module ins_cache_memory (
    input                   clock,
    input                   reset,
    input                   in_read,
    input   [31:0]          in_address,
    output reg [31:0]       out_readdata,
    output reg              out_busywait,
    output                  out_MAIN_MEM_READ,
    output [27:0]           out_MAIN_MEM_ADDRESS,
    input  [127:0]          in_MAIN_MEM_READ_DATA,
    input                   in_MAIN_MEM_BUSY_WAIT
);
    // Declare cache memory array 256x8-bits 
    reg [127:0] data_array [8:0];
    // Declare tag array 256x8-bits 
    reg [24:0] tag_array [8:0];
    // Declare valid bit array 256x8-bits 
    reg [1:0] validBit_array [8:0];

    parameter IDLE = 1'b0, MEM_READ = 1'b1;
    reg [1:0] state, next_state;

    // Variables to handle state changes
    reg CURRENT_VALID;
    reg [24:0] CURRENT_TAG;
    reg [31:0] CURRENT_DATA;
    wire TAG_MATCH;

    // Temporary variable to hold the data from the cache
    reg [31:0] temporary_data;

    // Variables to hold the values of the memory module
    reg out_MAIN_MEM_READ;
    reg [27:0] out_MAIN_MEM_ADDRESS;
    wire [127:0] in_MAIN_MEM_READ_DATA;
    wire in_MAIN_MEM_BUSY_WAIT;

    reg readCache; // Reg to remember the read to cache signal until the posedge
    reg writeCache; // Reg to write the write cache signal until the posedge 

    reg writeCache_mem; // Write enable signal to write to the cache mem after a memory read 

    // Initiating the memory module
    // data_memory myDataMem (clock, reset, out_MAIN_MEM_READ, out_MAIN_MEM_WRITE, out_MAIN_MEM_ADDRESS,
    //         out_MAIN_MEM_WRITE_DATA, in_MAIN_MEM_READ_DATA, in_MAIN_MEM_BUSY_WAIT);

    // Decoding the address
    wire [24:0] tag;
    wire [2:0] index;
    wire [1:0] offset;
    assign tag = in_address[31:7];
    assign index = in_address[6:4];
    assign offset = in_address[3:2];

    // Loading data 
    always @ (*)
    begin
        #1 // Loading the current values
        CURRENT_VALID = validBit_array[index];
        CURRENT_DATA  = data_array[index];
        CURRENT_TAG   = tag_array[index];
    end

    // Tag matching
    assign #0.9 TAG_MATCH = (tag == CURRENT_TAG); //~(tag[2]^CURRENT_TAG[2]) && ~(tag[1]^CURRENT_TAG[1]) && ~(tag[0]^CURRENT_TAG[0]);
    reg [127:0] temp;
    // Putting data if read access
    always @(*)
    begin
        if (in_readaccess) // Detect the idle read status
        #1
        begin
            temp = data_array[index];
            // Fetching data
            case(offset)
                2'b00:
                    out_readdata = data_array[index][31:0];
                2'b01:
                    out_readdata = data_array[index][63:32];
                2'b10:
                    out_readdata = data_array[index][95:64];
                2'b11:
                    out_readdata = data_array[index][127:96];
            endcase
        end
    end

    // Detecting an incoming memory access
    reg in_readaccess;
    always @(in_read)
    begin
        if (in_read) 
        begin
            out_busywait = 1'b1;
            in_readaccess = 1'b1;
        end
    end

    // Combinational next state logic
    always @(*)
    begin
        case (state)
            IDLE:
                if (!CURRENT_VALID && (in_readaccess)) 
                    next_state = MEM_READ;
                else if (CURRENT_VALID && TAG_MATCH && (in_readaccess))
                    next_state = IDLE;
                else if (CURRENT_VALID && !TAG_MATCH && (in_readaccess))
                    next_state = MEM_READ;
            
            MEM_READ:
                if (in_MAIN_MEM_BUSY_WAIT)
                    next_state = MEM_READ; 
                else
                    next_state = IDLE;
            
        endcase
    end

    // Combinational output logic
    always @(*)
    begin
        if (in_readaccess)
        begin
            case(state)
                IDLE:
                begin
                    // Set main memory read and write signal to low
                    out_MAIN_MEM_READ = 1'b0;                  
                        
                    if (in_readaccess && TAG_MATCH && CURRENT_VALID)
                    begin
                        readCache = 1'b1; // Set read cache memory to high
                        // out_readdata = temporary_data; // Output the data
                    end
                    else
                        readCache = 1'b0; // Set the readCache signal to zero                    
                end
            
                MEM_READ: 
                begin
                    out_MAIN_MEM_READ = 1'b1;
                    // Set the address to the main memory
                    out_MAIN_MEM_ADDRESS = {tag, index};
                    
                    if (!in_MAIN_MEM_BUSY_WAIT)  
                        writeCache_mem = 1'b1;
                    else
                        writeCache_mem = 1'b0;
                end                
            endcase
        end
    end

    integer i;

    // Sequential logic for state transitioning 
    always @(posedge reset)
    begin
        if(reset)
        begin
            out_busywait = 1'b0;
            for (i=0; i<8; i=i+1) // Resetting the registers
            begin
                data_array[i] = 0;
                validBit_array[i] = 0;
            end
        end
    end

    // State change logic
    always @ (posedge clock)
    begin
        if (!reset)
            state <= next_state;
        else
        begin
            // Set the busy wait signal to 0
            state <= IDLE;
            next_state <= IDLE;
        end
    end

    // Writing cache after a memory read
    always @ (posedge clock)
    begin
        if (writeCache_mem)
        begin
            #1
            // Put the read data to the cache
            data_array[index] = in_MAIN_MEM_READ_DATA;
            tag_array[index] = tag;
            validBit_array[index] = 1'b1; // Set the valid bit after loading data
            writeCache_mem = 1'b0;
        end
    end

    // To deassert and write back to the posedge
    always @ (posedge clock)
    begin
        if (readCache)
        begin       
            out_busywait = 1'b0; // Set the busy wait signal to zero     
            readCache = 1'b0; // Pull the read signal to low
            in_readaccess = 1'b0; // Pull the read access signal to low
        end
    end

    /* Cache Controller FSM End */

endmodule
