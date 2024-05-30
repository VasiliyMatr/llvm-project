#include "llvm/ADT/StringExtras.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"

#include "BCpuInstPrinter.h"
#include "MCTargetDesc/BCpuInfo.h"

using namespace llvm;

#include "BCpuGenAsmWriter.inc"

void BCpuInstPrinter::printRegName(raw_ostream &O, MCRegister Reg) const {
  O << getRegisterName(Reg);
}

void BCpuInstPrinter::printInst(const MCInst *MI, uint64_t Address,
                                StringRef Annot, const MCSubtargetInfo &STI,
                                raw_ostream &O) {
  printInstruction(MI, Address, O);
  printAnnotation(O, Annot);
}

void BCpuInstPrinter::printOperand(const MCInst *MI, int OpNo, raw_ostream &O) {
  const MCOperand &MO = MI->getOperand(OpNo);

  if (MO.isReg()) {
    printRegName(O, MO.getReg());
    return;
  }

  if (MO.isImm()) {
    O << MO.getImm();
    return;
  }

  if (MO.isExpr()) {
    MO.getExpr()->print(O, &MAI);
    return;
  }

  llvm_unreachable("Unknown operand kind in printOperand");
}

void BCpuInstPrinter::printBranchOperand(const MCInst *MI, uint64_t Address,
                                         unsigned OpNo, raw_ostream &O) {
  const MCOperand &MO = MI->getOperand(OpNo);
  if (!MO.isImm())
    return printOperand(MI, OpNo, O);

  if (PrintBranchImmAsAddress) {
    uint32_t Target = Address + MO.getImm();
    O << formatHex(static_cast<uint64_t>(Target));
  } else {
    O << MO.getImm();
  }
}
