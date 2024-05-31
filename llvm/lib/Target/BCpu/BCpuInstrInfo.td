// === Defines BCpu instruction info

// === Profiles and nodes

def SDT_BCpuCall : SDTypeProfile<0, -1, [SDTCisVT<0, i32>]>;

def SDT_BCpuBrCC : SDTypeProfile<0, 4,
    [SDTCisSameAs<0, 1>, SDTCisVT<2, OtherVT>, SDTCisVT<3, OtherVT>]>;

def SDT_BCpuCallSeqStart : SDCallSeqStart<
    [SDTCisVT<0, i32>, SDTCisVT<1, i32>]>;
def SDT_BCpuCallSeqEnd : SDCallSeqEnd<
    [SDTCisVT<0, i32>, SDTCisVT<1, i32>]>;

// These are target-independent nodes, but have target-specific formats.
def callseq_start : SDNode<"ISD::CALLSEQ_START", SDT_BCpuCallSeqStart,
    [SDNPHasChain, SDNPOutGlue]>;
def callseq_end : SDNode<"ISD::CALLSEQ_END", SDT_BCpuCallSeqEnd,
    [SDNPHasChain, SDNPOptInGlue, SDNPOutGlue]>;

def bcpu_ret : SDNode<"BCpuISD::RET", SDTNone,
    [SDNPHasChain, SDNPOptInGlue, SDNPVariadic]
>;

def bcpu_call : SDNode<"BCpuISD::CALL", SDT_BCpuCall,
    [SDNPHasChain, SDNPOptInGlue, SDNPOutGlue, SDNPVariadic]
>;

def bcpu_brcc : SDNode<"BCpuISD::BR_CC", SDT_BCpuBrCC,
    [SDNPHasChain]
>;

// === Include instr formats

include "BCpuInstrFormats.td"

// Pseudo instructions

let Defs = [R2], Uses = [R2] in {
def ADJCALLSTACKDOWN : BCpuPseudoInstr<(outs), (ins i32imm:$amt1, i32imm:$amt2),
    "# ADJCALLSTACKDOWN $amt1, $amt2", [(callseq_start timm:$amt1, timm:$amt2)]>;
def ADJCALLSTACKUP : BCpuPseudoInstr<(outs), (ins i32imm:$amt1, i32imm:$amt2),
    "# ADJCALLSTACKUP $amt1", [(callseq_end timm:$amt1, timm:$amt2)]>;
}

// === Operand, patterns and transformations

// Generic asm immediate
class ImmAsmOperand<string prefix, int width> : AsmOperandClass {
    let Name = prefix # "Imm" # width;
    let RenderMethod = "addImmOperands";
    let DiagnosticType = !strconcat("Invalid", Name);
}

// 16-bit signed immediate operand
def simm16 : Operand<i32>, ImmLeaf<i32, [{ return isInt<16>(Imm); }]> {
    let ParserMatchClass = ImmAsmOperand<"S", 16>;
    let EncoderMethod = "getSImm16OpValue";
    let DecoderMethod = "decodeSImmOperand<16>";
    let MCOperandPredicate = [{
        int64_t Imm;
        if (MCOp.evaluateAsConstantImm(Imm))
            return isInt<16>(Imm);
        return MCOp.isBareSymbolRef();
    }];
    let OperandType = "OPERAND_SIMM16";
    let OperandNamespace = "BCpuOp";
}

// 16-bit unsigned immediate operand
def uimm16 : Operand<i32>, ImmLeaf<i32, [{ return isInt<16>(Imm); }]> {
    let ParserMatchClass = ImmAsmOperand<"U", 16>;
    let EncoderMethod = "getUImm16OpValue";
    let DecoderMethod = "decodeUImmOperand<16>";
    let MCOperandPredicate = [{
        int64_t Imm;
        if (MCOp.evaluateAsConstantImm(Imm))
            return isInt<16>(Imm);
        return MCOp.isBareSymbolRef();
    }];
    let OperandType = "OPERAND_UIMM16";
    let OperandNamespace = "BCpuOp";
}

// 16-bit branch target
def btarget16 : Operand<OtherVT> {
    let ParserMatchClass = ImmAsmOperand<"S", 16>;
    let PrintMethod = "printBranchOperand";
    let EncoderMethod = "getBranchTarget16OpValue";
    let DecoderMethod = "decodeSImmOperand<16>";
    let MCOperandPredicate = [{
        int64_t Imm;
        if (MCOp.evaluateAsConstantImm(Imm))
            return isInt<16>(Imm);
        return MCOp.isBareSymbolRef();
    }];
    let OperandType = "OPERAND_PCREL";
}

// 16-bit call target
def ctarget16 : Operand<i32> {
    let ParserMatchClass = ImmAsmOperand<"S", 16>;
    let PrintMethod = "printBranchOperand";
    let EncoderMethod = "getBranchTarget16OpValue";
    let DecoderMethod = "decodeSImmOperand<16>";
    let MCOperandPredicate = [{
        int64_t Imm;
        if (MCOp.evaluateAsConstantImm(Imm))
            return isInt<16>(Imm);
        return MCOp.isBareSymbolRef();
    }];
    let OperandType = "OPERAND_PCREL";
}

// Selection DAG node for 16-bit lower immediate
def LI16 : SDNodeXForm<imm, [{
    auto val = static_cast<uint32_t>(N->getZExtValue()) & 0xffff;
    return CurDAG->getTargetConstant(val, SDLoc(N), MVT::i32);
}]>;

// Selection DAG node for 16-bit upper immediate
def HI16 : SDNodeXForm<imm, [{
    auto val = static_cast<uint64_t>(N->getZExtValue()) >> 16;
    return CurDAG->getTargetConstant(val, SDLoc(N), MVT::i32);
}]>;

// Pattern to match i32 to LI16
def i32li16 : Operand<i32>, PatLeaf<(i32 imm), [{
    auto low = N->getZExtValue() & 0xfffful;
    return low == N->getZExtValue();
}], LI16> {}

// Pattern to match i32 to HI16
def i32hi16 : Operand<i32>, PatLeaf<(i32 imm), [{
    auto high = N->getZExtValue() & 0xffff0000ul;
    return high == N->getZExtValue();
}], HI16> {}

// Frame index addressing mode
def AddrFI : ComplexPattern<iPTR, 1, "SelectAddrFI", [frameindex], []>;

// Base addr addressing mode
def BaseAddr : ComplexPattern<iPTR, 1, "SelectBaseAddr">;

// === Patterns for instr matching

class PatGpr<SDPatternOperator OpNode, BCpuInstr Instr>
    : Pat<(OpNode GPR:$r1), (Instr GPR:$r1)>;

class PatGprGpr<SDPatternOperator OpNode, BCpuInstr Instr>
    : Pat<(OpNode GPR:$r1, GPR:$r2), (Instr GPR:$r1, GPR:$r2)>;

class PatGprImm<SDPatternOperator OpNode, BCpuInstr Instr, ImmLeaf ImmType>
    : Pat<(i32 (OpNode (i32 GPR:$r1), ImmType:$r3_imm16)),
          (Instr GPR:$r1, ImmType:$r3_imm16)>;

class PatBcc<CondCode Cond, BCpuInstr Instr>
    : Pat<(bcpu_brcc GPR:$r1, GPR:$r2, Cond, bb:$r3_imm16),
          (Instr GPR:$r1, GPR:$r2, btarget16:$r3_imm16)>;

// === Instructions formats

let hasSideEffects = 0, mayLoad = 0, mayStore = 0,
isBranch = 1, isTerminator = 1 in
class BranchCC<bits<8> op, string opcodestr>
    : BCpuInstr<op, (outs), (ins GPR:$r1, GPR:$r2, btarget16:$r3_imm16),
              !strconcat(opcodestr, " $r1 $r2 $r3_imm16"), []>;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class ArithRR<bits<8> op, string opcodestr>
    : BCpuInstr<op, (outs GPR:$r1), (ins GPR:$r2, GPR:$r3_imm16),
              !strconcat(opcodestr, " $r1 $r2 $r3_imm16"), []>;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class ArithRI<bits<8> op, string opcodestr>
    : BCpuInstr<op, (outs GPR:$r1), (ins GPR:$r2, simm16:$r3_imm16),
              !strconcat(opcodestr, " $r1 $r2 $r3_imm16"), []>;

// === Instructions

// B: direct uncond branch
let hasSideEffects = 0, mayLoad = 0, mayStore = 0,
isBarrier = 1, isBranch = 1, isTerminator = 1,
r1 = 0, r2 = 0 in
def B : BCpuInstr<0xB0, (outs), (ins btarget16:$r3_imm16),
    "B $r3_imm16", [(br bb:$r3_imm16)]>;

// BL: branch and link reg (call)
let hasSideEffects = 0, mayLoad = 0, mayStore = 0,
isCall = 1, isBranch = 1, isTerminator = 1, r2 = 0 in
def BL : BCpuInstr<0xB1, (outs GPR:$r1), (ins ctarget16:$r3_imm16),
    "BL $r1 $r3_imm16", []>;

// BR: indirect branch
let hasSideEffects = 0, mayLoad = 0, mayStore = 0,
isCall = 1, isBranch = 1, isTerminator = 1, r2 = 0, r3_imm16 = 0 in
def BR : BCpuInstr<0xB2, (outs), (ins GPR:$r1),
    "BR $r1", [(brind GPR:$r1)]>;

// No BLR (indirect branch and link reg) support

// RET = BR R0
let isBarrier = 1, isReturn = 1, isTerminator = 1 in
def PseudoRET : BCpuPseudoInstr<(outs), (ins),
    "# PseudoRET", [(bcpu_ret)]>,
    PseudoInstExpansion<(BR R0)>;

// CALL = BL R0
let isCall = 1, Defs = [R0] in
def PseudoCALL : BCpuPseudoInstr<(outs), (ins ctarget16:$r3_imm16),
    "# PseudoCALL", [(bcpu_call tglobaladdr:$r3_imm16)]>,
    PseudoInstExpansion<(BL R0, ctarget16:$r3_imm16)>;

def BEQ  : BranchCC<0xBA, "B.EQ">;
def BNE  : BranchCC<0xBB, "B.NE">;
def BLE  : BranchCC<0xBC, "B.LE">;
def BGT  : BranchCC<0xBD, "B.GT">;
def BLEU  : BranchCC<0xBE, "B.LEU">;
def BGTU  : BranchCC<0xBF, "B.GTU">;

def : PatBcc<SETEQ, BEQ>;
def : PatBcc<SETNE, BNE>;
def : PatBcc<SETLE, BLE>;
def : PatBcc<SETGT, BGT>;
def : PatBcc<SETULE, BLEU>;
def : PatBcc<SETUGT, BGTU>;

// MOVli: move lower 16-bit immediate
let isAsCheapAsAMove = 1, isCodeGenOnly = 1, isReMaterializable = 1, r2 = 0 in
def MOVLI : BCpuInstr<0x10, (outs GPR:$r1), (ins i32li16:$r3_imm16),
                "MOVli $r1 $r3_imm16",
                [(set GPR:$r1, i32li16:$r3_imm16)]>;

// MOVhi: move high 16-bit immediate
let isAsCheapAsAMove = 1, isCodeGenOnly = 1,
    isReMaterializable = 1, r2 = 0 in
def MOVHI : BCpuInstr<0x11, (outs GPR:$r1), (ins i32hi16:$r3_imm16),
                     "MOVhi $r1 $r3_imm16",
                     [(set GPR:$r1, i32hi16:$r3_imm16)]>;

// STi: store with base reg and offset
let hasSideEffects = 0, mayLoad = 0, mayStore = 1 in
def STI : BCpuInstr<0x20, (outs), (ins GPR:$r1, GPR:$r2, simm16:$r3_imm16),
    "STi $r1 ${r2} ${r3_imm16}", []>;

def : Pat<(store (i32 GPR:$r1), BaseAddr:$r2),
    (STI GPR:$r1, BaseAddr:$r2, 0)>;
def : Pat<(store (i32 GPR:$r1), (add BaseAddr:$r2, simm16:$r3_imm16)),
    (STI GPR:$r1, BaseAddr:$r2, simm16:$r3_imm16)>;
def : Pat<(store (i32 GPR:$r1), (add AddrFI:$r2, simm16:$r3_imm16)),
    (STI GPR:$r1, AddrFI:$r2, simm16:$r3_imm16)>;

// LDi: load with base reg and offset
let hasSideEffects = 0, mayLoad = 1, mayStore = 0 in
def LDI: BCpuInstr<0x21, (outs GPR:$r1), (ins GPR:$r2, simm16:$r3_imm16),
    "LDi $r1 ${r2} ${r3_imm16}", []>;

def : Pat<(i32 (load BaseAddr:$r2)),
    (LDI BaseAddr:$r2, 0)>;
def : Pat<(i32 (load (add BaseAddr:$r2, simm16:$r3_imm16))),
    (LDI BaseAddr:$r2, simm16:$r3_imm16)>;
def : Pat<(i32 (load (add AddrFI:$r2, simm16:$r3_imm16))),
    (LDI AddrFI:$r2, simm16:$r3_imm16)>;

// Reg-reg arith
def ADD : ArithRR<0x30, "ADD">;  def : PatGprGpr<add,  ADD>;
def SUB : ArithRR<0x31, "SUB">;  def : PatGprGpr<sub,  SUB>;
def MUL : ArithRR<0x32, "MUL">;  def : PatGprGpr<mul,  MUL>;
def DIV : ArithRR<0x33, "DIV">;  def : PatGprGpr<sdiv, DIV>;
def OR  : ArithRR<0x34, "OR">;   def : PatGprGpr<or,   OR>;
def AND : ArithRR<0x35, "AND">;  def : PatGprGpr<and,  AND>;
def XOR : ArithRR<0x36, "XOR">;  def : PatGprGpr<xor,  XOR>;

// Reg-imm arith
def ADDI : ArithRI<0x40, "ADDi">; def : PatGprImm<add, ADDI, simm16>;
def MULI : ArithRI<0x41, "MULi">; def : PatGprImm<mul, MULI, simm16>;
def SHL : ArithRI<0x42, "SHL">; def : PatGprImm<shl, SHL, simm16>;
def SRL : ArithRI<0x43, "SRL">; def : PatGprImm<srl, SRL, simm16>;
def SRA : ArithRI<0x44, "SRA">; def : PatGprImm<sra, SRA, simm16>;
def ORI  : ArithRI<0x45, "ORi">;  def : PatGprImm<mul, ORI,  simm16>;

// window create
let r1 = 0, r2 = 0, r3_imm16 = 0 in
def WINDOW_CREATE : BCpuInstr<0xF0, (outs), (ins), "WINDOW_CREATE", [(int_bcpu_window_create)]>;

// window set pixel
def WINDOW_SET_PIXEL : BCpuInstr<0xF1, (outs), (ins GPR:$r1, GPR:$r2, GPR:$r3_imm16),
    "WINDOW_SET_PIXEL $r1 $r2 $r3_imm16", [(int_bcpu_window_set_pixel GPR:$r1, GPR:$r2, GPR:$r3_imm16)]>;

// window update
let r1 = 0, r2 = 0, r3_imm16 = 0 in
def WINDOW_UPDATE : BCpuInstr<0xF2, (outs), (ins), "WINDOW_UPDATE", [(int_bcpu_window_update)]>;

// mul fixed
def MUL_FIXED : BCpuInstr<0xF3, (outs GPR:$r1), (ins GPR:$r2, GPR:$r3_imm16),
    "MUL_FIXED $r1 $r2, $r3_imm16",
    [(set GPR:$r1, (int_bcpu_mul_fixed GPR:$r2, GPR:$r3_imm16))]>;

// div fixed
def DIV_FIXED : BCpuInstr<0xF4, (outs GPR:$r1), (ins GPR:$r2, GPR:$r3_imm16),
    "DIV_FIXED $r1 $r2, $r3_imm16",
    [(set GPR:$r1, (int_bcpu_div_fixed GPR:$r2, GPR:$r3_imm16))]>;

// === Other patterns

// mov i16 imm
def : Pat<(i32 i32li16:$r3_imm16), (MOVLI imm:$r3_imm16)>;

// mov i32 imm
def : Pat<(i32 imm:$imm), (ORI
        (MOVHI (HI16 imm:$imm)),
        (LI16 imm:$imm)
)>;



