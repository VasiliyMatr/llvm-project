#ifndef BCPUINFO_H
#define BCPUINFO_H

#include "llvm/MC/MCInstrDesc.h"

namespace llvm {

namespace BCpuCC {

enum CondCode {
  EQ,
  NE,
  LE,
  GT,
  LEU,
  GTU,
  INVALID,
};

CondCode getOppositeBranchCondition(CondCode);

enum BRCondCode {
  BREQ = 0x0,
};

} // namespace BCpuCC

namespace BCpuOp {

enum OperandType : unsigned {
  OPERAND_SIMM16 = MCOI::OPERAND_FIRST_TARGET,
  OPERAND_UIMM16
};

} // namespace BCpuOp

} // namespace llvm

#endif // BCPUINFO_H
