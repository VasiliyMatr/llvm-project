#ifndef BCPUREGISTERINFO_H
#define BCPUREGISTERINFO_H

#include "BCpuFrameLowering.h"

#define GET_REGINFO_HEADER
#include "BCpuGenRegisterInfo.inc"

namespace llvm {

struct BCpuRegisterInfo final : public BCpuGenRegisterInfo {
  BCpuRegisterInfo();

  const MCPhysReg *getCalleeSavedRegs(const MachineFunction *MF) const override;

  BitVector getReservedRegs(const MachineFunction &MF) const override;

  const uint32_t *getCallPreservedMask(const MachineFunction &MF,
                                       CallingConv::ID CC) const override;

  bool eliminateFrameIndex(MachineBasicBlock::iterator II, int SPAdj,
                           unsigned FIOperandNum,
                           RegScavenger *RS = nullptr) const override;

  // Debug information queries.
  Register getFrameRegister(const MachineFunction &MF) const override;
};

} // end namespace llvm

#endif // BCPUREGISTERINFO_H
