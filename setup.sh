#!/bin/bash
# Generalized Ukubona bootstrap script
# Usage: bash setup.sh <TEMPLATE_NAME> <TARGET_NAME>

set -e

TEMPLATE_NAME=$1
TARGET_NAME=$2

if [[ -z "$TEMPLATE_NAME" || -z "$TARGET_NAME" ]]; then
  echo "❗ Usage: bash setup.sh <TEMPLATE_REPO_NAME> <TARGET_REPO_NAME>"
  echo "👉 Example: bash setup.sh dummy birthday-special"
  exit 1
fi

PYTHON_VERSION="python3.11"
VENV_NAME="myenv"
TEMPLATE_REPO="https://github.com/abikesa/$TEMPLATE_NAME.git"
TARGET_REPO="https://github.com/abikesa/$TARGET_NAME.git"
REQUIREMENTS_PATH="template-repo/ukb/dolce/requirements.txt"

echo "🌱 Creating virtual environment..."
$PYTHON_VERSION -m venv "$VENV_NAME"

echo "✨ Activating virtual environment..."
source "$VENV_NAME/bin/activate"

echo "🔗 Cloning template repo: $TEMPLATE_REPO"
git clone "$TEMPLATE_REPO" template-repo

echo "📘 Cloning target repo: $TARGET_REPO"
git clone "$TARGET_REPO" "$TARGET_NAME"

echo "📦 Installing Python requirements..."
pip install --upgrade pip
pip install -r "$REQUIREMENTS_PATH"

echo "➕ Installing Jupyter Book and ghp-import..."
pip install jupyter-book ghp-import

echo "🧬 Copying template files into $TARGET_NAME/..."
cp -r template-repo/* "$TARGET_NAME/"

echo "✅ Setup complete."
echo "➡️ To activate environment later: source $VENV_NAME/bin/activate"
