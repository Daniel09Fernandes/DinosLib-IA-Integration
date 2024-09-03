# Fluxo de dados
![Fluxo do projeto](https://github.com/user-attachments/assets/1678b38f-52e5-4264-bb26-bd3ca4e31979)

# Configuração do Projeto

Para rodar este projeto, é necessário realizar algumas configurações:

## Pré-requisitos

### BASS
  Baixe os fontes aqui: https://www.un4seen.com/ 
  Incluir o bass.pas no projeto e o bass.dll junto com o exe (para este projeto já deixei os fontes do Bass, juntos)

### Conda
- Instale a distribuição Anaconda: https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html 

### PyTorch
- Instale a versão apropriada do PyTorch:
  - Guia de Instalação: https://pytorch.org/get-started/previous-versions/  
  - Caso tenha uma placa de vídeo compatível com CUDA, prefira essa opção devido ao desempenho.

#### Instalação com CUDA 11.8
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
 - Instale o Chocolatey: https://chocolatey.org/install 
    - Execute o comando abaixo para configurar a política de execução:
  
```bash
Run Get-ExecutionPolicy. If it returns Restricted, then run Set-ExecutionPolicy AllSigned or Set-ExecutionPolicy Bypass -Scope Process.
```

```bash
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### ffmpeg
- Instale o ffmpeg:
```bash
choco install ffmpeg
```

### Whisper
- Instale o Whisper:
```bash
pip install -U openai-whisper
```

```bash
pip install --upgrade --no-deps --force-reinstall git+https://github.com/openai/whisper.git
```

### Delphi OpenAI
  Instale a biblioteca Delphi OpenAI: Guia de Instalação: https://platform.openai.com/docs/libraries/community-libraries  


### Gerar a API Key
Gere AQUI: https://platform.openai.com/api-keys 
Adicione a API_KEY no arquivo Dinos.Bridge.GPT.Open.IA.
![image](https://github.com/user-attachments/assets/fcfef7cd-5761-425f-9891-e436c4d33984)

### Midware
- Para usar separadamente em seu projeto, utilize os midwares 
- Adicionar os midware ao projeto
  
![image](https://github.com/user-attachments/assets/84c18d0c-fdaf-4748-b78d-0c8f4cfdd998)











