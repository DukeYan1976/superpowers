#!/usr/bin/env bash
# Stop the brainstorm server and clean up
# 停止头脑风暴服务器并清理
#
# Usage: stop-server.sh <screen_dir>
# 用法：stop-server.sh <屏幕目录>
#
# Kills the server process. Only deletes session directory if it's
# 终止服务器进程。仅当会话目录位于
# under /tmp (ephemeral). Persistent directories (.superpowers/) are
# /tmp 下时删除（临时的）。持久化目录（.superpowers/）保留
# kept so mockups can be reviewed later.
# 以便后续可以回顾 mockup。

SCREEN_DIR="$1"

if [[ -z "$SCREEN_DIR" ]]; then
  echo '{"error": "Usage: stop-server.sh <screen_dir>"}'
  exit 1
fi

PID_FILE="${SCREEN_DIR}/.server.pid"

if [[ -f "$PID_FILE" ]]; then
  pid=$(cat "$PID_FILE")

  # Try to stop gracefully, fallback to force if still alive
  # 尝试优雅停止，如果仍在运行则强制终止
  kill "$pid" 2>/dev/null || true

  # Wait for graceful shutdown (up to ~2s)
  # 等待优雅关闭（最多约2秒）
  for i in {1..20}; do
    if ! kill -0 "$pid" 2>/dev/null; then
      break
    fi
    sleep 0.1
  done

  # If still running, escalate to SIGKILL
  # 如果仍在运行，升级到 SIGKILL
  if kill -0 "$pid" 2>/dev/null; then
    kill -9 "$pid" 2>/dev/null || true

    # Give SIGKILL a moment to take effect
    # 给 SIGKILL 一点时间生效
    sleep 0.1
  fi

  if kill -0 "$pid" 2>/dev/null; then
    echo '{"status": "failed", "error": "process still running"}'
    exit 1
  fi

  rm -f "$PID_FILE" "${SCREEN_DIR}/.server.log"

  # Only delete ephemeral /tmp directories
  # 仅删除临时的 /tmp 目录
  if [[ "$SCREEN_DIR" == /tmp/* ]]; then
    rm -rf "$SCREEN_DIR"
  fi

  echo '{"status": "stopped"}'
else
  echo '{"status": "not_running"}'
fi
