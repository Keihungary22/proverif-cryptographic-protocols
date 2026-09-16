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

## Verification

The repository includes an automated verification script that checks each model against its expected ProVerif result.

Run the verification locally from the repository root:

```bash
./scripts/verify-basic-secrecy.sh
```

A successful run ends with:

```text
All basic secrecy verification checks passed.
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

