## what is a badord? ... an ordered factor of numeric values
## to treat them properly one must preserve the numeric value, ie. scale
## not just their sorted order
## Actually, the ord/badord paradigm must go, in place of levels caching

matrix.sd <- function(x, na.rm=FALSE) {
  if(is.matrix(x)) apply(x, 2, sd, na.rm=na.rm)
  else if(is.vector(x)) sd(x, na.rm=na.rm)
  else if(is.data.frame(x)) sapply(x, sd, na.rm=na.rm)
  else sd(as.vector(x), na.rm=na.rm)
}

npseed <- function(seed){
  .C("np_set_seed",as.integer(abs(seed)), PACKAGE = "npRmpi")
  invisible()
}

numNotIn <- function(x){
  while(is.element(num <- rnorm(1),x)){}
  num
}

dlev <- function(x){
  if(is.ordered(x))
    x.dlev <- suppressWarnings(as.numeric(levels(x)))
  if (!is.ordered(x) || any(is.na(x.dlev)))
    x.dlev <- as.numeric(1:nlevels(x))
  x.dlev
}

isNum <- function(x){
  return(!any(is.na(suppressWarnings(as.numeric(x)))))
}

untangle <- function(frame){
  if (is.null(frame))
    return(NULL)
  
  iord <- unlist(lapply(frame, is.ordered))
  iuno <- unlist(lapply(frame, is.factor)) & !iord
  icon <- unlist(lapply(frame, is.numeric))

  if(!all(iord | iuno | icon)) 
    stop("non-allowed data type in data frame")

  inumord <-
    suppressWarnings(unlist(lapply(frame,
    function (z) {
      is.ordered(z) && is.numeric(tryCatch(as.numeric(levels(z)), warning = function (y) {
        FALSE }))
    })))

  all.lev <- lapply(frame, function(y){
    t.ret <- NULL
    if (is.factor(y))
      t.ret <- levels(y)
    t.ret
  })

  all.ulev <- lapply(frame, function (y) {
    t.ret <- NULL
    if (is.factor(y))
      t.ret <- sort(unique(y))
    t.ret
  })

  all.dlev <- lapply(frame, function (y) {
    t.ret <- NULL
    if (is.factor(y))
      t.ret <- dlev(y)
    t.ret
  })

  all.nlev <- lapply(frame, function(y) {
    t.ret <- NULL
    if (is.factor(y))
      t.ret <- nlevels(y)
    t.ret
  })

  list(iord = iord,
       iuno = iuno,
       icon = icon,
       inumord = inumord,
       all.lev = all.lev,
       all.ulev = all.ulev,
       all.dlev = all.dlev,
       all.nlev = all.nlev)
}

validateBandwidth <- function(bws){
  vari <- names(bws$bandwidth)
  bchecker <- function(j){
    v <- vari[j]
    dati <- bws$dati[[v]]
    bwv <- bws$bandwidth[[j]]
    stopifnot(length(bwv) == length(dati$iord))

    cd <- function(a,b){
      (a-b)/(a+b+.Machine$double.eps) > 5.0*.Machine$double.eps
    }
    
    vb <- sapply(1:length(bwv), function(i){
      falg <- (bwv[i] < 0)

      if (dati$icon[i] && (falg || (!is.finite(bwv[i])))){
        stop(paste("Invalid bandwidth supplied for continuous",
                   "variable", bws$varnames[[v]][i], ":",bwv[i]))
      }
      
      if (dati$iord[i] &&
          (falg || cd(bwv[i],oMaxL(dati$all.nlev[[i]],
                         kertype = bws$klist[[v]]$okertype)))){
        stop(paste("Invalid bandwidth supplied for ordered",
                   "variable", bws$varnames[[v]][i], ":",bwv[i]))
      }
      
      if (dati$iuno[i] &&
          (falg || cd(bwv[i],uMaxL(dati$all.nlev[[i]],
                         kertype = bws$klist[[v]]$ukertype)))){
        stop(paste("Invalid bandwidth supplied for unordered",
                   "variable", bws$varnames[[v]][i], ":",bwv[i]))
      }
      return(TRUE)
    })
    
    return(vb)
  }
  vbl <- lapply(1:length(vari), bchecker)
  invisible(vbl)
}

explodeFormula <- function(formula){
  res <- strsplit(strsplit(paste(deparse(formula), collapse=""),
                           " *[~] *")[[1]], " *[+] *")
  stopifnot(all(sapply(res,length) > 0))
  names(res) <- c("response","terms")
  res
}


explodePipe <- function(formula){
  tf <- as.character(formula)  
  tf <- tf[length(tf)]

  eval(parse(text=paste("c(",
               ifelse(length(as.character(formula)) == 3,
                      'strsplit(as.character(formula)[2]," *[+] *"),',""),
               'strsplit(strsplit(tf," *[|] *")[[1]]," *[+] *"))')))
}

"%~%" <- function(a,b) {
  all(class(a) == class(b)) && (length(a) == length(b)) &&
  all(unlist(lapply(a,coarseclass)) == unlist(lapply(b,coarseclass)))
}

coarseclass <- function(a) {
  ifelse(class(a) == "integer", "numeric", class(a))
}

toFrame <- function(frame) {
  if(!is.data.frame(frame)){
    t.names <- NULL

    if(!(is.vector(frame) || is.factor(frame) || is.matrix(frame)))
      stop(deparse(substitute(frame))," must be a data frame, matrix, vector, or factor")

    if(!is.matrix(frame))
      t.names <- deparse(eval(substitute(substitute(frame)), envir = parent.frame()))
    
    frame <- data.frame(frame, check.names=FALSE)
    
    if(!is.null(t.names))
      names(frame) <- t.names
  }
  return(frame)
}


cast <- function(a, b, same.levels = TRUE){
  if(is.ordered(b)){
    if(same.levels)
      ordered(a, levels = levels(b))
    else
      ordered(a)
  }   
  else if(is.factor(b)){
    if(same.levels)
      factor(a, levels = levels(b))
    else
      factor(a)
  }
  else if (coarseclass(b) == "numeric")
    as.double(a)
  else if (is.data.frame(b)) {
    if (dim(a)[2] == dim(b)[2]){
      r = data.frame(a)
      for (i in 1: length(b))
        r[,i] = cast(a[,i],b[,i], same.levels = same.levels)
      r
    } else { stop("a could not be cast as b") }
  }
}

subcol <- function(x, v, i){
  x[,i] = cast(v,x[,i])
  x
}

mcvConstruct <- function(dati){
  nuno <- sum(dati$iuno)
  nord <- sum(dati$iord)

  num.row <- max(sapply(dati$all.lev,length))

  pad.num <- numNotIn(unlist(dati$all.dlev))

  mcv <- matrix(data = pad.num, nrow = num.row, ncol = (nuno+nord))
  attr(mcv, "num.row") <- num.row
  attr(mcv, "pad.num") <- pad.num

  cnt <- 0
  if (nuno > 0)
    for (i in which(dati$iuno)) 
      mcv[1:length(dati$all.lev[[i]]), (cnt <- cnt+1)] <- dati$all.dlev[[i]]

  cnt <- 0
  if (nord > 0)
    for (i in which(dati$iord))
      mcv[1:length(dati$all.lev[[i]]), (cnt <- cnt+1)+nuno] <- dati$all.dlev[[i]]

  mcv
}

## when admitting new categories, adjustLevels will attempt to catch possible mistakes:
## if an unordered variable contains more than one new category, warn
## if an ordered, but scaleless variable contains a new category, error
## if an ordered, scale-possessing variable contains a new category lacking scale, error

adjustLevels <- function(data, dati, allowNewCells = FALSE){
  for (i in which(dati$iord | dati$iuno)){
    if (allowNewCells){
      newCats <- setdiff(levels(data[,i]),dati$all.lev[[i]])
      if (length(newCats) >= 1){
        if (dati$iuno[i]){
          if (length(newCats) > 1)
            warning(paste("more than one 'new' category is redundant when estimating on unordered data.\n",
                          "training data categories: ", paste(dati$all.lev[[i]], collapse=" "),"\n",
                          "redundant estimation data categories: ", paste(newCats, collapse=" "), "\n", sep=""))
          data[,i] <- factor(data[,i], levels = c(dati$all.lev[[i]], newCats))
        } else {
          if (dati$inumord[i]){
            if (!isNum(newCats))
              stop(paste("estimation data contains a new qualitative category, but training data is\n",
                         "ordered, and numeric.\n",
                         "training data categories: ", paste(dati$all.lev[[i]], collapse=" "),"\n",
                         "conflicting estimation data categories: ", paste(newCats, collapse=" "), "\n", sep=""))
          } else {
            stop(paste("estimation beyond the support of training data of an ordered,\n",
                       "categorical, qualitative variable is not supported.\n"))
          }

          data[,i] <- ordered(data[,i], levels = sort(as.numeric(c(dati$all.lev[[i]], newCats))))
        }
      } else {
        data[,i] <- factor(data[,i], levels = dati$all.lev[[i]])
      }
    } else {
      if (!all(is.element(levels(data[,i]), dati$all.lev[[i]])))
        stop("data contains unknown factors (wrong dataset provided?)")
      data[,i] <- factor(data[,i], levels = dati$all.lev[[i]])
    }
  }

  data
}

toMatrix <- function(data) {
  tq <- sapply(data, function(y) {
    if(is.factor(y))
      y <- dlev(y)[as.integer(y)]
    y})
  dim(tq) <- dim(data) ## cover the corner case of single element d.f.
  tq
}

## this doesn't just strictly check for the response, but does tell you
## that evaluating with response fails ... in principle the evaluation
## could fail without the response too, but then the calling routine is about
## to die a noisy death anyhow ...
succeedWithResponse <- function(tt, frame){
  !any(class(try(eval(expr = attr(tt, "variables"),
                      envir = frame, enclos = NULL), silent = TRUE)) == "try-error")
}

## determine whether a bandwidth
## matches a data set
bwMatch <- function(data, dati){
  if (length(dati$icon) != ncol(data))
    stop("bandwidth vector is of improper length")

  test.dati <- untangle(data)

  if (any(xor(dati$icon,test.dati$icon)) ||
      any(xor(dati$iord,test.dati$iord)) ||
      any(xor(dati$iuno,test.dati$iuno)))
    stop(paste("supplied bandwidths do not match","data", "in type"))
}

uMaxL <- function(c, kertype = c("aitchisonaitken","liracine")){
  switch(kertype,
         aitchisonaitken = (c-1.0)/c,
         liracine = 1.0)
}

oMaxL <- function(c, kertype = c("wangvanryzin", "liracine")){
  switch(kertype,
         wangvanryzin = 1.0,
         liracine = 1.0)
}

## tested with: rbandwidth
## right now all bandwidth objects have some crusty
## vestiges of their evolution, ie. non-list metadata
## such as xnames or ynames. The new metadata system is
## for the most part list based and facilitates generic
## operations

updateBwNameMetadata <- function(nameList, bws){
  ## names of 'old' metadata in bw object
  onames <- names(nameList)
  lapply(1:length(nameList), function(i) {
    bws[[onames[i]]] <<- nameList[[i]]
    bws$varnames[[substr(onames[i],1,1)]] <<- nameList[[i]]
  })
  return(bws)
}

## some string utility functions

pad <- function(s){
  ifelse(nchar(s) > 0, paste("",s,""), " ")
}

rpad <- function(s){
  ifelse(nchar(s) > 0, paste(s,""), "")
}

blank <- function(len){
  sapply(len, function(nb){
    paste(rep(' ', times = nb), collapse='')
  })
}

formatv <- function(v){
  sapply(1:length(v), function(j){ format(v[j]) })
}

## strings used in various report generating functions

genOmitStr <- function(x){
  t.str <- ''
  if(!is.null(x$rows.omit) & !identical(x$rows.omit, NA))
    t.str <- paste("\nNo. Complete Observations: ", x$nobs,
                   "No. NA Observations: ", x$nobs.omit,
                   "\nObservations omitted: ", paste(x$rows.omit, collapse=" "),
                   "\n")
  return(t.str)
}

## Estimation-related rgf's
genGofStr <- function(x){
  paste(ifelse(is.na(x$MSE),"",paste("\nResidual standard error:",
                                     format(sqrt(x$MSE)))),
        ifelse(is.na(x$R2),"",paste("\nR-squared:",
                                    format(x$R2))), sep="")
}

pCatGofStr <- function(x){
  if(!identical(x$confusion.matrix, NA)){
    cat("\nConfusion Matrix\n")
    print(x$confusion.matrix)
  }

  if (!identical(x$CCR.overall,NA))
    cat("\nOverall Correct Classification Ratio: ", format(x$CCR.overall))

  if (!identical(x$CCR.byoutcome,NA)){
    cat("\nCorrect Classification Ratio By Outcome:\n")
    print(x$CCR.byoutcome)
  }

  if (!identical(x$fit.mcfadden,NA))
    cat("\nMcFadden-Puig-Kerschner performance measure: ", format(x$fit.mcfadden))

}

genDenEstStr <- function(x){
  paste("\nBandwidth Type: ",x$ptype,
        ifelse(is.null(x$log_likelihood) || identical(x$log_likelihood, NA),"",
               paste("\nLog Likelihood:",
                     format(x$log_likelihood))),
        sep="")
}

genRegEstStr <- function(x){
  paste(ifelse(is.null(x$pregtype),"",
               paste("\nKernel Regression Estimator:",x$pregtype)),
        ifelse(is.null(x$ptype), "",
               paste("\nBandwidth Type:",x$ptype)),
        ifelse(is.null(x$tau), "", paste("\nTau:", x$tau)),
        sep = "")
}


## bandwidth-related report generating functions
genBwSelStr <- function(x){
  paste(ifelse(is.null(x$pregtype),"",paste("\nRegression Type:", x$pregtype)),
        ifelse(is.null(x$pmethod),"",paste("\nBandwidth Selection Method:",
                                           x$pmethod)),
        if (!identical(x$formula,NULL)) paste("\nFormula:",
                                              paste(deparse(x$formula), collapse="\n")),
        ifelse(is.null(x$ptype), "",
               paste("\nBandwidth Type: ",x$ptype, sep="")),
        ifelse(identical(x$fval,NA),"",
               paste("\nObjective Function Value: ", format(x$fval),
               " (achieved on multistart ", x$ifval, ")", sep="")), sep="")
}

genBwScaleStrs <- function(x){
  ## approach is to take metadata and flatten it so it then can be
  ## processed into a single string

  vari <- names(x$sumNum)
  
  t.icon <- lapply(vari, function(v){
    x$dati[[v]]$icon })

  sumText <- lapply(1:length(vari), function(i) {
    ifelse(t.icon[[i]],
           ifelse(x$type == "fixed",
                  "Scale Factor:",""), "Lambda Max:")
    
  })

  maxNameLen <- max(nchar(unlist(sumText)))
  print.sumText <- lapply(sumText, '!=', "")

  sumText <- lapply(1:length(sumText), function(i){
    paste(blank(maxNameLen - nchar(sumText[[i]])), sumText[[i]], sep="")
  })

  t.nchar <- lapply(x$varnames[vari], nchar)
                    
  maxNameLen <- max(unlist(t.nchar))

  vatText <- lapply(1:length(t.nchar), function(j){
    paste("\n", rpad(x$vartitleabb[[vari[j]]]), "Var. Name: ",
          x$varnames[[vari[j]]],
          sapply(t.nchar[[j]], function(nc){
            paste(rep(' ', maxNameLen - nc), collapse='')
          }), sep='')
  })

  return(sapply(1:length(t.nchar), function(j){
    paste(vatText[[j]], " Bandwidth: ", npFormat(x$bandwidth[[j]]), " ",
          ifelse(print.sumText[[j]],
                 paste(sumText[[j]], " ", npFormat(x$sumNum[[j]]), sep=""), ""),
          sep="", collapse="")
  }))
}

npFormat <- function(x){
  format(sapply(x,format))
}

genBwKerStrs <- function(x){
  vari <- names(x$klist)

  ncon <- sapply(vari, function(v){
    sum(x$dati[[v]]$icon)
  })

  nuno <- sapply(vari, function(v){
    sum(x$dati[[v]]$iuno)
  })

  nord <- sapply(vari, function(v){
    sum(x$dati[[v]]$iord)
  })

  cktype <- sapply(vari, function(v){
    x$klist[[v]]$ckertype
  })

  uktype <- sapply(vari, function(v){
    x$klist[[v]]$ukertype
  })

  oktype <- sapply(vari, function(v){
    x$klist[[v]]$okertype
  })

  tt <- ''

  if(any(ncon > 0)){
    tt <- paste("\n",
                ifelse(length(unique(cktype)) == 1,
                       paste("\nContinuous Kernel Type:",
                             x$klist[[vari[1]]]$pckertype),
                       paste(sapply(1:length(vari), function(v){
                         ifelse(ncon[v] > 0,
                                paste("\nContinuous Kernel Type (",
                                      x$vartitleabb[[vari[v]]],
                                      " Var.): ", x$klist[[vari[v]]]$pckertype, sep=""),"")
                       }), collapse = "")),
                sep = "")
    tt <-
      paste(tt, paste(sapply(1:length(vari), function(i){
        ifelse(ncon[i] > 0,
               paste("\nNo. Continuous", pad(x$vartitle[[vari[i]]]), "Vars.: ",
                     ncon[i], sep=""), "")
      }), collapse = ""), sep="")
  }
                
    
  if(any(nuno > 0)) {
    tt <- paste(tt, "\n",
                ifelse(length(unique(uktype)) == 1,
                       paste("\nUnordered Categorical Kernel Type:",
                             x$klist[[vari[1]]]$pukertype),
                       paste(sapply(1:length(vari), function(i){
                         ifelse(nuno[i] > 0,
                                paste("\nUnordered Categorical Kernel Type (",
                                      x$vartitleabb[[vari[i]]],
                                      " Var.): ", x$klist[[vari[i]]]$pukertype, sep=""),"")
                       }), collapse = "")),
                sep = "")
    tt <-
      paste(tt, paste(sapply(1:length(vari), function(i){
        ifelse(nuno[i] > 0,
               paste("\nNo. Unordered Categorical", pad(x$vartitle[[vari[i]]]), "Vars.: ",
                     nuno[i], sep=""), "")
      }), collapse = ""), sep="")

  }

  if(any(nord > 0)) {
    tt <- paste(tt, "\n",
                ifelse(length(unique(oktype)) == 1,
                paste("\nOrdered Categorical Kernel Type:",
                      x$klist[[vari[1]]]$pokertype),
                paste(sapply(1:length(vari), function(i){
                  ifelse(nord[i] > 0,
                         paste("\nOrdered Categorical Kernel Type (",
                               x$vartitleabb[[vari[i]]],
                               " Var.): ", x$klist[[vari[i]]]$pokertype, sep=""),"")
                }), collapse = "")),
         sep = "")
    tt <-
      paste(tt, paste(sapply(1:length(vari), function(i){
        ifelse(nord[i] > 0,
               paste("\nNo. Ordered Categorical", pad(x$vartitle[[vari[i]]]), "Vars.: ",
                     nord[i], sep=""), "")
      }), collapse = ""), sep="")

  }

  return(tt)
}

genBwKerStrsXY <- function(x){
  t.str <- ''
  cnt <- 0
  
  if (x$xncon + x$yncon > 0){
    t.str[cnt <- cnt + 1] <-
      paste(ifelse(x$pcxkertype == x$pcykertype,
                   paste("\n\nContinuous Kernel Type:",x$pcxkertype),
                   paste("\n", ifelse(x$xncon > 0,
                                      paste("\nContinuous Kernel Type (Exp. Var.):",
                                            x$pcxkertype), ""),
                         ifelse(x$yncon > 0,
                                paste("\nContinuous Kernel Type (Dep. Var.):",
                                      x$pcykertype), ""))),
            ifelse(x$yncon > 0,paste("\nNo. Continuous Dependent Vars.:",x$yncon),""),
            ifelse(x$xncon > 0,paste("\nNo. Continuous Explanatory Vars.:",x$xncon),""))
  }

  if (x$xnuno + x$ynuno > 0){
    t.str[cnt <- cnt + 1] <-
      paste(ifelse(x$puxkertype == x$puykertype,
                   paste("\n\nUnordered Categorical Kernel Type:",x$puxkertype),
                   paste("\n", ifelse(x$xnuno > 0,
                                      paste("\nUnordered Categorical Kernel Type (Exp. Var.):",
                                            x$puxkertype), ""),
                         ifelse(x$ynuno > 0,
                                paste("\nUnordered Categorical Kernel Type (Dep. Var.):",
                                      x$puykertype), ""))),
            ifelse(x$ynuno > 0,paste("\nNo. Unordered Categorical Dependent Vars.:",x$ynuno),""),
            ifelse(x$xnuno > 0,paste("\nNo. Unordered Categorical Explanatory Vars.:",x$xnuno),""))
  }

  if (x$xnord + x$ynord > 0){
    t.str[cnt <- cnt + 1] <-
      paste(ifelse(x$poxkertype == x$poykertype,
                   paste("\n\nOrdered Categorical Kernel Type:",x$poxkertype),
                   paste("\n", ifelse(x$xnord > 0,
                                      paste("\nOrdered Categorical Kernel Type (Exp. Var.):",
                                            x$poxkertype), ""),
                         ifelse(x$ynord > 0,
                                paste("\nOrdered Categorical Kernel Type (Dep. Var.):",
                                      x$poykertype), ""))),
            ifelse(x$ynord > 0,paste("\nNo. Ordered Categorical Dependent Vars.:",x$ynord),""),
            ifelse(x$xnord > 0,paste("\nNo. Ordered Categorical Explanatory Vars.:",x$xnord),""))
  }
  return(t.str)
}

genBwGOFStrs <- function(x) {
  ###paste("Residual standard error:", sqrt
}
  
## statistical functions
RSQfunc <- function(y,y.pred) {
  y.mean <- mean(y)
  (sum((y-y.mean)*(y.pred-y.mean))^2)/(sum((y-y.mean)^2)*sum((y.pred-y.mean)^2))
}

MSEfunc <- function(y,y.fit) {
  mean((y-y.fit)^2)
}

MAEfunc <- function(y,y.fit) {
  mean(abs(y-y.fit))
}

MAPEfunc <- function(y,y.fit) {
  jj = which(y != 0)
  
  mean(c(abs((y[jj]-y.fit[jj])/y[jj]), as.numeric(replicate(length(y)-length(jj),2))))
}

CORRfunc <- function(y,y.fit) {
  abs(corr(cbind(y,y.fit)))
}

SIGNfunc <- function(y,y.fit) {
  sum(sign(y) == sign(y.fit))/length(y)
}

EssDee <- function(y){

  sd.vec <- apply(as.matrix(y),2,sd)
  IQR.vec <- apply(as.matrix(y),2,IQR)/(qnorm(.25,lower.tail=F)*2)
  return(ifelse(sd.vec<IQR.vec|IQR.vec==0,sd.vec,IQR.vec))
  
}

### holding place for some generic methods

se <- function(x){
  UseMethod("se",x)
}

gradients <- function(x, ...){
  UseMethod("gradients",x)
}
### internal constants used in the c backend

SF_NORMAL = 0
SF_ARB = 1

BW_FIXED = 0
BW_GEN_NN = 1
BW_ADAP_NN = 2

IMULTI_TRUE = 1
IMULTI_FALSE = 0

RE_MIN_TRUE = 0
RE_MIN_FALSE = 1

IO_MIN_TRUE = 1
IO_MIN_FALSE = 0

USE_START_NO = 0
USE_START_YES = 1

NP_DO_DENS = 1
NP_DO_DIST = 0

##kernel defs
CKER_GAUSS = 0
CKER_EPAN  = 4
CKER_UNI   = 8

UKER_AIT = 0
UKER_LR = 1

OKER_WANG = 0
OKER_LR = 1

##density 
BWM_CVML = 0
BWM_CVLS = 1
BWM_CVML_NP= 2

##regression
BWM_CVAIC = 0

REGTYPE_LC = 0
REGTYPE_LL = 1

##conditional density/distribution
CBWM_CVML = 0
CBWM_CVLS = 1
CBWM_NPLS = 2
CBWM_CCDF = 3 # Added 7/2/2010 jracine

##integral operators on kernels
OP_NORMAL      = 0
OP_CONVOLUTION = 1
OP_DERIVATIVE  = 2
OP_INTEGRAL    = 3


## useful numerical constants of kernel integrals
int.kernels <- c(0.28209479177387814348, 0.47603496111841936711, 0.62396943688265038571, 0.74785078617543927990,
                 0.26832815729997476357, 0.55901699437494742410, 0.84658823667359826246, 1.1329342579014329689,
                 0.5)
