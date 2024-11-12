import TmModels.StateMachines.Dfa
import TmModels.StateMachines.Nfa

def Nfa.ofDfa {Γ S : Type*} (dfa : Dfa Γ S) : Nfa Γ S where
  accept := dfa.accept
  trans a s := {dfa.trans a s}

def Dfa.ofNfa {Γ S : Type*} (nfa : Nfa Γ S) : Dfa Γ (Set S) where
  accept ss := ∃ s ∈ ss, nfa.accept s
  trans a ss := ⋃ s ∈ ss, nfa.trans a s

instance Nfa.instDfaCast {Γ S : Type*} : DfaCast Γ S (Nfa Γ S) where
  dfaCast := Nfa.ofDfa

instance Dfa.instNfaCast {Γ S : Type*} : NfaCast Γ S (Dfa Γ (Set S)) where
  nfaCast := Dfa.ofNfa

-- theorem nfaEmulatesDfa {Γ S : Type*} (s : S) (l : List Γ) (dfa : Dfa Γ S): step_list (Machine.ofDfa dfa) s l = step_list (Machine.ofNfa (Nfa.ofDfa dfa)) {s} l := by
--   revert s
--   cases l
--   · intro s; rfl
--   · case cons a as =>
--     have IH := fun (s : S) => nfaEmulatesDfa s as dfa
--     intro s
--     simp [step_list]
--     constructor
--     · simp [step, Machine.ofDfa, Machine.ofNfa, Architecture.ofDfa, Architecture.ofNfa, Nfa.ofDfa]
--     · rw [IH]
--       congr
--       simp [step, Machine.ofDfa, Machine.ofNfa, Architecture.ofDfa, Architecture.ofNfa, Nfa.ofDfa]

-- theorem dfaEmulatesNfa {Γ S : Type*} (ss : Set S) (l : List Γ) (nfa : Nfa Γ S): step_list (Machine.ofNfa nfa) ss l = step_list (Machine.ofDfa (Dfa.ofNfa nfa)) ss l := by
--   revert ss
--   cases l
--   · intro ss; rfl
--   · case cons a as =>
--     have IH := fun (ss : Set S) => dfaEmulatesNfa ss as nfa
--     intro s
--     simp [step_list]
--     constructor
--     · simp [step, Machine.ofDfa, Machine.ofNfa, Architecture.ofDfa, Architecture.ofNfa, Dfa.ofNfa]
--     · rw [IH]
--       congr
--       simp [step, Machine.ofDfa, Machine.ofNfa, Architecture.ofDfa, Architecture.ofNfa, Dfa.ofNfa]
