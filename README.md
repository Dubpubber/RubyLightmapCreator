# RubyLightmapCreator
From the description: Ruby Lightmap creator is a program that ingeniously manufactures custom “lightmaps”. Through color, RLMC can generate any sized and colored lightmap which can then be interpreted and visualized at

# Usage
Using RLMC is a relatively simple and easy to grasp as the program is a simple generation -> output condenser. Generationcommands can be entered in any particular order so as long as it starts with: "lm g".

Generation commands run down:
<p>Color variation is the amount of colors that will be generated from the spectrum around the given color.</p>
 ```Color Variation [variation || v]: number(2-250)```
<p>Width is the size of the output to be generated on the x-axis.</p> 
 ```Width           [width     || w]: number(250-1000)```
<p>Height is the size of the output to be generated on the y-axis.</p>
 ```Height          [height    || h]: number(250-1000)```
<p>Color that will act as the starting point. # currently required.</p> 
 ```Color           [color     || c]: color hex```

## Commands
```
# Default case generation.
lm g
```
```
# Color variation 
lm g v 10
```
```
# Color variation and width+height set
lm g v 10 w 524 h 591
```
```
# Color variation, width+height set and color starting point
lm g v 10 w 524 h 591 c #FFFFFF
```
