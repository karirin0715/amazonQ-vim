## 1. AWS CLIのインストール

```bash
# Windows
curl "https://awscli.amazonaws.com/AWSCLIV2.msi" -o "AWSCLIV2.msi"
msiexec /i AWSCLIV2.msi

# または pip経由
pip install awscli
```

## 2. AWS認証情報の設定

```bash
aws configure
```

以下の情報を入力：
- AWS Access Key ID
- AWS Secret Access Key  
- Default region name (例: us-east-1)
- Default output format (json推奨)

## 3. Amazon Q Developer用の認証

Amazon Q Developerを使用する場合：

```bash
# AWS Builder IDでログイン
aws sso login --profile your-profile-name

# または
aws configure sso
```

## 4. Amazon Q CLIコマンドの使用

```bash
# Amazon Q Developerでコード生成
aws q developer generate-code --prompt "Python関数を作成してください"

# チャット機能
aws q developer chat --message "Pythonでファイルを読み込む方法を教えて"
```

## 5. 環境変数の設定（オプション）

```bash
# Windows
set AWS_PROFILE=your-profile-name
set AWS_REGION=us-east-1

# Linux/Mac
export AWS_PROFILE=your-profile-name
export AWS_REGION=us-east-1
```

## 注意点

- Amazon Q Developerは特定のリージョンでのみ利用可能
- 適切なIAMポリシーが必要
- AWS Builder IDまたはIAM Identity Centerでの認証が推奨

現在のVimプラグインは、この設定済みのAWS CLIを使用してAmazon Qと通信します。