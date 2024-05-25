#ifndef BCPU_H
#define BCPU_H

#include <iostream>

#include "llvm/Support/raw_ostream.h"

#include "MCTargetDesc/BCpuMCTargetDesc.h"

#define BCPU_DUMP_LOCATION()                                                   \
  {                                                                            \
    llvm::errs().changeColor(llvm::raw_ostream::GREEN)                         \
        << "  BCpu loc: " << __func__ << "\n    " << __FILE__ << ":"           \
        << __LINE__ << "\n";                                                   \
    llvm::errs().changeColor(llvm::raw_ostream::WHITE);                        \
  }

namespace llvm {

class BCpuTargetMachine;
class FunctionPass;

FunctionPass *createBCpuISelDag(BCpuTargetMachine &TM);

} // namespace llvm

#endif // BCPU_H
