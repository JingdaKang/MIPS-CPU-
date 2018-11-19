`include"./defines.v"
module alu(
  
  input [4:0]aluop_i,
  input [31:0]src0_i,//rs or shamt
  input [31:0]src1_i,//rd or transformed imm
  output [63:0]aluout_o,//32??????32??hi??32??lo??32?
  
  output zero_o
  );
  
  reg [31:0]logic_rlt;//logic
  reg [31:0]hi;
  reg [31:0]lo;
  reg [63:0]aluout_or;
  reg zero_or;
  reg signed[31:0] src0_is;
  reg signed[31:0] src1_is;
  integer i;
  assign aluout_o=aluout_or;
  assign zero_o=zero_or;
  
  
  always@(*)
  begin
    case(aluop_i)
      `ALUOP_AND:
        begin
        logic_rlt=src0_i&src1_i;
        aluout_or={32'd0,logic_rlt};
        lo=aluout_or[31:0];
        end 
      `ALUOP_OR:
        begin
        logic_rlt=src0_i|src1_i;
        aluout_or={32'd0,logic_rlt};
        lo=aluout_or[31:0];
        end
      `ALUOP_NOR:
        begin
        logic_rlt=~(src0_i|src1_i);
        aluout_or={32'd0,logic_rlt};
        lo=aluout_or[31:0];
        end
      `ALUOP_LUI:
        begin
        logic_rlt={src1_i[15:0],16'd0};
        aluout_or={32'd0,logic_rlt};
        lo=aluout_or[31:0];
        end
        
       `ALUOP_ADD:
        begin
        logic_rlt=src0_i+src1_i;
        aluout_or={32'd0,logic_rlt};
        lo=aluout_or[31:0];
        end
      `ALUOP_SUB:
        begin
        logic_rlt=src0_i-src1_i;
        aluout_or={32'd0,logic_rlt};
      
        lo=aluout_or[31:0];
        end
      `ALUOP_SLL:
        begin
        logic_rlt=src1_i<<src0_i;
        aluout_or={32'd0,logic_rlt};
        lo=aluout_or[31:0];
        end
      `ALUOP_SRL:
        begin
        logic_rlt=src1_i>>src0_i;
        aluout_or={32'd0,logic_rlt};
        lo=aluout_or[31:0];
        end
      `ALUOP_SRA:
        begin
        logic_rlt=src1_i>>src0_i;
        if((src1_i[31]==1)&&(src0_i>0))
          for(i=0;i<src0_i;i=i+1)
            logic_rlt[31-i]=1'd1;
        
        aluout_or={32'd0,logic_rlt};
        lo=aluout_or[31:0];
        end
      `ALUOP_SLT:
        begin
        src0_is=src0_i;
        src1_is=src1_i;
        logic_rlt=(src0_is<src1_is)?32'd1:32'd0;
       
        zero_or=(logic_rlt==0)?1'd0:1'd1;
        aluout_or={32'd0,logic_rlt};
        lo=aluout_or[31:0];
        end
      `ALUOP_SLTU:
        begin
        logic_rlt=(src0_i<src1_i)?32'd1:32'd0;
        zero_or=(logic_rlt==0)?1'd0:1'd1;
        aluout_or={32'd0,logic_rlt};
        lo=aluout_or[31:0];
        end
      `ALUOP_MULT:
        begin
        src0_is=src0_i;
        src1_is=src1_i;
        aluout_or=src0_is*src1_is;
        hi=aluout_or[63:32];
        lo=aluout_or[31:0];
        end
      `ALUOP_MULTU:
        begin
        aluout_or=src0_i*src1_i;
        hi=aluout_or[63:32];
        lo=aluout_or[31:0];
        end
      `ALUOP_DIV:
        begin
        src0_is=src0_i;
        src1_is=src1_i;
        hi=src0_is%src1_is;
        lo=src0_is/src1_is;
        aluout_or={hi,lo};
        end
      `ALUOP_DIVU:
        begin
        hi=src0_i%src1_i;
        lo=src0_i/src1_i;
        aluout_or={hi,lo};
        end
      default:
        aluout_or=64'd0;
        
       
    endcase
  end
endmodule
        
  
        

