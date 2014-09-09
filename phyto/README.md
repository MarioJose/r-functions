# phyto

## Function for calculate phytosociological table

### Usage:

`phyto(x, filter = NULL, area = NULL, criteria = NULL, measure = NULL, incDead = TRUE, nmDead = "Dead")`

* `x`:	Data frame with the follow data: plot, family, specie, diameter or circumference, (height). Height data is optional. It must be in this order, but not necessarily with this names.

* `filter`:	Numeric value informing witch filter to use: 1 = plot; 2 = family; 3 = specie. 

* `area`:	Numeric value informing total area of sampling.

* `criteria`: Numeric value informing including criteria to diameter: 1 = plot; 2 = family; 3 = specie"

* `measure`: Character value informing which measure was used: "d" = diameter; "c" = circumference.

* `incDead`: TRUE/FALSE value to inform if include or not dead individual to table.

* `nmDead`: Characters informing identification of dead individual in data.

**Details:** Details: Diameter must be in centimetres. Diameters will be converted to meters for usual measure of basal area (m^2^) and dominance (m^2^/ha). Usually, area is informed as hectare and height as meters. But, except for diameter, the output of parameters will be in the unit informed in data.

**Values: ** Data frame with follow columns:

If filter by "plot":

* `plot`: Plot number.

* `nInd`: Number of individuals.

* `nFamilies`: Number of families.

* `nSpecies`: Number of species.

If filter by "family" or "specie"

* `family`: Families names (if filter by family).

* `specie`: Species names (if filter by specie).

* `nInd`: Number of individuals.

* `AbsDens`: Absolute Density.

* `RelDens`: Relative Density (percentage).

* `nPlot`: Number of plot ocurrence.

* `AbsFreq`: Absolute Frequency.

* `RelFreq`: Relative Frequency (percentage).

* `tBasalArea`: Total Basal Area.

* `AbsDom`: Absolute Dominance.

* `RelDom`: Relative Dominance (percentage).

* `IVI`: Importance Value Index.

* `CVI`: Cover Value Index.

### Licence

Copyright (c) 2014 Mario José Marques-Azevedo

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
