#include <optional>

#include "llvm/CodeGen/Passes.h"
#include "llvm/CodeGen/TargetLoweringObjectFileImpl.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/CodeGen.h"
#include "llvm/Transforms/Scalar.h"

#include "BCpu.h"
#include "BCpuTargetMachine.h"
#include "TargetInfo/BCpuTargetInfo.h"

using namespace llvm;

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeBCpuTarget() {
  BCPU_DUMP_LOCATION();
  // Register the target
  RegisterTargetMachine<BCpuTargetMachine> reg_bcpu_machine(getBCpuTarget());
}

static std::string computeDataLayout(const Triple &TT, StringRef CPU,
                                     const TargetOptions &Options) {
  std::string Ret = "e-m:e-p:32:32-i8:8:32-i16:16:32-n32";
  return Ret;
}

static Reloc::Model getEffectiveRelocModel(bool JIT,
                                           std::optional<Reloc::Model> RM) {
  if (!RM || JIT)
    return Reloc::Static;
  return *RM;
}

BCpuTargetMachine::BCpuTargetMachine(const Target &T, const Triple &TT,
                                     StringRef CPU, StringRef FS,
                                     const TargetOptions &Options,
                                     std::optional<Reloc::Model> RM,
                                     std::optional<CodeModel::Model> CM,
                                     CodeGenOptLevel OL, bool JIT)
    : LLVMTargetMachine(T, computeDataLayout(TT, CPU, Options), TT, CPU, FS,
                        Options, getEffectiveRelocModel(JIT, RM),
                        getEffectiveCodeModel(CM, CodeModel::Small), OL),
      TLOF(std::make_unique<TargetLoweringObjectFileELF>()),
      Subtarget(TT, std::string(CPU), std::string(FS), *this) {
  BCPU_DUMP_LOCATION();
  initAsmInfo();
}

namespace {

/// BCpu Code Generator Pass Configuration Options.
class BCpuPassConfig : public TargetPassConfig {
public:
  BCpuPassConfig(BCpuTargetMachine &TM, PassManagerBase &PM)
      : TargetPassConfig(TM, PM) {}

  BCpuTargetMachine &getBCpuTargetMachine() const {
    return getTM<BCpuTargetMachine>();
  }

  bool addInstSelector() override {
    addPass(createBCpuISelDag(getBCpuTargetMachine()));
    return false;
  }
};

} // end anonymous namespace

TargetPassConfig *BCpuTargetMachine::createPassConfig(PassManagerBase &PM) {
  return new BCpuPassConfig(*this, PM);
}
