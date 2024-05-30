#include <algorithm>

#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/CodeGen/RegisterScavenging.h"
#include "llvm/CodeGen/TargetRegisterInfo.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"

#include "BCpuFrameLowering.h"
// #include "BCpuMachineFunctionInfo.h"
#include "BCpuSubtarget.h"

#define DEBUG_TYPE "bcpu-frame-lowering"

using namespace llvm;

void BCpuFrameLowering::adjustReg(MachineBasicBlock &MBB,
                                  MachineBasicBlock::iterator MBBI,
                                  const DebugLoc &DL, Register DestReg,
                                  Register SrcReg, int64_t Val,
                                  MachineInstr::MIFlag Flag) const {
  const BCpuInstrInfo *TII = STI.getInstrInfo();

  if (DestReg == SrcReg && Val == 0)
    return;

  if (isInt<16>(Val)) {
    BuildMI(MBB, MBBI, DL, TII->get(BCpu::ADDI), DestReg)
        .addReg(SrcReg)
        .addImm(Val)
        .setMIFlag(Flag);
  } else {
    // TODO: cycle
    llvm_unreachable("Only 16-bit reg adjustment is supported");
  }
}

void BCpuFrameLowering::emitPrologue(MachineFunction &MF,
                                     MachineBasicBlock &MBB) const {
  MachineFrameInfo &MFI = MF.getFrameInfo();
  MachineBasicBlock::iterator MBBI = MBB.begin();

  Register SPReg = BCpu::R1;

  // Debug location must be unknown since the first debug location is used
  // to determine the end of the prologue.
  DebugLoc DL;

  // Align func frame size
  uint64_t StackSize =
      alignTo(MFI.getStackSize() + MFI.getMaxCallFrameSize(), getStackAlign());
  MFI.setStackSize(StackSize);

  if (!isInt<16>(StackSize)) {
    // Stack offset won't fit in LDi
    llvm_unreachable("Stack frame size greater than 64k is not supported");
  }

  // Early exit if there is no need to allocate on the stack
  if (StackSize == 0 && !MFI.adjustsStack())
    return;

  // Allocate space on the stack if necessary.
  adjustReg(MBB, MBBI, DL, SPReg, SPReg, -StackSize, MachineInstr::FrameSetup);

  if (!hasFP(MF)) {
    return;
  }

  llvm_unreachable("No FP support!");
}

void BCpuFrameLowering::emitEpilogue(MachineFunction &MF,
                                     MachineBasicBlock &MBB) const {
  MachineFrameInfo &MFI = MF.getFrameInfo();
  Register SPReg = BCpu::R1;

  uint64_t StackSize = MFI.getStackSize();

  // Early exit if there is no need to deallocate the stack
  if (StackSize == 0 && !MFI.adjustsStack()) {
    return;
  }

  // Get the insert location for the epilogue. If there were no terminators in
  // the block, get the last instruction.
  MachineBasicBlock::iterator MBBI = MBB.end();
  DebugLoc DL;
  if (!MBB.empty()) {
    MBBI = MBB.getFirstTerminator();
    if (MBBI == MBB.end())
      MBBI = MBB.getLastNonDebugInstr();
    DL = MBBI->getDebugLoc();

    // If this is not a terminator, the actual insert location should be after
    // the last instruction.
    if (!MBBI->isTerminator())
      MBBI = std::next(MBBI);

    // Skip FrameDestroy instructions
    // TODO: is it necessary?
    while (MBBI != MBB.begin()) {
      if (!std::prev(MBBI)->getFlag(MachineInstr::FrameDestroy))
        break;
      --MBBI;
    }
  }

  // Deallocate stack
  adjustReg(MBB, MBBI, DL, SPReg, SPReg, StackSize, MachineInstr::FrameDestroy);
}

bool BCpuFrameLowering::hasFP(const MachineFunction &MF) const {
  const MachineFrameInfo &MFI = MF.getFrameInfo();
  const BCpuRegisterInfo *RI = STI.getRegisterInfo();

  assert(!MFI.hasVarSizedObjects() && "No var sized objs support");
  assert(!RI->hasStackRealignment(MF) && "No stack realignment support");

  return false;
}

MachineBasicBlock::iterator BCpuFrameLowering::eliminateCallFramePseudoInstr(
    MachineFunction &MF, MachineBasicBlock &MBB,
    MachineBasicBlock::iterator MI) const {
  Register SPReg = BCpu::R1;
  DebugLoc DL = MI->getDebugLoc();

  if (!hasReservedCallFrame(MF)) {
    // If space has not been reserved for a call frame, ADJCALLSTACKDOWN and
    // ADJCALLSTACKUP must be converted to instructions manipulating the stack
    // pointer. This is necessary when there is a variable length stack
    // allocation (e.g. alloca), which means it's not possible to allocate
    // space for outgoing arguments from within the function prologue.
    int64_t Amount = MI->getOperand(0).getImm();

    if (Amount != 0) {
      // Ensure the stack remains aligned after adjustment.
      Amount = alignSPAdjust(Amount);

      if (MI->getOpcode() == BCpu::ADJCALLSTACKDOWN)
        Amount = -Amount;

      adjustReg(MBB, MI, DL, SPReg, SPReg, Amount, MachineInstr::NoFlags);
    }
  }

  return MBB.erase(MI);
}
