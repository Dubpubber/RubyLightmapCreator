# Project Purpose
The purpose of the Ruby Lightmap creator was to use color to generate random lightmaps. A colleague of mine suggested that it would interesting to how a level or world for a video game could be generated via a “lightmap of colors.” For example, and the projects current usage; the resulting lightmap could be used to populate ores for a 2D mining game. Each color representing a different ore the player could mine.
# Project Usage
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
# Visualizing the LightMap
I wrote a nifty little tool for converting this programs output to a visualized lightmap in your browser! Find that here: <a href="https://loneboat.com/tools/rlmcdecorder.php">RLMC Decoder</a>
# Project Author
My name is Tyler Crowe, I'm currently a Computer Science student at the University of North Carolina at Charlotte. I try to put aside time every week specifically for creating to further grow my skills. I’ve been programming for about 8 years now and have no plans on stopping now! If you’re more interested in me or my work, visit [my website](https://loneboat.com/).
# Project License
Like most of my projects, this project is sourced under [The MIT License](https://opensource.org/licenses/MIT). (Basically, it's as much yours, reader, as it is mine.)
