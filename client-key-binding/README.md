# Client Key Binding Repair

This directory contains a repaired version of the naive handshake protocol.

The original protocol is vulnerable because the server-signed session key is not bound to the public key of the client for whom the key was generated.

## Vulnerable Protocol

The original server signs:

~~~text
(pkB, k)
~~~

The client verifies:

~~~prolog
let (=pkB, k:key) = checksign(y, pkB) in
~~~

The corresponding ProVerif result is:

~~~text
RESULT not attacker(s[]) is false.
~~~

This means that the attacker can derive the protected secret `s`.

The problem is that the signature proves that server B selected `k`, but does not prove which client the session key belongs to.

## Repair

The repaired server signs:

~~~text
(pkX, pkB, k)
~~~

where `pkX` is the public encryption key received for the intended client.

The server therefore sends:

~~~prolog
out(c, aenc(sign((pkX, pkB, k), skB), pkX));
~~~

The client verifies both its own public key and the trusted server signing key:

~~~prolog
let (=pkA, =pkB, k:key) = checksign(y, pkB) in
~~~

The equality pattern `=pkA` requires the client public key contained in the signed tuple to match the client's actual public key.

## Verification Result

ProVerif reports:

~~~text
RESULT not attacker(s[]) is true.
~~~

Under this model, the attacker can no longer derive the protected secret `s`.

## Why the Original Attack Fails

In the vulnerable protocol, the attacker can obtain a genuine signed session key for its own public key and reuse the signed value in a session with client A.

In the repaired protocol, a server response obtained for the attacker contains:

~~~text
(pkI, pkB, k)
~~~

Client A expects:

~~~text
(pkA, pkB, k)
~~~

Because `pkI` does not match `pkA`, the pattern check fails and client A does not accept the attacker-controlled session key.

## Security Effect

The repair introduces a cryptographic binding between:

~~~text
session key k
~~~

and:

~~~text
intended client public key
~~~

This prevents the cross-session reuse that affected the original protocol.

The result demonstrates secrecy of `s` in this ProVerif model. It does not by itself establish every possible security property of a real implementation.

ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー

# Client Key Bindingによる修正

このディレクトリには、naive handshake protocolをclient key bindingによって修正したモデルが含まれています。

元のプロトコルでは、Serverが署名するsession keyと、そのsession keyが生成された本来のClientのpublic keyがbindingされていませんでした。

## 脆弱なプロトコル

元のServerは以下を署名します。

~~~text
(pkB, k)
~~~

Clientは以下を検証します。

~~~prolog
let (=pkB, k:key) = checksign(y, pkB) in
~~~

このモデルに対するProVerifの結果は、

~~~text
RESULT not attacker(s[]) is false.
~~~

です。

つまり、攻撃者は保護対象の秘密値 `s` を取得できます。

問題は、署名によって「Server Bが `k` を選択した」ことは確認できても、その `k` がどのClient向けに生成されたものなのか確認できないことです。

## 修正

修正版ではServerが以下を署名します。

~~~text
(pkX, pkB, k)
~~~

`pkX` は、Serverが受信した本来のClientの公開暗号鍵です。

Serverの送信処理は以下になります。

~~~prolog
out(c, aenc(sign((pkX, pkB, k), skB), pkX));
~~~

Client側では、自身のpublic keyと信頼しているServer signing keyの両方を確認します。

~~~prolog
let (=pkA, =pkB, k:key) = checksign(y, pkB) in
~~~

`=pkA` によって、署名されたtupleに含まれるClient public keyが、実際のClient Aのpublic keyと一致することを要求します。

## 検証結果

ProVerifの結果は、

~~~text
RESULT not attacker(s[]) is true.
~~~

となりました。

このモデルでは、攻撃者は秘密値 `s` を取得できなくなっています。

## 元の攻撃が成立しなくなる理由

脆弱版では、攻撃者は自身のpublic key向けに発行された正規の署名付きsession keyを取得し、その署名値をClient Aとの別セッションで再利用できました。

修正版で攻撃者向けに生成される署名内容は、

~~~text
(pkI, pkB, k)
~~~

です。

一方、Client Aが要求する内容は、

~~~text
(pkA, pkB, k)
~~~

です。

`pkI` と `pkA` が一致しないため、Client Aのpattern checkが失敗し、攻撃者向けに発行されたsession keyを受け入れません。

## セキュリティ上の効果

この修正によって、

~~~text
session key k
~~~

と

~~~text
intended client public key
~~~

の間に暗号学的なbindingが追加されます。

これにより、元のプロトコルで成立していたcross-session reuseを防ぎます。

今回の結果は、このProVerifモデルにおいて `s` の秘密性が成立することを示しています。現実の実装におけるすべてのセキュリティプロパティを保証するものではありません。
