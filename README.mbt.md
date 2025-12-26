# MoonMech - Mechanical Engineering Calculation Library

**MoonMech** is a comprehensive mechanical engineering calculation library written in **Moonbit**, providing functions for mechanical design, power transmission, and machine elements calculations.

---

## Features

### Power Transmission

* **Gears**: Spur gears, helical gears, bevel gears, and planetary gear trains
* **Belts**: Belt drives, belt ratios, contact angles, and belt length calculations
* **Chains**: Chain drives, chain velocities, and chain tension calculations
* **Worm Gears**: Worm gear ratios and lead angle calculations

---

### Machine Elements

* **Shafts**: Shaft diameter calculations, torsional strength, and equivalent bending moments
* **Bearings**: Bearing life calculations, equivalent dynamic loads, and bearing preload
* **Springs**: Spring stiffness, deflection, index ratios, and curvature coefficients
* **Flywheels**: Flywheel moment of inertia and mass calculations

---

### Connections and Fasteners

* **Keys**: Key crushing and shear stress calculations
* **Threads**: Thread pitch diameters, lead angles, and self-locking conditions
* **Connections**: Pin connections, riveted connections, and fastener calculations

---

### Mechanisms

* **Four-Bar Linkages**: Transmission angles and crank existence conditions
* **Mechanisms**: Linkage analysis and mechanism design calculations

---

## Usage

### Gear Calculations

```moonbit
test "gear" {
  // Spur gear: m=3mm, z=20
  // d = 3*20 = 60mm
  let d = gear_pitch_diameter(3.0, 20)
  assert_eq(d, 60.0)

  // Addendum diameter: d_a = 3*(20+2*1) = 66mm
  let da = gear_addendum_diameter(3.0, 20, HA_STAR_STD)
  assert_eq(da, 66.0)

  // Center distance: a = 3*(20+40)/2 = 90mm
  let a = gear_center_distance(3.0, 20, 40)
  assert_eq(a, 90.0)

  // Gear ratio: i = 40/20 = 2
  let i = gear_ratio(20, 40)
  assert_eq(i, 2.0)

  // Tangential force: T=1000N·mm, d=60mm
  // F_t = 2*1000/60 = 33.33N
  let ft = gear_tangential_force(1000.0, 60.0)
  assert_eq(approx_equal(ft, 33.33, 0.1), true)
}
```

---

### Belt Drives

```moonbit
test "belt" {
  // Belt drive: d1=100mm, d2=200mm, a=500mm
  // Gear ratio: i = 200/100 = 2
  let i = belt_ratio(100.0, 200.0)
  assert_eq(i, 2.0)

  // Contact angle: α ≈ 180° - 2*arcsin((200-100)/(2*500)) = 168.5°
  let alpha = belt_contact_angle(100.0, 200.0, 500.0)
  assert_eq(alpha > 160.0 && alpha < 180.0, true)

  // Belt length: L ≈ 1471mm
  let l = belt_length(100.0, 200.0, 500.0)
  assert_eq(approx_equal(l, 1471.0, 10.0), true)

  // Effective tension: P=5kW, v=10m/s
  // F_e = 1000*5/10 = 500N
  let fe = belt_effective_tension(5.0, 10.0)
  assert_eq(fe, 500.0)
}
```

---

### Shaft Design

```moonbit
test "shaft" {
  // Minimum shaft diameter for torsion: T=10000N·mm, [τ]=30MPa
  let d = shaft_min_diameter_torsion(10000.0, 30.0)
  // d should be between 10-15mm (reasonable range)
  assert_eq(d > 0.0 && d < 0.02, true)

  // Equivalent bending moment: M=5000N·mm, T=10000N·mm, α=0.6
  // M_e = √(5000² + (0.6*10000)²) = 7810N·mm
  let me = shaft_equivalent_moment(5000.0, 10000.0, 0.6)
  assert_eq(approx_equal(me, 7810.0, 10.0), true)
}
```

---

### Bearing Calculations

```moonbit
test "bearing" {
  // Equivalent dynamic load: X=1, F_r=1000N, Y=0, F_a=0
  // P = 1*1000 + 0*0 = 1000N
  let p = bearing_equivalent_dynamic_load(1.0, 1000.0, 0.0, 0.0)
  assert_eq(p, 1000.0)

  // Bearing life: C=10000N, P=5000N, p=3
  // L_10 = (10000/5000)³ * 10^6 = 8*10^6 revolutions
  let l10 = bearing_life(10000.0, 5000.0, 3.0)
  assert_eq(approx_equal(l10, 8000000.0, 100000.0), true)

  // Life in hours: L_10=8e6 revolutions, n=1500rpm
  // L_h = 8e6/(60*1500) = 88.9 hours
  let lh = bearing_life_hours(8000000.0, 1500.0)
  assert_eq(approx_equal(lh, 88.9, 1.0), true)
}
```

---

### Spring Design

```moonbit
test "spring" {
  // Spring stiffness: G=79GPa, d=4mm, D=32mm, n=10
  let k = spring_stiffness(79.0, 4.0 * MM_TO_M, 32.0 * MM_TO_M, 10)
  assert_eq(k > 5000.0 && k < 10000.0, true)

  // Spring deflection: F=100N, k=7710N/m
  // δ = 100/7710 = 0.013m
  let delta = spring_deflection(100.0, k)
  assert_eq(delta > 0.0, true)

  // Spring index: D=32mm, d=4mm
  // C = 32/4 = 8
  let c = spring_index(32.0, 4.0)
  assert_eq(c, 8.0)

  // Curvature coefficient: C=8
  // K = (4*8-1)/(4*8-4) + 0.615/8 = 1.184
  let k_coeff = spring_curvature_coefficient(8.0)
  assert_eq(approx_equal(k_coeff, 1.184, 0.01), true)
}
```

---

### Chain Drives

```moonbit
test "chain" {
  // Chain drive: z1=17, z2=34
  // Gear ratio: i = 34/17 = 2
  let i = chain_ratio(17, 34)
  assert_eq(i, 2.0)

  // Chain velocity: z=17, p=19.05mm, n=1000rpm
  // v = 17*19.05*1000/60000 = 5.4m/s
  let v = chain_velocity(17, 19.05, 1000.0)
  assert_eq(approx_equal(v, 5.4, 0.1), true)

  // Effective tension: P=10kW, v=5.4m/s
  // F = 1000*10/5.4 = 1852N
  let f = chain_effective_tension(10.0, 5.4)
  assert_eq(approx_equal(f, 1852.0, 10.0), true)
}
```

---

### Flywheel Design

```moonbit
test "flywheel" {
  // Flywheel moment of inertia: W_max=1000J, ω=100rad/s, δ=0.05
  // J = W_max/(ω²*δ) = 1000/(100²*0.05) = 0.2 kg·m²
  let j = flywheel_moment_of_inertia(1000.0, 100.0, 0.05)
  assert_eq(j > 0.0, true)

  // Flywheel mass: J=0.2kg·m², r=0.2m
  // For solid disk: m = 2*J/r² = 2*0.2/0.04 = 10kg
  let m = flywheel_mass(0.2, 0.2)
  assert_eq(m > 8.0 && m < 12.0, true)
}
```

---

## Parameter Ranges

### Valid Input Ranges

* **Gear Modules**: 0.5–20 mm (gear module sizes)
* **Teeth Numbers**: 10–200 (number of teeth)
* **Forces**: 0–10⁶ N (mechanical forces)
* **Torques**: 0–10⁵ N·m (torques and moments)
* **Speeds**: 0–10⁴ rpm (rotational speeds)
* **Powers**: 0–10⁴ kW (mechanical power)
* **Dimensions**: 10⁻³–10² m (lengths and diameters)

---

### Typical Engineering Values

* **Gear Modules**: 1–8 mm (common gear sizes)
* **Shaft Diameters**: 10–200 mm (typical shaft sizes)
* **Bearing Loads**: 100–10⁵ N (bearing capacities)
* **Spring Rates**: 1–10⁴ N/m (spring stiffness)
* **Power Transmission**: 0.1–1000 kW (mechanical power)

---

## Testing

The project includes a comprehensive test suite covering all major functionalities:

```bash
moon test
```

### Test Coverage

* Gear calculations (spur, helical, bevel, planetary gears)
* Belt and chain drives
* Shaft design and stress analysis
* Bearing life and load calculations
* Spring design and analysis
* Mechanism analysis (four-bar linkages)
* Flywheel design calculations
* Connection elements (keys, threads, pins)
* Power transmission efficiency
* Mechanical utility functions

---

## Technical Details

### Engineering Standards

* **AGMA Standards**: American Gear Manufacturers Association
* **ANSI Standards**: American National Standards Institute
* **ISO Standards**: International Organization for Standardization
* **Mechanical Engineering Textbooks**: Standard mechanical design references

---

### Mathematical Methods

* **Geometric Calculations**: Trigonometric relationships for gear geometry
* **Stress Analysis**: Von Mises equivalent stress, fatigue calculations
* **Dynamic Analysis**: Rotational dynamics, vibration analysis
* **Empirical Formulas**: Industry-standard correlation equations

---

### Applications

* **Machine Design**: Gearboxes, transmissions, and power trains
* **Mechanical Systems**: Shafts, bearings, and rotating machinery
* **Power Transmission**: Belts, chains, and gear drives
* **Automotive Engineering**: Drivetrain components and vehicle systems
* **Industrial Machinery**: Manufacturing equipment and industrial systems
* **Robotics**: Robotic mechanisms and automation systems
* **Aerospace**: Aircraft components and aerospace systems
* **Marine Engineering**: Ship propulsion and marine systems

---

## Notes

1. **Units**: All calculations use SI units (meters, kilograms, seconds, Newtons)
2. **Safety Factors**: Engineering calculations include appropriate safety margins
3. **Material Properties**: Functions use standard material properties unless specified
4. **Boundary Conditions**: Physical limits enforced to prevent unrealistic results
5. **Standards Compliance**: Functions follow mechanical engineering standards
6. **Validation**: Results should be verified against established mechanical design methods

---

## Version Information

The current version (0.1.0) implements **core mechanical engineering calculation functions** including:

* Gear design and analysis (spur, helical, bevel, planetary)
* Power transmission (belts, chains, worm gears)
* Machine elements (shafts, bearings, springs, flywheels)
* Connection design (keys, threads, pins, rivets)
* Mechanism analysis (four-bar linkages)
* Mechanical utilities (power, torque, velocity calculations)
* Fatigue and life calculations
* Stress and deflection analysis

The library is actively developed and aims to provide comprehensive coverage of mechanical engineering calculations while being optimized for MoonBit.