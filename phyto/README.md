# phyto

## Function for calculate phytosociological table

### Usage:

`phyto(x, filter = NULL, area = NULL, criteria = NULL, incDead = TRUE, nmDead = "Dead")`

* `x`:	Data frame with the follow data: plot, family, specie, diameter, (height). Height data is optional. It must be in this order, but not necessarily with this names.

* `filter`:	Numeric value informing witch filter to use: 1 = plot; 2 = family; 3 = specie. 

* `area`:	Numeric value informing total area of sampling.

* `criteria`: Numeric value informing including criteria to diameter.

* `incDead`: TRUE/FALSE value to inform if include or not dead individual to table.

* `nmDead`: Characteres informing identification of dead individual in data.

**Details:** Details: Diameter must be in centimetres. Diameters will be converted to meters for usual measure of basal area (m^2^) and dominance (m^2^/ha). Usually, area is informed as hectare and height as meters. But, except for diameter, the output of parameters will be of unit used informed in data.

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
