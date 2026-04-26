# 设置路径名
path0 <- c("T1", "T2", "T3")
path <- "Rtrials/SSPC/data/"

for (m in 1:3) {
  # 读取csv文件中的数据
  dat <- read.csv(paste(path, path0[m], ".csv", sep = ""), header = TRUE)
  # 在其副本上修改
  dat0 <- dat
  # 将数据初始化
  for (i in 2:4) {
    dat0[, i] <- dat0[, i] / dat0[1, i]
  }
  # 将初始化后的数据分别赋值给dat1、dat2、dat3
  assign(paste("dat", m, sep = ""), dat0)
}

for (m in 1:3) {
  # 将dat1、dat2、dat3分别赋值给dat
  dat <- get(paste("dat", m, sep = ""))
  # 时间赋值给t
  t <- dat[, 1]
  # 画图
  plot(x = t, y = dat[, 2], pch = 1,
       ylim = c(1, max(dat[, c(2:4)])),
       xlab = "Times(h)", ylab = "Rds",
       main = paste("T", m, sep = ""))
  points(x = t, y = dat[, 3], pch = 2)
  points(x = t, y = dat[, 4], pch = 3)
  legend("topleft", legend = c("Rds 1", "Rds 2", "Rds 3"),
         pch = 1:3)
}