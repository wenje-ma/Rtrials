# R：置信区间

## 一、核心理论基础

设**连续型枢轴量**$T$，其概率密度函数$f(t)$满足$f(t)>0$且分布连续。给定置信水平$1-\alpha$，置信区间$[a, b]$满足概率约束：

$$
\int_{a}^{b}f(t)dt=1-\alpha
$$

置信区间的**最优性准则**：在满足置信水平约束的前提下，最小化区间长度$L = b-a$，即求解约束优化问题：

$$
\min_{a,b} \ L = b-a \quad \text{s.t.} \quad \int_{a}^{b}f(t)dt=1-\alpha
$$

## 二、拉格朗日乘数法推导

构造拉格朗日函数，将约束优化转化为无约束优化：

$$
\mathcal{L}=b-a+\lambda(\int_{a}^{b}f(t)dt-(1-\alpha))
$$

对决策变量$a,b$分别求一阶偏导数，并令偏导数为$0$：

$$
\begin{cases}
\frac{\partial\mathcal{L}}{\partial a} = -1-\lambda f(a)=0\\
\frac{\partial\mathcal{L}}{\partial b} = 1+\lambda f(b)=0
\end{cases}
$$

### 推导结论

1. 由第一式得：$\lambda=-\frac{1}{f(a)}$

2. 由第二式得：$\lambda=-\frac{1}{f(b)}$

3. 联立可得**最优置信区间的核心充要条件**：

$$
\boldsymbol{f(a) = f(b)}
$$

即：**连续型枢轴量的最短置信区间，其两个端点处的概率密度函数值相等**。

## 三、方法适用前提

该结论成立的前提：

1. $T$为**连续型随机变量**，密度函数$f(t)$**处处连续**；

2. 最优解为**内点解**：$a,b$不在密度支撑集的边界上，且$f(a),f(b)>0$；

3. 满足$f(a)=f(b)$与$\int_{a}^{b}f(t)dt=1-\alpha$的解$(a,b)$**唯一**。

## 四、分布适用性分类

### 1. 满足前提、可直接求解的分布

正态分布、$t$分布、逻辑分布、Cauchy分布、$\chi^2$分布、$F$分布、Gamma分布、Beta分布、Laplace分布。

### 2. 不满足前提、方法失效的分布

均匀分布、指数分布、Rayleigh分布、多峰分布、离散型分布、密度函数不连续的分布。

## 五、R语言求解实现

基于最优条件$f(a)=f(b)$和概率约束，使用`nleqslv`包求解非线性方程组，得到最短置信区间。

### 1. 依赖包与函数说明

- 依赖包：`nleqslv`（专门用于求解非线性方程组）

- 核心函数：`nleqslv(x, fn)`，`x`为迭代初始值，`fn`为待解方程组。

### 2. 完整R代码

```r
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
```

### 3. 标准正态分布测试

```r
> shortest_ci(dnorm, pnorm, qnorm)  
```

### 4. 测试输出结果

```                  
$a
[1] -1.959964

$b
[1] 1.959964

$length
[1] 3.919928

$return
[1] 1
```