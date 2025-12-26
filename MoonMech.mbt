// MoonMech - 机械工程库
// 主模块：包含核心计算功能

// ==================== 齿轮传动 ====================

///|
/// 齿轮分度圆直径
/// d = m * z
/// 参数: m - 模数 (mm), z - 齿数
pub fn gear_pitch_diameter(m : Double, z : Int) -> Double {
  m * z.to_double()
}

///|
/// 齿轮齿顶圆直径
/// d_a = m * (z + 2*h_a*)
/// 参数: m - 模数, z - 齿数, ha_star - 齿顶高系数
pub fn gear_addendum_diameter(m : Double, z : Int, ha_star : Double) -> Double {
  m * (z.to_double() + 2.0 * ha_star)
}

///|
/// 齿轮齿根圆直径
/// d_f = m * (z - 2*h_a* - 2*c*)
/// 参数: m - 模数, z - 齿数, ha_star - 齿顶高系数, c_star - 顶隙系数
pub fn gear_dedendum_diameter(
  m : Double,
  z : Int,
  ha_star : Double,
  c_star : Double,
) -> Double {
  m * (z.to_double() - 2.0 * ha_star - 2.0 * c_star)
}

///|
/// 齿轮中心距
/// a = (d1 + d2) / 2 = m * (z1 + z2) / 2
pub fn gear_center_distance(m : Double, z1 : Int, z2 : Int) -> Double {
  m * (z1.to_double() + z2.to_double()) / 2.0
}

///|
/// 齿轮传动比
/// i = z2 / z1 = n1 / n2
pub fn gear_ratio(z1 : Int, z2 : Int) -> Double {
  if z1 == 0 {
    return 0.0
  }
  z2.to_double() / z1.to_double()
}

///|
/// 齿轮圆周力
/// F_t = 2*T / d
/// 参数: t - 转矩 (N·mm), d - 分度圆直径 (mm)
pub fn gear_tangential_force(t : Double, d : Double) -> Double {
  if d <= 0.0 {
    return 0.0
  }
  2.0 * t / d
}

///|
/// 齿轮径向力
/// F_r = F_t * tan(α)
/// 参数: ft - 圆周力 (N), alpha_deg - 压力角 (度)
pub fn gear_radial_force(ft : Double, alpha_deg : Double) -> Double {
  let alpha_rad = deg_to_rad(alpha_deg)
  ft * tan(alpha_rad)
}

///|
/// 齿轮法向力
/// F_n = F_t / cos(α)
pub fn gear_normal_force(ft : Double, alpha_deg : Double) -> Double {
  let alpha_rad = deg_to_rad(alpha_deg)
  if abs(cos(alpha_rad)) < EPSILON {
    return 0.0
  }
  ft / cos(alpha_rad)
}

///|
/// 齿轮接触应力 (简化)
/// σ_H = K * √(F_t / (b * d))
/// 参数: k - 系数, ft - 圆周力, b - 齿宽, d - 分度圆直径
pub fn gear_contact_stress(
  k : Double,
  ft : Double,
  b : Double,
  d : Double,
) -> Double {
  if b <= 0.0 || d <= 0.0 {
    return 0.0
  }
  k * (ft / (b * d)).sqrt()
}

///|
/// 齿轮弯曲应力 (简化)
/// σ_F = K * F_t / (b * m * Y)
/// 参数: k - 系数, ft - 圆周力, b - 齿宽, m - 模数, y - 齿形系数
pub fn gear_bending_stress(
  k : Double,
  ft : Double,
  b : Double,
  m : Double,
  y : Double,
) -> Double {
  if b <= 0.0 || m <= 0.0 || y <= 0.0 {
    return 0.0
  }
  k * ft / (b * m * y)
}

// ==================== 带传动 ====================

///|
/// 带传动传动比
/// i = n1 / n2 = d2 / d1
pub fn belt_ratio(d1 : Double, d2 : Double) -> Double {
  if d1 <= 0.0 {
    return 0.0
  }
  d2 / d1
}

///|
/// 带传动包角
/// α = 180° - 2*arcsin((d2-d1)/(2*a))
/// 参数: d1, d2 - 带轮直径 (mm), a - 中心距 (mm)
pub fn belt_contact_angle(d1 : Double, d2 : Double, a : Double) -> Double {
  if a <= 0.0 {
    return 0.0
  }
  let term = (d2 - d1) / (2.0 * a)
  let alpha_rad = PI - 2.0 * asin(clamp(term, -1.0, 1.0))
  rad_to_deg(alpha_rad)
}

///|
/// 带传动带长
/// L ≈ 2*a + π*(d1+d2)/2 + (d2-d1)²/(4*a)
pub fn belt_length(d1 : Double, d2 : Double, a : Double) -> Double {
  2.0 * a + PI * (d1 + d2) / 2.0 + square(d2 - d1) / (4.0 * a)
}

///|
/// 带传动有效拉力
/// F_e = 1000*P / v
/// 参数: p - 功率 (kW), v - 带速 (m/s)
pub fn belt_effective_tension(p : Double, v : Double) -> Double {
  if v <= 0.0 {
    return 0.0
  }
  1000.0 * p / v
}

///|
/// 带传动紧边拉力
/// F_1 = F_e * e^(μα) / (e^(μα) - 1)
/// 参数: fe - 有效拉力, mu - 摩擦系数, alpha_deg - 包角
pub fn belt_tight_side_tension(
  fe : Double,
  mu : Double,
  alpha_deg : Double,
) -> Double {
  let alpha_rad = deg_to_rad(alpha_deg)
  let exp_term = @math.exp(mu * alpha_rad)
  if abs(exp_term - 1.0) < EPSILON {
    return 0.0
  }
  fe * exp_term / (exp_term - 1.0)
}

///|
/// 带传动松边拉力
/// F_2 = F_1 - F_e
pub fn belt_slack_side_tension(f1 : Double, fe : Double) -> Double {
  f1 - fe
}

// ==================== 链传动 ====================

///|
/// 链传动传动比
/// i = z2 / z1 = n1 / n2
pub fn chain_ratio(z1 : Int, z2 : Int) -> Double {
  if z1 == 0 {
    return 0.0
  }
  z2.to_double() / z1.to_double()
}

///|
/// 链传动中心距
/// a = (30~50) * p (推荐)
/// 参数: p - 节距 (mm)
pub fn chain_center_distance(p : Double, factor : Double) -> Double {
  factor * p
}

///|
/// 链节数
/// L_p ≈ 2*a/p + (z1+z2)/2 + (z2-z1)²/(4*π²*a/p)
pub fn chain_length(a : Double, p : Double, z1 : Int, z2 : Int) -> Double {
  if p <= 0.0 {
    return 0.0
  }
  let a_p = a / p
  2.0 * a_p +
  (z1.to_double() + z2.to_double()) / 2.0 +
  square(z2.to_double() - z1.to_double()) / (4.0 * square(PI) * a_p)
}

///|
/// 链速
/// v = z * p * n / (60*1000)
/// 参数: z - 齿数, p - 节距 (mm), n - 转速 (rpm)
pub fn chain_velocity(z : Int, p : Double, n : Double) -> Double {
  z.to_double() * p * n / 60000.0
}

///|
/// 链传动有效拉力
/// F = 1000*P / v
pub fn chain_effective_tension(p : Double, v : Double) -> Double {
  if v <= 0.0 {
    return 0.0
  }
  1000.0 * p / v
}

// ==================== 蜗杆传动 ====================

///|
/// 蜗杆传动比
/// i = z2 / z1
/// 参数: z1 - 蜗杆头数, z2 - 蜗轮齿数
pub fn worm_ratio(z1 : Int, z2 : Int) -> Double {
  if z1 == 0 {
    return 0.0
  }
  z2.to_double() / z1.to_double()
}

///|
/// 蜗杆导程角
/// γ = arctan(z1 * m / d1)
/// 参数: z1 - 头数, m - 模数, d1 - 蜗杆分度圆直径
pub fn worm_lead_angle(z1 : Int, m : Double, d1 : Double) -> Double {
  if d1 <= 0.0 {
    return 0.0
  }
  let gamma_rad = atan2(z1.to_double() * m, d1)
  rad_to_deg(gamma_rad)
}

///|
/// 蜗杆传动效率 (简化)
/// η = tan(γ) / tan(γ + φ_v)
/// 参数: gamma_deg - 导程角, phi_v_deg - 当量摩擦角
pub fn worm_efficiency(gamma_deg : Double, phi_v_deg : Double) -> Double {
  let gamma_rad = deg_to_rad(gamma_deg)
  let phi_v_rad = deg_to_rad(phi_v_deg)
  let tan_gamma = tan(gamma_rad)
  let tan_sum = tan(gamma_rad + phi_v_rad)
  if abs(tan_sum) < EPSILON {
    return 0.0
  }
  tan_gamma / tan_sum
}

// ==================== 轴设计 ====================

///|
/// 轴最小直径估算 (扭转强度)
/// d ≥ (16*T/(π*[τ]))^(1/3)
/// 参数: t - 转矩 (N·mm), tau_allow - 许用扭转应力 (MPa)
/// 返回: 直径 (m)
pub fn shaft_min_diameter_torsion(t : Double, tau_allow : Double) -> Double {
  if tau_allow <= 0.0 {
    return 0.0
  }
  // T单位是N·mm, 需要转成N·m
  let t_nm = t * NMM_TO_NM
  let tau_pa = tau_allow * MPA_TO_PA
  let d3 = 16.0 * t_nm / (PI * tau_pa)
  if d3 <= 0.0 {
    return 0.0
  }
  cbrt(d3)
}

///|
/// 立方根函数
pub fn cbrt(x : Double) -> Double {
  if x == 0.0 {
    0.0
  } else if x < 0.0 {
    -cbrt(-x)
  } else {
    let mut y = x
    let mut i = 0
    while i < 20 {
      let y3 = y * y * y
      let y2 = y * y
      if abs(y2) < EPSILON {
        break
      }
      let y_new = y - (y3 - x) / (3.0 * y2)
      if abs(y_new - y) < EPSILON {
        return y_new
      }
      y = y_new
      i = i + 1
    }
    y
  }
}

///|
/// 轴当量弯矩
/// M_e = √(M² + (α*T)²)
/// 参数: m - 弯矩, t - 转矩, alpha - 折算系数
pub fn shaft_equivalent_moment(
  m : Double,
  t : Double,
  alpha : Double,
) -> Double {
  (square(m) + square(alpha * t)).sqrt()
}

///|
/// 轴当量应力
/// σ_e = M_e / W
/// 参数: me - 当量弯矩, w - 抗弯模量
pub fn shaft_equivalent_stress(me : Double, w : Double) -> Double {
  if w <= 0.0 {
    return 0.0
  }
  me / w
}

///|
/// 轴临界转速 (简化)
/// n_cr = 30*π / L² * √(E*I / (ρ*A))
/// 参数: l - 轴长, e - 弹性模量, i - 惯性矩, rho - 密度, a - 截面积
pub fn shaft_critical_speed(
  l : Double,
  e : Double,
  i : Double,
  rho : Double,
  a : Double,
) -> Double {
  if l <= 0.0 || i <= 0.0 || rho <= 0.0 || a <= 0.0 {
    return 0.0
  }
  let e_pa = e * GPA_TO_PA
  let term = (e_pa * i / (rho * a)).sqrt()
  30.0 * PI / square(l) * term
}

// ==================== 轴承 ====================

///|
/// 轴承当量动载荷
/// P = X*F_r + Y*F_a
/// 参数: x - 径向系数, fr - 径向载荷, y - 轴向系数, fa - 轴向载荷
pub fn bearing_equivalent_dynamic_load(
  x : Double,
  fr : Double,
  y : Double,
  fa : Double,
) -> Double {
  x * fr + y * fa
}

///|
/// 轴承寿命计算
/// L_10 = (C/P)^p * 10^6
/// 参数: c - 基本额定动载荷, p - 当量动载荷, p_exp - 寿命指数
pub fn bearing_life(c : Double, p : Double, p_exp : Double) -> Double {
  if p <= 0.0 {
    return 0.0
  }
  let ratio = c / p
  let mut result = 1.0
  let mut i = 0
  while i < p_exp.to_int() {
    result = result * ratio
    i = i + 1
  }
  result * 1000000.0
}

///|
/// 轴承寿命 (小时)
/// L_h = L_10 / (60*n)
/// 参数: l10 - 寿命 (转), n - 转速 (rpm)
pub fn bearing_life_hours(l10 : Double, n : Double) -> Double {
  if n <= 0.0 {
    return 0.0
  }
  l10 / (60.0 * n)
}

///|
/// 轴承所需基本额定动载荷
/// C ≥ P * (L_h * 60 * n / 10^6)^(1/p)
pub fn bearing_required_c(
  p : Double,
  lh : Double,
  n : Double,
  p_exp : Double,
) -> Double {
  if n <= 0.0 || p_exp <= 0.0 {
    return 0.0
  }
  let term = (lh * 60.0 * n / 1000000.0).pow(1.0 / p_exp)
  p * term
}

///|
/// 幂函数 (简化，仅用于正数)
pub fn pow(x : Double, y : Double) -> Double {
  if x <= 0.0 {
    return 0.0
  }
  if abs(y - 1.0) < EPSILON {
    return x
  }
  if abs(y - 2.0) < EPSILON {
    return square(x)
  }
  if abs(y - 3.0) < EPSILON {
    return cube(x)
  }
  // 使用对数: x^y = exp(y * ln(x))
  let ln_x = @math.ln(x)
  @math.exp(y * ln_x)
}

// ==================== 螺纹连接 ====================

///|
/// 螺纹中径
/// d_2 ≈ 0.85 * d
/// 参数: d - 公称直径
pub fn thread_pitch_diameter(d : Double) -> Double {
  D2_COEFF * d
}

///|
/// 螺纹升角
/// λ = arctan(P / (π*d_2))
/// 参数: p - 螺距, d2 - 中径
pub fn thread_lead_angle(p : Double, d2 : Double) -> Double {
  if d2 <= 0.0 {
    return 0.0
  }
  let lambda_rad = atan2(p, PI * d2)
  rad_to_deg(lambda_rad)
}

///|
/// 螺纹自锁条件
/// λ ≤ φ
/// 参数: lambda_deg - 升角, phi_deg - 摩擦角
pub fn thread_self_locking(lambda_deg : Double, phi_deg : Double) -> Bool {
  lambda_deg <= phi_deg
}

///|
/// 螺纹预紧力 (简化)
/// F_0 = 0.6 * σ_s * A_s
/// 参数: sigma_s - 屈服强度, area_s - 螺纹应力截面积
pub fn thread_preload(sigma_s : Double, area_s : Double) -> Double {
  0.6 * sigma_s * area_s
}

// ==================== 键连接 ====================

///|
/// 键连接挤压应力
/// σ_p = 2*T / (d * k * l)
/// 参数: t - 转矩, d - 轴径, k - 键高, l - 键长
pub fn key_crushing_stress(
  t : Double,
  d : Double,
  k : Double,
  l : Double,
) -> Double {
  if d <= 0.0 || k <= 0.0 || l <= 0.0 {
    return 0.0
  }
  2.0 * t / (d * k * l)
}

///|
/// 键连接剪切应力
/// τ = 2*T / (d * b * l)
/// 参数: t - 转矩, d - 轴径, b - 键宽, l - 键长
pub fn key_shear_stress(
  t : Double,
  d : Double,
  b : Double,
  l : Double,
) -> Double {
  if d <= 0.0 || b <= 0.0 || l <= 0.0 {
    return 0.0
  }
  2.0 * t / (d * b * l)
}

///|
/// 键连接强度验算
pub fn key_strength_check(
  sigma_p : Double,
  tau : Double,
  sigma_p_allow : Double,
  tau_allow : Double,
) -> Bool {
  sigma_p <= sigma_p_allow && tau <= tau_allow
}

// ==================== 弹簧设计 ====================

///|
/// 压缩弹簧刚度
/// k = G * d⁴ / (8 * D³ * n)
/// 参数: g - 剪切模量, d - 簧丝直径, d_mean - 中径, n - 有效圈数
pub fn spring_stiffness(
  g : Double,
  d : Double,
  d_mean : Double,
  n : Int,
) -> Double {
  if d_mean <= 0.0 || n <= 0 {
    return 0.0
  }
  let g_pa = g * GPA_TO_PA
  g_pa * pow4(d) / (8.0 * cube(d_mean) * n.to_double())
}

///|
/// 压缩弹簧最大应力
/// τ_max = K * 8*F*D / (π*d³)
/// 参数: k - 曲度系数, f - 载荷, d_mean - 中径, d - 簧丝直径
pub fn spring_max_stress(
  k : Double,
  f : Double,
  d_mean : Double,
  d : Double,
) -> Double {
  if d <= 0.0 {
    return 0.0
  }
  k * 8.0 * f * d_mean / (PI * cube(d))
}

///|
/// 压缩弹簧变形量
/// δ = F / k
pub fn spring_deflection(f : Double, k : Double) -> Double {
  if k <= 0.0 {
    return 0.0
  }
  f / k
}

///|
/// 弹簧旋绕比
/// C = D / d
pub fn spring_index(d_mean : Double, d : Double) -> Double {
  if d <= 0.0 {
    return 0.0
  }
  d_mean / d
}

///|
/// 弹簧曲度系数
/// K = (4*C - 1) / (4*C - 4) + 0.615/C
pub fn spring_curvature_coefficient(c : Double) -> Double {
  if c <= 0.0 {
    return 0.0
  }
  (4.0 * c - 1.0) / (4.0 * c - 4.0) + 0.615 / c
}

// ==================== 凸轮设计 ====================

///|
/// 凸轮压力角
/// α = arctan((ds/dφ - e) / (s + r_b))
/// 参数: ds_dphi - 位移对转角导数, e - 偏距, s - 位移, rb - 基圆半径
pub fn cam_pressure_angle(
  ds_dphi : Double,
  e : Double,
  s : Double,
  rb : Double,
) -> Double {
  if abs(s + rb) < EPSILON {
    return 0.0
  }
  let alpha_rad = atan2(ds_dphi - e, s + rb)
  rad_to_deg(alpha_rad)
}

///|
/// 凸轮理论廓线半径
/// ρ = √((s + r_b)² + e²)
pub fn cam_theoretical_radius(s : Double, rb : Double, e : Double) -> Double {
  (square(s + rb) + square(e)).sqrt()
}

// ==================== 四杆机构 ====================

///|
/// 四杆机构传动角
/// γ = arccos((b² + c² - a² - d²) / (2*b*c))
/// 参数: a, b, c, d - 四杆长度
pub fn four_bar_transmission_angle(
  a : Double,
  b : Double,
  c : Double,
  d : Double,
) -> Double {
  if b <= 0.0 || c <= 0.0 {
    return 0.0
  }
  let term = (square(b) + square(c) - square(a) - square(d)) / (2.0 * b * c)
  let gamma_rad = acos(clamp(term, -1.0, 1.0))
  rad_to_deg(gamma_rad)
}

///|
/// 曲柄存在条件
/// a + d < b + c (最短杆 + 最长杆 < 其余两杆之和)
pub fn crank_existence_condition(
  a : Double,
  b : Double,
  c : Double,
  d : Double,
) -> Bool {
  // 找到最小值和最大值
  let min_len = min(min(a, b), min(c, d))
  let max_len = max(max(a, b), max(c, d))
  let sum = a + b + c + d
  min_len + max_len < sum - min_len - max_len
}

// ==================== 飞轮设计 ====================

///|
/// 飞轮转动惯量
/// J = W_max / (ω² * δ)
/// 参数: w_max - 最大盈亏功, omega - 角速度, delta - 不均匀系数
pub fn flywheel_moment_of_inertia(
  w_max : Double,
  omega : Double,
  delta : Double,
) -> Double {
  if abs(omega) < EPSILON || delta <= 0.0 {
    return 0.0
  }
  w_max / (square(omega) * delta)
}

///|
/// 飞轮质量 (实心圆盘)
/// m = J / (r² / 2)
/// 参数: j - 转动惯量, r - 半径
pub fn flywheel_mass(j : Double, r : Double) -> Double {
  if r <= 0.0 {
    return 0.0
  }
  j / (square(r) / 2.0)
}

///|
/// 飞轮直径 (实心圆盘)
/// D = 2 * (2*J / (m*π))^(1/4)
pub fn flywheel_diameter(j : Double, m : Double) -> Double {
  if m <= 0.0 {
    return 0.0
  }
  let term = 2.0 * j / (m * PI)
  if term <= 0.0 {
    return 0.0
  }
  2.0 * pow(term, 0.25)
}

// ==================== 辅助函数 ====================

///|
/// 计算效率
/// η = P_out / P_in
pub fn efficiency(p_out : Double, p_in : Double) -> Double {
  if p_in <= 0.0 {
    return 0.0
  }
  clamp(p_out / p_in, 0.0, 1.0)
}

///|
/// 计算损失功率
/// P_loss = P_in - P_out
pub fn power_loss(p_in : Double, p_out : Double) -> Double {
  max(0.0, p_in - p_out)
}

// ==================== 齿轮传动扩展 ====================

///|
/// 斜齿轮法向模数
/// m_n = m_t * cos(β)
/// 参数: mt - 端面模数, beta_deg - 螺旋角
pub fn helical_gear_normal_module(mt : Double, beta_deg : Double) -> Double {
  let beta_rad = deg_to_rad(beta_deg)
  mt * cos(beta_rad)
}

///|
/// 斜齿轮端面模数
/// m_t = m_n / cos(β)
pub fn helical_gear_transverse_module(mn : Double, beta_deg : Double) -> Double {
  let beta_rad = deg_to_rad(beta_deg)
  if abs(cos(beta_rad)) < EPSILON {
    return 0.0
  }
  mn / cos(beta_rad)
}

///|
/// 斜齿轮轴向力
/// F_a = F_t * tan(β)
/// 参数: ft - 圆周力, beta_deg - 螺旋角
pub fn helical_gear_axial_force(ft : Double, beta_deg : Double) -> Double {
  let beta_rad = deg_to_rad(beta_deg)
  ft * tan(beta_rad)
}

///|
/// 锥齿轮分度圆锥角
/// δ = arctan(z1/z2) (小齿轮)
pub fn bevel_gear_pitch_angle(z1 : Int, z2 : Int) -> Double {
  if z2 == 0 {
    return 0.0
  }
  let delta_rad = atan2(z1.to_double(), z2.to_double())
  rad_to_deg(delta_rad)
}

///|
/// 锥齿轮当量齿数
/// z_v = z / cos(δ)
pub fn bevel_gear_equivalent_teeth(z : Int, delta_deg : Double) -> Double {
  let delta_rad = deg_to_rad(delta_deg)
  if abs(cos(delta_rad)) < EPSILON {
    return 0.0
  }
  z.to_double() / cos(delta_rad)
}

///|
/// 行星齿轮传动比
/// i = 1 + z3/z1 (当太阳轮固定时)
/// 参数: z1 - 太阳轮齿数, z3 - 内齿圈齿数
pub fn planetary_gear_ratio_sun_fixed(z1 : Int, z3 : Int) -> Double {
  if z1 == 0 {
    return 0.0
  }
  1.0 + z3.to_double() / z1.to_double()
}

///|
/// 变位齿轮中心距
/// a' = a * cos(α) / cos(α')
/// 参数: a - 标准中心距, alpha_deg - 标准压力角, alpha_prime_deg - 实际压力角
pub fn gear_center_distance_modified(
  a : Double,
  alpha_deg : Double,
  alpha_prime_deg : Double,
) -> Double {
  let alpha_rad = deg_to_rad(alpha_deg)
  let alpha_prime_rad = deg_to_rad(alpha_prime_deg)
  if abs(cos(alpha_prime_rad)) < EPSILON {
    return 0.0
  }
  a * cos(alpha_rad) / cos(alpha_prime_rad)
}

///|
/// 齿轮变位系数和
/// x_Σ = (z1+z2) * (inv(α') - inv(α)) / (2*tan(α))
/// 简化计算
pub fn gear_total_modification_coefficient(
  z1 : Int,
  z2 : Int,
  alpha_deg : Double,
  alpha_prime_deg : Double,
) -> Double {
  let alpha_rad = deg_to_rad(alpha_deg)
  let alpha_prime_rad = deg_to_rad(alpha_prime_deg)
  let tan_alpha = tan(alpha_rad)
  if abs(tan_alpha) < EPSILON {
    return 0.0
  }
  // 简化: inv(α) ≈ tan(α) - α (小角度)
  let inv_alpha = tan(alpha_rad) - alpha_rad
  let inv_alpha_prime = tan(alpha_prime_rad) - alpha_prime_rad
  (z1.to_double() + z2.to_double()) *
  (inv_alpha_prime - inv_alpha) /
  (2.0 * tan_alpha)
}

// ==================== 带传动扩展 ====================

///|
/// 同步带节距
/// p = π * d / z
pub fn timing_belt_pitch(d : Double, z : Int) -> Double {
  if z == 0 {
    return 0.0
  }
  PI * d / z.to_double()
}

///|
/// 同步带中心距 (推荐)
/// a = (0.7~2) * (d1+d2)
pub fn timing_belt_center_distance(
  d1 : Double,
  d2 : Double,
  factor : Double,
) -> Double {
  factor * (d1 + d2)
}

///|
/// 同步带带长
/// L = 2*a + π*(d1+d2)/2 + (d2-d1)²/(4*a)
pub fn timing_belt_length(d1 : Double, d2 : Double, a : Double) -> Double {
  2.0 * a + PI * (d1 + d2) / 2.0 + square(d2 - d1) / (4.0 * a)
}

///|
/// 多楔带有效拉力
/// F_e = 1000*P / v
pub fn multi_rib_belt_effective_tension(p : Double, v : Double) -> Double {
  if v <= 0.0 {
    return 0.0
  }
  1000.0 * p / v
}

// ==================== 轴设计扩展 ====================

///|
/// 轴扭转角
/// φ = T * L / (G * J)
/// 参数: t - 转矩, l - 长度, g - 剪切模量, j - 极惯性矩
pub fn shaft_torsional_angle(
  t : Double,
  l : Double,
  g : Double,
  j : Double,
) -> Double {
  if g <= 0.0 || j <= 0.0 {
    return 0.0
  }
  let g_pa = g * GPA_TO_PA
  t * l / (g_pa * j)
}

///|
/// 轴弯曲刚度
/// k = 48*E*I / L³
/// 参数: e - 弹性模量, i - 惯性矩, l - 长度
pub fn shaft_bending_stiffness(e : Double, i : Double, l : Double) -> Double {
  if l <= 0.0 {
    return 0.0
  }
  let e_pa = e * GPA_TO_PA
  48.0 * e_pa * i / cube(l)
}

///|
/// 轴疲劳强度安全系数
/// n = σ_{-1} / (K_σ * σ_a + ψ_σ * σ_m)
/// 参数: sigma_minus1 - 对称循环疲劳极限, k_sigma - 有效应力集中系数, sigma_a - 应力幅, psi_sigma - 平均应力影响系数, sigma_m - 平均应力
pub fn shaft_fatigue_safety_factor(
  sigma_minus1 : Double,
  k_sigma : Double,
  sigma_a : Double,
  psi_sigma : Double,
  sigma_m : Double,
) -> Double {
  let denominator = k_sigma * sigma_a + psi_sigma * sigma_m
  if abs(denominator) < EPSILON {
    return 0.0
  }
  sigma_minus1 / denominator
}

///|
/// 轴扭转疲劳强度
/// n_τ = τ_{-1} / (K_τ * τ_a + ψ_τ * τ_m)
pub fn shaft_torsional_fatigue_safety_factor(
  tau_minus1 : Double,
  k_tau : Double,
  tau_a : Double,
  psi_tau : Double,
  tau_m : Double,
) -> Double {
  let denominator = k_tau * tau_a + psi_tau * tau_m
  if abs(denominator) < EPSILON {
    return 0.0
  }
  tau_minus1 / denominator
}

///|
/// 轴综合安全系数
/// n = n_σ * n_τ / √(n_σ² + n_τ²)
pub fn shaft_combined_safety_factor(n_sigma : Double, n_tau : Double) -> Double {
  let sum_sq = square(n_sigma) + square(n_tau)
  if sum_sq <= 0.0 {
    return 0.0
  }
  n_sigma * n_tau / sum_sq.sqrt()
}

///|
/// 轴一阶临界转速 (简支梁)
/// n_cr1 = (π² / L²) * √(E*I / (ρ*A)) * 60 / (2π)
pub fn shaft_first_critical_speed(
  l : Double,
  e : Double,
  i : Double,
  rho : Double,
  a : Double,
) -> Double {
  if l <= 0.0 || i <= 0.0 || rho <= 0.0 || a <= 0.0 {
    return 0.0
  }
  let e_pa = e * GPA_TO_PA
  let term = (e_pa * i / (rho * a)).sqrt()
  square(PI) / square(l) * term * 60.0 / (2.0 * PI)
}

// ==================== 轴承扩展 ====================

///|
/// 深沟球轴承当量动载荷 (简化)
/// P = F_r (当 F_a/F_r ≤ e)
/// P = 0.56*F_r + Y*F_a (当 F_a/F_r > e)
pub fn deep_groove_ball_bearing_equivalent_load(
  fr : Double,
  fa : Double,
  e : Double,
  y : Double,
) -> Double {
  if abs(fr) < EPSILON {
    return 0.0
  }
  let ratio = fa / fr
  if ratio <= e {
    fr
  } else {
    0.56 * fr + y * fa
  }
}

///|
/// 角接触球轴承当量动载荷
/// P = F_r (当 F_a/F_r ≤ e)
/// P = 0.44*F_r + Y*F_a (当 F_a/F_r > e)
pub fn angular_contact_ball_bearing_equivalent_load(
  fr : Double,
  fa : Double,
  e : Double,
  y : Double,
) -> Double {
  if abs(fr) < EPSILON {
    return 0.0
  }
  let ratio = fa / fr
  if ratio <= e {
    fr
  } else {
    0.44 * fr + y * fa
  }
}

///|
/// 圆锥滚子轴承当量动载荷
/// P = F_r (当 F_a/F_r ≤ e)
/// P = 0.4*F_r + Y*F_a (当 F_a/F_r > e)
pub fn tapered_roller_bearing_equivalent_load(
  fr : Double,
  fa : Double,
  e : Double,
  y : Double,
) -> Double {
  if abs(fr) < EPSILON {
    return 0.0
  }
  let ratio = fa / fr
  if ratio <= e {
    fr
  } else {
    0.4 * fr + y * fa
  }
}

///|
/// 轴承预紧力 (角接触球轴承)
/// F_0 = 0.5 * F_a
pub fn bearing_preload(fa : Double) -> Double {
  0.5 * fa
}

///|
/// 轴承润滑脂寿命修正
/// L = L_10 * a_1 * a_2 * a_3
/// 参数: l10 - 基本寿命, a1 - 可靠性系数, a2 - 材料系数, a3 - 工作条件系数
pub fn bearing_adjusted_life(
  l10 : Double,
  a1 : Double,
  a2 : Double,
  a3 : Double,
) -> Double {
  l10 * a1 * a2 * a3
}

// ==================== 连接设计扩展 ====================

///|
/// 销连接剪切应力
/// τ = 4*F / (π*d²)
/// 参数: f - 载荷, d - 销直径
pub fn pin_shear_stress(f : Double, d : Double) -> Double {
  if d <= 0.0 {
    return 0.0
  }
  4.0 * f / (PI * square(d))
}

///|
/// 销连接挤压应力
/// σ_p = F / (d * t)
/// 参数: f - 载荷, d - 销直径, t - 被连接件厚度
pub fn pin_crushing_stress(f : Double, d : Double, t : Double) -> Double {
  if d <= 0.0 || t <= 0.0 {
    return 0.0
  }
  f / (d * t)
}

///|
/// 铆接剪切强度
/// τ = F / (n * π*d²/4)
/// 参数: f - 载荷, n - 铆钉数, d - 铆钉直径
pub fn rivet_shear_stress(f : Double, n : Int, d : Double) -> Double {
  if n <= 0 || d <= 0.0 {
    return 0.0
  }
  let area = PI * square(d) / 4.0
  f / (n.to_double() * area)
}

///|
/// 铆接挤压强度
/// σ_p = F / (n * d * t)
pub fn rivet_crushing_stress(
  f : Double,
  n : Int,
  d : Double,
  t : Double,
) -> Double {
  if n <= 0 || d <= 0.0 || t <= 0.0 {
    return 0.0
  }
  f / (n.to_double() * d * t)
}

///|
/// 过盈配合接触压力
/// p = δ / (d * (1/E1 + 1/E2) * (C1 + C2))
/// 参数: delta - 过盈量, d - 配合直径, e1, e2 - 弹性模量, c1, c2 - 系数
pub fn interference_fit_contact_pressure(
  delta : Double,
  d : Double,
  e1 : Double,
  e2 : Double,
  c1 : Double,
  c2 : Double,
) -> Double {
  if d <= 0.0 || abs(e1) < EPSILON || abs(e2) < EPSILON {
    return 0.0
  }
  let e1_pa = e1 * GPA_TO_PA
  let e2_pa = e2 * GPA_TO_PA
  let term = (1.0 / e1_pa + 1.0 / e2_pa) * (c1 + c2)
  if abs(term) < EPSILON {
    return 0.0
  }
  delta / (d * term)
}

///|
/// 过盈配合传递转矩
/// T = π * d² * l * p * μ / 2
/// 参数: d - 配合直径, l - 配合长度, p - 接触压力, mu - 摩擦系数
pub fn interference_fit_torque(
  d : Double,
  l : Double,
  p : Double,
  mu : Double,
) -> Double {
  PI * square(d) * l * p * mu / 2.0
}

// ==================== 弹簧设计扩展 ====================

///|
/// 拉伸弹簧刚度
/// k = G * d⁴ / (8 * D³ * n)
pub fn extension_spring_stiffness(
  g : Double,
  d : Double,
  d_mean : Double,
  n : Int,
) -> Double {
  spring_stiffness(g, d, d_mean, n)
}

///|
/// 拉伸弹簧初拉力
/// F_0 = π*d³*τ_0 / (8*D*K)
/// 参数: d - 簧丝直径, d_mean - 中径, tau0 - 初应力, k - 曲度系数
pub fn extension_spring_initial_tension(
  d : Double,
  d_mean : Double,
  tau0 : Double,
  k : Double,
) -> Double {
  if d_mean <= 0.0 || k <= 0.0 {
    return 0.0
  }
  PI * cube(d) * tau0 / (8.0 * d_mean * k)
}

///|
/// 扭转弹簧刚度
/// k_t = E * d⁴ / (64 * D * n)
/// 参数: e - 弹性模量, d - 簧丝直径, d_mean - 中径, n - 圈数
pub fn torsion_spring_stiffness(
  e : Double,
  d : Double,
  d_mean : Double,
  n : Int,
) -> Double {
  if d_mean <= 0.0 || n <= 0 {
    return 0.0
  }
  let e_pa = e * GPA_TO_PA
  e_pa * pow4(d) / (64.0 * d_mean * n.to_double())
}

///|
/// 扭转弹簧最大应力
/// σ_max = 32*T / (π*d³)
pub fn torsion_spring_max_stress(t : Double, d : Double) -> Double {
  if d <= 0.0 {
    return 0.0
  }
  32.0 * t / (PI * cube(d))
}

///|
/// 碟形弹簧载荷
/// F = (4*E*t⁴ / ((1-ν²)*D²)) * f * ((h-t*f) * (h-t*f/2) + t²)
/// 简化公式
pub fn disc_spring_load(
  e : Double,
  t : Double,
  nu : Double,
  d : Double,
  h : Double,
  f : Double,
) -> Double {
  if d <= 0.0 || abs(1.0 - square(nu)) < EPSILON {
    return 0.0
  }
  let e_pa = e * GPA_TO_PA
  let coeff = 4.0 * e_pa * pow4(t) / ((1.0 - square(nu)) * square(d))
  let term = (h - t * f) * (h - t * f / 2.0) + square(t)
  coeff * f * term
}

// ==================== 凸轮设计扩展 ====================

///|
/// 等速运动规律位移
/// s = h * φ / φ_0
/// 参数: h - 升程, phi - 转角, phi0 - 总转角
pub fn cam_constant_velocity_displacement(
  h : Double,
  phi : Double,
  phi0 : Double,
) -> Double {
  if phi0 <= 0.0 {
    return 0.0
  }
  h * phi / phi0
}

///|
/// 等加速等减速运动规律位移
/// s = 2*h*(φ/φ_0)² (前半段)
/// s = h - 2*h*(1-φ/φ_0)² (后半段)
pub fn cam_constant_acceleration_displacement(
  h : Double,
  phi : Double,
  phi0 : Double,
) -> Double {
  if phi0 <= 0.0 {
    return 0.0
  }
  let ratio = phi / phi0
  if ratio <= 0.5 {
    2.0 * h * square(ratio)
  } else {
    h - 2.0 * h * square(1.0 - ratio)
  }
}

///|
/// 简谐运动规律位移
/// s = h * (1 - cos(π*φ/φ_0)) / 2
pub fn cam_harmonic_displacement(
  h : Double,
  phi : Double,
  phi0 : Double,
) -> Double {
  if phi0 <= 0.0 {
    return 0.0
  }
  h * (1.0 - cos(PI * phi / phi0)) / 2.0
}

///|
/// 摆线运动规律位移
/// s = h * (φ/φ_0 - sin(2π*φ/φ_0)/(2π))
pub fn cam_cycloidal_displacement(
  h : Double,
  phi : Double,
  phi0 : Double,
) -> Double {
  if phi0 <= 0.0 {
    return 0.0
  }
  let ratio = phi / phi0
  h * (ratio - sin(2.0 * PI * ratio) / (2.0 * PI))
}

///|
/// 凸轮从动件速度
/// v = ds/dφ * dφ/dt = ds/dφ * ω
pub fn cam_follower_velocity(ds_dphi : Double, omega : Double) -> Double {
  ds_dphi * omega
}

///|
/// 凸轮从动件加速度
/// a = d²s/dφ² * ω²
pub fn cam_follower_acceleration(d2s_dphi2 : Double, omega : Double) -> Double {
  d2s_dphi2 * square(omega)
}

// ==================== 机构扩展 ====================

///|
/// 滑块机构位移
/// s = r * (1 - cos(θ))
/// 参数: r - 曲柄长度, theta_deg - 曲柄转角
pub fn slider_crank_displacement(r : Double, theta_deg : Double) -> Double {
  let theta_rad = deg_to_rad(theta_deg)
  r * (1.0 - cos(theta_rad))
}

///|
/// 滑块机构速度
/// v = r * ω * sin(θ)
pub fn slider_crank_velocity(
  r : Double,
  omega : Double,
  theta_deg : Double,
) -> Double {
  let theta_rad = deg_to_rad(theta_deg)
  r * omega * sin(theta_rad)
}

///|
/// 滑块机构加速度
/// a = r * ω² * cos(θ)
pub fn slider_crank_acceleration(
  r : Double,
  omega : Double,
  theta_deg : Double,
) -> Double {
  let theta_rad = deg_to_rad(theta_deg)
  r * square(omega) * cos(theta_rad)
}

///|
/// 槽轮机构运动系数
/// k = (z-2) / (2*(z-1))
/// 参数: z - 槽数
pub fn geneva_drive_motion_coefficient(z : Int) -> Double {
  if z <= 2 {
    return 0.0
  }
  (z.to_double() - 2.0) / (2.0 * (z.to_double() - 1.0))
}

///|
/// 槽轮机构静止时间
/// t_s = (1-k) * T
/// 参数: k - 运动系数, t - 周期
pub fn geneva_drive_stationary_time(k : Double, t : Double) -> Double {
  (1.0 - k) * t
}

// ==================== 联轴器 ====================

///|
/// 刚性联轴器传递转矩
/// T = F * r
/// 参数: f - 切向力, r - 半径
pub fn rigid_coupling_torque(f : Double, r : Double) -> Double {
  f * r
}

///|
/// 弹性联轴器传递转矩
/// T = k * θ
/// 参数: k - 扭转刚度, theta_rad - 扭转角
pub fn flexible_coupling_torque(k : Double, theta_rad : Double) -> Double {
  k * theta_rad
}

///|
/// 万向联轴器传动比 (单万向节)
/// i = cos(β) / (1 - sin²(β)*cos²(φ))
/// 参数: beta_deg - 轴间夹角, phi_deg - 主动轴转角
pub fn universal_joint_ratio(beta_deg : Double, phi_deg : Double) -> Double {
  let beta_rad = deg_to_rad(beta_deg)
  let phi_rad = deg_to_rad(phi_deg)
  let cos_beta = cos(beta_rad)
  let sin_beta = sin(beta_rad)
  let cos_phi = cos(phi_rad)
  if abs(1.0 - square(sin_beta) * square(cos_phi)) < EPSILON {
    return 0.0
  }
  cos_beta / (1.0 - square(sin_beta) * square(cos_phi))
}

// ==================== 离合器 ====================

///|
/// 摩擦离合器传递转矩
/// T = μ * F * R_m * n
/// 参数: mu - 摩擦系数, f - 压紧力, rm - 平均半径, n - 摩擦面数
pub fn friction_clutch_torque(
  mu : Double,
  f : Double,
  rm : Double,
  n : Int,
) -> Double {
  mu * f * rm * n.to_double()
}

///|
/// 摩擦离合器所需压紧力
/// F = T / (μ * R_m * n)
pub fn friction_clutch_required_force(
  t : Double,
  mu : Double,
  rm : Double,
  n : Int,
) -> Double {
  if abs(mu * rm * n.to_double()) < EPSILON {
    return 0.0
  }
  t / (mu * rm * n.to_double())
}

///|
/// 超越离合器传递转矩
/// T = F * r * tan(α)
/// 参数: f - 法向力, r - 半径, alpha_deg - 楔角
pub fn overrunning_clutch_torque(
  f : Double,
  r : Double,
  alpha_deg : Double,
) -> Double {
  let alpha_rad = deg_to_rad(alpha_deg)
  f * r * tan(alpha_rad)
}

// ==================== 制动器 ====================

///|
/// 块式制动器制动力矩
/// M = μ * F * R
/// 参数: mu - 摩擦系数, f - 制动力, r - 制动轮半径
pub fn block_brake_torque(mu : Double, f : Double, r : Double) -> Double {
  mu * f * r
}

///|
/// 带式制动器制动力矩
/// M = (F_1 - F_2) * R
pub fn band_brake_torque(f1 : Double, f2 : Double, r : Double) -> Double {
  (f1 - f2) * r
}

///|
/// 盘式制动器制动力矩
/// M = μ * F * R_m * n
/// 参数: mu - 摩擦系数, f - 压紧力, rm - 平均半径, n - 摩擦面数
pub fn disc_brake_torque(
  mu : Double,
  f : Double,
  rm : Double,
  n : Int,
) -> Double {
  mu * f * rm * n.to_double()
}

// ==================== 润滑 ====================

///|
/// 滑动轴承油膜厚度
/// h_min = c * (1 - ε)
/// 参数: c - 半径间隙, epsilon - 偏心率
pub fn journal_bearing_film_thickness(c : Double, epsilon : Double) -> Double {
  c * (1.0 - epsilon)
}

///|
/// 滑动轴承承载能力 (简化)
/// W = 6*μ*ω*R*L / (c²) * f(ε)
/// 参数: mu - 动力粘度, omega - 角速度, r - 半径, l - 长度, c - 半径间隙, epsilon - 偏心率
pub fn journal_bearing_load_capacity(
  mu : Double,
  omega : Double,
  r : Double,
  l : Double,
  c : Double,
  epsilon : Double,
) -> Double {
  if c <= 0.0 {
    return 0.0
  }
  // 简化: f(ε) ≈ 2*ε
  let f_epsilon = 2.0 * epsilon
  6.0 * mu * omega * r * l / square(c) * f_epsilon
}

///|
/// 滑动轴承摩擦功率损失
/// P_f = μ * ω² * R² * L / c
pub fn journal_bearing_friction_power(
  mu : Double,
  omega : Double,
  r : Double,
  l : Double,
  c : Double,
) -> Double {
  if c <= 0.0 {
    return 0.0
  }
  mu * square(omega) * square(r) * l / c
}

///|
/// 滑动轴承温升
/// ΔT = P_f / (c_p * ρ * Q)
/// 参数: pf - 摩擦功率, cp - 比热容, rho - 密度, q - 流量
pub fn journal_bearing_temperature_rise(
  pf : Double,
  cp : Double,
  rho : Double,
  q : Double,
) -> Double {
  if abs(cp * rho * q) < EPSILON {
    return 0.0
  }
  pf / (cp * rho * q)
}

// ==================== 密封 ====================

///|
/// O型圈压缩量
/// δ = (d_0 - d_g) / d_0
/// 参数: d0 - 原始直径, dg - 沟槽直径
pub fn o_ring_compression(d0 : Double, dg : Double) -> Double {
  if d0 <= 0.0 {
    return 0.0
  }
  (d0 - dg) / d0
}

///|
/// 机械密封端面比压
/// p = F / A + p_0
/// 参数: f - 弹簧力, a - 端面面积, p0 - 介质压力
pub fn mechanical_seal_face_pressure(
  f : Double,
  a : Double,
  p0 : Double,
) -> Double {
  if a <= 0.0 {
    return 0.0
  }
  f / a + p0
}

// ==================== 公差配合 ====================

///|
/// 基本偏差 (孔, H)
/// ES = IT (上偏差)
pub fn basic_deviation_hole_h(it : Double) -> Double {
  it
}

///|
/// 基本偏差 (轴, h)
/// es = 0 (上偏差)
pub fn basic_deviation_shaft_h() -> Double {
  0.0
}

///|
/// 配合间隙
/// X = D_max - d_min = ES - ei
/// 参数: es - 孔上偏差, ei - 轴下偏差
pub fn fit_clearance(es : Double, ei : Double) -> Double {
  es - ei
}

///|
/// 配合过盈
/// Y = d_max - D_min = es - EI
/// 参数: es - 轴上偏差, ei - 孔下偏差
pub fn fit_interference(es : Double, ei : Double) -> Double {
  es - ei
}

///|
/// 配合类型判断
/// 返回: "clearance", "interference", "transition"
pub fn fit_type(clearance : Double, interference : Double) -> String {
  if clearance > 0.0 {
    "clearance"
  } else if interference > 0.0 {
    "interference"
  } else {
    "transition"
  }
}

// ==================== 减速器 ====================

///|
/// 单级圆柱齿轮减速器传动比
/// i = z2 / z1
pub fn single_stage_reducer_ratio(z1 : Int, z2 : Int) -> Double {
  gear_ratio(z1, z2)
}

///|
/// 二级圆柱齿轮减速器总传动比
/// i_total = i1 * i2
pub fn two_stage_reducer_ratio(i1 : Double, i2 : Double) -> Double {
  i1 * i2
}

///|
/// 减速器效率
/// η = η1 * η2 * ... (各级效率乘积)
pub fn reducer_efficiency(efficiencies : Array[Double]) -> Double {
  let mut result = 1.0
  for i = 0; i < efficiencies.length(); i = i + 1 {
    result = result * efficiencies[i]
  }
  result
}

///|
/// 减速器输出转矩
/// T_out = T_in * i * η
pub fn reducer_output_torque(t_in : Double, i : Double, eta : Double) -> Double {
  t_in * i * eta
}

// ==================== 振动分析 ====================

///|
/// 单自由度系统固有频率
/// ω_n = √(k / m)
/// 参数: k - 刚度, m - 质量
pub fn natural_frequency_sdof(k : Double, m : Double) -> Double {
  if m <= 0.0 {
    return 0.0
  }
  (k / m).sqrt()
}

///|
/// 单自由度系统阻尼比
/// ζ = c / (2*√(k*m))
/// 参数: c - 阻尼系数, k - 刚度, m - 质量
pub fn damping_ratio_sdof(c : Double, k : Double, m : Double) -> Double {
  if m <= 0.0 {
    return 0.0
  }
  let term = (k * m).sqrt()
  if abs(term) < EPSILON {
    return 0.0
  }
  c / (2.0 * term)
}

///|
/// 单自由度系统共振频率
/// ω_r = ω_n * √(1 - 2*ζ²)
pub fn resonance_frequency_sdof(omega_n : Double, zeta : Double) -> Double {
  let term = 1.0 - 2.0 * square(zeta)
  if term <= 0.0 {
    return 0.0
  }
  omega_n * term.sqrt()
}

///|
/// 单自由度系统振幅放大因子
/// β = 1 / √((1-r²)² + (2*ζ*r)²)
/// 参数: r - 频率比 (ω/ω_n), zeta - 阻尼比
pub fn amplitude_amplification_factor(r : Double, zeta : Double) -> Double {
  let term = square(1.0 - square(r)) + square(2.0 * zeta * r)
  if abs(term) < EPSILON {
    return 0.0
  }
  1.0 / term.sqrt()
}

// ==================== 热设计 ====================

///|
/// 热平衡温度
/// T = T_0 + P_loss / (h * A)
/// 参数: t0 - 环境温度, ploss - 损失功率, h - 传热系数, a - 散热面积
pub fn thermal_equilibrium_temperature(
  t0 : Double,
  ploss : Double,
  h : Double,
  a : Double,
) -> Double {
  if h <= 0.0 || a <= 0.0 {
    return t0
  }
  t0 + ploss / (h * a)
}

///|
/// 自然对流传热系数 (简化)
/// h ≈ 5~25 W/(m²·K) (一般值)
pub fn natural_convection_heat_transfer_coefficient() -> Double {
  15.0
}

///|
/// 强制对流传热系数
/// h = Nu * k / L
/// 参数: nu - 努塞尔数, k - 热导率, l - 特征长度
pub fn forced_convection_heat_transfer_coefficient(
  nu : Double,
  k : Double,
  l : Double,
) -> Double {
  if l <= 0.0 {
    return 0.0
  }
  nu * k / l
}

// ==================== 可靠性 ====================

///|
/// 系统串联可靠性
/// R_s = R1 * R2 * ... * Rn
pub fn system_series_reliability(reliabilities : Array[Double]) -> Double {
  let mut result = 1.0
  for i = 0; i < reliabilities.length(); i = i + 1 {
    result = result * reliabilities[i]
  }
  result
}

///|
/// 系统并联可靠性
/// R_s = 1 - (1-R1) * (1-R2) * ... * (1-Rn)
pub fn system_parallel_reliability(reliabilities : Array[Double]) -> Double {
  let mut result = 1.0
  for i = 0; i < reliabilities.length(); i = i + 1 {
    result = result * (1.0 - reliabilities[i])
  }
  1.0 - result
}

///|
/// 失效率 (指数分布)
/// λ = 1 / MTBF
/// 参数: mtbf - 平均故障间隔时间
pub fn failure_rate(mtbf : Double) -> Double {
  if mtbf <= 0.0 {
    return 0.0
  }
  1.0 / mtbf
}

///|
/// 可靠性 (指数分布)
/// R(t) = e^(-λ*t)
pub fn reliability_exponential(lambda : Double, t : Double) -> Double {
  @math.exp(-lambda * t)
}

// ==================== 材料选择 ====================

///|
/// 材料强度安全系数
/// n = σ_s / σ
/// 参数: sigma_s - 屈服强度, sigma - 工作应力
pub fn material_safety_factor(sigma_s : Double, sigma : Double) -> Double {
  if abs(sigma) < EPSILON {
    return 0.0
  }
  sigma_s / sigma
}

///|
/// 材料疲劳极限 (简化)
/// σ_{-1} ≈ 0.4 * σ_b (钢)
/// 参数: sigma_b - 抗拉强度
pub fn material_fatigue_limit(sigma_b : Double) -> Double {
  0.4 * sigma_b
}

///|
/// 材料硬度与强度关系 (简化)
/// σ_b ≈ 3.5 * HB (钢)
/// 参数: hb - 布氏硬度
pub fn material_strength_from_hardness(hb : Double) -> Double {
  3.5 * hb
}
