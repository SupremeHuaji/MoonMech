// MoonMech - 工具函数

// ==================== 基本数学运算 ====================

///|
/// 计算平方
pub fn square(x : Double) -> Double {
  x * x
}

///|
/// 计算立方
pub fn cube(x : Double) -> Double {
  x * x * x
}

///|
/// 计算四次方
pub fn pow4(x : Double) -> Double {
  let x2 = x * x
  x2 * x2
}

///|
/// 计算绝对值
pub fn abs(x : Double) -> Double {
  if x < 0.0 {
    -x
  } else {
    x
  }
}

///|
/// 计算最大值
pub fn max(a : Double, b : Double) -> Double {
  if a > b {
    a
  } else {
    b
  }
}

///|
/// 计算最小值
pub fn min(a : Double, b : Double) -> Double {
  if a < b {
    a
  } else {
    b
  }
}

///|
/// 安全除法，分母为零时返回默认值
pub fn safe_div(num : Double, den : Double, fallback : Double) -> Double {
  if abs(den) <= EPSILON {
    fallback
  } else {
    num / den
  }
}

///|
/// 判断两个浮点数是否近似相等
pub fn approx_equal(a : Double, b : Double, tolerance : Double) -> Bool {
  abs(a - b) < tolerance
}

///|
/// 限制值在范围内
pub fn clamp(value : Double, min_val : Double, max_val : Double) -> Double {
  if value < min_val {
    min_val
  } else if value > max_val {
    max_val
  } else {
    value
  }
}

// ==================== 角度转换 ====================

///|
/// 角度转弧度
pub fn deg_to_rad(deg : Double) -> Double {
  deg * PI / 180.0
}

///|
/// 弧度转角度
pub fn rad_to_deg(rad : Double) -> Double {
  rad * 180.0 / PI
}

// ==================== 三角函数 ====================

///|
/// 正弦函数
pub fn sin(x : Double) -> Double {
  @math.sin(x)
}

///|
/// 余弦函数
pub fn cos(x : Double) -> Double {
  @math.cos(x)
}

///|
/// 正切函数
pub fn tan(x : Double) -> Double {
  @math.tan(x)
}

///|
/// 反正切函数 (返回弧度)
pub fn atan2(y : Double, x : Double) -> Double {
  @math.atan2(y, x)
}

///|
/// 反正弦函数 (返回弧度)
pub fn asin(x : Double) -> Double {
  @math.asin(x)
}

///|
/// 反余弦函数 (返回弧度)
pub fn acos(x : Double) -> Double {
  @math.acos(x)
}

// ==================== 几何计算 ====================

///|
/// 圆形面积
pub fn circle_area(r : Double) -> Double {
  PI * square(r)
}

///|
/// 圆形周长
pub fn circle_perimeter(r : Double) -> Double {
  2.0 * PI * r
}

///|
/// 圆环面积
pub fn ring_area(r_outer : Double, r_inner : Double) -> Double {
  PI * (square(r_outer) - square(r_inner))
}

///|
/// 矩形面积
pub fn rect_area(width : Double, height : Double) -> Double {
  width * height
}

// ==================== 力学计算 ====================

///|
/// 计算功率
/// P = T * ω
/// 参数: t - 转矩 (N·m), omega - 角速度 (rad/s)
pub fn power_from_torque(t : Double, omega : Double) -> Double {
  t * omega
}

///|
/// 计算转矩
/// T = P / ω
pub fn torque_from_power(p : Double, omega : Double) -> Double {
  if abs(omega) < EPSILON {
    return 0.0
  }
  p / omega
}

///|
/// 角速度 (从转速)
/// ω = 2π * n / 60
/// 参数: n - 转速 (rpm)
pub fn angular_velocity(n : Double) -> Double {
  2.0 * PI * n / 60.0
}

///|
/// 转速 (从角速度)
/// n = ω * 60 / (2π)
pub fn rpm_from_angular_velocity(omega : Double) -> Double {
  omega * 60.0 / (2.0 * PI)
}

///|
/// 线速度
/// v = r * ω
pub fn linear_velocity(r : Double, omega : Double) -> Double {
  r * omega
}

///|
/// 向心加速度
/// a = r * ω²
pub fn centripetal_acceleration(r : Double, omega : Double) -> Double {
  r * square(omega)
}

// ==================== 材料力学 ====================

///|
/// 正应力
/// σ = F / A
pub fn normal_stress(force : Double, area : Double) -> Double {
  if area <= 0.0 {
    return 0.0
  }
  force / area
}

///|
/// 剪应力
/// τ = F / A
pub fn shear_stress(force : Double, area : Double) -> Double {
  if area <= 0.0 {
    return 0.0
  }
  force / area
}

///|
/// 弯曲应力
/// σ = M * y / I
pub fn bending_stress(moment : Double, y : Double, inertia : Double) -> Double {
  if inertia <= 0.0 {
    return 0.0
  }
  moment * y / inertia
}

///|
/// 扭转剪应力
/// τ = T * r / J
pub fn torsional_stress(
  torque : Double,
  r : Double,
  polar_inertia : Double,
) -> Double {
  if polar_inertia <= 0.0 {
    return 0.0
  }
  torque * r / polar_inertia
}

// ==================== 截面几何性质 ====================

///|
/// 圆形截面惯性矩
/// I = π * d⁴ / 64
pub fn circle_inertia(d : Double) -> Double {
  PI * pow4(d) / 64.0
}

///|
/// 圆形截面极惯性矩
/// J = π * d⁴ / 32
pub fn circle_polar_inertia(d : Double) -> Double {
  PI * pow4(d) / 32.0
}

///|
/// 圆形截面抗弯模量
/// W = π * d³ / 32
pub fn circle_section_modulus(d : Double) -> Double {
  PI * cube(d) / 32.0
}

///|
/// 矩形截面惯性矩
/// I = b * h³ / 12
pub fn rect_inertia(b : Double, h : Double) -> Double {
  b * cube(h) / 12.0
}

///|
/// 矩形截面抗弯模量
/// W = b * h² / 6
pub fn rect_section_modulus(b : Double, h : Double) -> Double {
  b * square(h) / 6.0
}

// ==================== 数值方法 ====================

///|
/// 牛顿法求根
/// f: 函数, df: 导数, x0: 初始值
pub fn newton_method(
  f : (Double) -> Double,
  df : (Double) -> Double,
  x0 : Double,
  tolerance : Double,
) -> Double {
  let mut x = x0
  let mut i = 0
  while i < 50 {
    let fx = f(x)
    if abs(fx) < tolerance {
      return x
    }
    let dfx = df(x)
    if abs(dfx) < EPSILON {
      return x
    }
    x = x - fx / dfx
    i = i + 1
  }
  x
}

///|
/// 二分法求根
pub fn bisection(
  f : (Double) -> Double,
  a : Double,
  b : Double,
  tolerance : Double,
) -> Double {
  let mut left = a
  let mut right = b
  let mut mid = (left + right) / 2.0
  let mut i = 0
  while abs(right - left) > tolerance && i < 100 {
    mid = (left + right) / 2.0
    let f_mid = f(mid)
    let f_left = f(left)
    if f_mid * f_left < 0.0 {
      right = mid
    } else {
      left = mid
    }
    i = i + 1
  }
  mid
}


