# Experiment: Thumbnails in ranger.

This is just an experiment. It might work, but it's not intended to be final or generally usable. 

The issue is tracked here:
https://github.com/ranger/ranger/issues/2224

It only works with kitty (or the kitty protocol, to be more precise).
To try it out you have to use kitty and turn on the settings:
```
set preview_images_method kitty
set show_thumbnails True
```

Add this to rc.conf to toggle between the modes:
```
map zt set show_thumbnails!
```

Thumbnails are created with the script `ranger/data/thumbnails.sh` (similar to scope.sh).
It uses convert, so imagemagick has to be installed.
At the moment the path to the script is hard coded.

The thumbnails are saved in the default ranger cachedir (generally this is `~/.cache/ranger/thumbnails`).
The dir should be created automatically.
Thumbnails are never deleted.

The thumbnail size is hard coded. And, currently, thumbnails are not remade when you change the size. 
Although they should be updated if the source file changes.

The thumbnails are drawn with kitty directly (no tempfiles or data transmission).
So once those files have been created the drawing is more or less immediate.

--- 
Todo/Tests:
- [x] Thumbnails in main column, preview column, and multipane.
- [x] update when toggling show_thumbnail
- [x] refresh the browser when loader has finished creating a new thumbnail
    - handled with browser.request_redraw()
- [x] changing tabs
- [x] changing viewmode and changing multipane columns:
    - handled with destroy
- [x] collapsing
    - handled in viewmiller.poke()
- [x] switching to pager/taskview
    - handled by browser.clear_all_images(), called in ui.open_pager/open_taskview.
- [x] drawing borders
    - handled with binding to setopt 
    - I think this works
- [ ] switching to other image display method should just work.
    - [ ] (tested and looks okay, but not sure)
- [ ] correction for scrollbegin
    - [x] scrolling works correctly
    - [x] go to HOME and END works correctly.
    - [x] select_file seems to work
    - [ ] page size is wrong, so jumping by a full or half page uses the browser.hei. Can be fixed by calling a new function browser.get_pagesize() instead of using browser.hei.
- [x] correction for mouse click position
- [x] changing thumbnail source (does the thumbnail image get updated when the source image changes?)
    - handled like previews, in actions.update_preview()
    - I think this works
- [ ] resizing window
    - [x] position is correct 
    - [x] don't draw thumbs if window is too small. 
    - [ ] problem: thumbs are not being redrawn immediately after resize, but only after input.
- [ ] changing thumbnail size (size is currently hardcoded)
- [ ] Bug: when changing viewmode, the tabs (in titlebar) are not drawn.
    - Probably related to redrawwin and refesh when calling ui.redraw_window, in ui._set_viewmode
    - I changed this. And it looks okay. I hope this doesn't break other things.
    - Dealing with those redrawwin and refreshes all over the place is difficult.
    - Are they even required. There should be only one refresh per redraw.
- [ ] update thumbnail dict when files on disk are no longer there?
- [ ] TODOs in code
- [ ] I changed some stuff in the Kitty displayer. Does this still work like before?
    - it looks okay, but needs more testing.
- [x] thumbnail script
- [ ] ... other ...

Problems:
- hintmenu: I can't draw the popup menus in front of the image. Or: I can't draw the image "behind" the background color of the hintmenu. But at least it can be drawn behind the text.
