#include "llvm/Target/TargetMachine.h"

#include "BCpu.h"
#include "BCpuSubtarget.h"

using namespace llvm;

#define DEBUG_TYPE "bcpu-subtarget"

#define GET_SUBTARGETINFO_TARGET_DESC
#define GET_SUBTARGETINFO_CTOR
#include "BCpuGenSubtargetInfo.inc"

BCpuSubtarget::BCpuSubtarget(const StringRef &CPU, const StringRef &TuneCPU,
                             const StringRef &FS, const TargetMachine &TM)
    : BCpuGenSubtargetInfo(TM.getTargetTriple(), CPU, TuneCPU, FS) {
  BCPU_DUMP_LOCATION();
}
