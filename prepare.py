import sys
import subprocess

subprocess.check_call([sys.executable, '-m', 'pip3', 'install', 'torch', 'torchvision', 'torchaudio', '--extra-index-url', 'https://download.pytorch.org/whl/cu116'])