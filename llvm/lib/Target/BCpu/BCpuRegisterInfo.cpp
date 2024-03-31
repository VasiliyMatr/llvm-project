#include "llvm/CodeGen/TargetInstrInfo.h"

#include "BCpu.h"
#include "BCpuRegisterInfo.h"

using namespace llvm;

#define GET_REGINFO_TARGET_DESC
#include "BCpuGenRegisterInfo.inc"

BCpuRegisterInfo::BCpuRegisterInfo() : BCpuGenRegisterInfo(BCpu::R0) {
  BCPU_DUMP_LOCATION();
}
