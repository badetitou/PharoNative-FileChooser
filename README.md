# PharoNative-FileChooser

I connect Pharo with the native file chooser system of the OS

> NO OSX support for now. You can contribute :smile:

## Installation

```st
Metacello new
  githubUser: 'badetitou' project: 'PharoNative-FileChooser' commitish: 'main' path: 'src';
  baseline: 'NativeFileChooser';
  load
```

### Baseline

```st
spec baseline: 'NativeFileChooser' with: [
  spec repository:
    'github://badetitou/PharoNative-FileChooser:main/src' ]
```
