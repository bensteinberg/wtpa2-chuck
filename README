wtpa2-chuck
===========

This is a ChucK class for speaking MIDI to a WTPA2 (http://blog.narrat1ve.com/wtpa2/).  Add it in initialize.ck, for example, like this:

```
Machine.add("/path/to/wtpa2-chuck/wtpa2.ck");
Machine.add("/path/to/score.ck");
```

Figure out the number of your MIDI device (here, zero) with miniAudicle or "chuck --probe", then create and initialize the object in score.ck:

```
WTPA2 wtpa2;

if (wtpa2.init(0) != 0) {
  me.exit();
}
```

Finally, do stuff:

```
wtpa2.noteOn(0, 73);
0.2::second => now;
wtpa2.startHalfSpeed(0);
0.2::second => now;
wtpa2.stopHalfSpeed(0);
0.2::second => now;
wtpa2.noteOff(0, 73);
```

See the code for the list of available functions; it should be self-explanatory.