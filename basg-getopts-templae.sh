#!/bin/bash

set -eu

# オプション格納用変数
#readonly ARGCOUNT=$#
# 許可オプションの設定（許可オプションのMAPを作成）
#declare -A CMD_ALLOWED_OPTS
#CMD_ALLOWED_OPTS["start"]="-h --help"

# シェル全体のUsage
function show_global_help() {
    cat <<EOL
description 

    Usage:
        ./bash-getopts-template.sh [global-option] [<command> [command-option]]

    Command:
        start           description

    Global Options:
        -h | --help     description

EOL
}

# 各コマンドのUsage
function show_start_help() {
    cat <<EOL
description 

    Usage:
        ./bash-getopts-template.sh [global-option] [<command> [command-option]]

    Command:
        start           description

    Options:
        -h | --help     description

EOL
}

# 表示するUsageを選択する
function select_show_usage() {
    case "$TARGET_TYPE" in
    "start")
        show_start_help
        ;;
    *)
        echo "Unexpected type '$TARGET_TYPE'."
        return 1
        ;;
    esac
}
