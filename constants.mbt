// MoonMech - 机械工程常量定义

// ==================== 数学常量 ====================

///|
/// 圆周率
pub const PI : Double = 3.141592653589793

///|
/// 浮点数比较精度
pub const EPSILON : Double = 1.0e-10

// ==================== 材料物理性质 ====================

///|
/// 钢材弹性模量 (GPa)
pub const E_STEEL : Double = 206.0

///|
/// 钢材剪切模量 (GPa)
pub const G_STEEL : Double = 79.0

///|
/// 钢材泊松比
pub const NU_STEEL : Double = 0.3

///|
/// 钢材密度 (kg/m³)
pub const RHO_STEEL : Double = 7850.0

///|
/// 铸铁弹性模量 (GPa)
pub const E_CAST_IRON : Double = 120.0

///|
/// 铝合金弹性模量 (GPa)
pub const E_ALUMINUM : Double = 70.0

///|
/// 铜弹性模量 (GPa)
pub const E_COPPER : Double = 110.0

// ==================== 齿轮参数 ====================

///|
/// 标准压力角 (度) - 20°
pub const PRESSURE_ANGLE_STD : Double = 20.0

///|
/// 标准模数系列 (mm) - 常用值
pub const MODULE_STD_1 : Double = 1.0

///|
pub const MODULE_STD_2 : Double = 2.0

///|
pub const MODULE_STD_3 : Double = 3.0

///|
pub const MODULE_STD_4 : Double = 4.0

///|
pub const MODULE_STD_5 : Double = 5.0

///|
/// 最小齿数 (避免根切)
pub const Z_MIN_STD : Int = 17

///|
/// 齿顶高系数 (标准)
pub const HA_STAR_STD : Double = 1.0

///|
/// 顶隙系数 (标准)
pub const C_STAR_STD : Double = 0.25

// ==================== 带传动参数 ====================

///|
/// V带包角修正系数 (简化)
pub const K_ALPHA_V_BELT : Double = 0.9

///|
/// 带传动滑动率
pub const SLIP_RATIO : Double = 0.01

///|
/// V带基准长度系列 (mm) - 常用值
pub const L_D_V_BELT_1000 : Double = 1000.0

///|
pub const L_D_V_BELT_1600 : Double = 1600.0

///|
pub const L_D_V_BELT_2500 : Double = 2500.0

// ==================== 链传动参数 ====================

///|
/// 滚子链节距系列 (mm) - 常用值
pub const P_CHAIN_12_7 : Double = 12.7

///|
pub const P_CHAIN_15_875 : Double = 15.875

///|
pub const P_CHAIN_19_05 : Double = 19.05

///|
pub const P_CHAIN_25_4 : Double = 25.4

///|
/// 链传动多边形效应系数
pub const POLYGON_EFFECT : Double = 1.0

// ==================== 轴承参数 ====================

///|
/// 深沟球轴承寿命指数
pub const P_BALL_BEARING : Double = 3.0

///|
/// 滚子轴承寿命指数
pub const P_ROLLER_BEARING : Double = 10.0 / 3.0

///|
/// 轴承基本额定寿命 (百万转)
pub const L10_BASE : Double = 1.0

///|
/// 温度系数 (一般工作温度)
pub const FT_TEMP : Double = 1.0

///|
/// 载荷系数 (平稳载荷)
pub const FP_LOAD : Double = 1.0

// ==================== 螺纹参数 ====================

///|
/// 标准螺纹牙型角 (度)
pub const THREAD_ANGLE : Double = 60.0

///|
/// 螺纹中径系数
pub const D2_COEFF : Double = 0.85

///|
/// 螺纹摩擦系数 (钢-钢)
pub const MU_THREAD : Double = 0.15

///|
/// 螺母摩擦系数
pub const MU_NUT : Double = 0.15

// ==================== 键连接参数 ====================

///|
/// 键连接许用挤压应力 (MPa) - 静连接
pub const SIGMA_P_KEY_STATIC : Double = 120.0

///|
/// 键连接许用挤压应力 (MPa) - 动连接
pub const SIGMA_P_KEY_DYNAMIC : Double = 50.0

///|
/// 键连接许用剪切应力 (MPa)
pub const TAU_P_KEY : Double = 90.0

// ==================== 弹簧参数 ====================

///|
/// 弹簧材料剪切模量 (GPa) - 弹簧钢
pub const G_SPRING : Double = 79.0

///|
/// 弹簧旋绕比推荐范围
pub const C_SPRING_MIN : Double = 4.0

///|
pub const C_SPRING_MAX : Double = 16.0

///|
/// 弹簧曲度系数 (简化)
pub const K_SPRING : Double = 1.2

// ==================== 轴设计参数 ====================

///|
/// 轴材料许用弯曲应力 (MPa) - 碳钢
pub const SIGMA_B_AXIS : Double = 55.0

///|
/// 轴材料许用扭转应力 (MPa) - 碳钢
pub const TAU_T_AXIS : Double = 30.0

///|
/// 轴安全系数
pub const N_AXIS : Double = 2.5

// ==================== 凸轮参数 ====================

///|
/// 凸轮基圆半径推荐值 (mm)
pub const R_BASE_CAM_MIN : Double = 20.0

///|
/// 凸轮压力角限制 (度)
pub const ALPHA_CAM_MAX : Double = 30.0

// ==================== 机构参数 ====================

///|
/// 四杆机构最小传动角 (度)
pub const GAMMA_MIN_LINKAGE : Double = 40.0

///|
/// 曲柄存在条件系数
pub const LAMBDA_CRANK : Double = 1.0

// ==================== 飞轮参数 ====================

///|
/// 飞轮不均匀系数
pub const DELTA_FLYWHEEL : Double = 0.05

///|
/// 飞轮材料密度 (kg/m³) - 铸铁
pub const RHO_FLYWHEEL : Double = 7200.0

// ==================== 单位换算 ====================

///|
/// MPa 转 Pa
pub const MPA_TO_PA : Double = 1000000.0

///|
/// GPa 转 Pa
pub const GPA_TO_PA : Double = 1000000000.0

///|
/// N·m 转 N·mm
pub const NM_TO_NMM : Double = 1000.0

///|
/// N·mm 转 N·m
pub const NMM_TO_NM : Double = 0.001

///|
/// mm 转 m
pub const MM_TO_M : Double = 0.001

///|
/// m 转 mm
pub const M_TO_MM : Double = 1000.0

///|
/// rpm 转 rad/s
pub const RPM_TO_RAD_S : Double = 0.104719755

///|
/// rad/s 转 rpm
pub const RAD_S_TO_RPM : Double = 9.549296586

///|
/// 度转弧度
pub const DEG_TO_RAD : Double = 0.017453292519943295

///|
/// 弧度转度
pub const RAD_TO_DEG : Double = 57.29577951308232

///|
/// kW 转 W
pub const KW_TO_W : Double = 1000.0

///|
/// W 转 kW
pub const W_TO_KW : Double = 0.001
