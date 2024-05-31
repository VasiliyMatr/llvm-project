#include "llvm/ADT/STLExtras.h"
#include "llvm/MC/MCELFObjectWriter.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCObjectWriter.h"
#include "llvm/MC/MCValue.h"
#include "llvm/Support/ErrorHandling.h"

#include "BCpu.h"
#include "MCTargetDesc/BCpuFixupKinds.h"
#include "MCTargetDesc/BCpuMCTargetDesc.h"

using namespace llvm;

namespace {
class BCpuELFObjectWriter : public MCELFObjectTargetWriter {
public:
  BCpuELFObjectWriter(bool Is64Bit, uint8_t OSABI)
      : MCELFObjectTargetWriter(Is64Bit, OSABI, ELF::EM_BCPU,
                                /*HasRelocationAddend*/ true) {}

protected:
  unsigned getRelocType(MCContext &Ctx, const MCValue &Target,
                        const MCFixup &Fixup, bool IsPCRel) const override;

  bool needsRelocateWithSymbol(const MCValue &Val, const MCSymbol &Sym,
                               unsigned Type) const override;
};
} // namespace

unsigned BCpuELFObjectWriter::getRelocType(MCContext &Ctx,
                                           const MCValue &Target,
                                           const MCFixup &Fixup,
                                           bool IsPCRel) const {
  MCFixupKind Kind = Fixup.getKind();
  if (Kind >= FirstLiteralRelocationKind)
    return Kind - FirstLiteralRelocationKind;

  if (Kind == BCpu::fixup_BCpu_PC16) {
    return ELF::R_BCPU_16;
  }

  // llvm::errs() << "Kind = " << Kind << "\n";

  llvm_unreachable("Unimplemented fixup -> relocation");
}

bool BCpuELFObjectWriter::needsRelocateWithSymbol(const MCValue &,
                                                  const MCSymbol &,
                                                  unsigned Type) const {
  return false;
}

std::unique_ptr<MCObjectTargetWriter>
llvm::createBCpuELFObjectWriter(bool Is64Bit, uint8_t OSABI) {
  return std::make_unique<BCpuELFObjectWriter>(Is64Bit, OSABI);
}
