import sys
import os

from piano_transcription_inference import PianoTranscription, sample_rate, load_audio

# MIDI変換関数
def transcribe(audio_path, output_midi_path):
    # Load audio
    audio, _ = load_audio(audio_path, sr=sample_rate, mono=True)

    # transcriptor = PianoTranscription(device='cuda', checkpoint_path=None)
    transcriptor = PianoTranscription(device='cpu', checkpoint_path=None)
    
    # Transcribe and write out to MIDI file
    transcriptor.transcribe(audio, output_midi_path)

# コマンドライン引数(Youtube動画ID)
args = sys.argv
youtubeID = args[1]

# 作業ディレクトリ
os.chdir('/tmp/' + youtubeID)

# MIDI変換処理
transcribe('piano.mp3', youtubeID + '.mid')