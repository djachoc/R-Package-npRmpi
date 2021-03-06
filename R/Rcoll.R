### Copyright (C) 2002 Hao Yu
mpi.probe <- function(source, tag, comm=1, status=0){
    .Call("mpi_probe", as.integer(source), as.integer(tag), 
        as.integer(comm), as.integer(status),
        PACKAGE = "npRmpi")
}

mpi.get.count <- function(type, status = 0){
    .Call("mpi_get_count",as.integer(status), 
        as.integer(type),PACKAGE = "npRmpi")
}

mpi.get.sourcetag <- function(status=0){
    .Call("mpi_get_sourcetag", as.integer(status),PACKAGE = "npRmpi")
}

mpi.gather <- function(x, type, rdata, root=0,  comm=1){
    .Call("mpi_gather",.force.type( x,type), as.integer(type), rdata, as.integer(root), as.integer(comm),PACKAGE = "npRmpi")
}

mpi.scatter <- function(x, type, rdata, root=0,  comm=1){
    .Call("mpi_scatter", .force.type(x,type), as.integer(type), rdata, 
        as.integer(root), as.integer(comm),PACKAGE = "npRmpi")
}

mpi.gatherv <- function(x, type, rdata, rcounts, root=0,  comm=1){
    .Call("mpi_gatherv", x, as.integer(type),rdata, as.integer(rcounts), 
        as.integer(root), as.integer(comm),PACKAGE = "npRmpi")
}

mpi.scatterv <- function(x, scounts, type, rdata, root=0, comm=1){
    .Call("mpi_scatterv", .force.type(x,type), as.integer(scounts), as.integer(type), rdata, 
        as.integer(root), as.integer(comm),PACKAGE = "npRmpi")
}
#strings.link<-function(manysts,newst){
#.Call("stringslink",as.character(manysts),as.character(newst),PACKAGE="npRmpi")
#}

#string.cut<-function(onest,newst){
#.Call("stringcut",as.character(onest),as.character(newst),PACKAGE="npRmpi")
#}



mpi.scatter.Robj <- function(obj=NULL, root=0, comm=1){
    if (mpi.comm.rank(comm) == root){
     size<-mpi.comm.size(comm)
        subobj<-lapply(obj,.mpi.serialize)
    sublen<-unlist(lapply(subobj,length))
        #newsubobj<-strings.link(subobj,string(sum(sublen)+1))
    newsubobj<-c(subobj,recursive=TRUE)
        strnum<-mpi.scatter(sublen,type=1,rdata=integer(1),root=root,comm=comm)
    outobj<-.mpi.unserialize(mpi.scatterv(newsubobj,scounts=sublen,type= 4,
                rdata=raw(strnum),root=root, comm=comm))
    }
    else {
        strnum<-mpi.scatter(integer(1),type=1,rdata=integer(1),root=root,comm=comm)
        outobj<-.mpi.unserialize(mpi.scatterv(raw(strnum),scounts=0, type=4,
                rdata=raw(strnum), root=root, comm=comm))
    }
    return(outobj)
}

mpi.scatter.Robj2slave=function (obj, comm = 1) {
    if (!is.list(obj))
        stop("Only list object is allowed to scatter to slaves.")
    if (length(obj) != (mpi.comm.size(comm)-1)) 
        stop("Length of your list object is not the same as total number of slaves.")
    .tmpname <- list(objname=deparse(substitute(obj), width.cutoff = 500))
    mpi.bcast.Robj2slave(.tmpname)
    mpi.bcast.cmd(cmd = .tmpRobj <- mpi.scatter.Robj(comm = .comm), 
        rank = 0, comm = comm)
    mpi.scatter.Robj(obj=c(list("master"),obj), root = 0, comm = comm)
    mpi.bcast.cmd(cmd = assign(.tmpname$objname, .tmpRobj, 
        envir = .GlobalEnv), rank = 0, comm = comm)
}

mpi.gather.Robj <- function(obj=NULL, root=0, comm=1){
    biobj<-.mpi.serialize(obj)
    bilen<-length(biobj)
    if (mpi.comm.rank(comm) == root){
        size<-mpi.comm.size(comm=comm)
        rcounts<-mpi.gather(bilen,type=1,rdata=integer(size),
            root=root,comm=comm)
        allbiobj<-mpi.gatherv(biobj,type=4,rdata=raw(sum(rcounts))
                        ,rcounts=rcounts,root=root,comm=comm)
    pos=c(0,cumsum(rcounts))
    cutobj=list()
    for(i in 1:size)
        cutobj[[i]]=allbiobj[(pos[i]+1):pos[i+1]]
         sapply(cutobj,.mpi.unserialize)
    }
    else {
         mpi.gather(bilen,type=1,rdata=integer(1),root=root,comm=comm)
         mpi.gatherv(biobj,type=4,rdata=raw(1),rcounts=0,root=root,comm=comm)
   }
}

mpi.allgather.Robj <- function(obj=NULL, comm=1){
    biobj<-.mpi.serialize(obj)
    bilen<-length(biobj)
    size<-mpi.comm.size(comm=comm)
    rcounts<-mpi.allgather(bilen,type=1,rdata=integer(size),comm=comm)
    allbiobj<-mpi.allgatherv(biobj,type=4,rdata=raw(sum(rcounts))
        ,rcounts=rcounts,comm=comm)
    pos=c(0,cumsum(rcounts))
    cutobj=list()
    for(i in 1:size)
          cutobj[[i]]=allbiobj[(pos[i]+1):pos[i+1]]
    sapply(cutobj,.mpi.unserialize)

   # bistrcut<-sapply(rcounts,string)
   # bistr<-string.cut(allbiobj,bistrcut)
   # lapply(bistr,unserialize)
}



mpi.allgather <- function(x, type, rdata, comm=1){
    .Call("mpi_allgather", x, as.integer(type), rdata, as.integer(comm),
        PACKAGE = "npRmpi")
}

mpi.allgatherv <- function(x, type, rdata, rcounts, comm=1){
    .Call("mpi_allgatherv", x, as.integer(type), rdata, 
    as.integer(rcounts), as.integer(comm),PACKAGE = "npRmpi")
}

mpi.bcast <- function (x, type, rank = 0, comm = 1) {
    .Call("mpi_bcast", .force.type(x,type), as.integer(type), as.integer(rank), 
        as.integer(comm),PACKAGE = "npRmpi")
}

bin.nchar <- function(x){
    if (!is.character(x))
        stop("Must be a (binary) character")
    .Call("bin_nchar", x[1],PACKAGE = "npRmpi")
}

mpi.bcast.cmd <- function (cmd=NULL, rank=0, comm=1, caller.execute = FALSE){
  if(mpi.comm.rank(comm) == rank){
    if(caller.execute)
      tcmd <- substitute(cmd)
    cmd <- deparse(substitute(cmd), width.cutoff=500)
    #cmd <- paste(cmd, collapse="\"\"/")
    cmd <- .mpi.serialize(cmd)
    #mpi.bcast(x=nchar(cmd), type=1, rank=rank, comm=comm)
    mpi.bcast(x=length(cmd), type=1, rank=rank, comm=comm)
    bcast.out <- mpi.bcast(x=cmd, type=4, rank=rank, comm=comm) ## Was missing
    if (caller.execute)
      eval(tcmd, envir = parent.frame())
    else
      invisible(bcast.out)
  } else {
    charlen <- mpi.bcast(x=integer(1), type=1, rank=rank, comm=comm)
    if (is.character(charlen))   #error
      parse(text="break")
    else {
      #out <- mpi.bcast(x=.Call("mkstr", as.integer(charlen),
      #    PACKAGE = "npRmpi"), type=3, rank=rank, comm=comm)
      out <- .mpi.unserialize(mpi.bcast(x=raw(charlen), type=4, rank=rank, comm=comm))
      #parse(text=unlist(strsplit(out,"\"\"/"))) 
      parse(text=out) 
    }
  }
}

mpi.bcast.Robj <- function(obj=NULL, rank=0, comm=1){
    if (mpi.comm.rank(comm) == rank){
    tmp <- .mpi.serialize(obj)
    mpi.bcast(as.integer(length(tmp)), 1, rank, comm)
    invisible(mpi.bcast(tmp, 4, rank, comm))
    }
    else {
    charlen <- mpi.bcast(integer(1), 1, rank, comm)
    .mpi.unserialize(mpi.bcast(raw(charlen), 4, rank, comm))
    }
}

mpi.bcast.Robj2slave <- function(obj, comm=1){
    objname <- deparse(substitute(obj),width.cutoff=500)
    obj <- list(objname=objname,obj=obj)
    mpi.bcast.cmd(cmd=.tmpRobj <- mpi.bcast.Robj(comm=.comm),
                    rank=0, comm=comm)
    mpi.bcast.Robj(obj, rank=0, comm=comm)
    mpi.bcast.cmd(cmd=assign(.tmpRobj$objname,.tmpRobj$obj, 
            envir = .GlobalEnv), rank=0, comm=comm)
    #mpi.bcast.cmd(rm(.tmpRobj,envir = .GlobalEnv), rank=0, comm=comm) 
}

mpi.send <- function (x, type,  dest, tag, comm=1){
    .Call("mpi_send", .force.type(x,type), as.integer(type), as.integer(dest), 
    as.integer(tag), as.integer(comm),PACKAGE = "npRmpi")
}

mpi.recv <- function (x, type, source, tag, comm=1, status=0){
    .Call("mpi_recv", x, as.integer(type), as.integer(source), 
    as.integer(tag), as.integer(comm), as.integer(status),
    PACKAGE = "npRmpi")
}

mpi.send.Robj <- function(obj, dest, tag, comm=1){
    mpi.send(x=.mpi.serialize(obj), type=4, dest=dest, tag=tag, comm=comm)
}

mpi.recv.Robj <- function(source, tag, comm=1, status=0){
    mpi.probe(source, tag, comm, status)
    srctag <- mpi.get.sourcetag(status)
    charlen <- mpi.get.count(type=4, status)
    .mpi.unserialize(mpi.recv(x=raw(charlen), type=4,srctag[1],srctag[2], comm, status))
}

mpi.reduce <- function(x, type=2, 
    op=c("sum","prod","max","min","maxloc","minloc"), dest=0, comm=1){
#   op <- switch(match.arg(op),sum=1,prod=2,max=3,min=4)
    op <- pmatch(match.arg(op), 
        c("sum","prod","max","min","maxloc","minloc"))
    if (is.integer(x)){
       if(type!=1)
        stop("data (integer) and type are not matched.")
    }
    else if (is.double(x)){
       if(type!=2)
        stop("data (double) and type are not matched.")
    }
    else 
        stop("Not implemented.")

#      if (op==5||op==6){
#           n <- length(x)
#           x <- rep(x,rep(2,n))
#       x[seq(2, 2*n, 2)] <- mpi.comm.rank(comm)
#   }
        
    .Call("mpi_reduce", x, as.integer(type), as.integer(op), 
        as.integer(dest), as.integer(comm),PACKAGE = "npRmpi")
}

mpi.allreduce <- function(x,type=2,
    op=c("sum","prod","max","min","maxloc","minloc"), comm=1){
#   op <- switch(match.arg(op),sum=1,prod=2,max=3,min=4)
    op <- pmatch(match.arg(op), c("sum","prod","max","min","maxloc","minloc"))
    if (is.integer(x)){
       if(type!=1)
        stop("data (integer) and type are not matched.")
    }
    else if (is.double(x)){
       if(type!=2)
        stop("data (double) and type are not matched.")
    }
    else 
        stop("Not implemented.")
    .Call("mpi_allreduce", x, as.integer(type), as.integer(op), 
        as.integer(comm),PACKAGE = "npRmpi")
}

mpi.isend <- function (x, type,  dest, tag, comm=1, request=0){
    #mpi.realloc.request(request+1)
    invisible(.Call("mpi_isend", .force.type(x,type), as.integer(type), as.integer(dest), 
    as.integer(tag), as.integer(comm), as.integer(request), PACKAGE = "npRmpi"))
}

mpi.irecv <- function (x, type, source, tag, comm=1, request=0){
    #mpi.realloc.request(request+1)
    if (type==3)
    stop ("Character receiver is not supported")
    invisible(.Call("mpi_irecv", x, as.integer(type), as.integer(source), 
    as.integer(tag), as.integer(comm), as.integer(request),
    PACKAGE = "npRmpi"))
}

mpi.isend.Robj <- function(obj, dest, tag, comm=1,request=0)
    mpi.isend(x=.mpi.serialize(obj), type=4, dest=dest, tag=tag, 
        comm=comm,request=request)

mpi.wait <- function(request, status=0)
    invisible(.Call("mpi_wait",  as.integer(request), as.integer(status), PACKAGE = "npRmpi"))
    
mpi.waitany <- function(count, status=0){
    #mpi.realloc.request(count)
    .Call("mpi_waitany",  as.integer(count), as.integer(status), PACKAGE = "npRmpi")
}

mpi.waitall <- function(count){
    #mpi.realloc.request(count)
    #mpi.realloc.status(count)
    invisible(.Call("mpi_waitall",  as.integer(count), PACKAGE = "npRmpi"))
}

mpi.waitsome <- function(count){
    #mpi.realloc.request(count)
    #mpi.realloc.status(count)
    tmp<-.Call("mpi_waitsome",  as.integer(count), PACKAGE = "npRmpi")
    if (tmp[1] <0 || tmp[1] > count)
        return(list(count=tmp[1],indices=NULL))
    else 
        return(list(count=tmp[1],indices=tmp[2:(1+tmp[1])]))
}

mpi.test <- function(request, status=0)
    as.logical(.Call("mpi_test",  as.integer(request), as.integer(status), PACKAGE = "npRmpi"))

mpi.testany <- function(count, status=0){
    #mpi.realloc.request(count)
    tmp <-.Call("mpi_testany",  as.integer(count), as.integer(status), PACKAGE = "npRmpi")
    list(index=tmp[1], flag=as.logical(tmp[2]))
}

mpi.testall <- function(count){
    #mpi.realloc.request(count)
    #mpi.realloc.status(count)
    as.logical(.Call("mpi_testall",  as.integer(count), PACKAGE = "npRmpi"))
}

mpi.testsome <- function(count){
    #mpi.realloc.request(count)
    #mpi.realloc.status(count)
    tmp<-.Call("mpi_testsome",  as.integer(count), PACKAGE = "npRmpi")
    if (tmp[1] < 0 || tmp[1] > count)
        return(list(count=tmp[1],indices=NULL))
    else 
        return(list(count=tmp[1],indices=tmp[2:(1+tmp[1])]))
}

mpi.cancel <- function(request)
    invisible(.Call("mpi_cancel",  as.integer(request), PACKAGE = "npRmpi"))

mpi.test.cancelled <- function(status=0)
    as.logical(.Call("mpi_test_cancelled", as.integer(status), PACKAGE = "npRmpi"))

mpi.iprobe <- function(source, tag, comm=1, status=0){
    as.logical(.Call("mpi_iprobe", as.integer(source), as.integer(tag), 
        as.integer(comm), as.integer(status),
        PACKAGE = "npRmpi"))
}

mpi.realloc.status <- function(newmaxsize)
    if (newmaxsize > mpi.status.maxsize())
        invisible(.Call("mpi_realloc_status", as.integer(newmaxsize), PACKAGE = "npRmpi"))

mpi.realloc.request <- function(newmaxsize)
    if (newmaxsize > mpi.request.maxsize())
        invisible(.Call("mpi_realloc_request", as.integer(newmaxsize), PACKAGE = "npRmpi"))

mpi.realloc.comm <- function(newmaxsize)
    if (newmaxsize > mpi.comm.maxsize())
       invisible(.Call("mpi_realloc_comm", as.integer(newmaxsize), PACKAGE="npRmpi"))

mpi.comm.maxsize <- function()
    .Call("mpi_comm_maxsize", PACKAGE="npRmpi")

mpi.status.maxsize <- function()
    .Call("mpi_status_maxsize", PACKAGE="npRmpi")
    
mpi.request.maxsize <- function()
    .Call("mpi_request_maxsize", PACKAGE="npRmpi")
    
.mpi.undefined <- function()
    .Call("mpi_undefined", PACKAGE="npRmpi")

.force.type <- function(x, type){ 
    switch(type,
        as.integer(x),
        as.double(x),
        as.character(x),
    as.raw(x))
}
.mpi.serialize<- function(obj){
    trans_obj=serialize(obj,NULL)
#    if ( version$major > 2 || version$minor >= 4.0)
    if (getRversion()>="2.4.0")
        return(trans_obj)
    else
        return(charToRaw(trans_obj))
}


.mpi.unserialize<- function(obj){
    #if ( version$major > 2 || version$minor >= 4.0)
    if (getRversion()>="2.4.0")
        return(unserialize(obj))
    else
        return(unserialize(rawToChar(obj)))
 }
#mpi.request.get.status <- function(request, status=0){
#    as.logical(.Call("mpi_request_get_status",  as.integer(request), 
#        as.integer(status), PACKAGE = "npRmpi"))
#}
