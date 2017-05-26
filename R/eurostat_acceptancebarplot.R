library("eurostat");

saveAsylumEurostatRds <- function()
{
  for (eCode in search_eurostat("asylum")$code)
  {
    message(sprintf("saving %s", eCode));
    d <- get_eurostat(eCode, time_format="date");
    saveRDS(d, file=sprintf("%s.rds", eCode));
  }
}


loadAsylumEurostatRds <- function()
{
  l <- list();
  for (fname in dir(pattern=".*\\.rds"))
  {
    eCode <- substr(fname, 1, nchar(fname) - 4);
    l[[eCode]] <- readRDS(fname);
  }
  return(l);
}


getApplicationsByGeo <- function(asyApp, geoName)
{
  b <- asyApp$geo == geoName & asyApp$age == "Total" & !is.na(asyApp$citizen);
  citizenList <- unique(asyApp$citizen);
  n <- length(citizenList);
  d <- data.frame(citizen=citizenList, m=rep(0L, n), f=rep(0L, n), stringsAsFactors=FALSE);
  for (i in seq(along=citizenList))
  {
    bc <- b & asyApp$citizen == citizenList[i];
    d[i, "f"] <- sum(asyApp$values[bc & asyApp$sex == "Females"]);
    d[i, "m"] <- sum(asyApp$values[bc & asyApp$sex == "Males"]);
  }
  return(d);
}


getApplicationsByCitizen <- function(asyApp, citizenName)
{
  b <- asyApp$citizen == citizenName & asyApp$age == "Total" & !is.na(asyApp$geo) & !is.na(asyApp$citizen);
  geoList <- unique(asyApp$geo);
  n <- length(geoList);
  d <- data.frame(geo=geoList, f=rep(0L, n), m=rep(0L, n), stringsAsFactors=FALSE);
  for (i in seq(along=geoList))
  {
    bc <- b & asyApp$geo == geoList[i];
    d[i, "f"] <- sum(asyApp$values[bc & asyApp$sex == "Females"]);
    d[i, "m"] <- sum(asyApp$values[bc & asyApp$sex == "Males"]);
  }
  return(d);
}


barplotMf <- function(d)
{
  m <- t(as.matrix(d[, c("f", "m")]));
  barplot(m, beside=TRUE, names.arg=d[[1]], las=2);
}


decisionFrequencyTable <- function(asyAcc)
{
  l <- list(decision = character(), frequency=numeric());
  for (decision in unique(asyAcc$decision))
  {
    l$decision = c(l$decision, decision);
    l$frequency = c(l$frequency, sum(asyAcc$values[asyAcc$decision == decision]));
  }
  return(data.frame(l));
}


acceptanceMatrix <- function(asyAcc, citizen, year=NULL)
{
  if (any(is.na(asyAcc$geo)))
  {
    warning("NAs in geo");
    asyAcc <- asyAcc[!is.na(asyAcc$geo), ];
  }
  if (any(is.na(asyAcc$citizen)))
  {
    warning("NAs in citizen");
    asyAcc <- asyAcc[!is.na(asyAcc$citizen), ];
  }
  asyAcc <- asyAcc[asyAcc$age == "Total", ];
  geoList <- unique(asyAcc$geo);
  asyAcc <- asyAcc[asyAcc$citizen == citizen, ];
  if (!is.null(year))
  {
    asyAcc = asyAcc[format(asyAcc$time, "%Y") == year, ];
  }
  m <- matrix(NA, nrow=4, ncol=length(geoList));
  rownames(m) <- c("fAccepted", "fRejected", "mAccepted", "mRejected");
  colnames(m) <- geoList;
  bAcc <- asyAcc$decision == "Total positive decisions";
  bRej <- asyAcc$decision == "Rejected";
  bFem <- asyAcc$sex == "Females";
  bMal <- asyAcc$sex == "Males";
  # message(sprintf("%d rows acc, %d rows rej, %d rows f, %d rows m", sum(bAcc), sum(bRej), sum(bFem), sum(bMal)));
  for (i in seq(along=geoList))
  {
    bGeo <- asyAcc$geo == geoList[i];
    # message(sprintf("%d rows for geo %s", sum(bGeo), geoList[i]));
    m["fAccepted", i] <- sum(asyAcc$values[bGeo & bAcc & bFem]);
    m["fRejected", i] <- sum(asyAcc$values[bGeo & bRej & bFem]);
    m["mAccepted", i] <- sum(asyAcc$values[bGeo & bAcc & bMal]);
    m["mRejected", i] <- sum(asyAcc$values[bGeo & bRej & bMal]);
  }
  return(m[, order(colSums(m), decreasing=TRUE)]);
}


acceptanceRateMatrix <- function(asyAcc, citizen, year=NULL)
{
  rate <- function(nAccepted, nRejected)
  {
    nTotal <- nAccepted + nRejected;
    ## print(sprintf("accepted: %s", class(nAccepted)));
    ## print(nAccepted);
    ## print(sprintf("rejected: %s", class(nRejected)));
    ## print(nRejected);
    ## print(sprintf("total: %s", class(nTotal)));
    ## print(nTotal);
    r <- nAccepted / nTotal;
    r[nTotal == 0] <- NA;
    return(r);
  }
  
  m <- acceptanceMatrix(asyAcc, citizen, year);
  a <- matrix(NA, nrow=2, ncol=ncol(m));
  rownames(a) <- c("f", "m");
  colnames(a) <- colnames(m);
  a["f", ] <- rate(m["fAccepted", ], m["fRejected", ]);
  a["m", ] <- rate(m["mAccepted", ], m["mRejected", ]);
  return(a);
}



acceptanceBarplot <- function(asyAcc, citizen, year=NULL, ...)
{
  m <- acceptanceMatrix(asyAcc, citizen, year);
  colorList <- c("#ff0000", "#400000", "#0000ff", "#000040");
  if (is.null(year))
  {
    bpMain <- sprintf("%s, all", citizen);
  }
  else
  {
    bpMain <- sprintf("%s, %s", citizen, year);
  }
  barplot(m, col=colorList, las=2, main=bpMain, ...);
  legend("topright", rownames(m), fill=colorList);
  return(invisible(m));
}


acceptanceRateBarplot <- function(asyAcc, citizen, year=NULL, ...)
{
  a <- acceptanceRateMatrix(asyAcc, citizen, year);
  if (is.null(year))
  {
    bpMain <- sprintf("%s, all", citizen);
  }
  else
  {
    bpMain <- sprintf("%s, %s", citizen, year);
  }
  colorList=c("#ff0000", "#0000ff");
  barplot(a, beside=TRUE, col=colorList, las=2, main=bpMain, ...);
  legend("topright", rownames(a), fill=colorList);
  return(invisible(a));
}


acceptanceDualBarplot <- function(asyAcc, citizen, year=NULL, ...)
{
  l <- list();
  opar <- par(no.readonly=TRUE);
  par(mfrow=c(2, 1));
  l$m <- acceptanceBarplot(asyAcc, citizen, year, ...);
  l$a <- acceptanceRateBarplot(asyAcc, citizen, year);
  par(opar);
  return(invisible(l));
}


