library(nleqslv)
shortest_ci <- function(dens_fun, p_fun, q_fun, alpha = 0.05) {

  # 满足方程组
  eq <- function(x) {
    a <- x[1]
    b <- x[2]
    c(
      dens_fun(a) - dens_fun(b),
      p_fun(b) - p_fun(a) - (1 - alpha)
    )
  }

  # 初始值：等尾区间
  start <- c(q_fun(alpha / 2), q_fun(1 - alpha / 2))

  # 求解非线性方程组
  sol <- nleqslv(start, eq)

  # 输出结果
  list(
    a = sol$x[1],
    b = sol$x[2],
    length = sol$x[2] - sol$x[1],
    return = sol$termcd
  )
}