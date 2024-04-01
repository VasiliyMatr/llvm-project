// Defines BCpu target

include "llvm/Target/Target.td"

include "BCpuRegisterInfo.td"
include "BCpuInstrInfo.td"
include "BCpuCallingConv.td"

class BCpuProcessor<string Name, list<SubtargetFeature> Features>: Processor<Name, NoItineraries, Features>;

// General purpose BCpu impl
def : BCpuProcessor<"BCpuA", []>;

def BCpuInstrInfo : InstrInfo;

def BCpu : Target {
    let InstructionSet = BCpuInstrInfo;
}
