= gbutils 0.5.1

- minor corrections in the documentation and file DESCRIPTION.


# gbutils 0.5

* new function `rpoly()` creates polynomials with real coefficients from their
  zeroes (roots) given in Cartesian or polar form.

* minor edits of the documentation of `adjacencyOfClasses()`.


# gbutils 0.4-0


# gbutils 0.3-1 (not on CRAN)

* deal with a NOTE on CRAN.

* new function `pseudoInverse()` (moved here from package mixAR).

* new examples for converting results of `adjacencyOfClasses()` to graph objects
  and plotting them.


# gbutils 0.2-4 - 0.3.0

* new function `adjacencyOfClasses()` gives the graph of the classes defined in
  one or more packages in several ways. It can also give a Wolfram language
  expression which can be evaluated in Mathematica, see the help page for
  details and examples.
  
* use Rd macro `\printExample` from package `Rdpack` for some examples in
  details section (see `adjacencyOfClasses()`). 


# gbutils 0.2-3 (not on CRAN)

* created `README.*`.
* added website created with 'pkgdown'.
* added github URL to DESCRIPTION.


# gbutils 0.2-2 (not on CRAN)

* corrected a couple of typo's in the vignette.


# gbutils 0.2-1

* New function `missing_arg()` returns TRUE if an element of a pairlist is
  missing.

* New function `plotpdf()` plots probability density and related functions over
  automatically selected intervals (based on cdf of qf).

* New function `cdf2quantile()` numerically computes quantiles of a given cdf.
  This is mainly for use by `plotpdf()`.

* A vignette illustrates `plotpdf()`.


# gbutils 0.2-0

* First CRAN version
