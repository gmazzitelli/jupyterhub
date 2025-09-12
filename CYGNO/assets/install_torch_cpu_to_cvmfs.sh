#!/bin/bash

# Configurazione
PYTHON_VERSION=3.11
TARGET_DIR=/mnt/py/Ubuntu22.04_Py3.11.9
STAGING_DIR=./torch_cpu_staging

# Step 1: Crea un ambiente temporaneo
echo "🛠️  Creo ambiente virtuale temporaneo in $STAGING_DIR"
python${PYTHON_VERSION} -m venv ${STAGING_DIR}/venv
source ${STAGING_DIR}/venv/bin/activate

# Step 2: Installa torch e torchvision CPU-only
echo "⬇️  Installo PyTorch e TorchVision (CPU-only)"
pip install --upgrade pip
pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu

# Step 3: Verifica
echo "✅ Verifica installazione"
python -c "import torch; import torchvision; print('Torch:', torch.__version__); print('Vision:', torchvision.__version__); print('CUDA:', torch.version.cuda)"

# Step 4: Copia i site-packages nel path destinazione
SITE_PACKAGES_DIR=$(python -c "import site; print(site.getsitepackages()[0])")
echo "📦 Copio pacchetti da $SITE_PACKAGES_DIR a $TARGET_DIR"

mkdir -p $TARGET_DIR
cp -r $SITE_PACKAGES_DIR/* $TARGET_DIR/

# Step 5: Cleanup
echo "🧹 Pulizia temporanea"
deactivate
rm -rf ${STAGING_DIR}

echo "✅ Installazione completata in $TARGET_DIR"
