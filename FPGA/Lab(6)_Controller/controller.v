module controller
(
    input wire zero,
    input [2:0] phase,
    input [2:0] opcode,

    output reg sel,
    output reg rd,
    output reg ld_ir,
    output reg inc_pc,
    output reg halt,
    output reg ld_pc,
    output reg data_e,
    output reg ld_ac,
    output reg wr
);


localparam integer HLT = 3'b000,
                   SKZ = 3'b001,
                   ADD = 3'b010,
                   AND = 3'b011,
                   XOR = 3'b100,
                   LDA = 3'b101,
                   STO = 3'b110,
                   JMP = 3'b111;

localparam integer INST_ADDR  = 3'b000,
                   INST_FETCH = 3'b001,
                   INST_LOAD  = 3'b010,
                   IDLE       = 3'b011,
                   OP_ADDR    = 3'b100,
                   OP_FETCH   = 3'b101,
                   ALU_OP     = 3'b110,
                   STORE      = 3'b111;

always @(*) begin

   
    sel    = 0;
    rd     = 0;
    ld_ir  = 0;
    inc_pc = 0;
    halt   = 0;
    ld_pc  = 0;
    data_e = 0;
    ld_ac  = 0;
    wr     = 0;
	
	if (phase ==INST_ADDR)
	begin
		sel=1;
	end
	else if (phase== INST_FETCH)
	begin
		sel=1;
		rd=1;
	end
	else if (phase==INST_LOAD)
	begin
		sel=1;
		rd=1;
		ld_ir=1;
	end
	else if (phase == IDLE)
	begin
		sel   = 1;
		rd    = 1;
		ld_ir = 1;
	end
	else if (phase==OP_ADDR)
	begin
		inc_pc=1;
		if (opcode==HLT)
		begin
			halt=1;
		end
		else
		begin
			halt=0;
		end
		
	end
	else if (phase == OP_FETCH)
	begin
		if (opcode >= ADD && opcode<=LDA)
		begin
			rd = 1;
		end
		else
		begin
			rd=0;
		end
	end
	else if (phase == ALU_OP)
	begin

		if (opcode >= ADD && opcode <= LDA)
		begin
			rd = 1;
		end
		else
		begin
			rd=0;
		end

		 if ((opcode == SKZ )&& zero)
		begin
			inc_pc = 1;
		end
		else
		begin
			inc_pc=0;
		end

		if (opcode == JMP)
		begin
			ld_pc = 1;
		end
		else
		begin
			ld_pc=0;
		end

	 if (opcode == STO)
		begin
			data_e = 1;
		end
		else
		begin
			data_e=0;
		end

	end
	else if (phase == STORE)
	begin
		if (opcode >= ADD && opcode <= LDA)
		begin
			rd    = 1;
			ld_ac = 1;
		end
		else
		begin
			rd    = 0;
			ld_ac = 0;
		end

		if (opcode == JMP)
			ld_pc = 1;
		else
			ld_pc = 0;

		if (opcode == STO)
		begin
			data_e = 1;
			wr     = 1;
		end
		else
		begin
			data_e = 0;
			wr     = 0;
		end
	end
end
	
endmodule
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	