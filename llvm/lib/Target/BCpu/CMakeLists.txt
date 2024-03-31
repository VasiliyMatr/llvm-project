add_llvm_component_group(BCpu)

set(LLVM_TARGET_DEFINITIONS BCpu.td)

tablegen(LLVM BCpuGenRegisterInfo.inc -gen-register-info)

add_public_tablegen_target(BCpuCommonTableGen)

add_llvm_target(BCpuCodeGen
    BCpuTargetMachine.cpp
    BCpuRegisterInfo.cpp

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
