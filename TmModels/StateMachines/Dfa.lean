/-
Copyright (c) 2024 Johannes Choo. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Johannes Choo
-/
import TmModels.Defs

structure Dfa (Γ S : Type*) where
  trans : Γ → S → S
  accept : S → Prop

class DfaCast (Γ S M : Type*) where
  /-- The canonical map `Dfa Γ S → M`. -/
  protected dfaCast : Dfa Γ S → M

def Architecture.ofDfa {Γ S : Type*} : Architecture S Γ Γ (S → S × Prop) Prop where
  inchan _ i := i
  stchan s f := (f s).fst
  exchan s f := (f s).snd

def Machine.ofDfa {Γ S : Type*} (dfa : Dfa Γ S) : Machine S Γ Γ (S → S × Prop) Prop := {
  Architecture.ofDfa with
  prog :=
    fun (a : Γ) (s : S) =>
    let s' := dfa.trans a s
    (s', dfa.accept s')
}

instance Machine.instDfaCast {Γ S : Type*} : DfaCast Γ S (Machine S Γ Γ (S → S × Prop) Prop) where
  dfaCast := Machine.ofDfa
