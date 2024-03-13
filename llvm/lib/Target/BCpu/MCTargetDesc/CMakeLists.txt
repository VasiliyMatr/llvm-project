add_llvm_component_library(LLVMBCpuDesc
    BCpuMCTargetDesc.cpp

    LINK_COMPONENTS
    MC
    Support
    BCpuInfo

    ADD_TO_COMPONENT
    BCpu
)
