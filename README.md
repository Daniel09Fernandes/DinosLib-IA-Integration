Para rodar este projeto, é necessario algumas configurações: 
![image](https://github.com/user-attachments/assets/4407f9d4-d9b2-4a5e-bed9-560d8d118c47)

Conda: 
  https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html
- Anaconda Distribution

PyTorch 
  https://pytorch.org/get-started/previous-versions/

  Caso tenha placa de video compativel com cudas, de preferencia, devido ao desempenho.
# CUDA 11.8
conda install pytorch==2.3.1 torchvision==0.18.1 torchaudio==2.3.1 pytorch-cuda=11.8 -c pytorch -c nvidia
# CUDA 12.1
conda install pytorch==2.3.1 torchvision==0.18.1 torchaudio==2.3.1 pytorch-cuda=12.1 -c pytorch -c nvidia
# CPU Only
conda install pytorch==2.3.1 torchvision==0.18.1 torchaudio==2.3.1 cpuonly -c pytorch

Chocolaty
  https://chocolatey.org/install 
Run Get-ExecutionPolicy. If it returns Restricted, then run Set-ExecutionPolicy AllSigned or Set-ExecutionPolicy Bypass -Scope Process.

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))


ffmpeg
 instalar
  choco install ffmpeg

Whisper
  Para instalar:  pip install -U openai-whisper
  pip install --upgrade --no-deps --force-reinstall git+https://github.com/openai/whisper.git

Delphi OpenAI
 instalar: https://platform.openai.com/docs/libraries/community-libraries  

Gerar a APIKEY
 Adione a API_KEY gerada no slide anterior no fonts ‘Dinos.Bridge.GPT.Open.IA’ 
 ![image](https://github.com/user-attachments/assets/576d1419-8c5a-4589-8ad5-1bf544174bc6)

  

