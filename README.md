# Fluxo de dados
![Fluxo do projeto](https://github.com/user-attachments/assets/1678b38f-52e5-4264-bb26-bd3ca4e31979)

# Configuração do Projeto

Para rodar este projeto, é necessário realizar algumas configurações:

## Pré-requisitos

### BASS
  Baixe os fontes aqui: https://www.un4seen.com/ 
  Incluir o bass.pas no projeto e o bass.dll junto com o exe (para este projeto já deixei os fontes do Bass, juntos)

### Conda
- Instale a distribuição Anaconda: Guia de Instalação

### PyTorch
- Instale a versão apropriada do PyTorch:
  - Guia de Instalação
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
 - Instale o Chocolatey: Guia de Instalação
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
Adicione a API_KEY no arquivo Dinos.Bridge.GPT.Open.IA.
![image](https://github.com/user-attachments/assets/fcfef7cd-5761-425f-9891-e436c4d33984)










