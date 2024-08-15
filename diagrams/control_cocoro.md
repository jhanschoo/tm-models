# control_cocoro

This document describes the virtualization of the control tape for $O(n \lg n)$ as a cocoro.

## Background definitions

We first reiterate some definitions in a non-precise, general manner. A kTM ocoro $O$ belonging to a host $M$ is specified as kTM with the following modifications. In addition to the tapes, it contains an emit function that maps its (state, head)-projected configuration to a symbol from an alphabet, where $H$ contains a distinguished element $B$. We say that the emit register of $O$ contains that symbol. The emit register hence partitions the (state, head)-projected configuration that the host should have access to. Next, from the internal view, the transition function $\delta_O$ is augmented by an additional argument where the value is an element of a fixed alphabet $P$; this is the symbol in the send register of the host. One symbol of $P$ is distinguished as the blank symbol $B$. Furthermore, $\delta_O$ satisfies the consistency guarantee that if a (state, head)-projected configuration is mapped by the emit function to a $B$ symbol, then $\delta_O$ is constant within that configuration, regardless of the host's send register value; we may say that $\delta_O$ ignores the send register.

This leads us to the external view. From the perspective of the host, the ocoro $O$'s emits behaves like its many tapes (and states), albeit with the emit symbol instead of an (overprint, direction) tuple. The host maintains a send register containing a non-blank symbol in $H$, again with the symbol defined as a function of the (state, head, emit register)-projected configuration of the host. The transition function $\delta$, in addition to the usual mappings, takes the send register as an argument, and implicitly, the ocoro definition and full configuration. Its return is augmented with a non-blank symbol from $H$, as well as another configuration for $O$; only the emit register is accessible, whereas the configuration remains "inaccessible" from the host in the sense that $\delta$ must maintain the following consistency between the input and output oracle configurations.

The function $\delta$ satisfies the consistency guarantee that the input configuration of the ocoro and the output configuration of the ocoro are separated by a positive integral number of steps where the input is that of the send register of the host, and the emit register returned by all but the last step is blank, and the emit register on the last step is exactly the one that is returned by $\delta$.

A **cocoro** is a kTM ocoro where some integer $N$ bound exists such that every $N$ consecutive steps must contain a step that emits a non-blank symbol.

## High-level description

The **control cocoro** dynamically emulates an immutable version of the control tape used in the $O(n \lg n)$ efficient UTM. It uses three tapes, with their roles and invariants as follows. We use $Z_0$, $Z_{1}$, ... to refer to the zones from the simulated head to the current head, when we do not want to specify whether it is on the left half-tape or the right half-tape. We use $Z_{i,u}$ and $Z_{i,l}$ to refer to the upper and lower half-zones of zone $Z_i$.

- The **control tape** (CT) is a copy of the virtual control tape that the host sees, that is filled in at least from $Z_0$ through the current head position. The primary role of the control tape is to manage recovery of the head back to $Z_0$ after it has gone down the tape, but it simplifies reasoning in general.
- The following tapes form the **active counter** (AC) and **recovering counter** (RC). The tapes swap roles as we move from one zone to another. The tapes are also associated with a **direction** which flips between zones and half-zones. Both tapes are binary, either blank or filled-in, and the filled-in cells of each tape, if present, form a contiguous region of the tape such that the head is always within the contiguous region or in a neighboring cell of the contiguous region.
- In addition to the aforementioned properties, the **active counter** (AC) maintains the following invariants, except at $Z_0$ and $Z_{1,u}$, and when doing constant-time cleanup.
  - When the control tape is in an upper half-zone
    - the size of the filled-in region is the size of the half-zone that the control tape's head is in.
    - The head's index counting from the start of the filled-in region wrt the current direction is exactly the index of the control tape's head wrt the start of the half-zone it is in.
  - When the control tape is in a lower half-zone
    - the size of the filled-in region is the size of the region from the last cell of the half-zone the control tape is in to the current cell containing the head, inclusive.
    - The head is at the first filled-in cell of the tape (wrt current direction).
- In addition to the aforementioned properties, the **recovering counter** (RC) maintains the following invariants, except at $Z_0$, and when doing constant-time cleanup.
  - The size of the filled-in region is the size of the region from the first cell of the zone the control tape is in to the current cell containing the head, inclusive.
  - The head is located at the last (wrt current direction) filled-in cell on the tape.

## Algorithm

### Form of the transition function

Because of the size of the input and output parameters and the fact that we are typically unconcerned in most parameters for any given rule, we borrow notation from probability to describe our transition function $\delta$.

The input and output of $\delta$ are specified as follows. We have
$$
\delta(a,d_0,d_{1},d_{-1};\rho,\kappa;\gamma_0,\gamma_1,\gamma_{-1})=(a',d_0',d_{1}',d_{-1}';\kappa';\gamma_0',\gamma_{1}',\gamma_{-1}';D_0,D_{1},D_{-1}).
$$
At least notationally, we should see $\delta$ as a function on rv's, each other symbol on the LHS as a rv, and each symbol on the RHS as a function on those same rv's. We write
$$
\begin{align*}
  s=&(a'=a,d_0'=d_0,d_1'=d_1,d_{-1}'=d_{-1}; \\
  &\qquad\kappa'=\kappa;\\
  &\qquad\gamma_0'=\gamma_0,\gamma_1'=\gamma_1,\gamma_{-1}'=\gamma_{-1};\\
  &\qquad D_c=1,D_a=1,D_b=1).
\end{align*}
$$
and, modify it, for example, with
$$
\begin{align*}
  s[\gamma_0'=B]=&(a'=a,d_0'=d_0,d_1'=d_1,d_{-1}'=d_{-1}; \\
  &\qquad\kappa'=\kappa;\\
  &\qquad\gamma_0'=B,\gamma_1'=\gamma_1,\gamma_{-1}'=\gamma_{-1};\\
  &\qquad D_c=0,D_a=0,D_b=0).
\end{align*}
$$


- $a\in\{1, -1\}$. This is a parameter that is implicitly used in our description to specify which underlying counter is active and which is recovering. We typically have $A'=A$, except when we want to swap which counter is active and which recovering, in which case we have $A'=-A$.
- $d_0,d_1,d_{-1}\in\{1,-1\}$ are parameters specifying the directionality of the tapes, since for counters we typically specify rules with $D_k=d_k$ to move forward on tape $k$, and $D_k=-d_k$ to move backward on tape $k$.
  - $d_0$ is somewhat differently used than $d_{1},d_{-1}$.
- $\rho=\{B\}\cup(\rho_0\times\rho_1)$ is the input from the host, where $B$ is the blank symbol.
- $\rho_0 \in \{Z_{u,e},Z_{u,h},Z_{u,f}\}$ denotes the control symbol the host wishes to write to the upper-half-zone markers (if relevant). We shall write $Z_{u,*}$ to refer to these symbols and their corresponding symbols in the output.
- $\rho_1 \in \{1,0,-1\}$ denotes the direction that the host wishes the control tape head move in. We may take $1$ to refer to moving right, $0$ to staying, and $-1$ to moving left.
- $\kappa,\kappa' \in Q$ denotes a state.
- $\gamma_0\in\{B,Z_0,Z_u,Z_l\}$ denotes the symbol under the head of the control tape. $\gamma_0'$ denotes the symbol to overprint in that position.
- $\gamma_1,\gamma_{-1}\in\{0,1\}$ are the symbols under the AC and RC heads. $\gamma_{1}',\gamma_{-1}'$ are the symbols to overprint in those positions. We typically do not specify them directly but in respect to which is currently the AC as $\gamma_a$ and $\gamma_{-a}$
- $D_0,D_{1},D_{-1}\in\{1,0,-1\}$ denote which direction to move the respective tape heads.

### Invariants

We say that the invariant $I_0$ is satisfied if
- The state is $\kappa=q_{0}$.
- The CT head is at $Z_0$ and sees either of $\gamma_0=B,Z_0$.
- Both counter tapes are empty, hence $\gamma_1=\gamma_{-1}=0$.


For nonnegative integer $i$, we say that the invariant $I_{i,u}[0]$ is satisfied if
- The state is $\kappa=q_u$.
- The CT head sees $Z_{u,*}$, and is at $Z_{i,u}[0]$. Furthermore, the zone markers from $Z_0$ through $Z_{i,u}$ are filled in, and the other cells in these zones are $B$.
- The AC's filled-in cells form a contiguous region of $|Z_{i,u}|$ cells with the head at the initial cell of the region wrt the direction $d_a$.
- The RC contains $1$ filled-in cell with the head on it.

For nonnegative integer $i$, and $j\in\{1,\ldots,|Z_{i,u}|-1\}$, we say that the invariant $I_{i,u}[j]$ is satisfied if
- The state is $\kappa=q_u$.
- The CT head sees $B$, and is at $Z_{i,u}[j]$. Furthermore, the zone markers from $Z_0$ through $Z_{i,u}$ are filled in, and the other cells in these zones are $B$.
- The AC's filled-in cells form a contiguous region of $|Z_{i,u}|$ cells with the head at the $j$-th (0-indexed) cell of the region wrt the direction $d_a$.
- The RC contains $j+1$ filled-in cells forming a contiguous region with the head on the last cell of the region wrt the direction $d_{-a}$.

For nonnegative integer $i$, we say that the invariant $I_{i,l}[0]$ is satisfied if
- The state is $\kappa=q_l$.
- The CT head sees $Z_{l}$, and is at $Z_{i,l}[0]$. Furthermore, the zone markers from $Z_0$ through $Z_{i,l}$ are filled in, and the other cells in these zones are $B$.
- The AC's filled-in cells form a contiguous region of $|Z_{i,l}|$ cells with the head at the $0$-th (0-indexed) cell of the region wrt the direction $d_a$.
- The RC contains $|Z_{i,u}|+1$ filled-in cells forming a contiguous region with the head on the last cell of the region wrt the direction $d_{-a}$.

For nonnegative integer $i$, and $j\in\{1,\ldots,|Z_{i,l}|-1\}$, we say that the invariant $I_{i,l}[j]$ is satisfied if
- The state is $\kappa=q_l$.
- The CT head sees $B$, and is at $Z_{i,l}[j]$. Furthermore, the zone markers from $Z_0$ through $Z_{i,l}$ are filled in, and the other cells in these zones are $B$.
- The AC's filled-in cells form a contiguous region of $|Z_{i,u}| - j$ cells with the head at the initial cell of the region wrt the direction $d_a$.
- The RC contains $|Z_{i,u}|+j+1$ filled-in cells forming a contiguous region with the head on the last cell of the region wrt the direction $d_{-a}$.

It is clear that given $(\kappa,\gamma_0)$, at most one of the 5 classes (ranging across $j$) of invariants can be satisfied. It is also clear that at most one of the invariants can be satisfied. We shall ensure with our operation of the cocoro that when $\kappa=q_*$, at least one of the invariants are satisfied. The emit function is correspondingly

- when $\kappa=q_{0}$, emit $Z_0$,
- if $\kappa=q_{u},q_{l}$, emit $\gamma_0$.
- otherwise, emit $B'$, the distinguished blank symbol, signalling incomplete computation.

We now name a specialization of $I_0$. If $I_0$ holds, and additionally $\gamma_0=Z_0$, we say that $I_0'$ is satisfied.

### Initial state

At initialization,
- The state is $q_{Z_0}$.
- The state registers are $a=d_0=d_1=d_2=1$.
- The tapes are all blank (having the symbol $B$),

hence $I_0$ is satisfied.

### Neutral input

Receiving a $\rho=0$ is a no-op, except perhaps for overprinting a $Z_{u,*}$.

$$
\begin{align*}
\delta[\rho_1=0;\gamma_0=Z_{u,*}]&=s[\gamma_0'=\rho_0] \\
\delta[\rho_1=0;\gamma_0\neq Z_{u,*}]&=s.
\end{align*}
$$

### Moving away from $Z_0$.

#### Step 1

##### Precondition

- The input has $\rho_1=1,-1$.
- Invariant $I_0$ is satisfied, and we may assume this simply from $\kappa=q_0$.

##### Action

- Initialize the CT at $Z_0$ to $Z_0$.
- Initialize AC, RC heads to $1$.
- Initialize the forward direction of the CT head based on $\rho_1$ (which side of the tape it is going to go).
- Move the CT head forward.
- Transition to an intermediate state $p_{Z_u,1}$.

$$
\begin{align*}
\delta[\rho_1=1,-1;\kappa=q_{0}]&=s[d_0'=D_0=\rho_1;\kappa'=p_{0,1};\gamma_0'=Z_0;\gamma_1'=\gamma_{-1}'=1].
\end{align*}
$$

##### Postcondition

- Invariant $I_{1,u}[0]$ is satisfied, except that
  - The state is $\kappa=p_{0,1}$.
  - The CT head sees one of $\gamma_0=B,Z_{u,*}$.

#### Step 2

##### Precondition

- Invariant $I_{1,u}[0]$ is satisfied, except that
  - The state is $\kappa=p_{Z_0,1}$.
  - The CT head sees one of $\gamma_0=B,Z_{u,*}$.

##### Action

- Transition the state to $q_u$.
- If not already initialized, and this is the first time we are entering $L_{u}$ or $R_{u}$ (henceforth $Z_u$), initialize it to $Z_{u,h}$ as half-used.

$$
\begin{align*}
\delta[\kappa=p_{Z_0,1};\gamma_0=B]&=s[\kappa'=q_u;\gamma_0'=Z_{u,h}], \\
\delta[\kappa=p_{Z_0,1};\gamma_0=Z_{u,*}]&=s[\kappa'=q_u].
\end{align*}
$$

##### Postcondition

- Invariant $I_{1,u}[0]$ is satisfied.

### Stepping forward in the upper half

#### Step 1

##### Precondition

- The input is $d_0\rho_1=1$.
- Invariant $I_{i,u}[j]$ is satisfied for some nonnegative $i,j$, and we may assume this simply from $\kappa=q_u$.

##### Action

- If the CT head is at $Z_{i,u}[0]$, overprint the input symbol.
- Move the the CT head in the direction $D_0=\rho_1$.
- Move both AC, RC heads in $D_i=d_i$.
- Transition to an intermediate state $p_{u,1}$.

$$
\begin{align*}
\delta[\rho_1=d_0;\kappa=q_{u};\gamma_0=Z_{u,*}]&=s[\kappa'=p_{u,1};\gamma_0'=\rho_0;D_0=\rho_1;D_1=d_1;D_{-1}=d_{-1}], \\
\delta[\rho_1=d_0;\kappa=q_{u};\gamma_0=B]&=s[\kappa'=p_{u,1};D_0=\rho_1;D_1=d_1;D_{-1}=d_{-1}].
\end{align*}
$$

##### Postcondition

Either that
- invariant $I_{i,u}[j+1]$ is satisfied except that
  - state $\kappa=p_{u,1}$,
  - the cell under the RC head is $0$;
- or invariant $I_{i,l}[0]$ is satisfied except that
  - state $\kappa=p_{u,1}$,
  - we have $\gamma_0=Z_l,B$,
  - the direction of $d_a$ is flipped,
  - the head is one cell behind from where it should be,
  - the cell under the RC head is $0$;

and we can distinguish between the two by the value of $\gamma_a$.

#### Case A Step 2

##### Precondition

- Invariant $I_{i,u}[j+1]$ is satisfied except that
  - state $\kappa=p_{u,1}$,
  - the cell under the RC head is $0$.

##### Action

- Transition back to $q_u$.
- Overprint $1$ on the RC head.

$$
\begin{align*}
\delta[\kappa=p_{u,1};\gamma_a=1]&=s[\kappa'=q_u;\gamma_{-a}'=1].
\end{align*}
$$

##### Postcondition

- invariant $I_{i,u}[j+1]$ is satisfied.

#### Case B Step 2

##### Precondition

- Invariant $I_{i,l}[0]$ is satisfied except that
  - state $\kappa=p_{u,1}$,
  - we have $\gamma_0=Z_l,B$,
  - the direction of $d_a$ is flipped,
  - the head of AC is one cell behind from where it should be
  - the cell under the RC head is $0$;

##### Action

- Transition to $q_l$.
- Overprint $\gamma_0'=Z_l$, $\gamma_{-a}'=1$.
- Move $D_a=-d_a$,
- flip $d_a$.

$$
\begin{align*}
\delta[\kappa=p_{u,1};\gamma_a=0]&=s[d_a'=-d_a;\kappa'=q_l;\gamma_0'=Z_l;\gamma_{-a}'=1;D_a=-d_a].
\end{align*}
$$

##### Postcondition

- invariant $I_{i,l}[0]$ is satisfied.

### Stepping forward in the lower half

#### Step 1

##### Precondition

- The input is $d_0\rho_1=1$.
- Invariant $I_{i,l}[j]$ is satisfied for some nonnegative $i,j$, and we may assume this simply from $\kappa=q_l$.

##### Action

- Move the the CT head in the direction $D_0=\rho_1$.
- Erase the cell under AC, then
- Move both AC, RC heads in $D_i=d_i$.
- Transition to an intermediate state $p_{l,1}$.

$$
\begin{align*}
\delta[\rho_1=d_0;\kappa=q_{l}]&=s[\kappa'=p_{l,1};\gamma_a=0;D_0=\rho_1;D_1=d_1;D_{-1}=d_{-1}].
\end{align*}
$$

##### Postcondition

Either that
- invariant $I_{i,l}[j+1]$ is satisfied except that
  - state $\kappa=p_{l,1}$,
  - the cell under the RC head is $0$;
- or invariant $I_{i,u}[0]$ is satisfied except that
  - state $\kappa=p_{l,1}$,
  - we have $\gamma_0=Z_{u,*},B$,
  - $a$ is flipped,
  - the direction of $d_a$ is flipped,
  - the head of AC is one cell behind from where it should be,
  - the RC tape is blank

and we can distinguish between the two by the value of $\gamma_a$.

#### Case A Step 2

##### Precondition

- Invariant $I_{i,l}[j+1]$ is satisfied except that
  - state $\kappa=p_{l,1}$,
  - the cell under the RC head is $0$.

##### Action

- Transition back to $q_l$.
- Overprint $1$ on the RC head.

$$
\begin{align*}
\delta[\kappa=p_{l,1};\gamma_a=1]&=s[\kappa'=q_u;\gamma_{-a}'=1].
\end{align*}
$$

##### Postcondition

- invariant $I_{i,l}[j+1]$ is satisfied.

#### Case B Step 2

##### Precondition

- Invariant $I_{i+1,u}[0]$ is satisfied except that
  - state $\kappa=p_{l,1}$,
  - we have $\gamma_0=Z_{u,*},B$,
  - $a$, the indicator of which counter is AC and which RC is flipped,
  - the direction of $d_a$ is flipped,
  - the head of AC is one cell behind from where it should be,
  - the RC tape is blank

##### Action

- Transition to $q_u$.
- If $\gamma_0=B$, initialize to $\gamma_0'=Z_{u,h}$.
- Flip $a$.
- Overprint $\gamma_a'=1$.
- Move $D_{-a}=-d_a$.
- Flip $d_{-a}$.

$$
\begin{align*}
\delta[\kappa=p_{l,1};\gamma_0=Z_{u,*};\gamma_a=0]&=s[a'=-a;d_{-a}'=-d_{-a};\kappa'=q_u;\gamma_{a}'=1;D_a=-d_a], \\
\delta[\kappa=p_{l,1};\gamma_0=B;\gamma_a=0]&=s[a'=-a;d_{-a}'=-d_{-a};\kappa'=q_u;\gamma_0'=Z_{u,h};\gamma_{a}'=1;D_a=-d_a], \\
\end{align*}
$$

##### Postcondition

- invariant $I_{i+1,u}[0]$ is satisfied.

### Stepping backward in the upper half

#### Case A Step 1

##### Precondition

- The input is $d_0\rho_1=-1$.
- Invariant $I_{i,u}[j]$ is satisfied for some nonnegative $i$ and positive $j$, and we may assume this simply from $\kappa=q_u$ and $\gamma_0=B$.

##### Action

- Move the the CT head in the direction $D_0=\rho_1$.
- Erase the cell under the RC.
- Move both AC, RC heads in $D_i=-d_i$.

$$
\begin{align*}
\delta[\rho_1=-d_0;\kappa=q_{u};\gamma_0=B]&=s[\gamma_{-a}'=0;D_0=\rho_1;D_1=-d_1;D_{-1}=-d_{-1}].
\end{align*}
$$

##### Postcondition

- Invariant $I_{i,u}[j-1]$ is satisfied.

#### Cases B, C Step 1

##### Precondition

- The input is $d_0\rho_1=-1$.
- Invariant $I_{i,u}[0]$ is satisfied for some nonnegative $i$, and we may assume this simply from $\kappa=q_u$ and $\gamma_0=Z_{u,*}$.

##### Action

- Overprint the CT with the input $\gamma_0=\rho_0$, and move the CT head in the direction $D_0=\rho_1$.
- Transition the state to $p_{u,-1}$.

$$
\begin{align*}
\delta[\rho_1=-d_0;\kappa=q_{u};\gamma_0=Z_{u,*}]&=s[\gamma_0'=\rho_0;D_0=\rho_1].
\end{align*}
$$

##### Postcondition

Either that
- invariant $I_{0}'$ is satisfied except that
  - state $\kappa=p_{u,-1}$,
  - the AC and RC both contain one filled-in cell under the head
- or invariant $I_{i-1,l}[|Z_{i-1,l}|-1]$ is satisfied except that
  - state $\kappa=p_{u,-1}$,
  - $a$ is flipped,
  - the direction of $d_{-a}$ is flipped,

and we can distinguish between the two by the value of $\gamma_0$.

#### Case B Step 2

##### Precondition

- Invariant $I_{0}'$ is satisfied except that
  - state $\kappa=p_{u,-1}$,
  - the AC and RC both contain one filled-in cell under the head

##### Action

- Transition to $q_0$.
- Erase under both AC and RC.

$$
\begin{align*}
\delta[\kappa=p_{u,-1};\gamma_0=Z_0]&=s[\kappa'=q_0;\gamma_{1}'=\gamma_{-1}'=0].
\end{align*}
$$

##### Postcondition

- invariant $I_{0}'$ is satisfied.

#### Case C Step 2

##### Precondition

- Invariant $I_{i-1,l}[|Z_{i-1,l}|-1]$ is satisfied except that
  - state $\kappa=p_{u,-1}$,
  - $a$ is flipped,
  - the direction of $d_{-a}$ is flipped,

##### Action

- Transition to $q_l$.
- Flip $a$.
- Flip $d_a$.

$$
\begin{align*}
\delta[\kappa=p_{u,-1};\gamma_0= Z_l,B]&=s[a=-a;d_a'=-d_a;\kappa'=q_l].
\end{align*}
$$

##### Postcondition

- Invariant $I_{i-1,l}[|Z_{i-1,l}|-1]$ is satisfied.

### Stepping backward in the lower half

#### Case A Step 1

##### Precondition

- The input is $d_0\rho_1=-1$.
- Invariant $I_{i,l}[j]$ is satisfied for some nonnegative $i$ and positive $j$, and we may assume this simply from $\kappa=q_l$ and $\gamma_0=B$.

##### Action

- Transition to $p_{l,-1}$
- Move the the CT head in the direction $D_0=\rho_1$.
- Erase the cell under RC, then
- Move both AC, RC heads in $D_i=-d_i$.

$$
\begin{align*}
\delta[\rho_1=-d_0;\kappa=q_{l};\gamma_0=B]&=s[\gamma_{-a}=0;\kappa'=p_{l,-1};D_0=\rho_1;D_1=-d_1;D_{-1}=-d_{-1}].
\end{align*}
$$

##### Postcondition

- Invariant $I_{i,l}[j-1]$ is satisfied except that
  - state $\kappa=p_{l,-1}$,
  - the cell under the AC head is $0$;

#### Case A Step 2

##### Precondition

- Invariant $I_{i,l}[j-1]$ is satisfied except that
  - state $\kappa=p_{l,-1}$,
  - the cell under the AC head is $0$.

##### Action

- Transition back to $q_l$.
- Overprint $1$ on the AC head.

$$
\begin{align*}
\delta[\kappa=p_{l,-1};\gamma_{-a}=0]&=s[\kappa'=q_u;\gamma_{a}'=1].
\end{align*}
$$

##### Postcondition

- invariant $I_{i,l}[j-1]$ is satisfied.

#### Case B Step 1

##### Precondition

- The input is $d_0\rho_1=-1$.
- Invariant $I_{i,l}[0]$ is satisfied for some nonnegative $i$, and we may assume this simply from $\kappa=q_l$ and $\gamma_0=Z_l$.

##### Action

- Transition to $q_u$.
- Move $D_0=\rho_1$.
- Flip $d_{a}$.
- Erase the RC head's cell.
- Move the RC head $D_{-a}=-d_{-a}$.

$$
\begin{align*}
\delta[\rho_1=-d_0;\kappa=q_{l};\gamma_0=Z_{l}]&=s[d_{a}'=-d_{a};\kappa'=q_u;\gamma_{-a}'=0;D_0=\rho_1;D_{-a}=-d_{-a}].
\end{align*}
$$

##### Postcondition

- invariant $I_{i,u}[|Z_{i,u}|-1]$ is satisfied.

