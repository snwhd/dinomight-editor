# Dino-Might Editor
https://dev.snwhd.com/dino


## pngtotmj

Convert the workshop map image to a map tmj file to be used
in dino-might editor. Useful for recovering lost map files, or altering
existing dinomight maps.

1. browse to the map in dinomight workshop
(e.g. https://foony.com/games/dinomight/workshop/7sW9lyd9GWC4nCAjAmrB)
1. right-click and "save image as" the map image
1. `./pngtotmj path/to/downloaded.png -o dinomight_map.tmj
1. open the new tmj file to dino-might editor

Optionally, provide `--convert` to match unexpected colors to their nearest
color in the valid palette. This can be used to generate maps from pixel art
like https://foony.com/games/dinomight/workshop/7gJCFGOspwPDzgV5rudF. However,
there is no guarantee that the producd map is valid. It may contain 0 spawn
points, players could be separated by walls, etc.


## attribution
Icons from Those Icons on Flat Icon: https://www.flaticon.com/authors/those-icons
