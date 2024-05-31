add_llvm_component_library(LLVMBCpuDesc
    BCpuMCTargetDesc.cpp
    BCpuMCAsmInfo.cpp
    BCpuInstPrinter.cpp
    BCpuMCCodeEmitter.cpp
    BCpuAsmBackend.cpp
    BCpuELFObjectWriter.cpp

    LINK_COMPONENTS
    MC
    Support
    BCpuInfo

    ADD_TO_COMPONENT
    BCpu
)
