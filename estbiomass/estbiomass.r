# Above Ground Biomass estimation
#
# Estimate above ground biomass following Chave et al. (2005)
#
# Chave, J. et al. 2005. Tree allometry and improved estimation of carbon 
#   stocks and balance in tropical forests. - Oecologia 145: 87–99.
#

estbiomass <- function(ro, h=NULL, dhb=NULL, chb=NULL, type=NULL){

  if (is.null(chb) & is.null(dhb)) { stop("chb or dhb must be defined\n") }
  if (!is.null(chb) & is.null(dhb)) { dhb <- chb/pi }
  if (missing(ro)) { stop("ro must be defined\n") }
  if (!(type %in% c("dry","moist","mangrove","wet"))){
    stop("type must be defined as: 'dry', 'moist', 'mangrove' or 'wet'\n")
  }
  
  if (!is.null(h)){
    out <- switch(type,
                  dry =  exp(-2.187 + 0.916 * log(ro * (dhb^2) * h)),
                  moist = exp(-2.977 + log(ro * (dhb^2) * h)),
                  mangrove = exp(-2.977 + log(ro * (dhb ^ 2) * h)),
                  wet = exp(-2.557 + 0.940 * log(ro * (dhb^2) * h)))
  } else {
    out <- switch(type,
                  dry =  (ro * exp(-0.667 + (1.784 * log(dhb)) + (0.207 * (log(dhb) ^ 2)) - (0.0281 * (log(dhb) ^ 3)))),
                  moist = (ro * exp(-1.449 + (2.148 * log(dhb)) + (0.207 * (log(dhb) ^ 2)) - (0.0281 * (log(dhb) ^ 3)))),
                  mangrove = (ro * exp(-1.349 + (1.980 * log(dhb)) + (0.207 * (log(dhb) ^ 2)) - (0.0281 * (log(dhb) ^ 3)))),
                  wet = (ro * exp(-1.239 + (1.980 * log(dhb)) + (0.207 * (log(dhb) ^ 2)) - (0.0281 * (log(dhb) ^ 3)))))
  }
  
  return(out)
}
