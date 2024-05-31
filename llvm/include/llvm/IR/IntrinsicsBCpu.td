let TargetPrefix = "bcpu" in {  // All intrinsics start with "llvm.bcpu.".

def int_bcpu_window_create : ClangBuiltin<"BCpuWindowCreate">,
    Intrinsic<[], [], [IntrNoMem, IntrHasSideEffects]>;

def int_bcpu_window_set_pixel: ClangBuiltin<"BCpuWindowSetPixel">,
  Intrinsic<[], [llvm_i32_ty, llvm_i32_ty, llvm_i32_ty],
  [IntrNoMem, IntrHasSideEffects]>;

def int_bcpu_window_update : ClangBuiltin<"BCpuWindowUpdate">,
    Intrinsic<[], [], [IntrNoMem, IntrHasSideEffects]>;

def int_bcpu_mul_fixed: ClangBuiltin<"BCpuMulFixed">,
  Intrinsic<[llvm_i32_ty], [llvm_i32_ty, llvm_i32_ty], [IntrNoMem]>;

def int_bcpu_div_fixed: ClangBuiltin<"BCpuDivFixed">,
  Intrinsic<[llvm_i32_ty], [llvm_i32_ty, llvm_i32_ty], [IntrNoMem]>;

} // TargetPrefix = "bcpu"
