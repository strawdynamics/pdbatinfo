# pdbatinfo

A simple Lua app for Playdate that displays the current battery charging state, voltage, and estimated % remaining (state of charge) using Panic-provided APIs. It also includes some general information about lithium-ion batteries, and information on why the Playdate's battery indicator isn't as accurate as, say, a smartphone's.

This app is not affiliated with or endorsed by Panic. Code and text are public domain (CC0). Nico fonts copyright [emhuo](https://emhuo.itch.io/), licensed under OFL.

## Building

``` bash
pdc source pdbatinfo.pdx && open pdbatinfo.pdx
```
