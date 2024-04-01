// Defines BCpu registers

class BCpuReg<bits<16> enc, string name> : Register<name> {
    let HWEncoding = enc;
    let Namespace = "BCpu";
}

// Add GPRs
foreach i = 0-15 in {
    def R#i : BCpuReg<i, "r"#i>;
}

// R0 - return address
// R1 - stack pointer
// R2 - frame pointer
// R15 - return value
def GPR : RegisterClass<"BCpu", [i32], 32,
    (add R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15)
>;
