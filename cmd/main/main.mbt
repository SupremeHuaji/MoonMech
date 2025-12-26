///|
fn main {
  // 示例：齿轮传动计算
  let d = @lib.gear_pitch_diameter(3.0, 20)
  let i = @lib.gear_ratio(20, 40)
  println("齿轮分度圆直径: \{d} mm")
  println("齿轮传动比: \{i}")

  // 示例：带传动计算
  let fe = @lib.belt_effective_tension(5.0, 10.0)
  println("带传动有效拉力: \{fe} N")

  // 示例：轴承寿命计算
  let l10 = @lib.bearing_life(10000.0, 5000.0, 3.0)
  let lh = @lib.bearing_life_hours(l10, 1500.0)
  println("轴承寿命: \{lh} 小时")
}
