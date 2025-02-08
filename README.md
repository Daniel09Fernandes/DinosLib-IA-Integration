# Project Flow
![image](https://github.com/user-attachments/assets/5f1ffb76-33d9-42ea-8378-0121cf550605)


# Project Configuration

To run this project, some configurations are necessary:

## Prerequisites

### BASS
  Download the sources here: https://www.un4seen.com/
  Include bass.pas in the project and bass.dll along with the executable (for this project, the Bass sources are already included).

### Conda
- Install the Anaconda distribution: https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html

### PyTorch
- Install the appropriate version of PyTorch:
  - Installation Guide: https://pytorch.org/get-started/previous-versions/  
  - If you have a CUDA-compatible graphics card, prefer this option for better performance.

#### Installation with CUDA 11.8:
```bash
conda install pytorch==2.3.1 torchvision==0.18.1 torchaudio==2.3.1 pytorch-cuda=11.8 -c pytorch -c nvidia
```

```bash
conda install pytorch==2.3.1 torchvision==0.18.1 torchaudio==2.3.1 pytorch-cuda=12.1 -c pytorch -c nvidia
```

```bash
conda install pytorch==2.3.1 torchvision==0.18.1 torchaudio==2.3.1 cpuonly -c pytorch
```

### Chocolatey
 - Install Chocolatey: https://chocolatey.org/install 
    - Run the following command to set the execution policy:
  
```bash
Run Get-ExecutionPolicy. If it returns Restricted, then run Set-ExecutionPolicy AllSigned or Set-ExecutionPolicy Bypass -Scope Process.
```

```bash
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### ffmpeg
- Install ffmpeg:
```bash
choco install ffmpeg
```

### Whisper
- Install Whisper:
```bash
pip install -U openai-whisper
```

```bash
pip install --upgrade --no-deps --force-reinstall git+https://github.com/openai/whisper.git
```

### Delphi OpenAI
  Install the Delphi OpenAI library: Installation Guide: https://platform.openai.com/docs/libraries/community-libraries  


### Generate API Key
Generate it HERE: https://platform.openai.com/api-keys 
Add the API_KEY in the file ```Dinos.Bridge.GPT.Open.IA```.
![image](https://github.com/user-attachments/assets/fcfef7cd-5761-425f-9891-e436c4d33984)

### Midware
- To use separately in your project, utilize the midwares.
- Add the midware to the project.
  
![image](https://github.com/user-attachments/assets/84c18d0c-fdaf-4748-b78d-0c8f4cfdd998)

To run the "Zé Notinha" project, the installation of ACBr is required. 
https://github.com/ProjetoACBr/ACBr  

Otherwise, you can run the test project.

---

### Additional Notes 
Material about this project 
https://www.canva.com/design/DAGeDMAtEeI/yqwJUz2lkixw-B6_t-OSOQ/edit?utm_content=DAGeDMAtEeI&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton  











