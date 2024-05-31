// BCpu target descriptions

#ifndef BCPUMCTARGETDESC_H
#define BCPUMCTARGETDESC_H

#include <memory>

namespace llvm {

class MCAsmBackend;
class MCCodeEmitter;
class MCContext;
class MCInstrInfo;
class MCObjectTargetWriter;
class MCRegisterInfo;
class MCSubtargetInfo;
class MCTargetOptions;
class Target;

MCCodeEmitter *createBCpuMCCodeEmitter(const MCInstrInfo &MCII, MCContext &Ctx);
MCAsmBackend *createBCpuAsmBackend(const Target &T, const MCSubtargetInfo &STI,
                                  const MCRegisterInfo &MRI,
                                  const MCTargetOptions &Options);
std::unique_ptr<MCObjectTargetWriter> createBCpuELFObjectWriter(bool Is64Bit,
                                                               uint8_t OSABI);

} // namespace llvm

#define GET_REGINFO_ENUM
#include "BCpuGenRegisterInfo.inc"

#define GET_INSTRINFO_ENUM
#include "BCpuGenInstrInfo.inc"

#endif // BCPUMCTARGETDESC_H
