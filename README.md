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

### Client Key Binding Repair

The `client-key-binding/` directory contains a repaired version of the naive handshake protocol.

The repair binds the fresh session key to the intended client's public key by signing:

~~~text
(pkX, pkB, k)
~~~

The client then verifies that the signed client public key matches its own `pkA`.

This changes the secrecy result from:

~~~text
Vulnerable: RESULT not attacker(s[]) is false.
Repaired:   RESULT not attacker(s[]) is true.
~~~

See [`client-key-binding/README.md`](client-key-binding/README.md) for the repair and comparison.

### Needham-Schroeder Public-Key Protocol

The `needham-schroeder/` directory contains a vulnerable Needham-Schroeder public-key protocol model demonstrating:

- fresh nonce challenge-response
- authentication events
- correspondence queries
- the classical Lowe attack
- authentication failure caused by missing responder-identity binding

ProVerif reports the expected authentication failure:

~~~text
RESULT event(endB(x,y,na,nb)) ==> event(beginA(x,y,na)) is false.
~~~

See [`needham-schroeder/README.md`](needham-schroeder/README.md) for the model and attack analysis.

### Lowe's Correction

The `lowe-correction/` directory contains the corrected Needham-Schroeder protocol.

Lowe's correction adds the responder identity to message 2 and requires Alice to verify it.

~~~text
Vulnerable: RESULT event(endB(x,y,na,nb)) ==> event(beginA(x,y,na)) is false.
Corrected:  RESULT event(endB(x,y,na,nb)) ==> event(beginA(x,y,na)) is true.
~~~

See [`lowe-correction/README.md`](lowe-correction/README.md) for the correction and comparison.

### Injective Authentication

The `injective-authentication/` directory strengthens the Lowe-corrected Needham-Schroeder authentication check using injective correspondence.

~~~text
RESULT inj-event(endB(x,y,na,nb)) ==> inj-event(beginA(x,y,na)) is true.
~~~

This requires distinct Bob completion events to correspond to distinct Alice start events.

See [`injective-authentication/README.md`](injective-authentication/README.md) for details.

### Broken Responder Identity Check

The `broken-identity-check/` directory intentionally removes the responder identity equality check from the Lowe-corrected protocol.

~~~prolog
let (=Na, Nb:nonce, pkY:pkey) = adec(m2, skA) in
~~~

Without `=pkX`, Alice no longer verifies that the responder identity matches the peer she intended to contact.

~~~text
RESULT inj-event(endB(x,y,na,nb)) ==> inj-event(beginA(x,y,na)) is false.
~~~

See [`broken-identity-check/README.md`](broken-identity-check/README.md) for the attack analysis.

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

GitHub Actions automatically runs verification and static-analysis checks on:

- pull requests
- pushes to `main`

The CI pipeline includes three complementary checks:

- **ProVerif** — verifies that each cryptographic protocol model produces its expected security result
- **ShellCheck** — performs static analysis of Shell scripts under `scripts/`
- **actionlint** — validates GitHub Actions workflow files under `.github/workflows/`

The ProVerif workflow reuses `scripts/verify-models.sh` so local and automated verification behavior remain consistent.

Static-analysis checks can also be run locally:

~~~bash
shellcheck scripts/*.sh
actionlint
~~~

ShellCheck detects common Shell scripting errors and unsafe patterns, while actionlint detects syntax and configuration problems in GitHub Actions workflows.

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

### Client Key Binding Repair

`client-key-binding/` ディレクトリには、naive handshake protocolの修正版が含まれています。

修正版ではfresh session keyを本来のClient public keyにbindingするため、Serverが以下を署名します。

~~~text
(pkX, pkB, k)
~~~

Client側では、署名されたClient public keyが自身の `pkA` と一致することを確認します。

これによりsecrecy resultは以下のように変化します。

~~~text
Vulnerable: RESULT not attacker(s[]) is false.
Repaired:   RESULT not attacker(s[]) is true.
~~~

修正内容と比較については、[`client-key-binding/README.md`](client-key-binding/README.md) を参照してください。

### Needham-Schroeder Public-Key Protocol

`needham-schroeder/` ディレクトリには、脆弱なNeedham-Schroeder public-key protocol modelが含まれています。

以下の内容を扱います。

- fresh nonceを使ったchallenge-response
- authentication event
- correspondence query
- classical Lowe attack
- responder-identity bindingの欠如によるauthentication failure

ProVerifでは期待どおりauthentication failureを確認します。

~~~text
RESULT event(endB(x,y,na,nb)) ==> event(beginA(x,y,na)) is false.
~~~

modelとattack analysisについては、[`needham-schroeder/README.md`](needham-schroeder/README.md) を参照してください。

### Lowe's Correction

`lowe-correction/` ディレクトリには、Needham-Schroeder protocolの修正版が含まれています。

Lowe's correctionではmessage 2にresponder identityを追加し、Aliceがそのidentityを確認します。

~~~text
Vulnerable: RESULT event(endB(x,y,na,nb)) ==> event(beginA(x,y,na)) is false.
Corrected:  RESULT event(endB(x,y,na,nb)) ==> event(beginA(x,y,na)) is true.
~~~

修正内容と比較については、[`lowe-correction/README.md`](lowe-correction/README.md) を参照してください。

### Injective Authentication

`injective-authentication/` ディレクトリでは、Lowe修正版Needham-Schroeder protocolに対してinjective correspondenceを使ったstronger authenticationを検証します。

~~~text
RESULT inj-event(endB(x,y,na,nb)) ==> inj-event(beginA(x,y,na)) is true.
~~~

異なるBobの完了eventが、それぞれ異なるAliceの開始eventに対応することを要求します。

詳細は [`injective-authentication/README.md`](injective-authentication/README.md) を参照してください。

### Broken Responder Identity Check

`broken-identity-check/` ディレクトリでは、Lowe修正版からresponder identityのequality checkを意図的に外しています。

~~~prolog
let (=Na, Nb:nonce, pkY:pkey) = adec(m2, skA) in
~~~

`=pkX` がないため、Aliceはmessage内のresponder identityが自分の意図した相手と一致することを確認しません。

~~~text
RESULT inj-event(endB(x,y,na,nb)) ==> inj-event(beginA(x,y,na)) is false.
~~~

attack analysisについては [`broken-identity-check/README.md`](broken-identity-check/README.md) を参照してください。

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

GitHub Actionsによって、検証とstatic analysisが以下のタイミングで自動実行されます。

- Pull Requestの作成・更新時
- `main` ブランチへのpush時

CIでは以下の3種類のチェックを実行します。

- **ProVerif** — 各暗号プロトコルモデルが期待されるsecurity resultを返すことを検証
- **ShellCheck** — `scripts/` 配下のShell scriptを静的解析
- **actionlint** — `.github/workflows/` 配下のGitHub Actions workflowを検証

ProVerif workflowでは `scripts/verify-models.sh` を再利用し、ローカル検証とCI上の検証結果を一致させています。

static analysisはローカルでも実行できます。

~~~bash
shellcheck scripts/*.sh
actionlint
~~~

ShellCheckはShell scriptの一般的な記述ミスや危険なパターンを検出し、actionlintはGitHub Actions workflowのsyntaxや設定上の問題を検出します。
