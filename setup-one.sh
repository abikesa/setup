#!/bin/bash
# Generalized Ukubona bootstrap script
# Usage:
#   bash setup.sh <TEMPLATE_NAME> <TARGET_NAME>
#   bash setup.sh <REPO_NAME>  # Single repo setup mode

set -e

PYTHON_VERSION="python3.11"
VENV_NAME="myenv"

TEMPLATE_NAME=$1
TARGET_NAME=$2

if [[ -z "$TEMPLATE_NAME" ]]; then
  echo "❗ Usage:"
  echo "👉 Two-repo mode: bash setup.sh <TEMPLATE_REPO_NAME> <TARGET_REPO_NAME>"
  echo "👉 Single-repo mode: bash setup.sh <REPO_NAME>"
  exit 1
fi

if [[ -z "$TARGET_NAME" ]]; then
  # Single-repo setup mode
  REPO_NAME=$TEMPLATE_NAME
  REPO_URL="https://github.com/abikesa/$REPO_NAME.git"
  REQUIREMENTS_PATH="$REPO_NAME/kitabo/ensi/requirements.txt"

  echo "🌱 Creating virtual environment..."
  $PYTHON_VERSION -m venv "$VENV_NAME"

  echo "✨ Activating virtual environment..."
  source "$VENV_NAME/bin/activate"

  echo "📘 Cloning repo: $REPO_URL"
  git clone "$REPO_URL"

  echo "📦 Installing Python requirements..."
  pip install --upgrade pip
  pip install -r "$REQUIREMENTS_PATH"

  echo "➕ Installing Jupyter Book and ghp-import..."
  pip install jupyter-book ghp-import

  echo "✅ Single-repo setup complete."
else
  # Two-repo mode
  TEMPLATE_REPO="https://github.com/abikesa/$TEMPLATE_NAME.git"
  TARGET_REPO="https://github.com/abikesa/$TARGET_NAME.git"
  REQUIREMENTS_PATH="template-repo/kitabo/ensi/requirements.txt"

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

  echo "✅ Two-repo setup complete."
fi

echo "➡️ To activate environment later: source $VENV_NAME/bin/activate"
