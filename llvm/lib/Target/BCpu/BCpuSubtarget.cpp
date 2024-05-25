#include "llvm/Target/TargetMachine.h"

#include "BCpu.h"
#include "BCpuSubtarget.h"

using namespace llvm;

#define DEBUG_TYPE "bcpu-subtarget"

#define GET_SUBTARGETINFO_TARGET_DESC
#define GET_SUBTARGETINFO_CTOR
#include "BCpuGenSubtargetInfo.inc"

BCpuSubtarget::BCpuSubtarget(const Triple &TT, const StringRef &CPU,
                             const StringRef &FS, const TargetMachine &TM)
    : BCpuGenSubtargetInfo(TM.getTargetTriple(), CPU, /* TuneCPU = */ CPU, FS),
      InstrInfo(), FrameLowering(*this), TLInfo(TM, *this) {
  BCPU_DUMP_LOCATION();
}
