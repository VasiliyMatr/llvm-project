add_llvm_component_group(BCpu)

add_llvm_target(BCpuCodeGen
    BCpuTargetMachine.cpp

    LINK_COMPONENTS
    CodeGen
    Core
    Support
    Target
    BCpuInfo

    ADD_TO_COMPONENT
    BCpu
)

add_subdirectory(MCTargetDesc)
add_subdirectory(TargetInfo)
