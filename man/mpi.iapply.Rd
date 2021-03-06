\name{mpi.iapplyLB}
\alias{mpi.iapplyLB}
\alias{mpi.iparApply}
\alias{mpi.iparLapply}
\alias{mpi.iparSapply}
\alias{mpi.iparRapply}
\alias{mpi.iparCapply}
\alias{mpi.iparReplicate}
\alias{mpi.iparMM}
\title{(Load balancing) parallel apply with nonblocking features}
\description{
(Load balancing) parallel\code{lapply} and related functions. 
}
\usage{
mpi.iapplyLB(x, fun, ..., apply.seq=NULL, comm=1, sleep=0.001)
mpi.iparApply(x, MARGIN, fun, ..., job.num = mpi.comm.size(comm)-1,
                    apply.seq=NULL, comm=1, sleep=0.001)
mpi.iparLapply(x, fun, ..., job.num=mpi.comm.size(comm)-1, apply.seq=NULL, 
		    comm=1,sleep=0.001)  
mpi.iparSapply(x, fun, ..., job.num=mpi.comm.size(comm)-1, apply.seq=NULL, 
		simplify=TRUE, USE.NAMES = TRUE, comm=1, sleep=0.001)  
mpi.iparRapply(x, fun, ..., job.num=mpi.comm.size(comm)-1, apply.seq=NULL, 
		comm=1, sleep=0.001)  
mpi.iparCapply(x, fun, ..., job.num=mpi.comm.size(comm)-1, apply.seq=NULL, 
		comm=1,sleep=0.001)  
mpi.iparReplicate(n, expr, job.num=mpi.comm.size(comm)-1, apply.seq=NULL, 
		simplify = TRUE, comm=1,sleep=0.001)
mpi.iparMM(A, B, comm=1, sleep=0.001)
}
\arguments{
  \item{x}{an array or matrix.}
  \item{MARGIN}{vector specifying the dimensions to use.}
  \item{fun}{a function.}
  \item{simplify}{logical; should the result be simplified to a vector or
          matrix if possible?}
  \item{USE.NAMES}{logical; if \code{TRUE} and if \code{x} is character, use \code{x} as
          \code{names} for the result unless it had names already.}
  \item{n}{number of replications.}
  \item{A}{a matrix}
  \item{B}{a matrix}
  \item{expr}{expression to evaluate repeatedly.}
  \item{job.num}{Total job numbers. If job numbers is bigger than total slave numbers (default 
value), a load balancing approach is used.}
  \item{apply.seq}{if reproducing the same computation (simulation) is desirable, set it 
to the integer vector .mpi.applyLB generated in previous computation (simulation).}
  \item{...}{optional arguments to \code{fun}}
  \item{comm}{a communicator number}
  \item{sleep}{a sleep interval on master node (in sec)}
}
\details{
\code{mpi.iparApply}, \code{mpi.iparLapply}, \code{mpi.iparSapply}, \code{mpi.iparRapply}, 
\code{mpi.iparCapply}, \code{mpi.iparSapply}, \code{mi.iparReplicate}, and \code{mpi.iparMM}
 are nonblocking versions of \code{mpi.parApply}, \code{mpi.parLapply}, \code{mpi.parSapply}, 
\code{mpi.parRapply}, \code{mpi.parCapply}, \code{mpi.parSapply}, \code{mpi.parReplicate}, 
and \code{mpi.parMM} respectively. The main difference is that \code{mpi.iprobe} and 
\code{Sys.sleep} are used so that master node consumes almost no CPU cycles while waiting for 
slaves results. However, due to frequent wake/sleep cycles on master, those functions are not 
suitable for running small jobs on slave nodes. If anticipated computing time for each job is 
relatively long, e.g., minutes or hours, setting sleep to be 1 second or longer will further 
reduce load on master (only slightly).
 }
\seealso{
\code{\link{mpi.iapply}}
}
\keyword{utilities}
