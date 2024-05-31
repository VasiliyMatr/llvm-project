// BCpu target descriptions

#include "llvm/MC/MCDwarf.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/ErrorHandling.h"

#include "BCpu.h"
#include "BCpuInstPrinter.h"
#include "BCpuMCAsmInfo.h"
#include "BCpuMCTargetDesc.h"
#include "BCpuTargetStreamer.h"
#include "MCTargetDesc/BCpuInfo.h"
#include "TargetInfo/BCpuTargetInfo.h"

using namespace llvm;

#define GET_REGINFO_MC_DESC
#include "BCpuGenRegisterInfo.inc"

#define GET_INSTRINFO_MC_DESC
#include "BCpuGenInstrInfo.inc"

#define GET_SUBTARGETINFO_MC_DESC
#include "BCpuGenSubtargetInfo.inc"

static MCRegisterInfo *createBCpuMCRegisterInfo(const Triple &TT) {
  BCPU_DUMP_LOCATION();

  MCRegisterInfo *reg_info = new MCRegisterInfo();
  InitBCpuMCRegisterInfo(reg_info, BCpu::R0);
  return reg_info;
}

static MCInstrInfo *createBCpuMCInstrInfo() {
  BCPU_DUMP_LOCATION();

  MCInstrInfo *instr_info = new MCInstrInfo();
  InitBCpuMCInstrInfo(instr_info);
  return instr_info;
}

static MCSubtargetInfo *createBCpuMCSubtargetInfo(const Triple &TT,
                                                  StringRef CPU, StringRef FS) {
  BCPU_DUMP_LOCATION();

  return createBCpuMCSubtargetInfoImpl(TT, CPU, /* TuneCPU */ CPU, FS);
}

static MCAsmInfo *createBCpuMCAsmInfo(const MCRegisterInfo &MRI,
                                      const Triple &TT,
                                      const MCTargetOptions &Options) {
  BCPU_DUMP_LOCATION();

  MCAsmInfo *MAI = new BCpuELFMCAsmInfo(TT);
  unsigned SP = MRI.getDwarfRegNum(BCpu::R1, true);
  MCCFIInstruction Inst = MCCFIInstruction::cfiDefCfa(nullptr, SP, 0);
  MAI->addInitialFrameState(Inst);
  return MAI;
}

static MCInstPrinter *createBCpuMCInstPrinter(const Triple &T,
                                              unsigned SyntaxVariant,
                                              const MCAsmInfo &MAI,
                                              const MCInstrInfo &MII,
                                              const MCRegisterInfo &MRI) {
  return new BCpuInstPrinter(MAI, MII, MRI);
}

BCpuTargetStreamer::BCpuTargetStreamer(MCStreamer &S) : MCTargetStreamer(S) {}

static MCTargetStreamer *createTargetAsmStreamer(MCStreamer &S,
                                                 formatted_raw_ostream &OS,
                                                 MCInstPrinter *InstPrint,
                                                 bool isVerboseAsm) {
  return new BCpuTargetStreamer(S);
}

// We need to define this function for linking succeed
extern "C" void LLVMInitializeBCpuTargetMC() {
  BCPU_DUMP_LOCATION();

  Target &bcpu_target = getBCpuTarget();

  // Register MC register info.
  TargetRegistry::RegisterMCRegInfo(bcpu_target, createBCpuMCRegisterInfo);
  // Register MC instruction info.
  TargetRegistry::RegisterMCInstrInfo(bcpu_target, createBCpuMCInstrInfo);
  // Register MC subtarget info.
  TargetRegistry::RegisterMCSubtargetInfo(bcpu_target,
                                          createBCpuMCSubtargetInfo);
  // Register MC asm info
  RegisterMCAsmInfoFn asm_info(bcpu_target, createBCpuMCAsmInfo);

  // Register the MCInstPrinter
  TargetRegistry::RegisterMCInstPrinter(bcpu_target, createBCpuMCInstPrinter);
  TargetRegistry::RegisterAsmTargetStreamer(bcpu_target,
                                            createTargetAsmStreamer);

  // Register the MC Code Emitter.
  TargetRegistry::RegisterMCCodeEmitter(bcpu_target, createBCpuMCCodeEmitter);
  // Register the asm backend.
  TargetRegistry::RegisterMCAsmBackend(bcpu_target, createBCpuAsmBackend);
}
