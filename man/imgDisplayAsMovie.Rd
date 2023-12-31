% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/imgDisplayAsMovie.R
\name{imgDisplayAsMovie}
\alias{imgDisplayAsMovie}
\title{Display Images as a Movie}
\usage{
imgDisplayAsMovie(img, interval = 1, N_repeat = 3, Output_format = "mp4")
}
\arguments{
\item{img}{A list of EBImage type images to be displayed in the movie.}

\item{interval}{Numeric value specifying the time interval between frames. Default is 1.}

\item{N_repeat}{Integer value specifying the number of times the sequence
should be repeated. Default is 3.}

\item{Output_format}{String specifying the output file format.
Should be either "mp4" or "mov". Default is "mp4".}
}
\value{
No return value, but a movie file is saved in the working directory.
}
\description{
Create a movie from a list of EBImage type images,
   with specified interval, repetition, and output format.
}
\details{
Display Images as a Movie

This function takes a list of images (of type EBImage) and creates a movie
by displaying the images in sequence.
The movie can be saved in either mp4 or mov format.
}
\examples{
\dontrun{
  img_list <- list(image1, image2, image3) # Example images of EBImage type
  imgDisplayAsMovie(img_list, interval = 2, N_repeat = 2, Output_format = "mov")
}
}
\author{
Satoshi Kume
}
