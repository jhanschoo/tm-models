# tm-models

[![PyPI - Version](https://img.shields.io/pypi/v/tm-models.svg)](https://pypi.org/project/tm-models)
[![PyPI - Python Version](https://img.shields.io/pypi/pyversions/tm-models.svg)](https://pypi.org/project/tm-models)

-----

## Table of Contents

- [tm-models](#tm-models)
  - [Table of Contents](#table-of-contents)
  - [Installation](#installation)
  - [License](#license)
  - [Pre-Blueprint Brainstorm](#pre-blueprint-brainstorm)

## Installation

```console
pip install tm-models
```

## License

`tm-models` is distributed under the terms of the [MIT](https://spdx.org/licenses/MIT.html) license.

## Pre-Blueprint Brainstorm

- Define kTM (our specific definition)
  - Our kTM has 1 immutable input tape and k work tapes, of which the last may be distinguished as an output tape; the kTM is allowed to not move the head and simply overprint. The kTM is allow multiple distinct halt states. It may continue to step after it enters a halt state. The tape is modeled as a left stack, a right stack, and the head register (which can be blank). The kTM cannot overprint the blank symbol. (Helps with reasoning about space complexity.)
- Define tape-equivalence. Two configurations that have a notion of left/right tape, head, and emit register are tape-equivalent if
- Define exec-equivalence
  - Two instances A and B of models CalA and CalB of computation with a notion of being initialized with input, a notion of a configuration and stepping through it (given a symbol input) are exec-equivalent if
    - for each nonnegative integer $k$, after stepping through $k$ times (given the same sequence of step-input-symbols) after being initialized with equivalent input, their configurations are tape-equivalent
  - Two models CalA and CalB of computation are c-equivalent if for each instance A of CalA there is an instance B of CalB such that A and B are c-equivalent, and vice versa
- Define Ocoros ("Oracle coroutines")
- Define Cocoro_0's (Ocoros that behave like a kTM but receive messages each step and has a bound that has it emit once every finite number of steps)
- Prove that kTMs and the class of Cocoro_0's that ignore incoming messages and emits either a dummy message or a halt message are c-equivalent.
    - Such a Cocoro_0 is a kTM, once we map each step that emits to a halt state.
    - Such a kTM is a Cocoro_0, once we map each transition to a halt state to an emission of a halt message, and the emission of a dummy message otherwise.
- Prove that 
- Define Cocoro_1's (Ocoros that behave like a TM with access to a Cocoro_1 or Cocoro_0)
- Define t-equivalence
  - We say that B is a $t_f$-refinement of A, where f is a positive integer-valued function on the nonnegative integers, if for each input on A and B, there exists an increasing 0-indexed sequence $s$ of nonnegative integers such that
    - for each index $k$, the configuration of B after exactly $s(k)$ steps is c-equivalent to the configuration of A after exactly $k$ steps.
    - $s(0) \leq f(0)$ and for each positive $k$, $s(k)-s(k-1) \leq f(k)$.
- Once we have a notion of input/output in terms of execution of TMs, we show that if B is a $t_M$-refinement of A, where $M$ is a constant function, then they belong to the same complexity class.
- We prove that if C is a $t_M$-refinement of B and B is a $t_N$ refinement of A, then $C$ is a $t_{MN}$ refinement of A.
- Prove that to each Cocoro_1 there exists a $t_M$-refinement of it that is a Cocoro_0, with $M$ parametrized only by that Cocoro_1.
- Define a Multiplexer Cocoro_1
- Define a Cocoro (Ocoros that behave like a TM with access to a finite number of Cocoro's)
- Prove that to each Cocoro there exists a $t_M$-refinement of it that is a Multiplexer Cocoro_1, with $M$ parametrized only by that Cocoro