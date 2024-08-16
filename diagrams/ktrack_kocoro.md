# ktape_kocoro

This document describes the virtualization of a $k$-track for $O(n \lg n)$ as a $k$-ocoro, where $k$ is configured in some initialization phase prior to simulation.

## Background definitions

A $k'$-**ocoro** is a kTM ocoro where some integer $N$ bound exists such that every $Nk'$ consecutive steps must contain a step that emits a non-blank symbol.

### Form of the transition function

Because of the size of the input and output parameters and the fact that we are typically unconcerned in most parameters for any given rule, we borrow notation from probability to describe our transition function $\delta$.

The input and output of $\delta$ are specified as follows. We have
$$
\delta(\rho,\kappa;\gamma_d,\gamma_c)=(\kappa';\gamma_d,\gamma_c;D_d,D_{c}).
$$
At least notationally, we should see $\delta$ as a function on rv's, each other symbol on the LHS as a rv, and each symbol on the RHS as a function on those same rv's. We write
$$
\begin{align*}
  s=(\kappa'&=\kappa;\\
  \gamma_d'&=\gamma_d,\gamma_c'=\gamma_c;\\
  D_d&=0,D_c=0).
\end{align*}
$$
and, modify it, for example, with
$$
\begin{align*}
  s[\gamma_d'=0]=(\kappa'&=\kappa;\\
  \gamma_d'&=0,\gamma_c'=\gamma_c;\\
  D_d&=0,D_c=0).
\end{align*}
$$


- $\rho=\{B, L, R, N, D, U\}$ is the input from the host, where $B$ is the blank symbol.
- $\kappa,\kappa' \in Q$ denotes a state.
- $\gamma_d\in\{0,1\}$.
- $\gamma_c\in\{0,1, 2\}$.
- $D_d,D_{c}\in\{-1,0,1\}$ denote which direction to move the respective tape heads.

### Initial state

At initialization,
- The state is $q_{i}$.
- The tapes are all blank (having the symbol $0$),

### Initialization

$$
\begin{align*}
\delta[\rho=D;\kappa=q_i]&=s[\gamma_c'=1;D_c=-1] \\
\delta[\rho=N;\kappa=q_i]&=s[\kappa'=q_0;D_c=1].
\end{align*}
$$

It is an error to input $\rho=N$ before any $\rho=D$.

### Neutral input

Receiving a $\rho=N$ is a no-op after initialization.

$$
\begin{align*}
\delta[\kappa=q_0;\rho=N]&=s.
\end{align*}
$$

### Moving $D$

$$
\begin{align*}
\delta[\kappa=q_0;\rho=D]&=s[\kappa'=p_{D,1};D_d=D_c=1], \\
\delta[\kappa=p_{D,1};\gamma_c=1]&=s[\kappa'=q_0], \\
\delta[\kappa=p_{D,1};\gamma_c=0]&=s[\kappa'=p_{D,2},D_d=D_c=-1], \\
\delta[\kappa=p_{D,2};\gamma_c=1]&=s[D_d=D_c=-1], \\
\delta[\kappa=p_{D,2};\gamma_c=0]&=s[D_d=D_c=1].
\end{align*}
$$

### Moving $U$

$$
\begin{align*}
\delta[\kappa=q_0;\rho=U]&=s[\kappa'=p_{U,1};D_d=D_c=-1], \\
\delta[\kappa=p_{U,1};\gamma_c=1]&=s[\kappa'=q_0], \\
\delta[\kappa=p_{U,1};\gamma_c=0]&=s[\kappa'=p_{U,2},D_d=D_c=1], \\
\delta[\kappa=p_{U,2};\gamma_c=1]&=s[D_d=D_c=1], \\
\delta[\kappa=p_{U,2};\gamma_c=0]&=s[D_d=D_c=-1].
\end{align*}
$$

### Moving $R$

$$
\begin{align*}
\delta[\kappa=q_0;\rho=R]&=s[\kappa'=p_{R,1};\gamma_c=2;D_d=D_c=1], \\
\delta[\kappa=p_{R,1};\gamma_c=1]&=s[D_d=D_c=1], \\
\delta[\kappa=p_{R,1};\gamma_c=0]&=s[\kappa'=p_{R,2};D_d=D_c=-1], \\
\delta[\kappa=p_{R,2};\gamma_c=1,2]&=s[D_d=D_c=-1], \\
\delta[\kappa=p_{R,2};\gamma_c=0]&=s[\kappa'=p_{R,3};D_d=D_c=1], \\
\delta[\kappa=p_{R,3};\gamma_c=1]&=s[D_d=D_c=1], \\
\delta[\kappa=p_{R,3};\gamma_c=2]&=s[\kappa'=q_0].
\end{align*}
$$

### Moving $L$

$$
\begin{align*}
\delta[\kappa=q_0;\rho=L]&=s[\kappa'=p_{L,1};\gamma_c=2;D_d=D_c=-1], \\
\delta[\kappa=p_{L,1};\gamma_c=1]&=s[D_d=D_c=-1], \\
\delta[\kappa=p_{L,1};\gamma_c=0]&=s[\kappa'=p_{L,2};D_d=D_c=1], \\
\delta[\kappa=p_{L,2};\gamma_c=1,2]&=s[D_d=D_c=1], \\
\delta[\kappa=p_{L,2};\gamma_c=0]&=s[\kappa'=p_{L,3};D_d=D_c=-1], \\
\delta[\kappa=p_{L,3};\gamma_c=1]&=s[D_d=D_c=-1], \\
\delta[\kappa=p_{L,3};\gamma_c=2]&=s[\kappa'=q_0].
\end{align*}
$$