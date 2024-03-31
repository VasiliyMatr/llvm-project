// Defines BCpu instruction info

// Profiles and nodes
def bcpu_ret: SDNode<"BCpuISD::RET", SDTNone, [SDNPHasChain, SDNPOptInGlue, SDNPVariadic]>;

// Include instr formats
include "BCpuInstrFormats.td"

// Operand, patterns and transformations
class BCpuImmAsmOperand<int width> : AsmOperandClass {
    let Name = "BCpuImm" # width;
    let RenderMethod = "addImmOperands";
    let DiagnosticType = !strconcat("Invalid", Name);
}

// For lower imm
def bcpu_imm20 : Operand<i32>, ImmLeaf<i32, [{return isInt<20>(Imm);}]> {
    let ParserMatchClass = BCpuImmAsmOperand<20>;
    let EncoderMethod = "getImmOpValue";
    let DecoderMethod = "decodeBCpuImmOperand<20>";
    let MCOperandPredicate = [{
        int64_t Imm;
        if (MCOp.evaluateAsConstantImm(Imm))
            return isInt<20>(Imm);
        return MCOp.isBareSymbolRef();
    }];
    let OperandType = "OPERAND_BCPU_IMM20";
    let OperandNamespace = "BCpuOp";
}

// Instructions

// br
let hasSideEffects = 0, mayLoad = 0, mayStore = 0, isCall = 1, isBranch = 1, isTerminator = 1 in
def BR : BCpuInstr<0x01, (outs), (ins GPR:$rs1), "BR $rs1", [(brind GPR:$rs1)]>;

// ret
let isBarrier = 1, isReturn = 1, isTerminator = 1 in
def PseudoRET : BCpuPseudoInstr<(outs), (ins), "# PseudoRET", [(bcpu_ret)]>,
                PseudoInstExpansion<(BR R0)>;

// movli
let isAsCheapAsAMove = 1, isCodeGenOnly = 1, isReMaterializable = 1 in
def MOVLI : BCpuInstr<0x02, (outs GPR:$rd), (ins bcpu_imm20:$imm),
                "MOVli $rd $imm", [(set GPR:$rd, bcpu_imm20:$imm)]>;
