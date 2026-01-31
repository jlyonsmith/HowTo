## Installation

Don't bother trying to get the Python scripts working.  Instead, use the `rhasspy/piper` compiled version:

```sh
mkdir piper
cd piper
wget https://github.com/rhasspy/piper/releases/download/v1.2.0/piper_arm64.tar.gz
tar -xvzf piper_arm64.tar.gz
wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/amy/medium/en_US-amy-medium.onnx
wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/amy/medium/en_US-amy-medium.onnx.json
echo 'Welcome to the world of speech synthesis!' | ./piper --model en_US-amy-medium.onnx --output file welcome.wav
```

## References

- [Reddit - Piper TTS working on Raspberry Pi](https://www.reddit.com/r/tts/comments/1cl14o6/has_anyone_gotten_piper_texttospeech_running_on_a)
- [Hugging Face - Piper Voices](https://huggingface.co/rhasspy/piper-voices)
- [`piper-rs`](https://github.com/thewh1teagle/piper-rs)
- [Piper Test Page](https://rhasspy.github.io/piper-samples/)
- [Piper TTS Main Repo](https://github.com/OHF-Voice/piper1-gpl)