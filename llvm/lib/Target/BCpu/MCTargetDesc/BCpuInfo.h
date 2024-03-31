#ifndef BCPUINFO_H
#define BCPUINFO_H

#include "llvm/MC/MCInstrDesc.h"

namespace llvm::BCpuOp {

enum OperandType : unsigned {
  OPERAND_BCPU_IMM20 = MCOI::OPERAND_FIRST_TARGET
};

} // namespace llvm::BCpuOp

#endif // BCPUINFO_H
