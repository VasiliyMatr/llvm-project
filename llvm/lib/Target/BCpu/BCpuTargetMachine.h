#ifndef BCPUTARGETMACHINE_H
#define BCPUTARGETMACHINE_H

#include <optional>

#include "llvm/Target/TargetMachine.h"

#include "BCpuInstrInfo.h"
#include "BCpuSubtarget.h"

namespace llvm {

class BCpuTargetMachine : public LLVMTargetMachine {
  std::unique_ptr<TargetLoweringObjectFile> TLOF;
  BCpuSubtarget Subtarget;

public:
  BCpuTargetMachine(const Target &T, const Triple &TT, StringRef CPU,
                    StringRef FS, const TargetOptions &Options,
                    std::optional<Reloc::Model> RM,
                    std::optional<CodeModel::Model> CM, CodeGenOptLevel OL,
                    bool JIT);

  const BCpuSubtarget *getSubtargetImpl(const Function &) const override {
    return &Subtarget;
  }

  TargetPassConfig *createPassConfig(PassManagerBase &PM) override;
  TargetLoweringObjectFile *getObjFileLowering() const override {
    return TLOF.get();
  }
};

} // namespace llvm

#endif // BCPUTARGETMACHINE_H
