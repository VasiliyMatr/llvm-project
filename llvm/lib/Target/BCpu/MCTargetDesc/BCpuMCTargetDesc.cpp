// BCpu target descriptions

#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"

#include "BCpu.h"
#include "BCpuMCTargetDesc.h"
#include "MCTargetDesc/BCpuInfo.h"
#include "TargetInfo/BCpuTargetInfo.h"

using namespace llvm;

#define GET_REGINFO_MC_DESC
#include "BCpuGenRegisterInfo.inc"

#define GET_INSTRINFO_MC_DESC
#include "BCpuGenInstrInfo.inc"

#define GET_SUBTARGETINFO_MC_DESC
#include "BCpuGenSubtargetInfo.inc"

static MCRegisterInfo *createBCpuMCRegisterInfo(const Triple &TT) {
  BCPU_DUMP_LOCATION();

  MCRegisterInfo *reg_info = new MCRegisterInfo();
  InitBCpuMCRegisterInfo(reg_info, BCpu::R0);
  return reg_info;
}

static MCInstrInfo *createBCpuMCInstrInfo() {
  BCPU_DUMP_LOCATION();

  MCInstrInfo *instr_info = new MCInstrInfo();
  InitBCpuMCInstrInfo(instr_info);
  return instr_info;
}

static MCSubtargetInfo *createBCpuMCSubtargetInfo(const Triple &TT,
                                                  StringRef CPU, StringRef FS) {
  BCPU_DUMP_LOCATION();

  return createBCpuMCSubtargetInfoImpl(TT, CPU, /* TuneCPU */ CPU, FS);
}

// We need to define this function for linking succeed
extern "C" void LLVMInitializeBCpuTargetMC() {
  BCPU_DUMP_LOCATION();

  Target &bcpu_target = getBCpuTarget();

  // Register MC register info.
  TargetRegistry::RegisterMCRegInfo(bcpu_target, createBCpuMCRegisterInfo);
  // Register MC instruction info.
  TargetRegistry::RegisterMCInstrInfo(bcpu_target, createBCpuMCInstrInfo);
  // Register the MC subtarget info.
  TargetRegistry::RegisterMCSubtargetInfo(bcpu_target,
                                          createBCpuMCSubtargetInfo);
}
