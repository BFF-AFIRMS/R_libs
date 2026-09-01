## -----------------------------------------------------------------------------
#| label: tbl-preprocessing
#| tbl-cap: "Pre-processing functions available in the package."
#| echo: false
#| message: false

library(prospectr)

preprocessing_fns <- data.frame(
  `Function` = c(
    "`movav`", "`savitzkyGolay`", "`gapDer`", "`baseline`",
    "`continuumRemoval`", "`detrend`", "`standardNormalVariate`",
    "`msc`", "`binning`", "`resample`", "`resample2`",
    "`blockScale`", "`blockNorm`"
  ),
  `Description` = c(
    "Simple moving (or running) average filter",
    "Savitzky--Golay smoothing and derivative",
    "Gap--segment derivative",
    "Baseline removal (similar to `continuumRemoval`)",
    "Computes continuum--removed values",
    "Detrend normalisation",
    "Standard Normal Variate (SNV) transformation",
    "Multiplicative Scatter Correction",
    "Average a signal in column bins",
    "Resample a signal to new band positions",
    "Resample a signal using new FWHM values",
    "Block scaling",
    "Sum of squares block weighting"
  ),
  check.names = FALSE
)

knitr::kable(preprocessing_fns)


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
#| label: fig-movav
#| fig-cap: "Effect of a moving average with window size of 11 bands on a raw spectrum."
#| fig-height: 4
#| fig-width: 6
#| echo: true

# Add some noise
noisy <- NIRsoil$spc + rnorm(length(NIRsoil$spc), 0, 0.001)

# Plot the first spectrum
plot(
  x = as.numeric(colnames(NIRsoil$spc)),
  y = noisy[1, ],
  type = "l",
  lwd = 1.5,
  xlab = "Wavelength",
  ylab = "Absorbance"
)

# Window size of 11 bands; note the 5 first and last bands are lost
X <- movav(X = noisy, w = 11)
lines(x = as.numeric(colnames(X)), y = X[1, ], lwd = 1.5, col = "red")
grid()
legend(
  "topleft",
  legend = c("Raw", "Moving average"),
  lty = 1,
  col = c("black", "red")
)


## -----------------------------------------------------------------------------
#| label: savitzky-golay
#| echo: true

# p = polynomial order
# w = window size (must be odd)
# m = m-th derivative (0 = smoothing)
# Accepts vectors, data frames, or matrices (observations row-wise)
sgvec <- savitzkyGolay(X = NIRsoil$spc[1, ], p = 3, w = 11, m = 0)
sg <- savitzkyGolay(X = NIRsoil$spc, p = 3, w = 11, m = 0)

# Bands at the edges of the spectral matrix are lost
dim(NIRsoil$spc)
dim(sg)


## -----------------------------------------------------------------------------
#| label: tbl-derivatives
#| tbl-cap: "Advantages and drawbacks of derivative spectra."
#| echo: false

der_table <- data.frame(
  Advantage = c(
    "Reduces baseline offset",
    "Can resolve overlapping absorptions",
    "Compensates for instrumental drift",
    "Enhances small spectral absorptions",
    "Often increases predictive accuracy for complex datasets"
  ),
  Drawback = c(
    "Risk of overfitting the calibration model",
    "Increases noise; smoothing required",
    "Increases uncertainty in model coefficients",
    "Complicates spectral interpretation",
    "Removes the baseline"
  )
)

knitr::kable(der_table)


## -----------------------------------------------------------------------------
#| label: fig-derivatives
#| fig-cap: "First and second derivatives of a raw spectrum."
#| fig-height: 4
#| fig-width: 6
#| echo: true

d1 <- t(diff(t(NIRsoil$spc), differences = 1))  # first derivative
d2 <- t(diff(t(NIRsoil$spc), differences = 2))  # second derivative

plot(
  as.numeric(colnames(d1)), d1[1, ],
  type = "l", lwd = 1.5,
  xlab = "Wavelength", ylab = ""
)
lines(as.numeric(colnames(d2)), d2[1, ], lwd = 1.5, col = "red")
grid()
legend(
  "topleft",
  legend = c("1st derivative", "2nd derivative"),
  lty = 1, col = c("black", "red")
)


## -----------------------------------------------------------------------------
#| label: fig-gap-derivative
#| fig-cap: "Comparison of first derivative (finite difference) and
#|   gap derivative (lag = 10 bands) for the first spectrum."
#| fig-height: 4
#| fig-width: 6
#| echo: true

# m = derivative order; w = gap size; s = segment size
gsd1 <- gapDer(X = NIRsoil$spc, m = 1, w = 11, s = 5)

plot(
  as.numeric(colnames(d1)), d1[1, ],
  type = "l", lwd = 1.5,
  xlab = "Wavelength (nm)", ylab = "1st derivative"
)
par(new = TRUE)
plot(
  as.numeric(colnames(gsd1)), gsd1[1, ],
  type = "l", lwd = 1.5, col = "red",
  xaxt = "n", yaxt = "n",
  xlab = "", ylab = ""
)
axis(4, col = "red")
mtext("Gap-segment derivative", side = 4, line = 3, col = "red")
grid()
legend(
  "topleft",
  legend = c("1st derivative", "Gap-segment 1st derivative"),
  lty = 1, col = c("black", "red")
)
par(new = FALSE)


## -----------------------------------------------------------------------------
#| label: fig-snv
#| fig-cap: "Raw absorbance spectra (left) and SNV-transformed spectra (right)
#|   for the first five observations."
#| fig-height: 4
#| fig-width: 8
#| echo: true

snv <- standardNormalVariate(X = NIRsoil$spc)
wav <- as.numeric(colnames(NIRsoil$spc))

par(mfrow = c(1, 2))

matplot(
  wav, t(NIRsoil$spc[1:5, ]),
  type = "l", lty = 1, lwd = 1.5,
  col = c("black", "grey20", "grey40", "grey60", "grey80"),
  xlab = "Wavelength (nm)", ylab = "Absorbance",
  main = "Raw"
)
grid()

matplot(
  wav, t(snv[1:5, ]),
  type = "l", lty = 1, lwd = 1.5,
  col = c("red", "tomato", "coral", "salmon", "lightsalmon"),
  xlab = "Wavelength (nm)", ylab = "SNV (Absorbance)",
  main = "SNV"
)
grid()

par(mfrow = c(1, 1))


## -----------------------------------------------------------------------------
#| label: fig-msc
#| fig-cap: "Effect of MSC on a raw spectrum (reference = mean spectrum)."
#| fig-height: 4
#| fig-width: 6
#| echo: true

# Reference spectrum is the column mean of the full matrix
msc_spc <- msc(X = NIRsoil$spc, ref_spectrum = colMeans(NIRsoil$spc))

plot(
  as.numeric(colnames(NIRsoil$spc)), NIRsoil$spc[1, ],
  type = "l", lwd = 1.5,
  xlab = "Wavelength (nm)", ylab = "Absorbance"
)
lines(as.numeric(colnames(msc_spc)), msc_spc[1, ], lwd = 1.5, col = "red")
grid()
legend(
  "topleft",
  legend = c("Raw", "MSC"),
  lty = 1, col = c("black", "red")
)


## -----------------------------------------------------------------------------
#| label: msc-transfer
#| eval: false
#| echo: true

# # Training and validation partitions
# Xr <- NIRsoil$spc[NIRsoil$train == 1, ]
# Xu <- NIRsoil$spc[NIRsoil$train == 0, ]
# 
# # Fit MSC on the training set (reference = mean of Xr by default)
# Xr_msc <- msc(Xr)
# 
# # Apply the same reference spectrum to the validation set
# Xu_msc <- msc(Xu, ref_spectrum = attr(Xr_msc, "Reference spectrum"))


## -----------------------------------------------------------------------------
#| label: fig-detrend
#| fig-cap: "Effect of SNV-Detrend on a raw spectrum. Note the different
#|   y-axis scales: raw absorbance (left) and detrended signal (right)."
#| fig-height: 4
#| fig-width: 6
#| echo: true

wav <- as.numeric(colnames(NIRsoil$spc))
dt  <- detrend(X = NIRsoil$spc, wav = wav)

# Dual y-axis: raw and detrended spectra are on different scales
plot(
  wav, NIRsoil$spc[1, ],
  type = "l", lwd = 1.5,
  xlab = "Wavelength (nm)", ylab = "Absorbance"
)
par(new = TRUE)
plot(
  wav, dt[1, ],
  type = "l", lwd = 1.5, col = "red",
  xaxt = "n", yaxt = "n",
  xlab = "", ylab = ""
)
axis(4, col = "red")
mtext("Detrended", side = 4, line = 3, col = "red")
grid()
legend(
  "topleft",
  legend = c("Raw", "SNV-Detrend"),
  lty = 1, col = c("black", "red")
)
par(new = FALSE)


## -----------------------------------------------------------------------------
#| label: fig-baseline
#| fig-cap: "Raw absorbance spectra (left) and baseline-corrected spectra (right)
#| for the first three observations."
#| fig-height: 4
#| fig-width: 8
#| echo: true

wav <- as.numeric(colnames(NIRsoil$spc))
bs <- baseline(NIRsoil$spc, wav)
fitted_baselines <- attr(bs, "baselines")

par(mfrow = c(1, 2))

# Raw spectra with fitted baselines
matplot(
  wav, t(NIRsoil$spc[1:3, ]),
  type = "l", lty = 1, lwd = 1.5,
  col = c("black", "grey40", "grey70"),
  xlab = "Wavelength (nm)", ylab = "Absorbance",
  main = "Raw and baseline"
)
matlines(wav, t(fitted_baselines[1:3, ]), lty = 2, col = c("black", "grey40", "grey70"))
grid()

# Baseline-corrected spectra
matplot(
  wav, t(bs[1:3, ]),
  type = "l", lty = 1, lwd = 1.5,
  col = c("red", "tomato", "salmon"),
  xlab = "Wavelength (nm)", ylab = "Absorbance",
  main = "Baseline corrected"
)
grid()

par(mfrow = c(1, 1))


## -----------------------------------------------------------------------------
#| label: block-scale
#| echo: true

# type = "soft" or "hard"
# Returns a list with the scaled matrix (Xscaled) and the divisor (f)
bsc <- blockScale(X = NIRsoil$spc, type = "hard")$Xscaled
sum(apply(bsc, 2, var))  # should equal 1


## -----------------------------------------------------------------------------
#| label: block-norm
#| echo: true

# targetnorm = desired Frobenius norm (sum of squares) for X
bn <- blockNorm(X = NIRsoil$spc, targetnorm = 1)$Xscaled
sum(bn^2)  # should equal 1


## -----------------------------------------------------------------------------
#| label: fig-resample
#| fig-cap: "Original NIR spectrum and resampled spectrum at a coarser
#|   resolution (every 10 nm) using interpolation."
#| fig-height: 4
#| fig-width: 6
#| echo: true

wav <- as.numeric(colnames(NIRsoil$spc))
wav_coarse <- seq(min(wav), max(wav), by = 10)

rs <- resample(X = NIRsoil$spc, wav = wav, new.wav = wav_coarse)

plot(
  wav, NIRsoil$spc[1, ],
  type = "l", lwd = 1.5,
  xlab = "Wavelength (nm)", ylab = "Absorbance"
)
lines(
  wav_coarse, rs[1, ], lwd = 1.5, col = "red", type = "b", pch = 19, cex = 0.5
)
grid()
legend(
  "topleft",
  legend = c("Original", "Resampled (10 nm)"),
  lty = 1, col = c("black", "red")
)


## -----------------------------------------------------------------------------
#| label: fig-continuum-removal
#| fig-cap: "Raw absorbance spectra (left) and continuum-removed spectra (right)
#|   for the first three observations."
#| fig-height: 4
#| fig-width: 8
#| echo: true

# type = "A" for absorbance, "R" for reflectance (default)
cr  <- continuumRemoval(X = NIRsoil$spc, type = "A")
wav <- as.numeric(colnames(NIRsoil$spc))

par(mfrow = c(1, 2))

matplot(
  wav, t(NIRsoil$spc[1:3, ]),
  type = "l", lty = 1, lwd = 1.5,
  col = c("black", "grey40", "grey70"),
  xlab = "Wavelength (nm)", ylab = "Absorbance",
  main = "Raw"
)
grid()

matplot(
  wav, t(cr[1:3, ]),
  type = "l", lty = 1, lwd = 1.5,
  col = c("red", "tomato", "salmon"),
  xlab = "Wavelength (nm)", ylab = "Continuum-removed",
  main = "Continuum removal"
)
grid()

par(mfrow = c(1, 1))

