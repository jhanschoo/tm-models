/-
Copyright (c) 2024 Johannes Choo. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Johannes Choo
-/
import TmModels.Defs

structure Mealy (S Γ Λ : Type*) where
  trans : Γ → S → S
  out : Γ → S → Λ

class MealyCast (S Γ Λ M : Type*) where
  /-- The canonical map `Mealy S Γ Λ → M`. -/
  protected mealyCast : Mealy S Γ Λ → M

def Architecture.ofMealy {S Γ Λ : Type*} : Architecture S Γ Γ (S → S × Λ) Λ where
  inchan _ i := i
  stchan s f := (f s).fst
  exchan s f := (f s).snd

def Machine.ofMealy {Γ S : Type*} (m : Mealy S Γ Λ) : Machine S Γ Γ (S → S × Λ) Λ := {
  Architecture.ofMealy with
  prog :=
    fun (a : Γ) (s : S) =>
    (m.trans a s, m.out a s)
}

instance Machine.instMealyCast {S Γ Λ : Type*} : MealyCast S Γ Λ (Machine S Γ Γ (S → S × Λ) Λ) where
  mealyCast m := Machine.ofMealy m
