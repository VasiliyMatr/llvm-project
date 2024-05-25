add_llvm_component_group(BCpu)

set(LLVM_TARGET_DEFINITIONS BCpu.td)

tablegen(LLVM BCpuGenRegisterInfo.inc -gen-register-info)
tablegen(LLVM BCpuGenInstrInfo.inc -gen-instr-info)
tablegen(LLVM BCpuGenSubtargetInfo.inc -gen-subtarget)
tablegen(LLVM BCpuGenCallingConv.inc -gen-callingconv)
tablegen(LLVM BCpuGenDAGISel.inc -gen-dag-isel)
tablegen(LLVM BCpuGenMCPseudoLowering.inc -gen-pseudo-lowering)
tablegen(LLVM BCpuGenAsmWriter.inc -gen-asm-writer)

add_public_tablegen_target(BCpuCommonTableGen)

add_llvm_target(BCpuCodeGen
    BCpuTargetMachine.cpp
    BCpuRegisterInfo.cpp
    BCpuInstrInfo.cpp
    BCpuSubtarget.cpp
    BCpuISelLowering.cpp
    BCpuISelDagToDag.cpp
    BCpuMCInstLower.cpp
    BCpuAsmPrinter.cpp

    LINK_COMPONENTS
    AsmPrinter
    CodeGen
    Core
    Support
    Target
    MC
    BCpuDesc
    BCpuInfo
    SelectionDAG

    ADD_TO_COMPONENT
    BCpu
)

add_subdirectory(MCTargetDesc)
add_subdirectory(TargetInfo)
