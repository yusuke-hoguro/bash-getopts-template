# bash-getopts-template
シェルスクリプトのコマンド/オプション起動のベース

## フォーマット機能の追加

- Shellコーディングに便利なフォーマッターshfmtを導入する

1. 下記コマンドでshfmtをインストールする
    ```bash
    sudo apt install shfmt

    ```
1. VSCode の拡張機能で`ShellCheck`と`shfmt`をインストール
1. VSCode 設定（settings.json）に下記を追加して自動フォーマットを有効化
    ```json
    {
    "[shellscript]": {
        "editor.defaultFormatter": "mkhl.shfmt",
        "editor.formatOnSave": true
    },
    "shfmt.executablePath": "shfmt",
    "shfmt.style": "default"
    }
    ```

