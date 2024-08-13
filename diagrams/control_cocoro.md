# control_cocoro

This document describes the virtualization of the control tape for $O(n \lg n)$ as a cocoro.

## Background definitions

We first reiterate some definitions in a non-precise, general manner. A kTM ocoro $O$ belonging to a host $M$ is specified as kTM with the following modifications. In addition to the tapes, it contains an emit register that is initialized to some $\eta \in H$, where $H$ contains a distinguished element $B$. The emit register is a convenience that partitions the (state, head)-projected configuration that the host should have access to. From the internal view, the transition function $\delta_O$ is augmented by the emit register and an additional argument where the value is an element of a fixed alphabet $P$. One symbol of $P$ is distinguished as the blank symbol $B$. The return value of $\delta_O$ is augmented by an element to be written to the emit register. Furthermore, $\delta_O$ satisfies the consistency guarantee that it is constant over the argument in $P$ whenever the emit register is $B$, though it may vary over the state and the head.

This leads us to the external view. From the perspective of the host, the ocoro $O$'s emits behaves like one of its many tapes, albeit with a special (overprint, direction) tuple. The host maintains a send register containing a non-blank symbol in $H$, again as a convenience that partitions the (state, head)-projected configuration. The transition function $\delta$ takes the send register as an argument, and implicitly, the ocoro definition and full configuration. Its return is augmented with a non-blank symbol from $H$, as well as another configuration for $O$.

The function $\delta$ satisfies the consistency guarantee that the input configuration of the ocoro and the output configuration of the ocoro are separated by a positive integral number of steps where the input is that of the send register of the host, and the emit register returned by all but the last step is blank, and the emit register on the last step is exactly the one that is returned by $\delta$.

A cocoro is a kTM ocoro where some integer $N$ bound exists such that every $N$ consecutive steps must contain a step that emits a non-blank symbol.

## High-level description

The **control cocoro** dynamically emulates an immutable version of the control tape used in the $O(n \lg n)$ efficient UTM. It uses three tapes, with their roles and invariants as follows. We use $Z_0$, $Z_{1}$, ... to refer to the zones from the simulated head to the current head, without specifying whether it is on the left half-tape or the right half-tape. We use $Z_{i,u}$ and $Z_{i,l}$ to refer to the upper and lower half-zones of zone $Z_i$.

- The **control tape** is a copy of the virtual control tape that the host sees, that is filled in at least from $Z_0$ through the current head position. The primary role of the control tape is to manage recovery of the head back to $Z_0$ after it has gone down the tape.
- The following tapes form the **active counter** and **recovering counter**. The tapes swap roles as we move from one zone to another. The tapes are also associated with a **direction** which flips between zones and half-zones. Both tapes are binary, either blank or filled-in, and the filled-in cells of each tape, if present, form a contiguous region of the tape such that the head is always within the contiguous region or in a neighboring cell of the contiguous region.
- In addition to the aforementioned properties, the **active counter** maintains the following invariants, except perhaps at $Z_0$ and $Z_{1,u}$, and when doing constant-time cleanup.
  - The size of the filled-in region is the size of the half-zone that the control tape's head is in.
  - The head's index counting from the start of the filled-in region wrt the current direction is exactly the index of the control tape's head wrt the start of the half-zone it is in.
- In addition to the aforementioned properties, the **recovering counter** maintains the following invariants, except perhaps at $Z_0$ and $Z_{1,u}$, and when doing constant-time cleanup.
  - The size of the filled-in region is the size of the region from the start of the zone the control tape is in to the current cell containing the head, inclusive.
  - The head is located at the last (wrt current direction) filled-in cell on the tape.

## Algorithm

### Description of the transition function

The input and output of $\delta$ are specified as follows. We have
$$
\delta(A,d_a,d_b;r,q;a_c,a_a,a_b;e)=(A',d_a',d_b';q';a_c',a_a',a_b';D_c,D_a,D_b;e'),
$$
or with less an abuse of notation
$$
\delta(A,(d_a,d_b)_{A^{-1}};r,q;a_c,(a_a,a_b)_{A^{-1}};e)=(A',(d_a',d_b')_{A^{-1}};q';a_c',(a_a',a_b')_{A^{-1}};D_c,(D_a,D_b)_{A^{-1}};e'),
$$
though we shall prefer the former to reduce notational clutter. The parameters are as follows.

- $A\in\{1, -1\}$. This is a parameter that is implicitly used in our description to specify which underlying counter is active and which is recovering. We typically have $A'=A$, except when we want to swap which counter is active and which recovering, in which case we have $A'=-A$.
    - Hence we have written $(\cdot,\cdot)_{A^{-1}}$ since by right the input to $\delta$ are the physical order of the counter tapes, and not in order of which was active and which recovering. For notational clarity, we shall immediately forget that and abuse notation so that the active counter at time just before stepping always appears first (on the left) in both input and result.
- $d_a,d_b\in\{1,-1\}$ are parameters specifying the directionality of the active counter and recovering counter respectively. At initialization, $d_a=d_b=1$ that maps $C$ to $L$ and $G$ to $R$. Typically, $d_a'=d_a$, but we use $d_a'=-d_a'$ denote a change in directionality; and likewise for $d_b'=d_b$ and $d_b'=-d_b$.
- $r \in \{R,N,L\}$ denotes the direction that the host wishes the control tape head move in. At $Z_0$ it is illegal to move the head $L$.
- $q,q' \in Q$ denotes a state.
- $a_c\in\{B,Z_0,Z_u,Z_l\}$ denotes the symbol under the head of the control tape. $a_c'$ denotes the symbol to overprint in that position.
- $a_a,a_b\in\{0,1\}$ are the symbols under the active and recovering tapes. $a_a',a_b'$ are the symbols to overprint in those positions.
- $D_c,D_a,D_b\in\{C,N,G\}$ denote whether to move the head forward (typically, right), stay, or backward. The convention of forward being right and backward for left may be swapped for the counters by setting the respective $d_*=-1$.
- $e'\in\{B',B,Z_0,Z_u,Z_l\}$ denotes the symbol to put on the emit register. $B'$ is the blank symbol for the purpose of host-oracle communication, $B$ denotes a blank.

### Neutral symbol

Receiving a $N$ is a no-op.

$$
\begin{align*}
\delta(A,d_a,d_b;N,q;a_c,a_a,a_b;e)
&=(A,d_a,d_b;q;a_c,a_a,a_b;N,N,N;e).
\end{align*}
$$

### Initialization

The cocoro is initialized with $A=d_a=d_b=1$, state $q_i$, and emit register $Z_0$. At initialization, the first symbol received is specially handled.

$$
\begin{align*}
\delta(A,d_a,d_b;r,q;a_c,a_a,a_b;e)
&=(A',d_a',d_b';q';a_c',a_a',a_b';D_c,D_a,D_b;e') \\
\end{align*}
$$

### Stepping down 