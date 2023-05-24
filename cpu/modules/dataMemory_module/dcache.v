`timescale 1ns/100ps

module data_cache_memory(
    input				CLK,
    input           	RESET,
    input[3:0]          READ,
    input[2:0]          WRITE,
    input[31:0]      	ADDRESS,
    input[31:0]     	WRITE_DATA,
    input[127:0]        MEM_READ_DATA,
    input               MEM_BUSY_WAIT,

    output[127:0]       MEM_WRITE_DATA,
    output reg [31:0]	READ_DATA,
    output[27:0]        MEM_ADDRESS,
    output reg      	BUSY_WAIT,
    output              MAIN_MEM_READ,
    output              MAIN_MEM_WRITE
    );

    // Declare internal register arrays
    reg [127:0] cache [8:0];
    reg [24:0] tag_arr [8:0];
    reg [1:0] dirtyBit_arr [8:0];
    reg [1:0] validBit_arr [8:0];

    parameter   STATE_IDLE = 2'b00, 
                STATE_MEM_READ = 2'b01, 
                STATE_MEM_WRITE = 2'b10;

    reg [1:0] state, next_state;

    reg dirty, valid;
    reg [24:0] current_tag;
    wire hit;

    reg [31:0] tempory_data;

    reg MAIN_MEM_READ, MAIN_MEM_WRITE;
    reg [27:0] MEM_ADDRESS;
    reg [127:0] MEM_WRITE_DATA;
    wire [127:0] MEM_READ_DATA;
    wire MEM_BUSY_WAIT;
    
    reg [31:0] CACHE_READ_DATA,  CACHE_WRITE_DATA;
    reg READ_CACHE;
    reg WRITE_CACHE;

    reg WRITE_CACHE_MEM;

    wire [24:0] tag;
    wire [2:0] index;
    wire [1:0] offset, byte_offset;
    
    assign tag = ADDRESS[31:7];
    assign index = ADDRESS[6:4];
    assign offset = ADDRESS[3:2];
    assign byte_offset = ADDRESS[1:0];


    
    always @(*)
    begin
        case(READ[2:0])
            3'b000: // LB
            case (byte_offset)
                2'b00:
                    READ_DATA = {{24{CACHE_READ_DATA[7]}}, CACHE_READ_DATA[7:0]};
                2'b01:
                    READ_DATA = {{24{CACHE_READ_DATA[15]}}, CACHE_READ_DATA[15:8]};
                2'b10:
                    READ_DATA = {{24{CACHE_READ_DATA[23]}}, CACHE_READ_DATA[23:16]};
                2'b11:
                    READ_DATA = {{24{CACHE_READ_DATA[31]}}, CACHE_READ_DATA[31:24]};
            endcase
            3'b001: // LH
                case(byte_offset)
                    2'b00:
                        READ_DATA = {{16{CACHE_READ_DATA[15]}}, CACHE_READ_DATA[15:0]};
                    2'b10:
                        READ_DATA = {{16{CACHE_READ_DATA[31]}}, CACHE_READ_DATA[31:16]};
                endcase
            3'b010: // LW
                READ_DATA = CACHE_READ_DATA;
            3'b100: // LBU
                case (byte_offset)
                    2'b00:
                        READ_DATA = {24'b0, CACHE_READ_DATA[7:0]};
                    2'b01:
                        READ_DATA = {24'b0, CACHE_READ_DATA[15:8]};
                    2'b10:
                        READ_DATA = {24'b0, CACHE_READ_DATA[23:16]};
                    2'b11:
                        READ_DATA = {24'b0, CACHE_READ_DATA[31:24]};
                endcase
            3'b101: // LHU
                case(byte_offset)
                    2'b00:
                        READ_DATA = {16'b0, CACHE_READ_DATA[15:0]};
                    2'b10:
                        READ_DATA = {16'b0, CACHE_READ_DATA[31:16]};
                endcase
        endcase
    end
        


    // loading data 
    always @ (*)
    begin
        #1
        valid = validBit_arr[index];
        dirty = dirtyBit_arr[index];
        current_tag   = tag_arr[index];
    end


    assign #1 hit = ~(tag[2]^current_tag[2]) && ~(tag[1]^current_tag[1]) && ~(tag[0]^current_tag[0]);


    wire [127:0] block;

    assign block = cache[3'b001];
    always @(*)
    begin
        if (readaccess)
        #10
        begin
            case(offset)
                2'b00:
                    CACHE_READ_DATA = cache[index][31:0];
                2'b01:
                    CACHE_READ_DATA = cache[index][63:32];
                2'b10:
                    CACHE_READ_DATA = cache[index][95:64];
                2'b11:
                    CACHE_READ_DATA = cache[index][127:96];
            endcase
        end
    end

    reg readaccess, writeaccess;
    always @(READ, WRITE)
    begin
        if (!(READ === 4'bx || WRITE === 3'bx))
            BUSY_WAIT = (READ[3] || WRITE[2]);
        else
            BUSY_WAIT = 1'b0;
        readaccess = (READ[3] && !WRITE[2])? 1 : 0;
        writeaccess = (!READ[3] && WRITE[2])? 1 : 0;
    end

    always @(*)
    begin
        case (state)
            STATE_IDLE:
                if (!valid && (readaccess || writeaccess)) 
                    next_state = STATE_MEM_READ;
                else if (valid && hit && (readaccess || writeaccess))
                    next_state = STATE_IDLE;
                else if (valid && !dirty && !hit && (readaccess || writeaccess))
                    next_state = STATE_MEM_READ;
                else if (valid && dirty && !hit && (readaccess || writeaccess))
                    next_state = STATE_MEM_WRITE;
            
            STATE_MEM_READ:
                if (MEM_BUSY_WAIT)
                    next_state = STATE_MEM_READ; 
                else
                    next_state = STATE_IDLE;               


            STATE_MEM_WRITE:
                if (MEM_BUSY_WAIT)
                    next_state = STATE_MEM_WRITE;
                else   
                    begin 
                        //next_state = STATE_IDLE;
                        if (valid && !hit)
                            next_state = STATE_MEM_READ;
                        else
                            next_state = STATE_IDLE;
                    end
            
        endcase
    end
    
    // combinational output logic
    always @(*)
    begin
        if (readaccess || writeaccess)
        begin
            case(state)
                STATE_IDLE:
                begin
                    MAIN_MEM_READ = 1'b0;
                    MAIN_MEM_WRITE = 1'b0;    

                    if (readaccess && hit && valid)
                    begin
                        READ_CACHE = 1'b1;
                    end
                    else READ_CACHE = 1'b0;
                    

                    if (writeaccess && hit && valid)
                    begin                                               
                        WRITE_CACHE = 1'b1;
                    end
                    else WRITE_CACHE = 1'b0;
                    
                end
            
                STATE_MEM_READ: 
                begin
                    MAIN_MEM_READ = 1'b1;
                    MAIN_MEM_WRITE = 1'b0;
                    MEM_ADDRESS = {tag, index};

                    if (!MEM_BUSY_WAIT)  WRITE_CACHE_MEM = 1'b1;
                    else WRITE_CACHE_MEM = 1'b0; 
                end

                STATE_MEM_WRITE: 
                begin
                    MAIN_MEM_READ = 1'b0;
                    MAIN_MEM_WRITE = 1'b1;
                    MEM_ADDRESS = {tag_arr[index], index};
                    MEM_WRITE_DATA = cache[index];
                    if (!MEM_BUSY_WAIT)
                    begin
                        validBit_arr[index] = 1'b1;
                        dirtyBit_arr[index] = 1'b0;
                    end
                end
                
            endcase
        end
    end

    integer i;

    always @(posedge RESET)
    begin
        if(RESET)
        begin
            BUSY_WAIT = 1'b0;
            for (i=0;i<8; i=i+1)
                begin
                    cache[i] = 0;
                    validBit_arr[i] = 0;
                    dirtyBit_arr[i] = 0;
                end
        end
    end

    always @ (posedge CLK)
    begin
        if (!RESET)
            state = next_state;
        else
            begin
                state = STATE_IDLE;
                next_state = STATE_IDLE;
            end
    end

    always @ (posedge CLK)
    begin
        if (WRITE_CACHE_MEM)
        begin
            #1
            cache[index] = MEM_READ_DATA;
            tag_arr[index] = tag;
            validBit_arr[index] = 1'b1;
            dirtyBit_arr[index] = 1'b0;
            WRITE_CACHE_MEM = 1'b0;
        end
    end

    // calculating the byte mask
    reg [31:0] write_mask;
    always @ (*) 
    begin
        case (WRITE[1:0])
            2'b00: // SB
                case(byte_offset)
                    2'b00:
                        begin
                            write_mask = {{24{1'b1}}, 8'b0};
                            CACHE_WRITE_DATA = WRITE_DATA;
                        end
                    2'b01:
                        begin
                            write_mask = {{16{1'b1}}, 8'b0, {8{1'b1}}};
                            CACHE_WRITE_DATA = WRITE_DATA << 8;
                        end
                    2'b10:
                        begin
                            write_mask = {{8{1'b1}}, 8'b0, {16{1'b1}}};
                            CACHE_WRITE_DATA = WRITE_DATA << 16;
                        end
                    2'b11:
                        begin
                            write_mask = {8'b0, {24{1'b1}}};
                            CACHE_WRITE_DATA = WRITE_DATA << 24;
                        end
                endcase
            2'b01: // SH
                case(byte_offset)
                    2'b00:
                        begin
                            write_mask = {{16{1'b1}}, 16'b0};    
                            CACHE_WRITE_DATA = WRITE_DATA;
                        end
                    2'b10:
                        begin
                            write_mask = {16'b0, {16{1'b1}}};
                            CACHE_WRITE_DATA = WRITE_DATA << 16;
                        end
                endcase
                
            2'b10: // SW
                begin
                    write_mask = 32'b0;
                    CACHE_WRITE_DATA = WRITE_DATA;
                end
        endcase
    end

    always @ (posedge CLK)
    begin
        
        if (WRITE_CACHE) 
        begin
            case(offset)
                2'b00:
                    begin
                        cache[index][31:0] = (cache[index][31:0] & write_mask);
                        // #1
                        cache[index][31:0] = (cache[index][31:0] | CACHE_WRITE_DATA);
                    end
                2'b01:
                    begin
                        cache[index][63:32] = (cache[index][63:32] & write_mask);
                        // #1
                        cache[index][63:32] = (cache[index][63:32] | CACHE_WRITE_DATA);
                    end
                2'b10:
                    begin
                        cache[index][95:64] = (cache[index][95:64] & write_mask);
                        // #1
                        cache[index][95:64] = (cache[index][95:64] | CACHE_WRITE_DATA);
                    end
                2'b11:
                    begin
                        cache[index][127:96] = ( cache[index][127:96] & write_mask);
                        // #1
                        cache[index][127:96] = (cache[index][127:96] | CACHE_WRITE_DATA);
                    end
            endcase

            dirtyBit_arr[index] = 1'b1; 
            WRITE_CACHE = 1'b0;
            BUSY_WAIT = 1'b0;
        end

        if (READ_CACHE)
        begin       
            BUSY_WAIT = 1'b0;
            READ_CACHE = 1'b0;
        end
    end


endmodule