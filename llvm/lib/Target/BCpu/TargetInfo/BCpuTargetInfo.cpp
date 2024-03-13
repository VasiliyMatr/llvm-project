#include "TargetInfo/BCpuTargetInfo.h"
#include "llvm/MC/TargetRegistry.h"

using namespace llvm;

Target &llvm::getBCpuTarget() {
  static Target BCpuTarget;
  return BCpuTarget;
}

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeBCpuTargetInfo() {
  RegisterTarget<Triple::bcpu> reg_bcpu(getBCpuTarget(), "bcpu", "BCpu 32", "BCPU");
}
