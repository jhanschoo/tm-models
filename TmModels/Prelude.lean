import Mathlib


abbrev WSeq' α := Stream' (Option α)

/-
Suppose that `f` given a state of type `γ` and input type `α` produces a new state of type  `γ` and output `β`.
Then `corec f g sa` is a stream of `β` produced by repeatedly applying `f g'` to the input stream, where `g'` is the state produced by the previous application of `f`; the initial state is `g`.
-/
def Stream'.corecMap (s : Stream' β) (f : α → β → δ) (g : α → β → α) (a : α) : Stream' δ :=
  corec (fun ⟨a, s⟩ => f a (head s)) (fun ⟨a, s⟩ => ⟨g a (head s), tail s⟩) (⟨a, s⟩ : α × Stream' β)
