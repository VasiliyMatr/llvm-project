#ifndef BCPUFRAMELOWERING_H
#define BCPUFRAMELOWERING_H

#include "llvm/CodeGen/TargetFrameLowering.h"

#include "BCpu.h"

namespace llvm {

class BCpuSubtarget;

class BCpuFrameLowering final : public TargetFrameLowering {
  const BCpuSubtarget &STI;

  void adjustReg(MachineBasicBlock &MBB, MachineBasicBlock::iterator MBBI,
                 const DebugLoc &DL, Register DestReg, Register SrcReg,
                 int64_t Val, MachineInstr::MIFlag Flag) const;

public:
  explicit BCpuFrameLowering(const BCpuSubtarget &STI)
      : TargetFrameLowering(TargetFrameLowering::StackGrowsDown, Align(4), 0),
        STI(STI) {
    BCPU_DUMP_LOCATION();
  }

  MachineBasicBlock::iterator
  eliminateCallFramePseudoInstr(MachineFunction &MF, MachineBasicBlock &MBB,
                                MachineBasicBlock::iterator I) const override;

  /// Insert prologue code into function
  void emitPrologue(MachineFunction &MF, MachineBasicBlock &MBB) const override;
  /// Insert epilogue code into function
  void emitEpilogue(MachineFunction &MF, MachineBasicBlock &MBB) const override;

  /// hasFP - Return true if the specified function should have a dedicated
  /// frame pointer register. For most targets this is true only if the function
  /// has variable sized allocas or if frame pointer elimination is disabled.
  bool hasFP(const MachineFunction &MF) const override;
};

} // namespace llvm

#endif // BCPUFRAMELOWERING_H
