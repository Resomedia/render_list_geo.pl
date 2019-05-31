# render_list_geo.pl
Perl script for automatic rendering OSM tiles for renderd+mod_tile with using geographic coordinates (WGS-84)

### Usage:
```perl
./render_list_geo.pl -n <n> -F <F>
```
```
where:
<n> - number of concurrent threads
<l> - maximum load
<m> - render tiles from this map
<F> - config file
```
### Config:
```yaml
zone_name:
    x: render tiles from this longitude
    X: render tiles to this longitude
    y: render tiles from this latitude
    Y: render tiles to this latitude
    z: render tiles from this zoom level
    Z: render tiles to this zoom level
```
### Samples:
```bash
#Ukraine
./render_list_geo.pl -n 2 -m map_name -F config.yml
#Belgium (using three threads)
./render_list_geo.pl -n 3 -F config.yml
#The Netherlands
./render_list_geo.pl -n 2 -m default -F config.yml
#Belgium (using 25 threads and a maximum load of 40)
./render_list_geo.pl -n 25 -l 40 -F config.yml
```
