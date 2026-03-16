#!/bin/bash

# Xeon ASR Skill 环境准备脚本（setup_env.sh）
# 支持 Ubuntu/Debian/CentOS/RHEL/AlibabaCloud/Rocky/AlmaLinux
# 默认使用 Miniconda（预编译 Python 3.10，无需编译）

set -euo pipefail

# 强制使用 hf-mirror 加速 HuggingFace 下载（必须在任何下载操作之前设置）
export HF_ENDPOINT=https://hf-mirror.com
export HF_HUB_ENABLE_HF_TRANSFER=0  # 禁用 hf-transfer 确保使用标准下载

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_step() { echo -e "${BLUE}[STEP]${NC} $1"; }

# 参数解析
MODEL_PATH=""
DEFAULT_MODEL_PATH="~/model/Qwen3-ASR-0.6B-INT8_ASYM-OpenVINO"
FORCE=0
SKIP_DEPS=0
SKIP_START=0

usage() {
    cat << EOF
Xeon ASR Skill 环境准备脚本

用法: $0 [选项]

选项:
  --model-path PATH    指定 Qwen3-ASR 模型路径（默认: ~/model/Qwen3-ASR-0.6B-INT8_ASYM-OpenVINO）
  --force              强制重新生成虚拟环境
  --skip-deps          跳过系统依赖安装
    --skip-start         仅安装和配置，不自动启动服务
  -h, --help           显示此帮助

示例:
  $0                    # 使用默认路径 ~/model/，自动下载模型
  $0 --force --model-path /opt/models/asr
EOF
    exit 0
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --model-path) MODEL_PATH="$2"; shift 2 ;;
        --force) FORCE=1; shift ;;
        --skip-deps) SKIP_DEPS=1; shift ;;
        --skip-start) SKIP_START=1; shift ;;
        -h|--help) usage ;;
        *) log_error "未知参数: $1"; usage ;;
    esac
done

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SKILL_DIR"

echo "========================================"
echo "  Xeon ASR Skill 环境准备"
echo "========================================"
echo ""

detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    elif [ -f /etc/redhat-release ]; then
        echo "centos"
    else
        echo "unknown"
    fi
}

OS=$(detect_os)
log_info "检测到操作系统: $OS"

check_sudo() {
    if [ "$EUID" -eq 0 ]; then
        SUDO=""
    elif command -v sudo &> /dev/null; then
        SUDO="sudo"
    else
        log_warn "没有 sudo 权限，且不是 root 用户"
        SUDO=""
    fi
}

install_system_deps() {
    if [ "$SKIP_DEPS" -eq 1 ]; then
        log_info "跳过系统依赖安装"
        return 0
    fi

    check_sudo

    case $OS in
        ubuntu|debian)
            install_deps_debian
            ;;
        centos|rhel|fedora|rocky|almalinux|ol|alibabacloud|alios)
            install_deps_redhat
            ;;
        *)
            log_warn "未知系统 $OS，继续尝试 Miniconda 安装"
            ;;
    esac
}

install_deps_debian() {
    log_step "安装系统依赖 (Debian/Ubuntu)..."
    $SUDO apt-get update -qq
    $SUDO apt-get install -y -qq wget curl git lsof net-tools unzip bzip2 ca-certificates || \
    $SUDO apt-get install -y wget curl git lsof net-tools unzip bzip2 ca-certificates
}

install_deps_redhat() {
    log_step "安装系统依赖 (RHEL/CentOS/AlibabaCloud)..."
    
    if command -v dnf &> /dev/null; then
        PKG_MGR="dnf"
        $SUDO dnf install -y -q epel-release 2>/dev/null || true
    else
        PKG_MGR="yum"
        $SUDO yum install -y -q epel-release 2>/dev/null || true
    fi
    
    # Alibaba Cloud 3 特殊处理
    if [[ "$OS" == "alibabacloud" ]] || [[ "$OS" == "alios" ]]; then
        log_info "检测到 Alibaba Cloud，安装额外依赖..."
        $SUDO $PKG_MGR install -y -q openssl11 openssl11-devel 2>/dev/null || true
    fi
    
    $SUDO $PKG_MGR install -y -q wget curl git lsof net-tools unzip bzip2 ca-certificates \
        which || \
    $SUDO $PKG_MGR install -y wget curl git lsof net-tools unzip bzip2 ca-certificates \
        which
}

# 使用 Miniconda 安装 Python 3.10（无需编译，100%成功）
setup_miniconda() {
    log_step "使用 Miniconda 部署 Python 3.10..."
    
    local CONDA_DIR="$HOME/miniconda3"
    local CONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-py310_23.11.0-2-Linux-x86_64.sh"
    
    if [ -d "$CONDA_DIR" ] && [ "$FORCE" -eq 0 ]; then
        log_info "Miniconda 已存在，跳过安装"
    else
        if [ "$FORCE" -eq 1 ] && [ -d "$CONDA_DIR" ]; then
            log_info "强制模式：删除旧 Miniconda"
            rm -rf "$CONDA_DIR"
        fi
        
        log_info "下载 Miniconda..."
        if ! wget --timeout=120 -q "$CONDA_URL" -O /tmp/miniconda.sh; then
            log_error "下载 Miniconda 失败，尝试使用 curl..."
            if ! curl -fsSL --connect-timeout 120 "$CONDA_URL" -o /tmp/miniconda.sh; then
                log_error "下载 Miniconda 失败，请检查网络"
                exit 1
            fi
        fi
        
        log_info "安装 Miniconda（约 30 秒）..."
        bash /tmp/miniconda.sh -b -p "$CONDA_DIR" >/dev/null 2>&1 || {
            log_error "Miniconda 安装失败"
            rm -f /tmp/miniconda.sh
            exit 1
        }
        rm -f /tmp/miniconda.sh
        log_info "Miniconda 安装完成"
    fi
    
    # 设置路径
    export PATH="$CONDA_DIR/bin:$PATH"
    
    # 初始化 conda（用于当前 shell）
    if [ -f "$CONDA_DIR/etc/profile.d/conda.sh" ]; then
        source "$CONDA_DIR/etc/profile.d/conda.sh" 2>/dev/null || true
    fi
    
    # 验证
    if [ ! -f "$CONDA_DIR/bin/python" ]; then
        log_error "Miniconda 安装验证失败"
        exit 1
    fi
    
    local PY_VERSION=$("$CONDA_DIR/bin/python" --version 2>&1)
    log_info "Python 就绪: $PY_VERSION"
    
    PYTHON_CMD="$CONDA_DIR/bin/python"
}

setup_venv() {
    if [ "$FORCE" -eq 1 ] && [ -d "venv" ]; then
        log_info "强制模式：删除旧虚拟环境"
        rm -rf venv
    fi
    
    if [ ! -d "venv" ]; then
        log_step "创建 Python 虚拟环境..."
        "$PYTHON_CMD" -m venv venv || {
            log_error "创建虚拟环境失败"
            exit 1
        }
    fi
    
    source venv/bin/activate
    pip install -q --upgrade pip
    log_info "虚拟环境就绪"
}

install_python_packages() {
    log_step "安装 xdp-audio-service..."
    pip install -q xdp-audio-service || {
        log_error "安装 xdp-audio-service 失败"
        log_info "尝试不使用缓存重新安装..."
        pip install --no-cache-dir xdp-audio-service || {
            exit 1
        }
    }
    log_info "xdp-audio-service 安装完成"
}

generate_config() {
    if [ -f "audio_config.json" ] && [ "$FORCE" -ne 1 ]; then
        log_info "配置文件已存在，跳过生成（使用 --force 覆盖）"
        return 0
    fi
    
    log_step "生成 ASR 配置文件..."
    
    if command -v xdp-asr-init-config &> /dev/null; then
        xdp-asr-init-config --output ./audio_config.json || create_default_config
    else
        create_default_config
    fi
}

create_default_config() {
        cat > audio_config.json <<EOF
{
  "qwen3_asr_ov": {
        "model": "$HOME/model/Qwen3-ASR-0.6B-INT8_ASYM-OpenVINO",
    "device": "CPU",
    "sample_rate": 16000,
    "language": "zh",
    "max_tokens": 256
  },
  "server": {
    "host": "127.0.0.1",
    "port": 5001
  }
}
EOF
    log_info "已生成默认配置文件（模型路径: $HOME/model/...）"
}

# 展开路径中的 ~ 为实际路径
expand_path() {
    local path="$1"
    if [[ "$path" == ~* ]]; then
        path="${path/#\~/$HOME}"
    fi
    echo "$path"
}

# 解析可用的 Hugging Face CLI 命令
resolve_hf_cli() {
    export PATH="$HOME/miniconda3/bin:$HOME/.local/bin:$PATH"

    if command -v hf &> /dev/null; then
        echo "hf"
        return 0
    fi

    if [ -x "$HOME/miniconda3/bin/hf" ]; then
        echo "$HOME/miniconda3/bin/hf"
        return 0
    fi

    if [ -x "$HOME/.local/bin/hf" ]; then
        echo "$HOME/.local/bin/hf"
        return 0
    fi

    if command -v huggingface-cli &> /dev/null; then
        echo "huggingface-cli"
        return 0
    fi

    if [ -x "$HOME/miniconda3/bin/huggingface-cli" ]; then
        echo "$HOME/miniconda3/bin/huggingface-cli"
        return 0
    fi

    if [ -x "$HOME/.local/bin/huggingface-cli" ]; then
        echo "$HOME/.local/bin/huggingface-cli"
        return 0
    fi

    log_info "安装 Hugging Face CLI..."
    if pip install -q 'huggingface_hub[cli]' 2>/dev/null || pip install -q huggingface_hub 2>/dev/null; then
        export PATH="$HOME/miniconda3/bin:$HOME/.local/bin:$PATH"
        if command -v hf &> /dev/null; then
            echo "hf"
            return 0
        fi
        if [ -x "$HOME/miniconda3/bin/hf" ]; then
            echo "$HOME/miniconda3/bin/hf"
            return 0
        fi
        if [ -x "$HOME/.local/bin/hf" ]; then
            echo "$HOME/.local/bin/hf"
            return 0
        fi
        if command -v huggingface-cli &> /dev/null; then
            echo "huggingface-cli"
            return 0
        fi
        if [ -x "$HOME/miniconda3/bin/huggingface-cli" ]; then
            echo "$HOME/miniconda3/bin/huggingface-cli"
            return 0
        fi
        if [ -x "$HOME/.local/bin/huggingface-cli" ]; then
            echo "$HOME/.local/bin/huggingface-cli"
            return 0
        fi
    fi

    return 1
}

# 下载模型（使用 hf CLI + hf-mirror）
download_model() {
    local target_path="$1"
    local expanded_path
    local hf_cli
    expanded_path=$(expand_path "$target_path")
    
    log_step "自动下载模型到: $target_path"
    log_info "使用 hf CLI + hf-mirror 下载..."
    
    export HF_ENDPOINT=https://hf-mirror.com
    export HF_HUB_ENABLE_HF_TRANSFER=0

    mkdir -p "$expanded_path"

    hf_cli=$(resolve_hf_cli) || {
        log_error "未能安装或找到 Hugging Face CLI"
        return 1
    }

    log_info "正在下载模型文件（约 1.3GB，请耐心等待）..."
    if [[ "$hf_cli" == *"hf" ]] && [[ "$hf_cli" != *"huggingface-cli" ]]; then
        if "$hf_cli" download dseditor/Qwen3-ASR-0.6B-INT8_ASYM-OpenVINO --local-dir "$expanded_path"; then
            log_info "✓ 模型下载完成"
            return 0
        fi
    elif "$hf_cli" download dseditor/Qwen3-ASR-0.6B-INT8_ASYM-OpenVINO --local-dir "$expanded_path" --local-dir-use-symlinks False; then
        log_info "✓ 模型下载完成"
        return 0
    fi

    log_error "模型下载失败"
    return 1
}

update_model_path() {
    # 如果没有指定模型路径，使用默认值
    if [ -z "$MODEL_PATH" ]; then
        MODEL_PATH="$DEFAULT_MODEL_PATH"
        log_info "使用默认模型路径: $MODEL_PATH"
    fi
    
    # 展开路径（处理 ~）
    local expanded_path
    expanded_path=$(expand_path "$MODEL_PATH")
    
    # 检查模型是否存在
    if [ ! -d "$expanded_path" ] || [ -z "$(ls -A "$expanded_path" 2>/dev/null)" ]; then
        log_warn "模型目录不存在或为空: $MODEL_PATH"
        
        # 自动下载（非交互式环境默认下载）
        log_info "自动下载模型..."
        if ! download_model "$MODEL_PATH"; then
            log_error "模型下载失败"
            log_info "请手动下载："
            log_info "  1. 访问: https://hf-mirror.com/dseditor/Qwen3-ASR-0.6B-INT8_ASYM-OpenVINO"
            log_info "  2. 下载到: $MODEL_PATH"
            return 0
        fi
    fi
    
    log_step "配置模型路径: $MODEL_PATH"
    
    # 写入展开后的绝对路径，确保下游服务无需自行展开 ~
    local config_path="$expanded_path"
    
    python3 << PYEOF
import json
import sys

try:
    with open('./audio_config.json', 'r', encoding='utf-8') as f:
        config = json.load(f)
    
    if 'qwen3_asr_ov' not in config:
        config['qwen3_asr_ov'] = {}
    
    config['qwen3_asr_ov']['model'] = '$config_path'
    
    with open('./audio_config.json', 'w', encoding='utf-8') as f:
        json.dump(config, f, indent=2, ensure_ascii=False)
    
    print(f"✓ 模型路径已更新: $config_path")
except Exception as e:
    print(f"✗ 更新失败: {e}")
    sys.exit(1)
PYEOF
}

setup_openclaw() {
    local OPENCLAW_CONFIG="$HOME/.openclaw/openclaw.json"

    if [ ! -f "$OPENCLAW_CONFIG" ]; then
        log_warn "未找到 OpenClaw 配置，跳过 OpenClaw 集成"
        return 0
    fi

    log_step "配置 OpenClaw 集成（QQBot/Feishu/重复插件处理）..."

    bash "$SKILL_DIR/configure_openclaw_integration.sh"
    log_info "OpenClaw 集成配置完成"
}

auto_start_stack() {
    if [ "$SKIP_START" -eq 1 ]; then
        log_info "跳过自动启动（--skip-start）"
        return 0
    fi

    log_step "自动启动 Xeon ASR 双服务..."
    bash "$SKILL_DIR/start_all.sh" || {
        log_warn "自动启动未完全成功，请手动检查 start_all.sh 输出"
        return 0
    }
}

ensure_scripts_executable() {
    if [ -f "$SKILL_DIR/start_asr.sh" ]; then
        chmod +x "$SKILL_DIR/start_asr.sh"
        log_info "start_asr.sh 已设为可执行"
    fi
    
    if [ -f "$SKILL_DIR/stop_asr.sh" ]; then
        chmod +x "$SKILL_DIR/stop_asr.sh"
        log_info "stop_asr.sh 已设为可执行"
    fi

    if [ -f "$SKILL_DIR/configure_openclaw_integration.sh" ]; then
        chmod +x "$SKILL_DIR/configure_openclaw_integration.sh"
        log_info "configure_openclaw_integration.sh 已设为可执行"
    fi
}

show_completion() {
    echo ""
    echo "========================================"
    echo "  环境准备完成！"
    echo "========================================"
    echo ""
    
    echo -e "${BLUE}【模型配置】${NC}"
    if [ -z "$MODEL_PATH" ]; then
        MODEL_PATH="$DEFAULT_MODEL_PATH"
    fi
    echo "  模型路径: $MODEL_PATH"
    echo "  支持 ~ 表示用户主目录（适配 Docker）"
    echo ""
    
    echo -e "${BLUE}【启动方式】${NC}"
    echo "  方式1 - 手动启动:"
    echo "    ./start_asr.sh  # 启动 Flask ASR (5001)"
    echo "    npm start       # 启动 ASR Skill (9001)"
    echo ""
    echo "  方式2 - 一键启动:"
    echo "    ./start_all.sh  # 同时启动 5001 和 9001"
    echo ""
    echo "  方式3 - 仅修复 OpenClaw 集成:"
    echo "    ./configure_openclaw_integration.sh"
    echo ""
    
    echo -e "${BLUE}【管理命令】${NC}"
    echo "  停止服务: ./stop_asr.sh"
    echo "  查看日志: tail -f $SKILL_DIR/asr.log"
    echo ""
    
    if command -v openclaw &> /dev/null; then
        echo -e "${BLUE}【OpenClaw】${NC}"
        echo "  重启 Gateway: openclaw gateway restart"
        echo ""
    fi
}

main() {
    install_system_deps
    setup_miniconda  # 直接使用 Miniconda，不再尝试 pyenv 或系统 Python
    setup_venv
    install_python_packages
    generate_config
    update_model_path
    ensure_scripts_executable
    setup_openclaw
    auto_start_stack
    show_completion
}

main