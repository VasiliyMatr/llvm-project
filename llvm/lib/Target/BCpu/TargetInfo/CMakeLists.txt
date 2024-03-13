add_llvm_component_library(LLVMBCpuInfo
    BCpuTargetInfo.cpp

    LINK_COMPONENTS
    MC
    Support

    ADD_TO_COMPONENT
    BCpu
)
