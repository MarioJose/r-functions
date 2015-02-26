# estbiomass

## Function for above ground biomass (AGB) estimation using Chave et al. (2005) expression

### Usage:

`estbiomass(ro, h=NULL, dhb=NULL, chb=NULL, type=NULL)`

* `ro`:  Numeric value or numeric vector with wood density of individual specie.

* `h`: Numeric value or numeric vector with height, in meters, of individual.

* `dhb`: Numeric value or numeric vector with diameter at height breast, in centimetres, of individual.

* `chb`:  Numeric value or numeric vector with circumference at height breast, in centimetres, of individual.

* `type`: Character value informing with expression to use to estimate biomass: "dry", "moist", "mangrove" or "wet".

**Details:** Values of `ro`, `h`, `dhb` or `chb` may be a single value or a vector of values. If you inform a vector, all this parameters must be the same length. By default expression use dhb to estimate biomass, than if you inform chb, the function will transform chb to dhb. `type` must be one of the four options ("dry", "moist", "mangrove" or "wet"). To more information about this options see Chave et al. (2005).

**Values:** Numeric value or numeric vector with AGB estimation in kilogram.

**Reference:**

Chave, J. et al. 2005. Tree allometry and improved estimation of carbon stocks and balance in tropical forests. - Oecologia 145: 87–99.
