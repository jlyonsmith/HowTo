## General Usage

Get a list of ALSA audio devices:

```sh
aplay -l
```

The device name is given inside square brackets, e.g. `[bcm2835 headphones]` for the `bcm2835 headphones` device.


Play WAV audio:

```sh
aplay something.wav # To play on default device
aplay -D device something.wav # For a specific device
```

Bring up interactive audio mixer:

```sh
alsamixer
```

Playing MP3:

```sh
apt install mpg123
mpg123 something.mp3
```

## Configuration

