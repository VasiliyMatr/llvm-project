#ifndef BCPUMCASMINFO_H
#define BCPUMCASMINFO_H

#include "llvm/MC/MCAsmInfoELF.h"

namespace llvm {

class Triple;

struct BCpuELFMCAsmInfo : public MCAsmInfoELF {
  explicit BCpuELFMCAsmInfo(const Triple &TT);
};

} // namespace llvm

#endif // BCPUMCASMINFO_H
