# Showoff TextMate bundle #

The TextMate bundle to create and preview [Showoff](http://github.com/schacon/showoff) presentation files.

## Vaguely Related Flickr Image ##

[Showing Off](http://farm4.static.flickr.com/3152/3033004415_fc593a0819_m.jpg)

## Installation ##

To install via Git:

    mkdir -p ~/Library/Application\ Support/TextMate/Bundles
    cd ~/Library/Application\ Support/TextMate/Bundles
    git clone git://github.com/drnic/Showoff.tmbundle.git
    osascript -e 'tell app "TextMate" to reload bundles'

Source can be viewed or forked via GitHub: [http://github.com/drnic/Showoff.tmbundle](http://github.com/drnic/Showoff.tmbundle)

## Commands ##

**New Slide** - `slide` tab completion

    !SLIDE bullets
    # Title #
    
After activating, to get different slide types:

* `b` - bullets
* `c` - commandline
* `co` - code
* `ce` - center
* `f` - full-page
* `s` - smbullets

**New Slide from Header** - `Shift+Enter` key binding

This works the same as **New Slide**, except it will consume the selected text or current word near the carat and put it in the new slide's header.

From:

    This is my slide title

To:

    !SLIDE bullets
    # This is my slide title #

Like **New Slide** you can change the slide type with its initial letters.

**Preview Slides** - `Cmd+R` key binding

Want to see what the current document's slides will look like? "Run" them.

After running the first time, maximise the TextMate HTML window to see your slides in largest window.

