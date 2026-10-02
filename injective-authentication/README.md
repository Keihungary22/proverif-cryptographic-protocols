# Injective Authentication

This directory contains the Lowe-corrected Needham-Schroeder public-key protocol with a stronger authentication query.

## Query

The ordinary correspondence query checks whether a matching Alice start event exists:

~~~prolog
event(endB(x,y,na,nb)) ==> event(beginA(x,y,na))
~~~

The injective correspondence query additionally requires distinct Bob completion events to correspond to distinct Alice start events:

~~~prolog
inj-event(endB(x,y,na,nb)) ==> inj-event(beginA(x,y,na))
~~~

## Verification Result

ProVerif reports:

~~~text
RESULT inj-event(endB(x,y,na,nb)) ==> inj-event(beginA(x,y,na)) is true.
~~~

The Lowe-corrected protocol therefore satisfies the stronger injective authentication property in this model.

ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー

# Injective Authentication

このディレクトリには、Lowe修正版Needham-Schroeder public-key protocolに対するstronger authentication verificationが含まれています。

## Query

通常のcorrespondence queryは、対応するAliceの開始eventが存在するかを確認します。

~~~prolog
event(endB(x,y,na,nb)) ==> event(beginA(x,y,na))
~~~

injective correspondenceではさらに、異なるBobの完了eventが、それぞれ異なるAliceの開始eventに対応することを要求します。

~~~prolog
inj-event(endB(x,y,na,nb)) ==> inj-event(beginA(x,y,na))
~~~

## 検証結果

ProVerifは以下を報告します。

~~~text
RESULT inj-event(endB(x,y,na,nb)) ==> inj-event(beginA(x,y,na)) is true.
~~~

したがって、このモデルではLowe修正版protocolがより強いinjective authentication propertyも満たします。
