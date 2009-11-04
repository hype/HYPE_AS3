
the HYPE framework
-------------------------------------------------------------------------------



Installation & Setup
-------------------------------------------------------------------------------

You and HYPE have a play date in about 5 minutes! Let's make sure you're ready!

First, you have to have Flash Professional CS4 installed on your computer. PC
or Mac, it doesn't matter.

Now take a look at all of the other files that came long with this readme.

If you're crusty developer type, grab the "src" folder, look at the docs and
examples and get down with your bad self - I'll see you in a few paragraphs if
you still want to go through the tutorial, otherwise, have fun!

For folks who want a slightly easier route, go ahead and double click on the
"HYPE.mxp" file. Check out the window-o'-legalese and click "Accept". You've
now copied all of the source files that make up HYPE into your personal library
area that Flash sets up when it gets installed.

(If you get some kind of goofy error you probably have an older version of
Flash still installed on your computer. That's not a problem, just make sure
that you open the MXP file with "Adobe Extension Manager CS4".)

There's just one more step - you need to open the "Setup Classpaths.jsfl" file
with Flash CS4. You should be able to just double-click on it, but in case that
doesn't work just use the Commands > Run Command... menu inside of Flash to run
it. This just makes sure that Flash knows about where that MXP just stashed the
HYPE source code.



Play Time!
-------------------------------------------------------------------------------

First thing's first, crack open Flash CS4 and create a new ActionScript 3 FLA.
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
FilterRhythm - which just runs a filter repeatedly on an instance of
BitmapData, which is exactly what we need!

First add the import statement to the top of your code:

 import hype.extended.rhythm.FilterRhythm;

Then add the following to the bottom of your code:

 var blur:BlurFilter = new BlurFilter(5, 5, 3);
 var blurRhythm:FilterRhythm = new FilterRhythm([blur], canvas.bitmap.bitmapData);
 blurRhythm.start();

This code makes a new BlurFilter (this is a built-in class). Then, it makes an
instance of FilterRhythm and tells it the only filter it will use is the blur
filter instance and to use the BitmapData instance that's part of our canvas!

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

Get playing!

~ Love,

Branden Hall & Joshua Davis



-------------------------------------------------------------------------------

Change Log
-------------------------------------------------------------------------------

1.0.0 / Initial release
1.0.1 / Bug fixes:
        - Fixed memory leaks in Adjuster & HotKey - thanks to @SiRobertson
	- Fixed issue with SoundAnalyzer, frequency index 0 was  always 0.
          Now it duplicates index 1 (seems to be bug in SoundMixer)


Credits
-------------------------------------------------------------------------------

HYPE was developed and is copyrighted by Branden Hall & Joshua Davis, 2009.
See license.txt for licensing information.

Joshua and Branden would sincerely like to thank their families for the support
and understanding during the development of HYPE and throughout their careers!

Mr. Doob's Stats is included courtesy of Mr. Doob.
(http://code.google.com/p/mrdoob/wiki/stats)

LOVE to bevin keley aka blevin blectum for letting us use two of her tracks,
"Retrice" and "Foyer Fire", from her Gular Flutter album, for our SoundAnalyzer
examples. (http://blevin.LSR1.com)


