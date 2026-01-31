## General Usage

Get a list of ALSA audio devices:

```sh
aplay -l
```

Look for the card number and device number, for example: 

```
card 1: USB [USB Audio], device 0: USB Audio [USB Audio]
...
```

Play WAV audio:

```sh
aplay something.wav # To play on default device
aplay -D hw:1,0 something.wav # To play to card 1, device 0
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

