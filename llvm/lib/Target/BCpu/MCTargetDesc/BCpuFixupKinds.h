#ifndef BCPUFIXUPKINDS_H
#define BCPUFIXUPKINDS_H

#include "llvm/MC/MCFixup.h"

namespace llvm {
namespace BCpu {

  // Although most of the current fixup types reflect a unique relocation
  // one can have multiple fixup types for a given relocation and thus need
  // to be uniquely named.
  //
  // This table *must* be in the same order of
  // MCFixupKindInfo Infos[BCpu::NumTargetFixupKinds]
  // in BCpuAsmBackend.cpp.
  //
  enum Fixups {
    fixup_BCpu_PC16 = FirstTargetFixupKind,
    // Marker
    LastTargetFixupKind,
    NumTargetFixupKinds = LastTargetFixupKind - FirstTargetFixupKind
  };

} // namespace BCpu
} // namespace llvm


#endif // BCPUFIXUPKINDS_H
