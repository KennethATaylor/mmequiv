% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api_rate_limit_helpers.R
\name{advise_api_usage}
\alias{advise_api_usage}
\title{Provide advisory message about potential API rate limit issues}
\usage{
advise_api_usage(n_patients, use_api, rate_limit = 50)
}
\arguments{
\item{n_patients}{Number of unique patients}

\item{use_api}{Whether API is being used}

\item{rate_limit}{The API rate limit (default: 50)}
}
\value{
Invisible NULL, called for side effects (informational messages)
}
\description{
Provide advisory message about potential API rate limit issues
}
\keyword{internal}
