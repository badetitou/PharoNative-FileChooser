# PharoNative-FileChooser

I connect Pharo with the native file chooser system of the OS

> Only windows supported for now

## Installation 

```st
Metacello new
  githubUser: 'badetitou' project: 'PharoNativeFileChooser' commitish: 'main' path: 'src';
  baseline: 'NativeFileChooser';
  load
```

