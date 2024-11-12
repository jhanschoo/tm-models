/-
Copyright (c) 2024 Johannes Choo. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Johannes Choo
-/
import TmModels.StateMachines.Mealy
import TmModels.StateMachines.Moore

def Mealy.ofMoore {S Γ Λ : Type*} (m : Moore S Γ Λ) : Mealy S Γ Λ where
  trans := m.trans
  out _ := m.out

def Mealy.ofMooreState {S : Type*} : S → S := id

theorem mealy_emulates_moore {S Γ Λ : Type*} (m : Moore S Γ Λ) : (Machine.ofMealy (Mealy.ofMoore m)).step = (Machine.ofMoore m).step := rfl
