# phyto

## Function for calculate phytosociological table

### Usage:

phyto(x, filter = NULL, area = NULL, criteria = NULL, incDead = TRUE, nmDead = "Dead")

* x:	Data frame with the follow data: plot, family, specie, diameter, (height). Height data is optional. It must be in this order, but not necessarily with this names.

* filter:	Inform witch filter to use: 1 = plot; 2 = family; 3 = specie. 

* area:	Total area of sampling.

* criteria: Including criteria to diameter.

* incDead: Inform if include or not dead individual to table.

* nmDead: Identification of dead individual in data.

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
