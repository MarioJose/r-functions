# phyto

### Version: 1.2.0

## Function for calculate phytosociological table

### Usage:

`phyto(x, filter = NULL, area = NULL, criteria = NULL, measure = NULL, incDead = TRUE, nmDead = "Dead", diversity = TRUE, evenness = TRUE)`

* `x`: Data frame with the follow data: plot, family, specie, diameter or circumference, (height). Height data is optional. It must be in this order, but not necessarily with this names.

* `filter`: Numeric value informing witch filter to use: "plot", "family", "genus", "specie". 

* `area`: Numeric value informing total area of sampling.

* `criteria`: Numeric value informing including criteria to diameter. Diameters values above or equal `criteria` will be included in calculation.

* `measure`: Character value informing which measure was used: "d" = diameter; "c" = circumference. If you inform circumference, your data will be converted to diameter.

* `incDead`: TRUE/FALSE value to inform if include or not dead individual to table.

* `nmDead`: Characters informing identification of dead individual in data.

* `diversity`: TRUE/FALSE value to inform if calculate Shannon and Simpson diversity index.

* `evenness`: TRUE/FALSE value to inform if calculate E<sub>var</sub> and E<sub>1/D</sub> evenness index.

**Details:** Diameter must be in centimetres. Diameters will be converted to meters for usual measure of basal area (m<sup>2</sup>) and dominance (m<sup>2</sup>/ha). Usually, area is informed as hectare and height as meters. But, except for diameter, the output of parameters will be in the unit informed in data. Multiple diameters, circumferences or heights are allowed. Values must be delimited by "+" character. For diameters or circumferences, function split multiple values and return diameter of total basal area for each individual. For multiples heights, function return mean height of each individual. Shannon index variance is calculated as recommended by Hutcheson (1970). Simpson index and its variance is calculated as Simpson (1949). Evenness index E<sub>var</sub> and E<sub>1/D</sub> is calculated as described in Smith and Wilson (1996).

**References:**

Hutcheson, K. 1970. A test for comparing diversities based on the shannon formula. J. Theor. Biol. 29: 151-154.

Simpson, E. H. 1949. Measurement of diversity. Nature 163: 688-688.

Smith, B. and Wilson, J. B. 1996. A consumer's guide to evenness indices. Oikos 76: 70-82.

**Values:** Data frame with follow columns:

If filter by "plot":

* `plot`: Plot number.

* `nInd`: Number of individuals.

* `nFamilies`: Number of families.

* `nGenera`: Number of genera.

* `nSpecies`: Number of species.

* `H` and `varH`: Shannon index and its variance.

* `D` and `varD`: Simpson index and its variance.

* `Evar` and `E1D`: E<sub>var</sub> and E<sub>1/D</sub> evennedd index.

* `tBasalArea`: Total Basal Area.

If filter by "family" , "genus" or "specie"

* `family`: Families names (if filter by family, genus or specie).

* `genus`: Genus names (if filter by genus).

* `specie`: Species names (if filter by specie).

* `nInd`: Number of individuals.

* `nGenera`: Number of genera (if filter by family).

* `nSpecies`: Number of species (if filter by family or genus).

* `tBasalArea`: Total Basal Area.

* `AbsDens`: Absolute Density.

* `RelDens`: Relative Density (percentage).

* `nPlot`: Number of plot occurrence.

* `AbsFreq`: Absolute Frequency.

* `RelFreq`: Relative Frequency (percentage).

* `AbsDom`: Absolute Dominance.

* `RelDom`: Relative Dominance (percentage).

* `IVI`: Importance Value Index.

* `CVI`: Cover Value Index.

**Example:**
```
dt <- read.table('sample.csv', header=T, sep=";")

phyto(dt, filter = 'plot', area = 1, criteria = 1, measure = 'c', incDead = FALSE, nmDead = 'Dead')
```
