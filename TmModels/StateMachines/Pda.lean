/-
Copyright (c) 2024 Johannes Choo. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Johannes Choo
-/
import TmModels.Defs

structure Pda (Γ P S : Type*) where
  trans : Γ → P → S → Set (Option (P × P) × S)
  accept : S → Prop

class PdaCast (Γ P S M : Type*) where
  /-- The canonical map `Pda Γ S P → M`. -/
  protected pdaCast : Pda Γ P S → M

/--
In this choice of API, `(Set ((P × S) × (Option (P × P) × S)) × Prop)` is the relation induced by `trans (i : Γ)`, then further specialized to only what's present in the previous state.

Note that less expressive choices were considered, such as `Set (P × S) → ...` and `P × S → ...`, but those choices meant significant transformation to obtain the `Prop` output at that step.
-/
def Architecture.ofPda {Γ P S : Type*} : Architecture (Set (Stream' P × S)) Γ (Set (P × S) × Γ) (Set ((P × S) × (Option (P × P) × S)) × Prop) Prop where
  inchan spss i := (spss.image (Prod.map Stream'.head id), i)
  stchan spss relp := ⋃ pss ∈ spss, {(ps', s') |
    let (ps, s) := pss
    let p := ps.head
    (((p, s), (none, s')) ∈ relp.fst ∧ ps' = ps.tail) ∨
    (((p, s), (some (ps'.get 0, ps'.get 1), s')) ∈ relp.fst ∧ ps'.drop 2 = ps.tail) }
  exchan _ rel := rel.snd

def Machine.ofPda {Γ P S : Type*} (pda : Pda Γ P S) : Machine (Set (Stream' P × S)) Γ (Set (P × S) × Γ) (Set ((P × S) × (Option (P × P) × S)) × Prop) Prop := {
  Architecture.ofPda with
  prog := fun ⟨sps, i⟩ =>
    let trans' := pda.trans i
    let rel := ⋃ ps ∈ sps,
      let (p, s) := ps
      {((p, s), pout) | pout ∈ trans' p s}
    (rel, ∃ ps ∈ rel, pda.accept ps.snd.snd)
}

instance Machine.instPdaCast {Γ P S : Type*} : PdaCast Γ P S (Machine (Set (Stream' P × S)) Γ (Set (P × S) × Γ) (Set ((P × S) × (Option (P × P) × S)) × Prop) Prop) where
  pdaCast := Machine.ofPda
