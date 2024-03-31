#ifndef BCPUINSTRINFO_H
#define BCPUINSTRINFO_H

#include "llvm/CodeGen/TargetInstrInfo.h"

#include "BCpuRegisterInfo.h"
#include "MCTargetDesc/BCpuInfo.h"

#define GET_INSTRINFO_HEADER
#include "BCpuGenInstrInfo.inc"

namespace llvm {

struct BCpuInstrInfo : public BCpuGenInstrInfo {
  BCpuInstrInfo();
};

} // namespace llvm

#endif // BCPUINSTRINFO_H
