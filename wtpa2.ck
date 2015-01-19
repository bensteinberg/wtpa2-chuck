public class WTPA2
{
  MidiOut mout;
  MidiMsg msg;

  // you must run this first
  fun int init(int device) {
    if (!mout.open(device)) {
      <<< "error: couldn't open MIDI device", device >>>;
      return 1;
    }
    return 0;
  }

  // utility functions
  fun void _MIDIcc(int channel, int val1, int val2) {
    channel + 176 => msg.data1;
    val1 => msg.data2;
    val2 => msg.data3;
    mout.send(msg);
  }

  fun int _constrainValue(int val, int min, int max) {
    if (val < min) return min;
    if (val > max) return max;
    return val;
  }

  fun int _checkBank (int bank) {
    return _constrainValue(bank, 0, 2);
  }

  fun void _genericStart(int bank, int cc) {
    _checkBank(bank) => bank;
    _MIDIcc(bank, cc, 1);
  }

  fun void _genericStop(int bank, int cc) {
    _checkBank(bank) => bank;
    _MIDIcc(bank, cc, 0);
  }
  
  fun void _genericSet(int bank, int cc, int val, int min, int max) {
    _checkBank(bank) => bank;
    _constrainValue(val, min, max) => val;
    _MIDIcc(bank, cc, val);
  }

  // note functions
  // velocity not yet implemented in WTPA2
  fun void _MIDInote(int onoff, int bank, int note, int velocity)
  {
    _checkBank(bank) => bank;
    if (onoff == 0) 128 + bank => msg.data1;
    else            144 + bank => msg.data1;
    note => msg.data2;
    velocity => msg.data3;
    mout.send(msg);
  }
  
  fun void noteOn(int bank, int note) {
    _MIDInote(1, bank, note, 127);
  }

  fun void noteOff(int bank, int note) {
    _MIDInote(0, bank, note, 127);
  }
  
  // cc functions
  // Command or Effect:
  // Control Change #
  // Value:

  // Start/Stop Recording
  // 3
  // 0 = Stop, >0 = Start
  fun void startRecording(int bank) {
    3 => int cc;
    _genericStart(bank, cc);
  }

  fun void stopRecording(int bank) {
    3 => int cc;
    _genericStop(bank, cc);
  }

  // Start/Stop Overdub
  // 9
  // 0 = Stop, >0 = Start
  fun void startOverdub(int bank) {
    9 => int cc;
    _genericStart(bank, cc);
  }

  fun void stopOverdub(int bank) {
    9 => int cc;
    _genericStop(bank, cc);
  }

  // Start/Stop Realtime
  // 14
  // 0 = Stop, >0 = Start
  fun void startRealtime(int bank) {
    14 => int cc;
    _genericStart(bank, cc);
  }

  fun void stopRealtime(int bank) {
    14 => int cc;
    _genericStop(bank, cc);
  }

  // Loop Continuously/Once
  // 15
  // 0 = Once, >0 = Cont.
  fun void loopContinuously(int bank) {
    15 => int cc;
    _genericStart(bank, cc);
  }

  fun void loopOnce(int bank) {
    15 => int cc;
    _genericStop(bank, cc);
  }
  
  // Half Speed Playback
  // 16
  // 0 = Stop, >0 = Start
  fun void startHalfspeed(int bank) {
    16 => int cc;
    _genericStart(bank, cc);
  }
    
  fun void stopHalfspeed(int bank) {
    16 => int cc;
    _genericStop(bank, cc);
  }
    
  // Backwards Playback
  // 17
  // 0 = Stop, >0 = Start
  fun void startBackwards(int bank) {
    17 => int cc;
    _genericStart(bank, cc);
  }
  
  fun void stopBackwards(int bank) {
    17 => int cc;
    _genericStop(bank, cc);
  }
    
  // Cancel All Effects
  // 18
  // Any
  fun void cancelEffects(int bank) {
    18 => int cc;
    _genericStart(bank, cc);
  }

  // Bit Reduction
  // 19
  // 0-7
  fun void setBitDepth(int bank, int depth) {
    19 => int cc;
    _genericSet(bank, cc, depth, 0, 7);
  }

  // Granularize Sample
  // 20
  // 0-127
  fun void setGranularity(int bank, int granularity) {
    20 => int cc;
    // is granularity 0-127 or 0-256? 255?
    _genericSet(bank, cc, granularity, 0, 127);
  }

  fun void unsetGranularity(int bank) {
    setGranularity(bank, 0);
  }

  // Introduce Jitter Errors
  // 21
  // 0-127
  fun void introduceJitter(int bank, int jitter) {
    21 => int cc;
    _genericSet(bank, cc, jitter, 0, 127);
  }

  // Change Output Combination Math
  // 22
  // 0-3
  // 0 = Sum the banks during output. This makes normal audio.
  // 1 = Multiply the two banks together for output. Modulates and saturates,
  // and requires two samples to be playing back (ie, multiplying by 0 is
  // always silence).
  // 2 = Bitwise AND banks during output. Crusty. Requires valid samples in A&B.
  // 3 = Bitwise XOR the banks. Doesn't sound weird with only one sample, sounds
  // crusty with two.
  // 4 = Subtract Bank 1 from Bank 0. Sounds weird with phasey sounds, otheriwse
  // is not that strange.
  
  fun void setOutputMode(int bank, int mode) {
    22 => int cc;
    _genericSet(bank, cc, mode, 0, 3);
  }

  // Store Default Record Note
  // 23
  // Any
  fun void storeDefaultRecordNote(int bank, int note) {
    23 => int cc;
    // can note really be anything?
    _genericSet(bank, cc, note, 0, 127);
  }

  // Adjust Sample Start RESOLUTE
  // 24
  // 0-127
  fun void setSampleStart(int bank, int start) {
    24 => int cc;
    _genericSet(bank, cc, start, 0, 127);
  }

  // Adjust Sample End RESOLUTE
  // 25
  // 0-127
  fun void setSampleEnd(int bank, int end) {
    25 => int cc;
    _genericSet(bank, cc, end, 0, 127);
  }

  // Adjust Sample Window RESOLUTE
  // 26
  // 0-127
  fun void setSampleWindow(int bank, int window) {
    26 => int cc;
    _genericSet(bank, cc, window, 0, 127);
  }

  // Revert Sample to Unadjusted
  // 27
  // 0-127
  fun void unsetSample(int bank) {
    27 => int cc;
    // why 0-127?
    _genericStop(bank, cc);
  }

  // Adjust Sample Start WIDE
  // 28
  // 0-127
  fun void setSampleStartWide(int bank, int start) {
    28 => int cc;
    _genericSet(bank, cc, start, 0, 127);
  }

  // Adjust Sample End WIDE
  // 29
  // 0-127
  fun void setSampleEndWide(int bank, int end) {
    29 => int cc;
    _genericSet(bank, cc, end, 0, 127);
  }

  // Adjust Sample Window WIDE
  // 30
  // 0-127
  fun void setSampleWindowWide(int bank, int window) {
    30 => int cc;
    _genericSet(bank, cc, window, 0, 127);
  }

  // Change SD Card Bank
  // 52
  // 0-3
  fun void setSDCardBank(int sdbank) {
    52 => int cc;
    _constrainValue(sdbank, 0, 3) => sdbank;
    _MIDIcc(0, cc, sdbank); // ????
  }
}
