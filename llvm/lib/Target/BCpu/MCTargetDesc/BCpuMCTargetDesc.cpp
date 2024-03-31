// BCpu target descriptions

#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/TargetRegistry.h"

#include "BCpu.h"
#include "TargetInfo/BCpuTargetInfo.h"
#include "BCpuMCTargetDesc.h"

using namespace llvm;

#define GET_REGINFO_MC_DESC
#include "BCpuGenRegisterInfo.inc"

static MCRegisterInfo *createBCpuMCRegisterInfo(const Triple &t) {
  BCPU_DUMP_LOCATION();

  MCRegisterInfo *reg_info = new MCRegisterInfo();
  InitBCpuMCRegisterInfo(reg_info, BCpu::R0);
  return reg_info;
}

// We need to define this function for linking succeed
extern "C" void LLVMInitializeBCpuTargetMC() {
  BCPU_DUMP_LOCATION();

  Target &bcpu_target = getBCpuTarget();
  // Register MC register info.
  TargetRegistry::RegisterMCRegInfo(bcpu_target, createBCpuMCRegisterInfo);
}
