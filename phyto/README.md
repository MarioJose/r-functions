# phyto

## Function for calculate phytosociological table

### Usage:

`phyto(x, filter = NULL, area = NULL, criteria = NULL, measure = NULL, incDead = TRUE, nmDead = "Dead")`

* `x`: Data frame with the follow data: plot, family, specie, diameter or circumference, (height). Height data is optional. It must be in this order, but not necessarily with this names.

* `filter`: Numeric value informing witch filter to use: "plot", "family", "genus", "specie". 

* `area`: Numeric value informing total area of sampling.

* `criteria`: Numeric value informing including criteria to diameter. Diameters values above or equal `criteria` will be included in calculation.

* `measure`: Character value informing which measure was used: "d" = diameter; "c" = circumference. If you inform circumference, your data will be converted to diameter.

* `incDead`: TRUE/FALSE value to inform if include or not dead individual to table.

* `nmDead`: Characters informing identification of dead individual in data.

**Details:** Diameter must be in centimetres. Diameters will be converted to meters for usual measure of basal area (m<sup>2</sup>) and dominance (m<sup>2</sup>/ha). Usually, area is informed as hectare and height as meters. But, except for diameter, the output of parameters will be in the unit informed in data. Multiple diameters, circumferences or heights are allowed. Values must be delimited by "+" character. For diameters or circumferences, function split multiple values and return diameter of total basal area for each individual. For multiples heights, function return mean height of each individual.

**Values:** Data frame with follow columns:

If filter by "plot":

* `plot`: Plot number.

* `nInd`: Number of individuals.

* `nFamilies`: Number of families.

* `nGenera`: Number of genera.

* `nSpecies`: Number of species.

If filter by "family" , "genus" or "specie"

* `family`: Families names (if filter by family, genus or specie).

* `genus`: Genus names (if filter by genus).

* `specie`: Species names (if filter by specie).

* `nInd`: Number of individuals.

* `nGenera`: Number of genera (if filter by family).

* `nSpecies`: Number of species (if filter by family or genus).

* `AbsDens`: Absolute Density.

* `RelDens`: Relative Density (percentage).

* `nPlot`: Number of plot occurrence.

* `AbsFreq`: Absolute Frequency.

* `RelFreq`: Relative Frequency (percentage).

* `tBasalArea`: Total Basal Area.

* `AbsDom`: Absolute Dominance.

* `RelDom`: Relative Dominance (percentage).

* `IVI`: Importance Value Index.

* `CVI`: Cover Value Index.
