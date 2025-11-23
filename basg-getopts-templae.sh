#!/bin/bash

set -eu

# オプション格納用変数
readonly ARGCOUNT=$#
SET_COMMAND=""
# 許可オプションの設定（許可オプションのMAPを作成）
declare -A CMD_ALLOWED_OPTS
CMD_ALLOWED_OPTS["start"]="-h --help"

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

# グローバルオプション処理関数
function parse_global_arguments() {
    local opt
    local optarg
    # optに現在解析中のオプション文字が入り、getoptsで解析
    # -:はロングオプションを処理するトリック
    while getopts "h-:" opt; do
        # OPTARGはgetoptsがセットするオプション引数、空なら空文字をセット
        # 「:-」は値が空や未設定のときに代入するものを設定（ここでは空文字）
        optarg="${OPTARG:-}"
        # getoptsが「-」を返した場合はロングオプションがきたと判断する
        if [[ "$opt" = "-" ]]; then
            # 最初の「=」で区切る前の分だけ取り出す
            opt="-${OPTARG%%=*}"
            # パターンにマッチした部分だけを取り出す構文
            # 「= の前までの文字列を削除」して残りを取得
            optarg="${OPTARG/${OPTARG%%=*}/}"
            # 先頭の = を削除してこれでオプション引数完成
            optarg="${optarg#=}"

            # optarg が空の場合 → --option の次の引数が値かもしれない
            # OPTIND は 次に解析される引数のインデックス
            # ${!OPTIND} は次のコマンドライン引数の値を参照
            # 次の引数が - で始まっていなければ、それを値として使える
            if [[ -z "$optarg" ]] && [[ ! "${!OPTIND:-}" = -* ]]; then
                # 次の引数を optarg にセット
                optarg="${!OPTIND:-}"
                # shift で引数リストから削除して、次の getopts 処理に進める
                shift
            fi
        fi
        case "-${opt}" in
        -h | --help)
            show_global_help
            exit
            ;;
        -*)
            echo "Invalid option: -${opt}"
            show_global_help
            exit
            ;;
        esac

    done
}

# サブコマンドオプション処理関数
function parse_opt_arguments() {
    local opt
    local optarg
    local optstring

    # サブコマンドのオプション文字列を設定する
    case "${SET_COMMAND}" in
    "start")
        optstring="a:hp:-:"
        ;;
    *)
        echo "Unexpected command '${SET_COMMAND}'"
        select_show_usage
        return 1
        ;;
    esac

    # optに現在解析中のオプション文字が入り、getoptsで解析
    # -:はロングオプションを処理するトリック
    while getopts "$optstring" opt; do
        # OPTARGはgetoptsがセットするオプション引数、空なら空文字をセット
        # 「:-」は値が空や未設定のときに代入するものを設定（ここでは空文字）
        optarg="${OPTARG:-}"
        # getoptsが「-」を返した場合はロングオプションがきたと判断する
        if [[ "$opt" = "-" ]]; then
            # 最初の「=」で区切る前の分だけ取り出す
            opt="-${OPTARG%%=*}"
            # パターンにマッチした部分だけを取り出す構文
            # 「= の前までの文字列を削除」して残りを取得
            optarg="${OPTARG/${OPTARG%%=*}/}"
            # 先頭の = を削除してこれでオプション引数完成
            optarg="${optarg#=}"

            # optarg が空の場合 → --option の次の引数が値かもしれない
            # OPTIND は 次に解析される引数のインデックス
            # ${!OPTIND} は次のコマンドライン引数の値を参照
            # 次の引数が - で始まっていなければ、それを値として使える
            if [[ -z "$optarg" ]] && [[ ! "${!OPTIND:-}" = -* ]]; then
                # 次の引数を optarg にセット
                optarg="${!OPTIND:-}"
                # shift で引数リストから削除して、次の getopts 処理に進める
                shift
            fi
        fi
        case "-${opt}" in
        -h | --help)
            show_global_help
            exit
            ;;
        -*)
            echo "Invalid option: -${opt}"
            show_global_help
            exit
            ;;
        esac

    done
}

parse_global_arguments "$@"
