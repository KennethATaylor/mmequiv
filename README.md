
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mmequiv <img src="man/figures/logo.png" align="right" height="139"/>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/mmequiv)](https://CRAN.R-project.org/package=mmequiv)
[![R-CMD-check](https://github.com/KennethATaylor/mmequiv/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/KennethATaylor/mmequiv/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

The goal of `mmequiv` is to provide users access to the NIH HEAL
Morphine Milligram Equivalent Online Calculator API directly from R.

The NIH HEAL Initiative requires that clinical pain studies monitor use
of opioids prescribed for pain management, reported in morphine
milligram equivalents (MME). `mmequiv` passes information about
prescription opioids used by study participants, and directly interfaces
with the [NIH HEAL MME Online
Calculator](https://research-mme.wakehealth.edu/)’s API to calculate the
MME based on several standardized definitions.

This package (just like the online portal for the MME calculator) is
intended as a data resource for: research, analytical purposes using
claims or dispensing data, and surveillance of population-level
medication utilization.

**Important**: Users should be aware of the caveats and limitations of
the NIH HEAL MME Online Calculator:

>     The data collection tool is NOT intended for any clinical decision-making by clinicians while prescribing opioids. The MME conversion factors in this survey DO NOT constitute any clinical guidance for prescribing or recommendations for converting patients from one form of opioid analgesic to another.

To read more about the NIH HEAL MME Calculator, see [Adams, *et al*.
(2025)](https://www.doi.org/10.1097/j.pain.0000000000003529).

## Installation

You can install the development version of `mmequiv` like so:

``` r
# install.packages("remotes")
remotes::install_github('KennethATaylor/mmequiv')
```

## Citation

In addition to citing the original paper by [Adams, *et al*.
(2025)](https://www.doi.org/10.1097/j.pain.0000000000003529), consider
citing this package. You can obtain information needed to cite the
package by running:

``` r
citation("mmequiv")
```
