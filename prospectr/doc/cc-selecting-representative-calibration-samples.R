## -----------------------------------------------------------------------------
#| label: tbl-sampling
#| tbl-cap: "Calibration sampling functions available in the package."
#| echo: false
#| message: false
library(prospectr)
sampling_fns <- data.frame(
  Function = c("`naes`", "`kenStone`", "`duplex`",
               "`puchwein`", "`shenkWest`", "`honigs`"),
  Algorithm = c(
    "k-means sampling [@naes2002]",
    "Kennard-Stone (CADEX) sampling [@kennard1969]",
    "DUPLEX sampling [@snee1977]",
    "Puchwein sampling [@puchwein1988]",
    "SELECT algorithm [@shenk1991]",
    "Honigs sampling [@honigs1985]"
  )
)

knitr::kable(sampling_fns)


## -----------------------------------------------------------------------------
#| label: load-NIRsoil
#| message: false

library(prospectr)
data(NIRsoil)
# NIRsoil is a data.frame with 825 observations and 5 variables:
# Nt (Total Nitrogen), Ciso (Carbon), CEC (Cation Exchange Capacity),
# train (0/1 indicator for training (1) and validation (0) samples),
# spc (spectral matrix)
str(NIRsoil)


## -----------------------------------------------------------------------------
#| label: fig-naes
#| fig-cap: "Selection of representative samples by k-means sampling on a
#|   synthetic grid dataset (left, $n = 10$) and on the NIRsoil dataset in
#|   PC space (right, $n = 5$)."
#| fig-height: 4.5
#| fig-width: 8
#| fig-align: center
#| echo: true

# Synthetic grid dataset with jitter
set.seed(1002)
grid_xy <- expand.grid(x1 = 1:30, x2 = 1:30)
X_synthetic <- data.frame(
  x1 = grid_xy$x1 + rnorm(nrow(grid_xy), 0, 0.3),
  x2 = grid_xy$x2 + rnorm(nrow(grid_xy), 0, 0.3)
)
kms_synthetic <- naes(X = X_synthetic, k = 40, iter.max = 100)

# NIRsoil dataset in PC space
kms <- naes(X = NIRsoil$spc, k = 5, pc = 2, iter.max = 100)

par(mfrow = c(1, 2))

plot(
  X_synthetic,
  col = rgb(0, 0, 0, 0.3), pch = 19,
  main = "k-means (synthetic)"
)
grid()
points(X_synthetic[kms_synthetic$model, ], col = "red", pch = 19)
legend(
  x = "top",
  inset = c(0, -0.15),
  xpd = TRUE,
  horiz = TRUE,
  bty = "n",
  legend = c("All samples", "Selected"),
  pch = 19,
  col = c(rgb(0, 0, 0, 0.3), "red"),
  bg = rgb(1, 1, 1, 0.8)
)

plot(
  kms$pc,
  col = rgb(0, 0, 0, 0.3), pch = 19,
  main = "k-means (NIRsoil)"
)
grid()
points(kms$pc[kms$model, ], col = "red", pch = 19)
legend(
  x = "top",
  inset = c(0, -0.15),
  xpd = TRUE,
  horiz = TRUE,
  bty = "n",
  legend = c("All samples", "Selected"),
  pch = 19,
  col = c(rgb(0, 0, 0, 0.3), "red"),
  bg = rgb(1, 1, 1, 0.8)
)

par(mfrow = c(1, 1))


## -----------------------------------------------------------------------------
#| label: fig-kenstone
#| fig-cap: "Kennard-Stone sampling on a synthetic two-variable dataset (left,
#|   $n = 40$) and on the NIRsoil dataset in Mahalanobis PC space (right,
#|   $n = 20$)."
#| fig-height: 4.5
#| fig-width: 8
#| echo: true

# Synthetic dataset: grid with jitter
grid_xy    <- expand.grid(x1 = 1:30, x2 = 1:30)
set.seed(1014)
X_synthetic <- data.frame(
  x1 = grid_xy$x1 + rnorm(nrow(grid_xy), 0, 0.3),
  x2 = grid_xy$x2 + rnorm(nrow(grid_xy), 0, 0.3)
)
ken <- kenStone(X_synthetic, k = 40)

# NIRsoil dataset — Mahalanobis distance in PC space
ken_mahal <- kenStone(X = NIRsoil$spc, k = 20, metric = "mahal", pc = 2)

par(mfrow = c(1, 2))

plot(
  X_synthetic,
  col = rgb(0, 0, 0, 0.3), pch = 19,
  main = "Kennard-Stone (synthetic)"
)
grid()
points(X_synthetic[ken$model, ], col = "red", pch = 19, cex = 1.2)
legend(
  x = "top",
  inset = c(0, -0.15),
  xpd = TRUE,
  horiz = TRUE,
  bty = "n",
  legend = c("All samples", "Selected"),
  pch = 19,
  col = c(rgb(0, 0, 0, 0.3), "red"),
  bg = rgb(1, 1, 1, 0.8)
)

plot(
  ken_mahal$pc[, 1], ken_mahal$pc[, 2],
  col = rgb(0, 0, 0, 0.3), pch = 19,
  xlab = "PC1", ylab = "PC2",
  main = "Kennard-Stone (NIRsoil)"
)
grid()
points(
  ken_mahal$pc[ken_mahal$model, 1],
  ken_mahal$pc[ken_mahal$model, 2],
  pch = 19, col = "red"
)
legend(
  x = "top",
  inset = c(0, -0.15),
  xpd = TRUE,
  horiz = TRUE,
  bty = "n",
  legend = c("All samples", "Selected"),
  pch = 19,
  col = c(rgb(0, 0, 0, 0.3), "red"),
  bg = rgb(1, 1, 1, 0.8)
)

par(mfrow = c(1, 1))


## -----------------------------------------------------------------------------
#| label: kenstone-init
#| echo: true

initialization_ind <- c(486, 702, 722, 728)
ken_mahal_init <- kenStone(
  X = NIRsoil$spc,
  k = 20,
  metric = "mahal",
  pc = 2,
  init = initialization_ind
)
ken_mahal_init$model


## -----------------------------------------------------------------------------
#| label: fig-kenstone-init
#| fig-cap: "Kennard-Stone sampling with 4 forced initialisation samples (blue)
#|   and the remaining selected samples (red) in PC space."
#| fig-height: 4.5
#| fig-width: 4
#| fig-align: center
#| echo: true

plot(
  ken_mahal_init$pc[, 1], ken_mahal_init$pc[, 2],
  col = rgb(0, 0, 0, 0.3), pch = 19,
  xlab = "PC1", ylab = "PC2",
  main = "Kennard-Stone with initialisation"
)
grid()
points(
  ken_mahal_init$pc[ken_mahal_init$model, 1],
  ken_mahal_init$pc[ken_mahal_init$model, 2],
  pch = 19, col = "red"
)
points(
  ken_mahal_init$pc[initialization_ind, 1],
  ken_mahal_init$pc[initialization_ind, 2],
  pch = 19, cex = 1.5, col = "dodgerblue"
)
legend(
  x = "top",
  inset = c(0, -0.15),
  xpd = TRUE,
  horiz = TRUE,
  bty = "n",
  legend = c("All samples", "Selected", "Initialisation"),
  pch = 19,
  col = c(rgb(0, 0, 0, 0.3), "red", "dodgerblue"),
  bg = rgb(1, 1, 1, 0.8)
)


## -----------------------------------------------------------------------------
#| label: fig-duplex
#| fig-cap: "Selection of 15 calibration and 15 validation samples with the
#|   DUPLEX algorithm on a synthetic grid dataset (left) and on the NIRsoil
#|   dataset in Mahalanobis PC space (right)."
#| fig-height: 4.5
#| fig-width: 8
#| fig-align: center
#| echo: true

dup     <- duplex(X = X_synthetic, k = 15)
dup_nir <- duplex(X = NIRsoil$spc, k = 20, metric = "mahal", pc = 2)

par(mfrow = c(1, 2))

plot(
  X_synthetic,
  col = rgb(0, 0, 0, 0.3), pch = 19,
  main = "DUPLEX (synthetic)"
)
grid()
points(X_synthetic[dup$model, ], col = "red", pch = 19)
points(X_synthetic[dup$test, ],  col = "dodgerblue", pch = 19)
legend(
  x = "top",
  inset = c(0, -0.15),
  xpd = TRUE,
  horiz = TRUE,
  bty = "n",
  legend = c("All samples", "Calibration", "Validation"),
  pch = 19,
  col = c(rgb(0, 0, 0, 0.3), "red", "dodgerblue")
)

plot(
  dup_nir$pc[, 1], dup_nir$pc[, 2],
  col = rgb(0, 0, 0, 0.3), pch = 19,
  xlab = "PC1", ylab = "PC2",
  main = "DUPLEX (NIRsoil)"
)
grid()
points(dup_nir$pc[dup_nir$model, 1], dup_nir$pc[dup_nir$model, 2],
       col = "red", pch = 19)
points(dup_nir$pc[dup_nir$test, 1],  dup_nir$pc[dup_nir$test, 2],
       col = "dodgerblue", pch = 19)
legend(
  x = "top",
  inset = c(0, -0.15),
  xpd = TRUE,
  horiz = TRUE,
  bty = "n",
  legend = c("All samples", "Calibration", "Validation"),
  pch = 19,
  col = c(rgb(0, 0, 0, 0.3), "red", "dodgerblue")
)
par(mfrow = c(1, 1))


## -----------------------------------------------------------------------------
#| label: fig-shenk
#| fig-cap: "Samples selected by the SELECT algorithm on a synthetic grid
#|   dataset (left, `d.min` = 0.1) and on the NIRsoil dataset in PC space (right,
#|   `d.min` = 0.6)."
#| fig-height: 4.5
#| fig-width: 8
#| fig-align: center
#| echo: true

shenk_synthetic <- shenkWest(X = X_synthetic, d.min = 0.1)
shenk <- shenkWest(X = NIRsoil$spc, d.min = 0.6, pc = 2)

par(mfrow = c(1, 2), mar = c(5, 4, 6, 2))

plot(
  X_synthetic,
  col = rgb(0, 0, 0, 0.3), pch = 19,
  main = "SELECT (synthetic)"
)
grid()
points(X_synthetic[shenk_synthetic$model, ], col = "red", pch = 19)
legend(
  x = "top",
  inset = c(0, -0.15),
  xpd = TRUE,
  horiz = TRUE,
  bty = "n",
  legend = c("All samples", "Selected"),
  pch = 19,
  col = c(rgb(0, 0, 0, 0.3), "red")
)

plot(
  shenk$pc,
  col = rgb(0, 0, 0, 0.3), pch = 19,
  xlab = "PC1", ylab = "PC2",
  main = "SELECT (NIRsoil)"
)
grid()
points(shenk$pc[shenk$model, ], col = "red", pch = 19)
legend(
  x = "top",
  inset = c(0, -0.15),
  xpd = TRUE,
  horiz = TRUE,
  bty = "n",
  legend = c("All samples", "Selected"),
  pch = 19,
  col = c(rgb(0, 0, 0, 0.3), "red")
)

par(mfrow = c(1, 1))


## -----------------------------------------------------------------------------
#| label: fig-puchwein
#| fig-cap: "Samples selected by the Puchwein algorithm on a synthetic grid
#|   dataset (left) and on the NIRsoil dataset in PC space (right)."
#| fig-height: 4.5
#| fig-width: 8
#| fig-align: center
#| echo: true

pu_synthetic <- puchwein(X = X_synthetic, k = 0.2)
pu <- puchwein(X = NIRsoil$spc, k = 0.2, pc = 2)

par(mfrow = c(1, 2), mar = c(5, 4, 6, 2))

plot(
  X_synthetic,
  col = rgb(0, 0, 0, 0.3), pch = 19,
  main = "Puchwein (synthetic)"
)
grid()
points(X_synthetic[pu_synthetic$model, ], col = "red", pch = 19)
legend(
  x = "top",
  inset = c(0, -0.15),
  xpd = TRUE,
  horiz = TRUE,
  bty = "n",
  legend = c("All samples", "Selected"),
  pch = 19,
  col = c(rgb(0, 0, 0, 0.3), "red")
)

plot(
  pu$pc,
  col = rgb(0, 0, 0, 0.3), pch = 19,
  xlab = "PC1", ylab = "PC2",
  main = "Puchwein (NIRsoil)"
)
grid()
points(pu$pc[pu$model, ], col = "red", pch = 19)
legend(
  x = "top",
  inset = c(0, -0.15),
  xpd = TRUE,
  horiz = TRUE,
  bty = "n",
  legend = c("All samples", "Selected"),
  pch = 19,
  col = c(rgb(0, 0, 0, 0.3), "red")
)

par(mfrow = c(1, 1))


## -----------------------------------------------------------------------------
#| label: fig-puchwein-leverage
#| fig-cap: "Puchwein leverage diagnostics: difference between theoretical and
#|   observed sum of leverages (top) and number of samples retained per loop
#|   (bottom). The first loop is typically optimal."
#| fig-height: 5
#| fig-width: 6
#| fig-align: center
#| echo: true

par(mfrow = c(2, 1))

plot(
  pu$leverage$removed, pu$leverage$diff,
  type = "l",
  xlab = "Samples removed",
  ylab = "Difference (theoretical vs observed leverages)"
)

plot(
  pu$leverage$loop, nrow(NIRsoil) - pu$leverage$removed,
  type = "l",
  xlab = "Loop",
  ylab = "Samples retained"
)

par(mfrow = c(1, 1))


## -----------------------------------------------------------------------------
#| label: fig-honigs
#| fig-cap: "All NIRsoil spectra (left) and the 10 samples selected by the
#|   Honigs algorithm with the wavelength bands used during selection marked
#|   (right)."
#| fig-height: 4.5
#| fig-width: 8
#| fig-align: center
#| echo: true

ho  <- honigs(X = NIRsoil$spc, k = 10, type = "A")
wav <- as.numeric(colnames(NIRsoil$spc))

par(mfrow = c(1, 2), mar = c(5, 4, 6, 2))

matplot(
  wav, t(NIRsoil$spc),
  type = "l", lty = 1, lwd = 0.5,
  col = rgb(0, 0, 0, 0.1),
  xlab = "Wavelength (nm)", ylab = "Absorbance",
  main = "All spectra"
)
matlines(wav, t(NIRsoil$spc[ho$model, ]), lty = 1, lwd = 1.5, col = "red")
legend(
  x = "top",
  inset = c(0, -0.15),
  xpd = TRUE,
  horiz = TRUE,
  bty = "n",
  legend = c("All spectra", "Selected"),
  lty = 1,
  col = c(rgb(0, 0, 0, 0.3), "red")
)

matplot(
  wav, t(NIRsoil$spc[ho$model, ]),
  type = "l", lty = 1, lwd = 1.5,
  xlab = "Wavelength (nm)", ylab = "Absorbance",
  main = "Selected spectra"
)
abline(v = wav[ho$bands], lty = 2, col = "grey40")
grid()
legend(
  x = "top",
  inset = c(0, -0.15),
  xpd = TRUE,
  horiz = TRUE,
  bty = "n",
  legend = c("Selected spectra", "Bands used"),
  lty = c(1, 2),
  col = c("black", "grey40")
)

par(mfrow = c(1, 1))

