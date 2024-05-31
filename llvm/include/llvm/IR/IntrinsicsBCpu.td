let TargetPrefix = "bcpu" in {  // All intrinsics start with "llvm.bcpu.".

def int_bcpu_window_create : ClangBuiltin<"engine_windowCreate">,
    Intrinsic<[], [], [IntrNoMem, IntrHasSideEffects]>;

def int_bcpu_window_set_pixel: ClangBuiltin<"engine_windowSetPixel">,
  Intrinsic<[], [llvm_i32_ty, llvm_i32_ty, llvm_i32_ty],
  [IntrNoMem, IntrHasSideEffects]>;

def int_bcpu_window_update : ClangBuiltin<"engine_windowUpdate">,
    Intrinsic<[], [], [IntrNoMem, IntrHasSideEffects]>;

def int_bcpu_mul_fixed: ClangBuiltin<"engine_mulFixed">,
  Intrinsic<[llvm_i32_ty], [llvm_i32_ty, llvm_i32_ty], [IntrNoMem]>;

def int_bcpu_div_fixed: ClangBuiltin<"engine_divFixed">,
  Intrinsic<[llvm_i32_ty], [llvm_i32_ty, llvm_i32_ty], [IntrNoMem]>;

} // TargetPrefix = "bcpu"
