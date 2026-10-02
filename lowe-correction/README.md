# Lowe's Correction

This directory contains the corrected Needham-Schroeder public-key protocol.

## Change

The vulnerable protocol sends:

~~~text
B -> A : aenc((Na, Nb), pkA)
~~~

Lowe's correction adds the responder identity:

~~~text
B -> A : aenc((Na, Nb, pkB), pkA)
~~~

Alice verifies that the responder identity matches the public key she intended to contact:

~~~prolog
let (=Na, Nb:nonce, =pkX) = adec(m2, skA) in
~~~

## Verification Result

Vulnerable protocol:

~~~text
RESULT event(endB(x,y,na,nb)) ==> event(beginA(x,y,na)) is false.
~~~

Corrected protocol:

~~~text
RESULT event(endB(x,y,na,nb)) ==> event(beginA(x,y,na)) is true.
~~~

The correction prevents the classical Lowe attack by binding the responder identity to message 2.

ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー

# Lowe's Correction

このディレクトリには、Needham-Schroeder public-key protocolの修正版が含まれています。

## 修正内容

脆弱版のmessage 2:

~~~text
B -> A : aenc((Na, Nb), pkA)
~~~

Lowe's correctionではresponder identityを追加します。

~~~text
B -> A : aenc((Na, Nb, pkB), pkA)
~~~

Aliceは、message内のresponder identityが自分の意図した相手 `pkX` と一致することを確認します。

~~~prolog
let (=Na, Nb:nonce, =pkX) = adec(m2, skA) in
~~~

## 検証結果

脆弱版:

~~~text
RESULT event(endB(x,y,na,nb)) ==> event(beginA(x,y,na)) is false.
~~~

修正版:

~~~text
RESULT event(endB(x,y,na,nb)) ==> event(beginA(x,y,na)) is true.
~~~

message 2にresponder identityをbindingすることで、classical Lowe attackを防ぎます。
