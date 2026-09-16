# Basic Secrecy Experiments

This directory contains introductory ProVerif models for understanding attacker knowledge, public/private values, public/private channels, and secrecy queries.

## Models

### `public-message.pv`

Sends only `publicMsg` over a public channel.

Result:

```text
RESULT not attacker(secretMsg[]) is true.
```

Interpretation:

The attacker cannot derive `secretMsg` because it is never sent.

### `public-channel-leak.pv`

Sends `secretMsg` over a public channel.

Result:

```text
RESULT not attacker(secretMsg[]) is false.
```

Interpretation:

Declaring `secretMsg` as private does not prevent it from being leaked later through a public channel.

### `private-channel.pv`

Sends `secretMsg` only over a private channel.

Result:

```text
RESULT not attacker(secretMsg[]) is true.
```

Interpretation:

The attacker cannot derive `secretMsg` when it is sent only over a private channel.

### `tuple-leak.pv`

Sends `(publicMsg, secretMsg)` over a public channel.

Result:

```text
RESULT not attacker(secretMsg[]) is false.
```

Interpretation:

Placing a secret inside a tuple does not protect it. The attacker can receive the tuple and extract `secretMsg`.

## Result Interpretation

For a query such as:

```prolog
query attacker(secretMsg).
```

ProVerif reports the secrecy property using `not attacker(secretMsg)`.

- `true`: the attacker cannot derive the secret
- `false`: the attacker can derive the secret
