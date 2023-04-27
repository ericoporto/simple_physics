# simple_physics

box2d lite ported to ags script 

![](https://user-images.githubusercontent.com/2244442/234153243-03c043fe-654c-46d0-aadd-b3116c9de0d3.gif)

requires  AGS4 with managed pointers in managed structs support. Tests done with legacy ags compiler, probably works too with the new ags compiler.

I will probably delete/archive this in the future when I figure out improvements to make this more useful/performant and re-submit under a repository with a different name.

things I want to do, roughly in this order

- [ ] add circles 
- [ ] see what can be ported from the early commits of box2c (box2d v3)
- [ ] optimize performance
- [ ] rethink API

Additionally, I probably want to think about some game that can use this and also be able to explore the limitations - mostly in performance/number of entities.

One shape I really would like to pull from box2c are the rounded rectangles/capsules, which are very useful for player characters. In agsbox2d the Mouse Joint was particularly useful, so that joint would be interesting, but other joints are lower priority overall.

Unfortunately right now I have little time, so best I can do is release this here as is
