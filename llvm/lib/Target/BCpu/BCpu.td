// Defines BCpu target

include "llvm/Target/Target.td"

include "BCpuRegisterInfo.td"
include "BCpuInstrInfo.td"

def BCpuInstrInfo : InstrInfo;

def BCpu : Target {
    let InstructionSet = BCpuInstrInfo;
}
