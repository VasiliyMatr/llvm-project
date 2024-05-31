; ModuleID = 'top'
source_filename = "top"

; @X_WINDOW_SIZE = dso_local global i32 0, align 4
; @Y_WINDOW_SIZE = dso_local global i32 0, align 4

define dso_local i32 @_start() {
  ; store i32 400, i32* @X_WINDOW_SIZE, align 4
  ; store i32 400, i32* @Y_WINDOW_SIZE, align 4
  %1 = call i32 @app()
  ret i32 %1
}

define dso_local i32 @complMulRe(i32 %0, i32 %1, i32 %2, i32 %3) {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 %0, i32* %5, align 4
  store i32 %1, i32* %6, align 4
  store i32 %2, i32* %7, align 4
  store i32 %3, i32* %8, align 4
  br label %9

9:                                                ; preds = %4
  %10 = load i32, i32* %5, align 4
  %11 = load i32, i32* %7, align 4
  %12 = call i32 @llvm.bcpu.mul.fixed(i32 %10, i32 %11)
  %13 = load i32, i32* %6, align 4
  %14 = load i32, i32* %8, align 4
  %15 = call i32 @llvm.bcpu.mul.fixed(i32 %13, i32 %14)
  %16 = sub i32 %12, %15
  ret i32 %16
}

define dso_local i32 @complMulIm(i32 %0, i32 %1, i32 %2, i32 %3) {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 %0, i32* %5, align 4
  store i32 %1, i32* %6, align 4
  store i32 %2, i32* %7, align 4
  store i32 %3, i32* %8, align 4
  br label %9

9:                                                ; preds = %4
  %10 = load i32, i32* %5, align 4
  %11 = load i32, i32* %8, align 4
  %12 = call i32 @llvm.bcpu.mul.fixed(i32 %10, i32 %11)
  %13 = load i32, i32* %6, align 4
  %14 = load i32, i32* %7, align 4
  %15 = call i32 @llvm.bcpu.mul.fixed(i32 %13, i32 %14)
  %16 = add i32 %12, %15
  ret i32 %16
}

define dso_local i32 @complSq(i32 %0, i32 %1) {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  store i32 %1, i32* %4, align 4
  br label %5

5:                                                ; preds = %2
  %6 = load i32, i32* %3, align 4
  %7 = load i32, i32* %3, align 4
  %8 = call i32 @llvm.bcpu.mul.fixed(i32 %6, i32 %7)
  %9 = load i32, i32* %4, align 4
  %10 = load i32, i32* %4, align 4
  %11 = call i32 @llvm.bcpu.mul.fixed(i32 %9, i32 %10)
  %12 = add i32 %8, %11
  ret i32 %12
}

define dso_local i32 @calcMandIterRe(i32 %0, i32 %1, i32 %2, i32 %3) {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 %0, i32* %5, align 4
  store i32 %1, i32* %6, align 4
  store i32 %2, i32* %7, align 4
  store i32 %3, i32* %8, align 4
  br label %9

9:                                                ; preds = %4
  %10 = load i32, i32* %5, align 4
  %11 = load i32, i32* %6, align 4
  %12 = load i32, i32* %5, align 4
  %13 = load i32, i32* %6, align 4
  %14 = call i32 @complMulRe(i32 %10, i32 %11, i32 %12, i32 %13)
  %15 = load i32, i32* %7, align 4
  %16 = add i32 %14, %15
  ret i32 %16
}

define dso_local i32 @calcMandIterIm(i32 %0, i32 %1, i32 %2, i32 %3) {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 %0, i32* %5, align 4
  store i32 %1, i32* %6, align 4
  store i32 %2, i32* %7, align 4
  store i32 %3, i32* %8, align 4
  br label %9

9:                                                ; preds = %4
  %10 = load i32, i32* %5, align 4
  %11 = load i32, i32* %6, align 4
  %12 = load i32, i32* %5, align 4
  %13 = load i32, i32* %6, align 4
  %14 = call i32 @complMulIm(i32 %10, i32 %11, i32 %12, i32 %13)
  %15 = load i32, i32* %8, align 4
  %16 = add i32 %14, %15
  ret i32 %16
}

define dso_local i32 @app() {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca i32, align 4
  %16 = alloca i32, align 4
  %17 = alloca i32, align 4
  %18 = alloca i32, align 4
  br label %19

19:                                               ; preds = %0
  call void @llvm.bcpu.window.create()
  store i32 20, i32* %1, align 4
  store i32 -47625, i32* %2, align 4
  store i32 16874, i32* %3, align 4
  br label %20

20:                                               ; preds = %36, %19
  br i1 1, label %21, label %22

21:                                               ; preds = %20
  store i32 196608, i32* %4, align 4
  store i32 196608, i32* %5, align 4
  store i32 0, i32* %6, align 4
  br label %23

22:                                               ; preds = %20
  ret i32 0

23:                                               ; preds = %51, %21
  %24 = load i32, i32* %6, align 4
  %25 = load i32, i32* %1, align 4
  %26 = icmp slt i32 %24, %25
  br i1 %26, label %27, label %36

27:                                               ; preds = %23
  %28 = load i32, i32* %2, align 4
  %29 = load i32, i32* %4, align 4
  %30 = call i32 @llvm.bcpu.div.fixed(i32 %29, i32 131072)
  %31 = sub i32 %28, %30
  store i32 %31, i32* %7, align 4
  %32 = load i32, i32* %3, align 4
  %33 = load i32, i32* %5, align 4
  %34 = call i32 @llvm.bcpu.div.fixed(i32 %33, i32 131072)
  %35 = sub i32 %32, %34
  store i32 %35, i32* %8, align 4
  store i32 0, i32* %9, align 4
  br label %37

36:                                               ; preds = %23
  br label %20

37:                                               ; preds = %74, %27
  %38 = load i32, i32* %9, align 4
  ; %39 = load i32, i32* @X_WINDOW_SIZE, align 4
  %40 = icmp slt i32 %38, 400
  br i1 %40, label %41, label %51

41:                                               ; preds = %37
  %42 = load i32, i32* %9, align 4
  %43 = load i32, i32* %4, align 4
  %44 = shl i32 %42, 16
  %45 = call i32 @llvm.bcpu.mul.fixed(i32 %44, i32 %43)
  ; %46 = load i32, i32* @X_WINDOW_SIZE, align 4
  %47 = shl i32 400, 16
  %48 = call i32 @llvm.bcpu.div.fixed(i32 %45, i32 %47)
  %49 = load i32, i32* %7, align 4
  %50 = add i32 %48, %49
  store i32 %50, i32* %10, align 4
  store i32 0, i32* %11, align 4
  br label %60

51:                                               ; preds = %37
  call void @llvm.bcpu.window.update()
  %52 = load i32, i32* %4, align 4
  %53 = call i32 @llvm.bcpu.mul.fixed(i32 %52, i32 196608)
  %54 = call i32 @llvm.bcpu.div.fixed(i32 %53, i32 262144)
  store i32 %54, i32* %4, align 4
  %55 = load i32, i32* %4, align 4
  %56 = call i32 @llvm.bcpu.mul.fixed(i32 %55, i32 196608)
  %57 = call i32 @llvm.bcpu.div.fixed(i32 %56, i32 262144)
  store i32 %57, i32* %5, align 4
  %58 = load i32, i32* %6, align 4
  %59 = add i32 %58, 1
  store i32 %59, i32* %6, align 4
  br label %23

60:                                               ; preds = %85, %41
  %61 = load i32, i32* %11, align 4
  ; %62 = load i32, i32* @Y_WINDOW_SIZE, align 4
  %63 = icmp slt i32 %61, 400
  br i1 %63, label %64, label %74

64:                                               ; preds = %60
  %65 = load i32, i32* %11, align 4
  %66 = load i32, i32* %5, align 4
  %67 = shl i32 %65, 16
  %68 = call i32 @llvm.bcpu.mul.fixed(i32 %67, i32 %66)
  ; %69 = load i32, i32* @Y_WINDOW_SIZE, align 4
  %70 = shl i32 400, 16
  %71 = call i32 @llvm.bcpu.div.fixed(i32 %68, i32 %70)
  %72 = load i32, i32* %8, align 4
  %73 = add i32 %71, %72
  store i32 %73, i32* %12, align 4
  store i32 0, i32* %13, align 4
  store i32 0, i32* %14, align 4
  store i32 0, i32* %15, align 4
  store i32 1, i32* %16, align 4
  br label %77

74:                                               ; preds = %60
  %75 = load i32, i32* %9, align 4
  %76 = add i32 %75, 1
  store i32 %76, i32* %9, align 4
  br label %37

77:                                               ; preds = %112, %64
  %78 = load i32, i32* %16, align 4
  %79 = icmp eq i32 %78, 1
  br i1 %79, label %80, label %85

80:                                               ; preds = %77
  %81 = load i32, i32* %13, align 4
  %82 = load i32, i32* %14, align 4
  %83 = call i32 @complSq(i32 %81, i32 %82)
  %84 = icmp sgt i32 %83, 262144
  br i1 %84, label %93, label %94

85:                                               ; preds = %77
  %86 = load i32, i32* %9, align 4
  %87 = load i32, i32* %11, align 4
  %88 = load i32, i32* %15, align 4
  %89 = load i32, i32* %15, align 4
  %90 = load i32, i32* %15, align 4
  call void @llvm.bcpu.window.set.pixel(i32 %86, i32 %87, i32 %88)
  %91 = load i32, i32* %11, align 4
  %92 = add i32 %91, 1
  store i32 %92, i32* %11, align 4
  br label %60

93:                                               ; preds = %80
  store i32 0, i32* %16, align 4
  br label %94

94:                                               ; preds = %93, %80
  %95 = load i32, i32* %13, align 4
  %96 = load i32, i32* %14, align 4
  %97 = load i32, i32* %10, align 4
  %98 = load i32, i32* %12, align 4
  %99 = call i32 @calcMandIterRe(i32 %95, i32 %96, i32 %97, i32 %98)
  store i32 %99, i32* %17, align 4
  %100 = load i32, i32* %13, align 4
  %101 = load i32, i32* %14, align 4
  %102 = load i32, i32* %10, align 4
  %103 = load i32, i32* %12, align 4
  %104 = call i32 @calcMandIterIm(i32 %100, i32 %101, i32 %102, i32 %103)
  store i32 %104, i32* %18, align 4
  %105 = load i32, i32* %17, align 4
  store i32 %105, i32* %13, align 4
  %106 = load i32, i32* %18, align 4
  store i32 %106, i32* %14, align 4
  %107 = load i32, i32* %15, align 4
  %108 = add i32 %107, 1
  store i32 %108, i32* %15, align 4
  %109 = load i32, i32* %15, align 4
  %110 = icmp sge i32 %109, 256
  br i1 %110, label %111, label %112

111:                                              ; preds = %94
  store i32 0, i32* %16, align 4
  br label %112

112:                                              ; preds = %111, %94
  br label %77
}
