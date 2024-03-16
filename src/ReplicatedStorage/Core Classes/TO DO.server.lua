--[[

-- || CHARACTER CLASS ||
[X] - Move the humanoid state functions into it's own module (3/3/24)
[X] - Move the variable functions into it's own module (3/3/24)
[X] - Implement the roll & backstep (3/6/24)
[] - Update variables like health on the server
[X] - Add in Mito's desired features (see Discord)
[X] - Allow for the stamina regen speed to be changed (3/8/24)

-- || PLAYER CLASS ||
[] - Upgrade the input system
[X] - Create the player effect system (3/5/24)
[] - Allow for the enabling and disabling of player controls
[X] - Create a variable function module  (3/5/24)
[] - Implement the new camera system


_________________________________________


All model related actions (such as equipping a weapon or armor) will be handled by the server
Remote or bindable functions are to be used

Damage calculation is also to be used on the server

Any core variables are to be updated on the server

_________________________________________

-- || DEVLOG ||

[3/8/24]

Made some good progress. Nothing flashy, but I finally allowed the character's stamina regen rate to be changed on the fly. Ran into a bug with the 
effect system, pretty sure I fixed it but further testing is needed. I know this has nothing to do with this game but I'm super happy to see 
RoSouls 3 gaining traction, we're averaging 15-20 people at a time!

[3/6/24]

A decent day today. Got a good chunk of bugs fixed, as well as a few new features added in. I'm not sure what I'm going to do with the camera system,
because quite frankly I think the one I've been provided with sucks (my dearest apologies to whoever made it. Not my rodeo, I know, but I'd rather use 
an in house solution that I actually understand rather than whatever that is. But that remains an issue for another day.

[3/5/24]

Today has been a rather productive day. I spend a good chunk of time on my other game (RoSouls III), but I got some good work done.
First and foremost, I've created a new Player class that will inherit from the character class. As you can probably guess, this'll be used for
all character related functions (things like camera manipulation, player input, etc). One of my least favorite things about my current setup in
RoSouls is that I have very little control over limiting what the player can and cannot do, an error I'm not going to make twice.

I did some more work on the rolling system, and I can't say I'm all too happy with how it's turning out. I can't tell if it's the animation or code,
but seeing as I'm using almost the exact same code as I did in RoSouls, I'm betting on the animation being off. I'll be working on tweaking the velocity
and animation speed and see how it turns out. 

I've taken some time to think about how I'm going to accomplish replecating variables and actions to the server. I think my best course of action
is to create a script (likely inside Server Script Service) that will essentially be a 'hub' for all character (and by proxy player) instances. Upon creation
of a new character instance, I'll have an event (or remote event if on a client) sent to the afformentioned script containing a table of events (or remote
events) that can be called upon to spur a reaction from said character. A good usecase of this system would be character damage. By having a localized list
of all current characters, I can easily not on deal damage, but incur animated reactions, such as staggering upon being hit. Mind you, I have yet to 
implement any of this, so my plans may change over time.

Overall, I am extremely happy with how this is turning out. A lot of the mistakes I've made with previous character handlers have been rectified,
and a lot of new features have been added.

]]