# Amazon Q Vim Plugin

VimでAmazon Qのチャット機能を使用するためのプラグインです。

## インストール

### dein.vimを使用する場合

`.vimrc`または`init.vim`に以下を追加：

```vim
call dein#add('your-username/amazonQ-vim')
```

### 手動インストール

1. このリポジトリをVimのプラグインディレクトリにクローン：
```bash
git clone https://github.com/your-username/amazonQ-vim ~/.vim/pack/plugins/start/amazonQ-vim
```

### 共通設定

2. AWS CLIをインストールし、Amazon Qへのアクセスを設定

## 使用方法

### コマンド
- `:AmazonQChat` - チャットウィンドウを開く
- `:AmazonQAsk` - 質問を入力してすぐに回答を得る
- `:AmazonQGenerate <filename>` - 指定したファイル名でコード生成
- `:AmazonQSaveResponse` - 最後の回答をファイルに保存

### キーマッピング
- `<leader>qq` - チャットウィンドウを開く
- `<leader>qa` - 質問を入力
- `<leader>qg` - ファイル生成コマンド
- `<leader>qs` - 最後の回答を保存

### チャットウィンドウでの操作
- 質問を入力して`<Enter>`で送信
- 履歴が自動的に保存される

### ファイル生成機能
- Amazon Qにコード生成を依頼し、自動でファイルに保存
- 生成されたファイルは自動的にVimで開かれる

## 設定

`.vimrc`で以下の設定が可能：

```vim
" Pythonのパスを指定（デフォルト: 'python'）
let g:amazonq_python_path = 'python3'
```

## 必要な環境
- Vim 8.0以上
- Python 3.6以上
- AWS CLI
- Amazon Qへのアクセス権限