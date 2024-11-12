/-
Copyright (c) 2024 Johannes Choo. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Johannes Choo
-/
import TmModels.Defs

structure Moore (S Γ Λ : Type*) where
  trans : Γ → S → S
  out : S → Λ

class MooreCast (S Γ Λ M : Type*) where
  /-- The canonical map `Moore S Γ Λ → M`. -/
  protected mooreCast : Moore S Γ Λ → M

def Architecture.ofMoore {S Γ Λ : Type*} : Architecture S Γ Γ (S → S × Λ) Λ where
  inchan _ i := i
  stchan s f := (f s).fst
  exchan s f := (f s).snd

def Machine.ofMoore {Γ S : Type*} (m : Moore S Γ Λ) : Machine S Γ Γ (S → S × Λ) Λ := {
  Architecture.ofMoore with
  prog :=
    fun (a : Γ) (s : S) =>
    (m.trans a s, m.out s)
}

instance Machine.instMooreCast {S Γ Λ : Type*} : MooreCast S Γ Λ (Machine S Γ Γ (S → S × Λ) Λ) where
  mooreCast m := Machine.ofMoore m
