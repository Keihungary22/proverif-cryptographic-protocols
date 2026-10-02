# Broken Responder Identity Check

This directory contains an intentionally weakened variant of the Lowe-corrected Needham-Schroeder protocol.

## Change

The corrected initiator verifies the responder identity:

~~~prolog
let (=Na, Nb:nonce, =pkX) = adec(m2, skA) in
~~~

The broken variant replaces the equality check with a fresh variable:

~~~prolog
let (=Na, Nb:nonce, pkY:pkey) = adec(m2, skA) in
~~~

As a result, Alice no longer verifies that the responder identity in message 2 matches the peer she intended to contact.

## Verification Result

ProVerif reports:

~~~text
RESULT inj-event(endB(x,y,na,nb)) ==> inj-event(beginA(x,y,na)) is false.
RESULT (even event(endB(x,y,na,nb)) ==> event(beginA(x,y,na)) is false.)
~~~

Removing the responder identity equality check breaks both injective and ordinary authentication in this model.

The attack succeeds because Alice accepts a response from Bob even though she started the run intending to communicate with the intruder.

ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー

# Broken Responder Identity Check

このディレクトリには、Lowe修正版Needham-Schroeder protocolを意図的に弱くしたモデルが含まれています。

## 変更内容

正しい修正版ではresponder identityを確認します。

~~~prolog
let (=Na, Nb:nonce, =pkX) = adec(m2, skA) in
~~~

壊した版では `=pkX` をfresh variableに変更します。

~~~prolog
let (=Na, Nb:nonce, pkY:pkey) = adec(m2, skA) in
~~~

これによりAliceは、message 2に含まれるresponder identityが、自分が通信しようとした相手と一致するか確認しなくなります。

## 検証結果

~~~text
RESULT inj-event(endB(x,y,na,nb)) ==> inj-event(beginA(x,y,na)) is false.
RESULT (even event(endB(x,y,na,nb)) ==> event(beginA(x,y,na)) is false.)
~~~

このモデルでは、responder identityのequality checkを外すことでinjective authenticationだけでなくordinary authenticationも成立しなくなります。

AliceはIntruderを相手としてrunを開始していますが、BobはAliceをpeerだと信じてrunを完了できます。
