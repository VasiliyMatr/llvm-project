#ifndef BCPUISELLOWERING_H
#define BCPUISELLOWERING_H

#include "llvm/CodeGen/SelectionDAG.h"
#include "llvm/CodeGen/TargetLowering.h"

#include "BCpu.h"

namespace llvm {

class BCpuSubtarget;
class BCpuTargetMachine;

namespace BCpuISD {

enum NodeType : unsigned {
  // Start the numbering where the builtin ops and target ops leave off.
  FIRST_NUMBER = ISD::BUILTIN_OP_END,
  RET,
  CALL,
  BR_CC,
};

} // namespace BCpuISD

class BCpuTargetLowering : public TargetLowering {
public:
  explicit BCpuTargetLowering(const TargetMachine &TM,
                              const BCpuSubtarget &STI);

  /// Provide custom lowering hooks for some operations.
  SDValue LowerOperation(SDValue Op, SelectionDAG &DAG) const override;

  /// This method returns the name of a target specific DAG node.
  const char *getTargetNodeName(unsigned Opcode) const override;

  /// Return true if the addressing mode represented by AM is legal for this
  /// target, for a load/store of the specified type.
  bool isLegalAddressingMode(const DataLayout &DL, const AddrMode &AM, Type *Ty,
                             unsigned AS,
                             Instruction *I = nullptr) const override;

  BCpuSubtarget const &getSubtarget() const { return STI; }

private:
  const BCpuSubtarget &STI;

  void ReplaceNodeResults(SDNode *N, SmallVectorImpl<SDValue> &Results,
                          SelectionDAG &DAG) const override;

  // TODO: advanced opts
  SDValue PerformDAGCombine(SDNode *N, DAGCombinerInfo &DCI) const override {
    return {};
  }

  SDValue LowerFormalArguments(SDValue Chain, CallingConv::ID CallConv,
                               bool IsVarArg,
                               const SmallVectorImpl<ISD::InputArg> &Ins,
                               const SDLoc &DL, SelectionDAG &DAG,
                               SmallVectorImpl<SDValue> &InVals) const override;

  SDValue LowerCall(TargetLowering::CallLoweringInfo &CLI,
                    SmallVectorImpl<SDValue> &InVals) const override;

  SDValue LowerReturn(SDValue Chain, CallingConv::ID CallConv, bool IsVarArg,
                      const SmallVectorImpl<ISD::OutputArg> &Outs,
                      const SmallVectorImpl<SDValue> &OutVals, const SDLoc &DL,
                      SelectionDAG &DAG) const override;

  bool CanLowerReturn(CallingConv::ID CallConv, MachineFunction &MF,
                      bool IsVarArg,
                      const SmallVectorImpl<ISD::OutputArg> &ArgsFlags,
                      LLVMContext &Context) const override;

  bool mayBeEmittedAsTailCall(const CallInst *CI) const override;

  SDValue lowerBR_CC(SDValue Op, SelectionDAG &DAG) const;
  SDValue lowerFRAMEADDR(SDValue Op, SelectionDAG &DAG) const;
};

} // namespace llvm

#endif // BCPUISELLOWERING_H
