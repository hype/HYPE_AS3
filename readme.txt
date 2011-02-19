
the HYPE framework
-------------------------------------------------------------------------------



Installation & Setup
-------------------------------------------------------------------------------

You and HYPE have a play date in about 5 minutes! Let's make sure you're ready!

First, you have to have Flash Professional CS4 or later  installed on your 
computer. PC or Mac, it doesn't matter.

To install HYPE for use in a project you simply need to tell Flash to include
the "hype.swc" file. There are two ways to do this - globally or on a per-FLA
basis. You will probably want to just install it globally (don't worry, none
of the HYPE classes are included in a SWF unless you use them!)

To install the SWC globally you need to open the main application preferences
for Flash. Then select the "ActionScript" option on the left. Next click the
"ActionScript 3.0 Settings..." button. In the middle you will see a section
labeled "Library path:". Press the red and white button with the "f" on it and
browse to the "hype.swc" file. Now just click "Ok" and you're all set!

It's a very similar procedure if you want to just link the SWC to a particular
FLA. To do that open the publish settings of your FLA and select the Flash tab.
Then, in the middle of the panel select the "Library" tab. Finally, click the
red and white button with the "f" on it and browse to the "hype.swc" file.
Click "Ok" and you're all done!

If you ever run into a problem where Flash complains that it doesn't know
about some HYPE class, you usually just forgot to link in the "hype.swc" file.

Play Time!
-------------------------------------------------------------------------------

First thing's first, crack open Flash Pro and create a new ActionScript 3 FLA.
Now, go ahead and draw a circle (you can get all artsy and draw a rhombus or
something, but I'm going to keep calling it a circle so don't get confused!).
Now select your circle and open the Modify > Convert to Symbol... menu. Name
your symbol "Circle" and hit OK.

Next select your instance of Circle on the stage and give it an instance name
of "circle" (I generally capitalize symbol names and leave instance names lower
case - it helps to keep track of which is which!).

Now add a new layer to your timeline and name it actions - we'll be putting our
code here. Yes, I can hear you developers moaning. No, I don't care. We're
playing here, there are no rules except for one - have fun! If you want to
clean up the code and make it use a document class later - feel free!

Anyways, select that first frame in your actions layer and open the actions
panel. The first thing we need to do is to import the bits of HYPE we're going
to need. First up, we're going to need the MouseFollowSpring class - you can
import it by adding this line:

 import hype.extended.behavior.MouseFollowSpring;

Now we just need to make an instance of that behavior and attach it to our
circle. That's as easy as adding this next line:

 var b:MouseFollowSpring = new MouseFollowSpring(circle, 0.8, 0.1);

So what's going on here? Well, we're making a new instance of MouseFollowSpring
and assigning it to a variable named b. We're passing the constructor 3
arguments. The first says that we'll be making our circle instance follow the
mouse, the second says how much spring there will be to it's movement and the
third says how quickly the circle can move toward the mouse (0.1 means it can,
at most, move 10% of the way to the mouse on each step).

Now if you run your movie... nothing will happen! We have to start our behavior
for it to work! To do so add this line:

 b.start();

And then run your movie - the circle will now track the mouse!

What you see here is a behavior - a staple of HYPE. Behaviors make things do
stuff. Yes that is a horribly vague statement, but given the flexibility of
HYPE it is the most accurate definition! There are a bunch of behaviors
built-in with HYPE - play with them. All of them. Do it. Now is fine or when
you're done - but do it! HYPE is best learned through play!

Now, as for our example, back when Flash 3 came out this was some cutting edge
stuff... but 10 years later it is, to say the very least, passe. Let's make it
a bit more hip.



Blitting a Bitmap
-------------------------------------------------------------------------------

The BitmapCanvas class allows you to easily capture any other display object as
a bitmap. Let's add one to our movie and tell it to continuously draw (never
erase). To do this first add this to the top of your code:

 import hype.framework.display.BitmapCanvas;

Now, we have a slight problem with our code. BitmapCanvas needs to be able to
point to a display object to draw it. We could just point it at the stage, but
then it would draw everything on the stage, and we might not want that.
Instead, let's make a container for canvas to draw.

First, go ahead and remove the circle instance there on the stage. Then, open
the Circle symbol, click the Advanced button and select "Export for
ActionScript" and "Export in Frame 1". Then, give it a class name of Circle and
click OK.

Now, under the imports but above our mouse follow code add the following:

 var container:Sprite = new Sprite();
 var circle:MovieClip = new Circle();
 container.addChild(circle);
 addChild(container);

This code just makes a new container, then makes a new instance of circle,
stuffs it in the container, and displays the container.

Note that while we're adding the container to the stage, the only reason we
need to do that is because the MouseFollowSpring code uses the "stage" property
of it's target (our circle) - and that property doesn't exist if the target
isn't placed on the stage.

So far so good, but nothing new or sexy visually is happening. Let's fix that.
Add this code at the bottom:

 var canvas:BitmapCanvas = new BitmapCanvas(550, 400);
 canvas.startCapture(container, true);
 addChild(canvas);

This code creates a new BitmapCanvas instance, sets it's size to 550 x 400
(change it to whatever your stage size is!), tells the canvas to start
capturing and never to erase (that's the second argument), and finally adds
canvas to the stage.

Run your code and check it out! Still passe, but a bit more sexy. Now let's
really dial it up and blur it out over time!



Blurring the Lines (and the fills)
-------------------------------------------------------------------------------

A Rhythm is just code that is run over time. Like Behaviors that can be started
and stopped. The only non-simple rhythm that comes with HYPE v1.0 is the
FilterCanvasRhythm - which just runs a filter repeatedly on an instance of
BitmapCanvas, which is exactly what we need!

First add the import statement to the top of your code:

 import hype.extended.rhythm.FilterCanvasRhythm;

Then add the following to the bottom of your code:

 var blur:BlurFilter = new BlurFilter(5, 5, 3);
 var blurRhythm:FilterCanvasRhythm = new FilterCanvasRhythm([blur], canvas);
 blurRhythm.start();

This code makes a new BlurFilter (this is a built-in class). Then, it makes an
instance of FilterCanvasRhythm and tells it the only filter it will use is the 
blur filter instance and to use the BitmapData instance that's part of our 
canvas!

Finally, the code tells the rhythm to get started. Now run the code. Yes it's
still a mouse follower, and is thus lame, but at least it looks all cool and
blurry!

One last thing before you head off to play. Let's say you wanted that blur
filter to only run every 4th frame so that it blurred out less quickly. To do
this all you need to do is add this import at the top of your code:

 import hype.framework.core.TimeType;

And then change the line that starts the FilterRhythm instance from this:

 blurRhythm.start();

to this:

 blurRhythm.start(TimeType.ENTER_FRAME, 4);

This tells the rhythm that it must use ENTER_FRAME as it's timing mechanism
(which is the default) and to only run every 4th frame. Give the code a test
and you'll see it blurs out much more slowly.



The Beginning
-------------------------------------------------------------------------------

That's it. You're now playing with HYPE. Don't let me stop you! Fiddle around
with some of the numbers I used in the examples. Try adding another clip that
also follows the mouse. Have fun, and if you get stuck, check out the
"docs.html" file - it will launch the asdocs for HYPE. These are simple
explanations for all of the parts of HYPE, their syntax, and how they work.

If you have any questions about HYPE or want to just chat with fellow HYPE
users please join the official HYPE mailing list:

http://groups.google.com/group/hypeframework/

Now, get playing!

~ Love,

Branden Hall & Joshua Davis

@hypeframework
@waxpraxis
@joshuadavis


-------------------------------------------------------------------------------

Change Log
-------------------------------------------------------------------------------
1.1.9 / Enhancements / Updates / Bug Fixes :
    - added destroy method to ObjectPool (thanks nodename!)
    - split ICanvas into two interfaces, ICanvas and IEncodable
    - changed ICanvas so that startCapture can accept either a DisplayObject 
      or a Vector or Array of DisplayObjects
    - added colorTransform method to ICanvas
    - removed get/set target from ICanvas
    - updated encoder infrastructure to use IEncoder rather than ICanavs
    - added new BitmapCanvasCompositor class that can be used to combine 
      multiple BitmapCanvas instances with alpha compositing
    - added new scale parameter to BitmapCanvas so that content can be scaled 
      before it is captured
    - fixed issue on BitmapCanvas where clear wouldn't clear the large canvas
    - added colorTransform method to BitmapCanvas
    - changed PixelColorist so it supports either passing the constructor a 
      class that subclasses BitmapData or an instance of BitmapData
    - added getColorAt method to get the color at a specific x and y location
    - added automatic support for BitmapCanvasCompositor to ContextSaveImage
    - added destroyManager and destroy methods to RhythmManager 
      (thanks magicbruno!)
    - removed MXP package
    - combined hype_framework.swc and hype_extended.swc into hype.swc
    - now compiled with mxmlc 4.1.0

1.1.8 / Enhancements / Updates :
    - updated all FLA-based examples for increased clarity
    - added SimpleProximity behavior

1.1.7 / Enhancements / Updates :
    - modified 01_adjuster example
    - added 02_adjuster example
    - the Adjuster class now exposes activeClip property
    - modified PixelColorist to deal with multiple children in the target sprite
    - added DepthShuffle behavior
    - added examples 01_depthShuffle, 02_depthShuffle, 03_depthShuffle,
      04_depthShuffle, and 05_depthShuffle

1.1.6 / Bug fixes
    - fixed nasty bug in ObjectPool
    - added applyLayout to ILayout (thanks markstar!)

1.1.5 / Bug fixes / Enhancements / Updates :
    - fixed bugs in ObjectSet that were causing runtime errors

    - exposed all properties of behaviors so they could be changed at runtime
      (see Swarm behavior for example)

    - deprecated ContextSavePNG in favor of generalized ContextSaveImage

    - created hype-framework.swc and hype-extended.swc for use with either
      Flash CS4+ or FlexBuilder/FlashBuilder

    - added TGACanvasEncoder to output Targa (TGA) files
      Targa output size is only limited by user RAM, PNG is limited to approx.
      100,000 total pixels - at that point script timeout errors will occur

    - moved Flash-based examples into own folder, added some basic pure AS3
      examples (more coming in later releases)

    - fixed all outstanding issues on GitHub 
      (thanks sebleedelise and markstar!)

1.1.1 / Updates :
    - moved all examples that use ContextSavePNG to their own folder and added
      a new example

1.1.0 / Enhancements / Updates :
    - added ability for ObjectPool's constructor to accept either single
      classes or an array of classes that are randomly chosen from

    - added new CanvasFilterRhythm class that makes filtering instances of
      BitmapCanvas easier

    - created new ICanvas interface and two classes that implement it,
      SimpleCanvas and GridCanvas

    - modified BitmapCanvas to use new ICanvas classes and added new
      setupLargeCanvas(scale:int) method

    - added new CanvasPNGEncoder for creating PNGs from ICanvas classes

    - added new ContextSavePNG - a simple class to assist in encoding and
      saving large PNGs from BitmapCanvas instances

    - created two new BitmapCanvas examples, 06 and 07, to show new PNG
      encoding capabilities

1.0.2 / Bug fixes / Enhancements / Updates :

    - jDavis made tons of changes to almost every .fla to polish things like
      variable name consistency, removing addChild(clipContainer) if not
      needed, etc. website also reflects all updates.

    - added RandomTrigger.as to extended/trigger - used in SimpleBallistic
      examples 02 and 03

    - added PixelColorist.as to extended/color - used in Color
      examples 03, 04 and 05 - applies color to object in relation to a
      specific pixel color found on a linked image

    - added SimpleBallistic.as to extended/behavior - new examples added.

    - modified ExitShapeTrigger.as / constructor to support new enterOnceFlag
      argument. Defaults to false. If true the target MUST enter the shape at
      least once before the trigger will fire

    - modified Oscillator.as / Added new argument to constructor
      (linkOffset - links offset to frequency). The frequency is now modified
      through a property. Added new amplitude property. Added new offset
      property. Added new linkOffset property.

    - added new function clear to BitmapCanvas.as / which clears the canvas
      back to it's base color

    - new examples / BitmapCanvas, Color, SimpleBallistic, and Oscillator

    - fixed Setup Classpath.jsfl so it works properly for our PC friends

1.0.1 / Bug fixes / Updates :

    - Fixed memory leaks in Adjuster & HotKey - thanks to @SiRobertson

    - Fixed issue with SoundAnalyzer, frequency index 0 was always 0.
      Now it duplicates index 1 (seems to be bug in SoundMixer).
      Updated 03_soundAnalyzer and 04_soundAnalyzer.

    - Added 05_soundAnalyzer and 06_soundAnalyzer to demonstrate
      soundAnalyzer.getFrequencyRange

1.0.0 / Initial release


Credits
-------------------------------------------------------------------------------

HYPE was developed and is copyrighted by Branden Hall & Joshua Davis, 2009.
See license.txt for licensing information.

Joshua and Branden would sincerely like to thank their families for the support
and understanding during the development of HYPE and throughout their careers!

Mr. Doob's Stats is included courtesy of Mr. Doob.
(http://code.google.com/p/mrdoob/wiki/stats)

CanvasPNGEncoder is based on PNGEncoder from AS3CoreLib. See license.doc for
licensing information.

LOVE to bevin keley aka blevin blectum for letting us use two of her tracks,
"Retrice" and "Foyer Fire", from her Gular Flutter album, for our SoundAnalyzer
examples. (http://blevin.LSR1.com)


