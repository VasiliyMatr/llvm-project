#ifndef BCPUTARGETSTREAMER_H
#define BCPUTARGETSTREAMER_H

#include "llvm/MC/MCStreamer.h"

namespace llvm {

struct BCpuTargetStreamer : public MCTargetStreamer {
  BCpuTargetStreamer(MCStreamer &S);
};

} // end namespace llvm

#endif // BCPUTARGETSTREAMER_H
