# Step_Head

This document illustrates the algorithm executed in the middle part of a simulated step in the $O(n \lg n)$ simulation.

Start: $a$ is at $Z_0$ that contains the newly overprinted symbol (wrt the simulated machine), and the scratch tape contains a single cell of data.

```mermaid
block-beta
    columns 9

    space:4
    a0(("a0"))
    space:4

    space
    cg1u["G1u"]
    cg0l["G0l"]
    cg0u["G0u"]
    cz0["Z0"]
    cc0u["C0u"]
    cc0l["C0l"]
    cc1u["C1u"]
    space
    block:dg1u:2
        dg1n1["v"] dg1n0["w"]
    end
    block:dg0l:1
        dg0n1["x"]
    end
    block:dg0u:1
        dg0n0["y"]
    end
    dz0["z"]
    block:dc0u:1
        dc0n0["b"]
    end
    block:dc0l:1
        dc0n1[" "]
    end
    block:dc1u:2
        dc1n0["c"]
        dc1n1["d"]
    end

    s0[" "] s1["a"] s2[" "] s3[" "] s4[" "] s5[" "]
    space:3

    space
    b0(("b0"))

    a0-.->cz0
    b0-.->s1
```

Part 0: Perform a swap while moving $a$ down. This is the only step.
$$
\begin{align*}
    \delta(q_s;Z_0,\gamma_1,\gamma_2)
    &=(q_h;Z_0,\gamma_2,\gamma_1;G,N)
\end{align*}
$$