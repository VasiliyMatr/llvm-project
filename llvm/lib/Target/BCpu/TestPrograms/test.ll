define dso_local i32 @do_math_1(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4, i32 noundef %5) #0 {
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  store i32 %0, i32* %7, align 4
  store i32 %1, i32* %8, align 4
  store i32 %2, i32* %9, align 4
  store i32 %3, i32* %10, align 4
  store i32 %4, i32* %11, align 4
  store i32 %5, i32* %12, align 4
  %13 = load i32, i32* %7, align 4
  %14 = load i32, i32* %8, align 4
  %15 = add nsw i32 %13, %14
  %16 = load i32, i32* %9, align 4
  %17 = add nsw i32 %15, %16
  %18 = load i32, i32* %10, align 4
  %19 = add nsw i32 %17, %18
  %20 = load i32, i32* %11, align 4
  %21 = add nsw i32 %19, %20
  %22 = load i32, i32* %12, align 4
  %23 = add nsw i32 %21, %22
  ret i32 %23
}

define dso_local i32 @do_math_2(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4) #0 {
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store i32 %0, i32* %6, align 4
  store i32 %1, i32* %7, align 4
  store i32 %2, i32* %8, align 4
  store i32 %3, i32* %9, align 4
  store i32 %4, i32* %10, align 4
  %11 = load i32, i32* %6, align 4
  %12 = load i32, i32* %7, align 4
  %13 = add nsw i32 %11, %12
  %14 = load i32, i32* %8, align 4
  %15 = add nsw i32 %13, %14
  %16 = load i32, i32* %9, align 4
  %17 = add nsw i32 %15, %16
  %18 = load i32, i32* %10, align 4
  %19 = add nsw i32 %17, %18
  ret i32 %19
}

define dso_local i32 @call_math() #0 {
  %1 = call i32 @do_math_1(i32 noundef 1, i32 noundef 2, i32 noundef 3, i32 noundef 4, i32 noundef 5, i32 noundef 6)
  %2 = call i32 @do_math_2(i32 noundef 10, i32 noundef 20, i32 noundef 30, i32 noundef 40, i32 noundef 50)
  %3 = add nsw i32 %1, %2
  ret i32 %3
}
