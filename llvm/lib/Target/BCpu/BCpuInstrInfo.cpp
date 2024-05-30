#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineMemOperand.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"

#include "BCpu.h"
#include "BCpuInstrInfo.h"

using namespace llvm;

#define GET_INSTRINFO_CTOR_DTOR
#include "BCpuGenInstrInfo.inc"

BCpuInstrInfo::BCpuInstrInfo() : BCpuGenInstrInfo() {}

// unsigned BCpuInstrInfo::isLoadFromStackSlot(const MachineInstr &MI,
//                                             int &FrameIndex) const {
//   llvm_unreachable("");
// }

// unsigned BCpuInstrInfo::isStoreToStackSlot(const MachineInstr &MI,
//                                            int &FrameIndex) const {
//   llvm_unreachable("");
// }

static BCpuCC::CondCode getCondFromBranchOpc(unsigned Opc) {
  switch (Opc) {
  case BCpu::BEQ:
    return BCpuCC::EQ;
  case BCpu::BNE:
    return BCpuCC::NE;
  case BCpu::BLE:
    return BCpuCC::LE;
  case BCpu::BGT:
    return BCpuCC::GT;
  case BCpu::BLEU:
    return BCpuCC::LEU;
  case BCpu::BGTU:
    return BCpuCC::GTU;

  default:
    return BCpuCC::INVALID;
  }
}

static void parseCondBranch(MachineInstr &LastInst, MachineBasicBlock *&Target,
                            SmallVectorImpl<MachineOperand> &Cond) {
  // Block ends with fall-through condbranch.
  assert(LastInst.getDesc().isConditionalBranch() &&
         "Unknown conditional branch");

  Target = LastInst.getOperand(2).getMBB();
  unsigned CC = getCondFromBranchOpc(LastInst.getOpcode());
  Cond.push_back(MachineOperand::CreateImm(CC));
  Cond.push_back(LastInst.getOperand(0));
  Cond.push_back(LastInst.getOperand(1));
}

const MCInstrDesc &BCpuInstrInfo::getBrCond(BCpuCC::CondCode CC) const {
  switch (CC) {
  case BCpuCC::EQ:
    return get(BCpu::BEQ);
  case BCpuCC::NE:
    return get(BCpu::BNE);
  case BCpuCC::LE:
    return get(BCpu::BLE);
  case BCpuCC::GT:
    return get(BCpu::BGT);
  case BCpuCC::LEU:
    return get(BCpu::BLEU);
  case BCpuCC::GTU:
    return get(BCpu::BGTU);

  default:
    llvm_unreachable("Unknown condition code!");
  }
}

BCpuCC::CondCode BCpuCC::getOppositeBranchCondition(BCpuCC::CondCode CC) {
  switch (CC) {
  case BCpuCC::EQ:
    return BCpuCC::NE;
  case BCpuCC::NE:
    return BCpuCC::EQ;
  case BCpuCC::LE:
    return BCpuCC::GT;
  case BCpuCC::GT:
    return BCpuCC::LE;
  case BCpuCC::LEU:
    return BCpuCC::GTU;
  case BCpuCC::GTU:
    return BCpuCC::LEU;

  default:
    llvm_unreachable("Unknown condition code!");
  }
}

bool BCpuInstrInfo::analyzeBranch(MachineBasicBlock &MBB,
                                  MachineBasicBlock *&TBB,
                                  MachineBasicBlock *&FBB,
                                  SmallVectorImpl<MachineOperand> &Cond,
                                  bool AllowModify) const {
  TBB = FBB = nullptr;
  Cond.clear();

  // If the block has no terminators, it just falls into the block after it.
  MachineBasicBlock::iterator I = MBB.getLastNonDebugInstr();
  if (I == MBB.end() || !isUnpredicatedTerminator(*I))
    return false;

  // Count the number of terminators and find the first unconditional or
  // indirect branch.
  MachineBasicBlock::iterator FirstUncondOrIndirectBr = MBB.end();
  int NumTerminators = 0;
  for (auto J = I.getReverse(); J != MBB.rend() && isUnpredicatedTerminator(*J);
       J++) {
    NumTerminators++;
    if (J->getDesc().isUnconditionalBranch() ||
        J->getDesc().isIndirectBranch()) {
      FirstUncondOrIndirectBr = J.getReverse();
    }
  }

  // If AllowModify is true, we can erase any terminators after
  // FirstUncondOrIndirectBR.
  if (AllowModify && FirstUncondOrIndirectBr != MBB.end()) {
    while (std::next(FirstUncondOrIndirectBr) != MBB.end()) {
      std::next(FirstUncondOrIndirectBr)->eraseFromParent();
      NumTerminators--;
    }
    I = FirstUncondOrIndirectBr;
  }

  // Can't handle indirect branch.
  if (I->getDesc().isIndirectBranch())
    return true;

  // We can't handle blocks with more than 2 terminators.
  if (NumTerminators > 2)
    return true;

  // Handle a single unconditional branch.
  if (NumTerminators == 1 && I->getDesc().isUnconditionalBranch()) {
    TBB = getBranchDestBlock(*I);
    return false;
  }

  // Handle a single conditional branch.
  if (NumTerminators == 1 && I->getDesc().isConditionalBranch()) {
    parseCondBranch(*I, TBB, Cond);
    return false;
  }

  // Handle a conditional branch followed by an unconditional branch.
  if (NumTerminators == 2 && std::prev(I)->getDesc().isConditionalBranch() &&
      I->getDesc().isUnconditionalBranch()) {
    parseCondBranch(*std::prev(I), TBB, Cond);
    FBB = getBranchDestBlock(*I);
    return false;
  }

  // Otherwise, we can't handle this.
  return true;
}

unsigned BCpuInstrInfo::removeBranch(MachineBasicBlock &MBB,
                                     int *BytesRemoved) const {
  if (BytesRemoved)
    *BytesRemoved = 0;

  MachineBasicBlock::iterator I = MBB.getLastNonDebugInstr();
  if (I == MBB.end())
    return 0;

  // Can remove only direct branches
  if (!I->getDesc().isUnconditionalBranch() &&
      !I->getDesc().isConditionalBranch())
    return 0;

  // Remove first branch
  if (BytesRemoved)
    *BytesRemoved += getInstSizeInBytes(*I);
  I->eraseFromParent();

  I = MBB.end();

  // Check for second branch
  if (I == MBB.begin() || !(--I)->getDesc().isConditionalBranch())
    return 1;

  // Remove second branch
  if (BytesRemoved)
    *BytesRemoved += getInstSizeInBytes(*I);
  I->eraseFromParent();

  return 2;
}

MachineBasicBlock *
BCpuInstrInfo::getBranchDestBlock(const MachineInstr &MI) const {
  assert(MI.getDesc().isBranch() && "Expected branch instr!");

  return MI.getOperand(MI.getNumExplicitOperands() - 1).getMBB();
}

void BCpuInstrInfo::copyPhysReg(MachineBasicBlock &MBB,
                                MachineBasicBlock::iterator MBBI,
                                const DebugLoc &DL, MCRegister DstReg,
                                MCRegister SrcReg, bool KillSrc) const {
  assert(BCpu::GPRRegClass.contains(DstReg, SrcReg) && "Expected GPR regs");

  BuildMI(MBB, MBBI, DL, get(BCpu::ADDI), DstReg)
      .addReg(SrcReg, getKillRegState(KillSrc))
      .addImm(0);
}

void BCpuInstrInfo::storeRegToStackSlot(MachineBasicBlock &MBB,
                                        MachineBasicBlock::iterator I,
                                        Register SrcReg, bool IsKill, int FI,
                                        const TargetRegisterClass *RC,
                                        const TargetRegisterInfo *TRI,
                                        Register VReg) const {
  DebugLoc DL;
  if (I != MBB.end())
    DL = I->getDebugLoc();

  MachineFunction *MF = MBB.getParent();
  MachineFrameInfo &MFI = MF->getFrameInfo();

  MachineMemOperand *MMO = MF->getMachineMemOperand(
      MachinePointerInfo::getFixedStack(*MF, FI), MachineMemOperand::MOStore,
      MFI.getObjectSize(FI), MFI.getObjectAlign(FI));

  BuildMI(MBB, I, DL, get(BCpu::STI))
      .addReg(SrcReg, getKillRegState(IsKill))
      .addFrameIndex(FI)
      .addImm(0)
      .addMemOperand(MMO);
}

void BCpuInstrInfo::loadRegFromStackSlot(MachineBasicBlock &MBB,
                                         MachineBasicBlock::iterator I,
                                         Register DstReg, int FI,
                                         const TargetRegisterClass *RC,
                                         const TargetRegisterInfo *TRI,
                                         Register VReg) const {
  DebugLoc DL;
  if (I != MBB.end())
    DL = I->getDebugLoc();

  MachineFunction *MF = MBB.getParent();
  MachineFrameInfo &MFI = MF->getFrameInfo();

  MachineMemOperand *MMO = MF->getMachineMemOperand(
      MachinePointerInfo::getFixedStack(*MF, FI), MachineMemOperand::MOLoad,
      MFI.getObjectSize(FI), MFI.getObjectAlign(FI));

  BuildMI(MBB, I, DL, get(BCpu::LDI), DstReg)
      .addFrameIndex(FI)
      .addImm(0)
      .addMemOperand(MMO);
}

bool BCpuInstrInfo::reverseBranchCondition(
    SmallVectorImpl<MachineOperand> &Cond) const {
  assert((Cond.size() == 3) && "Invalid cond branch operands!");

  auto CC = static_cast<BCpuCC::CondCode>(Cond[0].getImm());
  Cond[0].setImm(getOppositeBranchCondition(CC));
  return false;
}

unsigned BCpuInstrInfo::insertBranch(
    MachineBasicBlock &MBB, MachineBasicBlock *TBB, MachineBasicBlock *FBB,
    ArrayRef<MachineOperand> Cond, const DebugLoc &DL, int *BytesAdded) const {
  assert(TBB && "insertBranch must not be used to insert a fallthrough");
  assert((Cond.size() == 3 || Cond.empty()) && "Wrong number of args");

  if (BytesAdded)
    *BytesAdded = 0;

  // Unconditional branch.
  if (Cond.empty()) {
    MachineInstr &MI = *BuildMI(&MBB, DL, get(BCpu::B)).addMBB(TBB);
    if (BytesAdded)
      *BytesAdded += getInstSizeInBytes(MI);
    return 1;
  }

  // Either a one or two-way conditional branch.
  auto CC = static_cast<BCpuCC::CondCode>(Cond[0].getImm());
  MachineInstr &CondMI =
      *BuildMI(&MBB, DL, getBrCond(CC)).add(Cond[1]).add(Cond[2]).addMBB(TBB);
  if (BytesAdded)
    *BytesAdded += getInstSizeInBytes(CondMI);

  // One-way conditional branch.
  if (!FBB)
    return 1;

  // Two-way conditional branch.
  MachineInstr &MI = *BuildMI(&MBB, DL, get(BCpu::B)).addMBB(FBB);
  if (BytesAdded)
    *BytesAdded += getInstSizeInBytes(MI);
  return 2;
}

unsigned BCpuInstrInfo::getInstSizeInBytes(const MachineInstr &MI) const {
  return BCpuInstrSize;
}

// TODO
bool BCpuInstrInfo::getBaseAndOffsetPosition(const MachineInstr &MI,
                                             unsigned &BasePos,
                                             unsigned &OffsetPos) const {
  llvm_unreachable("");
}
