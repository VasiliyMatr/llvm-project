#ifndef BCPUREGISTERINFO_H
#define BCPUREGISTERINFO_H

#include "BCpuFrameLowering.h"

#define GET_REGINFO_HEADER
#include "BCpuGenRegisterInfo.inc"

namespace llvm {

struct BCpuRegisterInfo : public BCpuGenRegisterInfo {
  BCpuRegisterInfo();
};

} // end namespace llvm

#endif // BCPUREGISTERINFO_H
