# phyto

### Version: 1.2.0

## Function for calculate phytosociological table

### Usage:

`phyto(x, filter = NULL, area = NULL, criteria = NULL, measure = NULL, incDead = TRUE, nmDead = "Dead", diversity = TRUE, evenness = TRUE)`

* `x`: Data frame with the follow data: plot, family, specie, diameter or
  circumference and (optionally) height. It must be in this order, but not
  necessarily with this names. See 'Details' for measure units.

* `filter`: Character value informing witch filter to use: "plot", "family",
  "genus", "specie".

* `area`: Numeric value informing total area of sampling. Usually informed as
  hectare. See 'Details'.

* `criteria`: Numeric value informing including criteria to diameter. Diameters
  values above or equal `criteria` will be included in calculation.

* `measure`: Character value informing which measure was used: "d" = diameter;
  "c" = circumference. If you inform circumference, your data will be converted
  to diameter.

* `incDead`: TRUE/FALSE value to inform if include or not dead individual to
  table.

* `nmDead`: Characters informing identification of dead individual in data.

* `diversity`: TRUE/FALSE value to inform if calculate Shannon and Simpson
  diversity index.

* `evenness`: TRUE/FALSE value to inform if calculate E<sub>var</sub> and
  E<sub>1/D</sub> evenness index.


**Details:** Diameter or circumference values must be in centimetres. This
  values will be converted to meters for usual measure of basal area
  (m<sup>2</sup>) and dominance (m<sup>2</sup>/area unit). Usually, area is
  informed as hectare and height as meters. But, except for diameter, the output
  of parameters will be in the unit informed in data. The function do not
  convert area unit to usually used unit (hectare). Multiple diameters,
  circumferences or heights are allowed. This multiples values must be delimited
  by "+" character. For diameters or circumferences, function split multiple
  values and return diameter of total basal area for each individual. For
  multiples heights, function return mean and standard deviation height of each
  species. Although standard deviation is returned, it does not mean that height
  values has normal distribution. Then, this information maybe not make any
  sense. Shannon index variance is calculated as recommended by Hutcheson
  (1970). Simpson index and its variance is calculated as Simpson
  (1949). Evenness index E<sub>var</sub> and E<sub>1/D</sub> is calculated as
  described in Smith and Wilson (1996).


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

* `tBasalArea`: Total Basal Area in m<sup>2</sup>.

If filter by "family" , "genus" or "specie"

* `family`: Families names (if filter by family, genus or specie).

* `genus`: Genus names (if filter by genus).

* `specie`: Species names (if filter by specie).

* `nInd`: Number of individuals.

* `nGenera`: Number of genera (if filter by family).

* `nSpecies`: Number of species (if filter by family or genus).

* `tBasalArea`: Total Basal Area in m<sup>2</sup>.

* `AbsDens`: Absolute Density (individuals/area unit) estimate number of
  individuals of a group (family, genus or specie) per unit of area.

* `RelDens`: Relative Density (percentage) is the proportion of individual of a group (family, genus or specie) per total sampled individuals.

* `nPlot`: Number of occurrence plot.

* `AbsFreq`: Absolute Frequency (percentage) is a proportion of sampled units
  where a group (family, genus or specie) occur per total sampled units.

* `RelFreq`: Relative Frequency (percentage) is a proportion of absolute
  frequency of a group (family, genus or specie) per sum of absolute frequency.

* `AbsDom`: Absolute Dominance (m<sup>2</sup>/unit area) estimate occupied area
  of a group (basal area of family, genus or specie) per unit of area.

* `RelDom`: Relative Dominance (percentage) is the proportion of occupied area
  of a group (family, genus or specie) per total area occupied by all groups.

* `IVI`: Importance Value Index is the sum of the relative density, frequency,
  and dominance parameters.

* `CVI`: Cover Value Index is the sum of relative density and dominance
  parameters.

* `meanHeight`: Mean of heights in unit of data.

* `sdHeight`: Standard deviation of heights.


**Example:**
```
dt <- read.table('sample.csv', header=T, sep=";")

phyto(dt, filter = 'plot', area = 1, criteria = 1, measure = 'c', incDead = FALSE, nmDead = 'Dead')
```

