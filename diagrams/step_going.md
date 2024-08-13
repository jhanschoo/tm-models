Start: $a$ is at $G_{1,u}$, and $b$ is at start of scratch containing half-zone data.

```mermaid
block-beta
    columns 14
    space:12
    a(("a"))
    space

    g3u["G3u"]
    space:3
    g2l["G2l"]
    space:3
    g2u["G2u"]
    space
    g1l["G1l"]
    space
    g1u["G1u"]
    g0l["G0l"]

    block:d3u:1
        c0n1[" "]
    end
    block:d2l:4
        d2n7["e"] d2n6["f"] d2n5["g"] d2n4["h"]
    end
    block:d2u:4
        d2n3[" "] d2n2[" "] d2n1[" "] d2n0[" "]
    end
    block:d1l:2
        d1n3["t"] d1n2["u"]
    end
    block:d1u:2
        d1n1["v"] d1n0["w"]
    end
    block:d0l:1
        d0n0[" "]
    end

    s0[" "] s1["y"] s2["x"] s3[" "] s4[" "] s5[" "]
    space:8

    space
    b(("b"))

    a-->g1u
    b-->s1
```

Step 1: Swap data in $G_{1,u}$ inclusive through $G_{2,u}$ exclusive.
$$
\begin{align*}
    \delta(q_s;Z_{u,e/h/f},\gamma_1,\gamma_2)
    &=(q_1;Z_{u,e/h/f},\gamma_2,\gamma_1;G,R) \\
    \delta(q_1;B,\gamma_1,\gamma_2)
    &=(q_1;B,\gamma_2,\gamma_1;G,R) \\
    \delta(q_1;Z_l,\gamma_1,\gamma_2)
    &=(q_1;Z_l,\gamma_2,\gamma_1;G,R)
\end{align*}
$$

```mermaid
block-beta
    columns 14

    space:8
    a1(("a1"))
    space:3
    a0(("a0"))
    space

    g3u["G3u"]
    space:3
    g2l["G2l"]
    space:3
    g2u["G2u"]
    space
    g1l["G1l"]
    space
    g1u["G1u"]
    g0l["G0l"]

    block:d3u:1
        c0n1[" "]
    end
    block:d2l:4
        d2n7["e"] d2n6["f"] d2n5["g"] d2n4["h"]
    end
    block:d2u:4
        d2n3[" "] d2n2[" "] d2n1[" "] d2n0[" "]
    end
    block:d1l:2
        d1n3[" "] d1n2[" "]
    end
    block:d1u:2
        d1n1["x"] d1n0["y"]
    end
    block:d0l:1
        d0n0[" "]
    end

    s0[" "] s1["w"] s2["v"] s3["u"] s4["t"] s5[" "]
    space:8

    space
    b0(("b0"))
    space:3
    b1(("b1"))

    a0-.->a1
    a1-->g2u
    b0-.->b1
    b1-->s5
```

Step 2: Move back to $G_{1,u}$ while moving $b$ back.
$$
\begin{align*}
    \delta(q_1;Z_{u,e/h/f},\gamma_1,\gamma_2)
    &=(q_2;Z_{u,e/h/f},\gamma_1,\gamma_2;C,L) \\
    \delta(q_2;B,\gamma_1,\gamma_2)
    &=(q_2;B,\gamma_2,\gamma_1;C,L) \\
    \delta(q_2;Z_l,\gamma_1,\gamma_2)
    &=(q_2;Z_l,\gamma_2,\gamma_1;C,L)
\end{align*}
$$

```mermaid
block-beta
    columns 14

    space:8
    a1(("a1"))
    space:3
    a2(("a2"))
    space

    g3u["G3u"]
    space:3
    g2l["G2l"]
    space:3
    g2u["G2u"]
    space
    g1l["G1l"]
    space
    g1u["G1u"]
    g0l["G0l"]

    block:d3u:1
        c0n1[" "]
    end
    block:d2l:4
        d2n7["e"] d2n6["f"] d2n5["g"] d2n4["h"]
    end
    block:d2u:4
        d2n3[" "] d2n2[" "] d2n1[" "] d2n0[" "]
    end
    block:d1l:2
        d1n3[" "] d1n2[" "]
    end
    block:d1u:2
        d1n1["x"] d1n0["y"]
    end
    block:d0l:1
        d0n0[" "]
    end

    s0[" "] s1["w"] s2["v"] s3["u"] s4["t"] s5[" "]
    space:8

    space
    b2(("b2"))
    space:3
    b1(("b1"))

    a1-.->a2
    a2-->g1u
    b1-.->b2
    b2-->s1
```

Step 3a: If $G_1$ was empty, update usage and move on to the next segment of the algorithm; typically recovery to $Z_0$.
$$
\begin{align*}
    \delta(q_2;Z_{u,e},\gamma_1,\gamma_2)
    &=(q_r;Z_{u,h},\gamma_1,\gamma_2;C,N)
\end{align*}
$$

Step 3b: If $G_1$ was half-empty, update usage, scan to $G_{1,l}$, swap to $G_{2,u}$, then move on to recovery.
$$
\begin{align*}
    \delta(q_2;Z_{u,h},\gamma_1,\gamma_2)
    &=(q_3;Z_{u,f},\gamma_1,\gamma_2;G,N) \\
    \delta(q_3;B,\gamma_1,\gamma_2)
    &=(q_3;B,\gamma_1,\gamma_2;G,N)
\end{align*}
$$

Step 4b: Move data from scratch from $G_{1,l}$ inclusive to $G_{2,u}$ exclusive.
$$
\begin{align*}
    \delta(q_3;Z_l,\gamma_1,\gamma_2)
    &=(q_4;Z_l,\gamma_2,B;G,R) \\
    \delta(q_4;B,\gamma_1,\gamma_2)
    &=(q_4;B,\gamma_2,B;G,R)
\end{align*}
$$

Step 5b: Recover to $G_{1,l}$ while moving $b$ back.
$$
\begin{align*}
    \delta(q_4;Z_{u,e/h/f},\gamma_1,\gamma_2)
    &=(q_5;Z_{u,e/h/f},\gamma_1,\gamma_2;C,L) \\
    \delta(q_5;B,\gamma_1,\gamma_2)
    &=(q_5;B,\gamma_1,\gamma_2;C,L) \\
    \delta(q_5;Z_l,\gamma_1,\gamma_2)
    &=(q_r;Z_l,\gamma_1,\gamma_2;C,N)
\end{align*}
$$

Step 3c: If $G_1$ was full, update usage, scan to $G_{2,u}$, and recurse.
$$
\begin{align*}
    \delta(q_2;Z_{u,f},\gamma_1,\gamma_2)
    &=(q_6;Z_{u,h},\gamma_1,\gamma_2;G,N) \\
    \delta(q_6;B,\gamma_1,\gamma_2)
    &=(q_6;B,\gamma_1,\gamma_2;G,N) \\
    \delta(q_6;Z_l,\gamma_1,\gamma_2)
    &=(q_6;Z_l,\gamma_1,\gamma_2;G,N) \\
    \delta(q_6;Z_{u,e/h/f},\gamma_1,\gamma_2)
    &=(q_1;Z_{u,e/h/f},\gamma_2,\gamma_1;G,R)
\end{align*}
$$

Step recovery: We list the rules that recover the head to $Z_0$
$$
\begin{align*}
    \delta(q_r;Z_0,\gamma_1,\gamma_2)
    &=\dots \\
    \delta(q_r;B,\gamma_1,\gamma_2)
    &=(q_r;B,\gamma_1,\gamma_2;C,N) \\
    \delta(q_2;Z_{u,e/h/f},\gamma_1,\gamma_2)
    &=(q_2;Z_{u,e/h/f},\gamma_1,\gamma_2;C,L) \\
    \delta(q_r;Z_l,\gamma_1,\gamma_2)
    &=(q_r;Z_l,\gamma_1,\gamma_2;C,N)
\end{align*}
$$

