/-
Copyright (c) 2024 Johannes Choo. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Johannes Choo
-/
import TmModels.Defs

structure Nfa (Γ S : Type*) where
  trans : Γ → S → Set S
  accept : S → Prop

class NfaCast (Γ S M : Type*) where
  /-- The canonical map `Nfa Γ S → M`. -/
  protected nfaCast : Nfa Γ S → M

/--
  Recommend using this pattern for defining `Architecture.ofConcreteModel` and `Machine.ofConcreteModel`, with the purpose of ensuring that `inchan` and `exchan` functions benefit from definitional equality.
-/
def Architecture.ofNfa {Γ S : Type*} : Architecture (Set S) Γ Γ (Set S → Set S × Prop) Prop where
  inchan _ i := i
  stchan ss f := (f ss).fst
  exchan ss f := (f ss).snd

def Machine.ofNfa {Γ S : Type*} (nfa : Nfa Γ S) : Machine (Set S) Γ Γ (Set S → Set S × Prop) Prop := {
  Architecture.ofNfa with
  prog :=
    fun (a : Γ) (ss : Set S) =>
    let ss' := ⋃ s ∈ ss, nfa.trans a s
    (ss', ∃ s ∈ ss', nfa.accept s)
}

instance Machine.instNfaCast {Γ S : Type*} : NfaCast Γ S (Machine (Set S) Γ Γ (Set S → Set S × Prop) Prop) where
  nfaCast := Machine.ofNfa
