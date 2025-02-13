# Reproduction

![Video](./Recordings/iPad13,8-iOS18.1.1-22B91-Annotated.mp4)

- Open `PiP.xcodeproj`
- Run the `PiP` target on an iPadOS 18 device
- Start playout by pressing the "Play/Pause" button
- Put the Player in "Picture in Picture" mode by pressing the button "TogglePiP"
- Pause the player by pressing the button inside the PiP window.
- Wait until the text on top changes from *"Seekrange: OK ✅"* into *"Broken seek ‼️"*. Usually this happens when the seekable range has no overlap with the loaded range and the seekable range starts after the end of the loaded range. Usually that happens after about 40s depending on the livestream.
- Try to resume the player by pressing the button inside the PiP window.

**Expected behaviour**

- The player resumes playback

**Actual behaviour**

- The player does not resume and the play pause button inside the PiP window is broken.