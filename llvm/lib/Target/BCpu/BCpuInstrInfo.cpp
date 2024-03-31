#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineMemOperand.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"

#include "BCpu.h"
#include "BCpuInstrInfo.h"

using namespace llvm;

#define GET_INSTRINFO_CTOR_DTOR
#include "BCpuGenInstrInfo.inc"

BCpuInstrInfo::BCpuInstrInfo() : BCpuGenInstrInfo() { BCPU_DUMP_LOCATION(); }
