# Step_Coming

This document illustrates the algorithm executed in the first part of a simulated step in the $O(n \lg n)$ simulation.

Start: the head $a$ scans down the tape looking for a non-empty zone.

$$
\begin{align*}
    \delta(q_{?};Z_{0},\gamma_1,\gamma_2)
    &=(q_s;Z_{0},\gamma_1,\gamma_2;C,N) \\
    \delta(q_s;B,\gamma_1,\gamma_2)
    &=(q_s;B,\gamma_1,\gamma_2;C,N) \\
    \delta(q_s;Z_{u,e},\gamma_1,\gamma_2)
    &=(q_s;Z_{u,e},\gamma_1,\gamma_2;C,N) \\
    \delta(q_s;Z_{l},\gamma_1,\gamma_2)
    &=(q_s;Z_{l},\gamma_1,\gamma_2;C,N)
\end{align*}
$$

```mermaid
block-beta
    columns 14
    space:5
    a(("a"))
    space:8
    c0l["C0l"]
    c1u["C1u"]
    space
    c1l["C1l"]
    space
    c2u["C2u"]
    space:3
    c2l["C2l"]
    space:3
    c3u["C3u"]
    block:d0l:1
        c0n1[" "]
    end
    block:d1u:2
        d1n0[" "]
        d1n1[" "]
    end
    block:d1l:2
        d1n2[" "]
        d1n3[" "]
    end
    block:d2u:4
        d2n0["a"]
        d2n1["b"]
        d2n2["c"]
        d2n3["d"]
    end
    block:d2l:4
        d2n4["e"]
        d2n5["f"]
        d2n6["g"]
        d2n7["h"]
    end
    block:d3u:1
        d3n0["t"]
    end

    s0[" "]
    s1[" "]
    s2[" "]
    s3[" "]
    s4[" "]
    s5[" "]
    space:8

    space
    b(("b"))

    a-->c2u
    b-->s1
```

Part 0: Update $C_{2,u}$ to remove half its capacity, and continue scanning down.
$$
\begin{align*}
    \delta(q_s;Z_{u,f},\gamma_1,\gamma_2)
    &=(q_0;Z_{u,h},\gamma_1,\gamma_2;C,N) \\
    \delta(q_s;Z_{u,h},\gamma_1,\gamma_2)
    &=(q_0;Z_{u,e},\gamma_1,\gamma_2;C,N)
\end{align*}
$$

```mermaid
block-beta
    columns 14
    space:5
    a(("a"))
    a0(("a0"))
    space:7
    c0l["C0l"]
    c1u["C1u"]
    space
    c1l["C1l"]
    space
    c2u["C2u"]
    space:3
    c2l["C2l"]
    space:3
    c3u["C3u"]
    block:d0l:1
        c0n1[" "]
    end
    block:d1u:2
        d1n0[" "]
        d1n1[" "]
    end
    block:d1l:2
        d1n2[" "]
        d1n3[" "]
    end
    block:d2u:4
        d2n0["a"]
        d2n1["b"]
        d2n2["c"]
        d2n3["d"]
    end
    block:d2l:4
        d2n4["e"]
        d2n5["f"]
        d2n6["g"]
        d2n7["h"]
    end
    block:d3u:1
        d3n0["t"]
    end

    s0[" "]
    s1[" "]
    s2[" "]
    s3[" "]
    s4[" "]
    s5[" "]
    space:8

    space
    b0(("b0"))

    a-.->a0
    a-->c2u
    a0-->d2n1
    b0-->s1
```

Part 1: Scan $a$ down to $C_{2,l}$.
$$
\begin{align*}
    \delta(q_0;B,\gamma_1,\gamma_2)
    &=(q_0;B,\gamma_1,\gamma_2;C,N)
\end{align*}
$$

```mermaid
block-beta
    columns 14
    space:6
    a0(("a0"))
    space:2
    a1(("a1"))
    space:4
    c0l["C0l"]
    c1u["C1u"]
    space
    c1l["C1l"]
    space
    c2u["C2u"]
    space:3
    c2l["C2l"]
    space:3
    c3u["C3u"]
    block:d0l:1
        c0n1[" "]
    end
    block:d1u:2
        d1n0[" "]
        d1n1[" "]
    end
    block:d1l:2
        d1n2[" "]
        d1n3[" "]
    end
    block:d2u:4
        d2n0["a"]
        d2n1["b"]
        d2n2["c"]
        d2n3["d"]
    end
    block:d2l:4
        d2n4["e"]
        d2n5["f"]
        d2n6["g"]
        d2n7["h"]
    end
    block:d3u:1
        d3n0["t"]
    end

    s0[" "]
    s1[" "]
    s2[" "]
    s3[" "]
    s4[" "]
    s5[" "]
    space:8

    space
    b1(("b1"))

    a0-.->a1
    a1-->c2l
    b1-->s1
```

Part 2: Move data in $C_{2,l}$ inclusive through $C_{3,u}$ exclusive to scratch.
$$
\begin{align*}
    \delta(q_0;Z_l,\gamma_1,\gamma_2)
    &=(q_1;Z_l,B,\gamma_1;C,R) \\
    \delta(q_1;B,\gamma_1,\gamma_2)
    &=(q_1;B,B,\gamma_1;C,R)
\end{align*}
$$

```mermaid
block-beta
    columns 14
    space:9
    a1(("a1"))
    space:3
    a2(("a2"))
    c0l["C0l"]
    c1u["C1u"]
    space
    c1l["C1l"]
    space
    c2u["C2u"]
    space:3
    c2l["C2l"]
    space:3
    c3u["C3u"]
    block:d0l:1
        c0n1[" "]
    end
    block:d1u:2
        d1n0[" "]
        d1n1[" "]
    end
    block:d1l:2
        d1n2[" "]
        d1n3[" "]
    end
    block:d2u:4
        d2n0["a"]
        d2n1["b"]
        d2n2["c"]
        d2n3["d"]
    end
    block:d2l:4
        d2n4[" "]
        d2n5[" "]
        d2n6[" "]
        d2n7[" "]
    end
    block:d3u:1
        d3n0["t"]
    end

    s0[" "]
    s1["e"]
    s2["f"]
    s3["g"]
    s4["h"]
    s5[" "]
    space:8

    space
    b1(("b1"))
    space:3
    b2(("b2"))

    a1-.->a2
    a2-->c3u
    b2-->s5
```

Part 3: Recover $a$ back to $C_{2,l}$.
$$
\begin{align*}
    \delta(q_1;Z_{u,e/h/f},\gamma_1,\gamma_2)
    &=(q_2;Z_{u,e/h/f},\gamma_1,\gamma_2;G,N) \\
    \delta(q_2;B,\gamma_1,\gamma_2)
    &=(q_2;B,\gamma_1,\gamma_2;G,N)
\end{align*}
$$

```mermaid
block-beta
    columns 14
    space:9
    a3(("a3"))
    space:3
    a2(("a2"))

    c0l["C0l"]
    c1u["C1u"]
    space
    c1l["C1l"]
    space
    c2u["C2u"]
    space:3
    c2l["C2l"]
    space:3
    c3u["C3u"]
    block:d0l:1
        c0n1[" "]
    end
    block:d1u:2
        d1n0[" "] d1n1[" "]
    end
    block:d1l:2
        d1n2[" "] d1n3[" "]
    end
    block:d2u:4
        d2n0["a"] d2n1["b"] d2n2["c"] d2n3["d"]
    end
    block:d2l:4
        d2n4[" "] d2n5[" "] d2n6[" "] d2n7[" "]
    end
    block:d3u:1
        d3n0["t"]
    end

    s0[" "] s1["e"] s2["f"] s3["g"] s4["h"] s5[" "]
    space:9

    space:4
    b3(("b3"))

    a2-.->a3
    a3-->c2l
    b3-->s5
```

Part 4: Step $a$ and $b$ back once.
$$
\begin{align*}
    \delta(q_2;Z_{l},\gamma_1,\gamma_2)
    &=(q_3;Z_{l},\gamma_1,\gamma_2;G,L)
\end{align*}
$$

```mermaid
block-beta
    columns 14
    space:8
    a4(("a4"))
    a3(("a3"))
    space:4

    c0l["C0l"]
    c1u["C1u"]
    space
    c1l["C1l"]
    space
    c2u["C2u"]
    space:3
    c2l["C2l"]
    space:3
    c3u["C3u"]
    block:d0l:1
        c0n1[" "]
    end
    block:d1u:2
        d1n0[" "] d1n1[" "]
    end
    block:d1l:2
        d1n2[" "] d1n3[" "]
    end
    block:d2u:4
        d2n0["a"] d2n1["b"] d2n2["c"] d2n3["d"]
    end
    block:d2l:4
        d2n4[" "] d2n5[" "] d2n6[" "] d2n7[" "]
    end
    block:d3u:1
        d3n0["t"]
    end

    s0[" "] s1["e"] s2["f"] s3["g"] s4["h"] s5[" "]
    space:9

    space:3
    b4(("b4"))
    b3(("b3"))

    a3-.->a4
    a4-->d2n3
    b3-.->b4
    b4-->s4
```

Part 5: Swap through $C_{2,u}$.
$$
\begin{align*}
    \delta(q_3;B,\gamma_1,\gamma_2)
    &=(q_3;B,\gamma_2,\gamma_1;G,L)
\end{align*}
$$

```mermaid
block-beta
    columns 14
    space:5
    a5(("a5"))
    space:2
    a4(("a4"))
    space:5

    c0l["C0l"]
    c1u["C1u"]
    space
    c1l["C1l"]
    space
    c2u["C2u"]
    space:3
    c2l["C2l"]
    space:3
    c3u["C3u"]
    block:d0l:1
        c0n1[" "]
    end
    block:d1u:2
        d1n0[" "] d1n1[" "]
    end
    block:d1l:2
        d1n2[" "] d1n3[" "]
    end
    block:d2u:4
        d2n0["a"] d2n1["f"] d2n2["g"] d2n3["h"]
    end
    block:d2l:4
        d2n4[" "] d2n5[" "] d2n6[" "] d2n7[" "]
    end
    block:d3u:1
        d3n0["t"]
    end

    s0[" "] s1["e"] s2["b"] s3["c"] s4["d"] s5[" "]
    space:8

    space
    b5(("b5"))
    space:2
    b4(("b4"))

    a4-.->a5
    a5-->c2u
    b4-.->b5
    b5-->s1
```

Part 6: Swap once, stepping up on $a$, but no-move on $b$.
$$
\begin{align*}
    \delta(q_3;Z_{u,e/h/f},\gamma_1,\gamma_2)
    &=(q_4;Z_{u,e/h/f},\gamma_2,\gamma_1;G,N)
\end{align*}
$$

```mermaid
block-beta
    columns 14
    space:4
    a6(("a6"))
    a5(("a5"))
    space:8

    c0l["C0l"]
    c1u["C1u"]
    space
    c1l["C1l"]
    space
    c2u["C2u"]
    space:3
    c2l["C2l"]
    space:3
    c3u["C3u"]
    block:d0l:1
        c0n1[" "]
    end
    block:d1u:2
        d1n0[" "] d1n1[" "]
    end
    block:d1l:2
        d1n2[" "] d1n3[" "]
    end
    block:d2u:4
        d2n0["e"] d2n1["f"] d2n2["g"] d2n3["h"]
    end
    block:d2l:4
        d2n4[" "] d2n5[" "] d2n6[" "] d2n7[" "]
    end
    block:d3u:1
        d3n0["t"]
    end

    s0[" "] s1["a"] s2["b"] s3["c"] s4["d"] s5[" "]
    space:8

    space
    b6(("b6"))
    

    a5-.->a6
    a6-->d1n3
    b6-->s1

```

Part 7: Scan $a$ back to $C_{1,u}$. If instead $C_Z$ is detected, transition to next segment of the algorithm
$$
\begin{align*}
    \delta(q_4;B,\gamma_1,\gamma_2)
    &=(q_4;B,\gamma_1,\gamma_2;G,N) \\
    \delta(q_4;Z_l,\gamma_1,\gamma_2)
    &=(q_4;Z_l,\gamma_1,\gamma_2;G,N) \\
    \delta(q_4;Z_0,\gamma_1,\gamma_2)
    &=\dots
\end{align*}
$$

```mermaid
block-beta
    columns 14
    space
    a7(("a7"))
    space:2
    a6(("a6"))
    space:9

    c0l["C0l"]
    c1u["C1u"]
    space
    c1l["C1l"]
    space
    c2u["C2u"]
    space:3
    c2l["C2l"]
    space:3
    c3u["C3u"]
    block:d0l:1
        c0n1[" "]
    end
    block:d1u:2
        d1n0[" "] d1n1[" "]
    end
    block:d1l:2
        d1n2[" "] d1n3[" "]
    end
    block:d2u:4
        d2n0["e"] d2n1["f"] d2n2["g"] d2n3["h"]
    end
    block:d2l:4
        d2n4[" "] d2n5[" "] d2n6[" "] d2n7[" "]
    end
    block:d3u:1
        d3n0["t"]
    end

    s0[" "] s1["a"] s2["b"] s3["c"] s4["d"] s5[" "]
    space:8

    space
    b7(("b7"))
    

    a6-.->a7
    a7-->c1u
    b7-->s1
```

Part 8: Move data from $C_{1,u}$ inclusive through $C_{2,u}$ exclusive from scratch tape back to the main tape, simultaneously updating $C_{1,u}$.
$$
\begin{align*}
    \delta(q_4;Z_{u,e},\gamma_1,\gamma_2)
    &=(q_5;Z_{u,f},\gamma_2,B;C,R) \\
    \delta(q_5;B,\gamma_1,\gamma_2)
    &=(q_{5};B,\gamma_2,B;G,N) \\
    \delta(q_5;Z_l,\gamma_1,\gamma_2)
    &=(q_{5};Z_l,\gamma_2,B;G,N)
\end{align*}
$$

```mermaid
block-beta
    columns 14
    space
    a7(("a7"))
    space:3
    a8(("a8"))
    space:8

    c0l["C0l"]
    c1u["C1u"]
    space
    c1l["C1l"]
    space
    c2u["C2u"]
    space:3
    c2l["C2l"]
    space:3
    c3u["C3u"]
    block:d0l:1
        c0n1[" "]
    end
    block:d1u:2
        d1n0["a"] d1n1["b"]
    end
    block:d1l:2
        d1n2["c"] d1n3["d"]
    end
    block:d2u:4
        d2n0["e"] d2n1["f"] d2n2["g"] d2n3["h"]
    end
    block:d2l:4
        d2n4[" "] d2n5[" "] d2n6[" "] d2n7[" "]
    end
    block:d3u:1
        d3n0["t"]
    end

    s0[" "] s1[" "] s2[" "] s3[" "] s4[" "] s5[" "]
    space:8

    space
    b7(("b7"))
    space:3
    b8(("b8"))

    a7-.->a8
    a8-->c2u
    b7-.->b8
    b8-->s5
```

Part 9: Recover back to $C_{1,u}$
$$
\begin{align*}
    \delta(q_5;Z_{u,e/h},\gamma_1,\gamma_2)
    &=(q_6;Z_{u,e/h},\gamma_1,\gamma_2;G,L) \\
    \delta(q_6;B,\gamma_1,\gamma_2)
    &=(q_{6};B,\gamma_1,\gamma_2;G,L) \\
    \delta(q_6;Z_l,\gamma_1,\gamma_2)
    &=(q_{6};Z_l,\gamma_1,\gamma_2;G,L)
\end{align*}
$$

```mermaid
block-beta
    columns 14

    space
    a9(("a9"))
    space:3
    a8(("a8"))
    space:8

    c0l["C0l"]
    c1u["C1u"]
    space
    c1l["C1l"]
    space
    c2u["C2u"]
    space:3
    c2l["C2l"]
    space:3
    c3u["C3u"]
    block:d0l:1
        c0n1[" "]
    end
    block:d1u:2
        d1n0["a"] d1n1["b"]
    end
    block:d1l:2
        d1n2["c"] d1n3["d"]
    end
    block:d2u:4
        d2n0["e"] d2n1["f"] d2n2["g"] d2n3["h"]
    end
    block:d2l:4
        d2n4[" "] d2n5[" "] d2n6[" "] d2n7[" "]
    end
    block:d3u:1
        d3n0["t"]
    end

    s0[" "] s1[" "] s2[" "] s3[" "] s4[" "] s5[" "]
    space:8

    space
    b9(("b9"))
    space:3
    b8(("b8"))
    

    a8-.->a9
    a9-->c1u
    b8-.->b9
    b9-->s1
```

Part 10: Recurse back to Part 0.
$$
\begin{align*}
    \delta(q_6;Z_{u,f},\gamma_1,\gamma_2)
    &=(q_0;Z_{u,h},\gamma_1,\gamma_2;C,N)
\end{align*}
$$

```mermaid
block-beta
    columns 14

    space
    a9(("a9"))
    a10(("a10"))
    space:11

    c0l["C0l"]
    c1u["C1u"]
    space
    c1l["C1l"]
    space
    c2u["C2u"]
    space:3
    c2l["C2l"]
    space:3
    c3u["C3u"]
    block:d0l:1
        c0n1[" "]
    end
    block:d1u:2
        d1n0["a"] d1n1["b"]
    end
    block:d1l:2
        d1n2["c"] d1n3["d"]
    end
    block:d2u:4
        d2n0["e"] d2n1["f"] d2n2["g"] d2n3["h"]
    end
    block:d2l:4
        d2n4[" "] d2n5[" "] d2n6[" "] d2n7[" "]
    end
    block:d3u:1
        d3n0["t"]
    end

    s0[" "] s1[" "] s2[" "] s3[" "] s4[" "] s5[" "]
    space:8

    space
    b10(("b10"))

    a9-.->a10
    a10-->d1n1
    b10-->s1
```
