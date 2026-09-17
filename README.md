# ProVerif Cryptographic Protocols

Cryptographic protocol modeling and formal verification with ProVerif.

## Current Models

### Basic Secrecy

The `basic-secrecy/` directory contains introductory models demonstrating:

- secrecy of unexposed private values
- information leakage over public channels
- secrecy over private channels
- information leakage through tuples

See [`basic-secrecy/README.md`](basic-secrecy/README.md) for model-specific results and explanations.

### Naive Handshake

The `naive-handshake/` directory contains a deliberately vulnerable public-key handshake model demonstrating:

- symmetric and asymmetric encryption
- digital signatures
- fresh session keys
- replicated protocol sessions
- a cross-session attack caused by missing client-key binding

See [`naive-handshake/README.md`](naive-handshake/README.md) for the protocol model, verification result, and attack analysis.

## Verification

The repository includes an automated verification script that checks each model against its expected ProVerif result.

Run the verification locally from the repository root:

```bash
./scripts/verify-models.sh
```

A successful run ends with:

```text
All ProVerif model verification checks passed.
```

Some models intentionally demonstrate secrecy violations. For those models, a ProVerif result such as:

```text
RESULT not attacker(secretMsg[]) is false.
```

is an expected result and therefore counts as a successful verification check.

## Continuous Integration

GitHub Actions automatically runs the ProVerif verification workflow on:

- pull requests
- pushes to `main`

The CI workflow reuses the same local verification script to keep local and automated verification behavior consistent.

ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー

# ProVerif Cryptographic Protocols

ProVerifを用いた暗号プロトコルのモデリングと形式検証を行うリポジトリです。

## 現在のモデル

### Basic Secrecy

`basic-secrecy/` ディレクトリには、ProVerifの基本的な秘密性検証を学ぶためのモデルが含まれています。

以下の内容を扱います。

- 外部に送信されていない秘密値の秘密性
- 公開チャネルを通じた情報漏えい
- 秘密チャネルを利用した秘密性
- タプルを通じた情報漏えい

各モデルの検証結果と解説については、[`basic-secrecy/README.md`](basic-secrecy/README.md) を参照してください。

### Naive Handshake

`naive-handshake/` ディレクトリには、意図的に脆弱なpublic-key handshake modelが含まれています。

以下の内容を扱います。

- 共通鍵暗号と公開鍵暗号
- 電子署名
- fresh session key
- replicationによる複数プロトコルセッション
- client key bindingの欠如によって発生するcross-session attack

プロトコルモデル、検証結果、攻撃分析については、[`naive-handshake/README.md`](naive-handshake/README.md) を参照してください。

## 検証

このリポジトリには、各モデルのProVerif実行結果が期待される結果と一致するかを自動確認する検証スクリプトが含まれています。

リポジトリのルートディレクトリから、以下のコマンドでローカル検証を実行できます。

```bash
./scripts/verify-models.sh
```

すべての検証が成功すると、最後に以下が表示されます。

```text
All ProVerif model verification checks passed.
```

一部のモデルは、秘密性が破られる状況を意図的に再現しています。

そのため、例えば以下のようなProVerifの結果は、

```text
RESULT not attacker(secretMsg[]) is false.
```

モデルの想定どおりであれば、検証成功として扱います。

## 継続的インテグレーション

GitHub Actionsによって、ProVerifの検証ワークフローが以下のタイミングで自動実行されます。

- Pull Requestの作成・更新時
- `main` ブランチへのpush時

CIではローカル環境と同じ検証スクリプトを再利用することで、ローカル検証と自動検証の挙動を一致させています。
