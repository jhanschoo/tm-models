/-
Copyright (c) 2024 Johannes Choo. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Johannes Choo
-/
import TmModels.Prelude

/--
See: [def:architecture]

* `S` is the type of the configuration.
* `U₀` is the external input type.
* `U₁` is the internal input type.
* `V₁` is the internal output type.
* `V₀` is the external output type.
* `inchan : S → Option U₀ → U₁` is a function that "projects" part of the configuration and the extrernal input into a program input
* `stchan : S → V₁ → S` is a function that maps the instruction output by the program, and the configuration, to a new configuration and external output.
* `exchan : S → V₁ → Option V₀` is a function that maps the instruction output by the program and the configuration to a new configuration and external output.

The reason for separating computational processes into `inchan`, `prog`, `stchan`, and `exchan` is that we frequently want to specify a particular model of computation by fixing (or at least parameterizing) both `inchan`, `stchan` and `exchan`, while allowing `prog` to range over comparatively small sets `V₁` and especially `U₁`.
-/
structure Architecture (S U₀ U₁ V₁ V₀) where
  inchan : S → U₀ → U₁
  stchan : S → V₁ → S
  exchan : S → V₁ → V₀

/--
See: [def:machine]

A machine of a given architecture is the architecture extended with a transition function and a neutral configuration.
* `δ : U₁ → V₁` is the transition function of the machine.
* `neutral : S × V₀` specifies a neutral configuration for the machine, which may or not be used as the initial configuration of an execution on the machine.
-/
structure Machine (S U₀ U₁ V₁ V₀) extends Architecture S U₀ U₁ V₁ V₀ where
  prog : U₁ → V₁

/--
Taking a step on a machine from a fixed state and input gives us the next state and output.
-/
def Machine.step {S U₀ U₁ V₁ V₀} (m : Machine S U₀ U₁ V₁ V₀) (su₀ : S × U₀) : S × V₀ :=
  let (s, u₀) := su₀
  let pin := m.inchan s u₀
  let pex := m.prog pin
  ⟨m.stchan s pex, m.exchan s pex⟩

/--
Stepping induces a relation.
-/
def Machine.step_rel {S U₀ U₁ V₁ V₀} (m : Machine S U₀ U₁ V₁ V₀) : Set ((S × U₀) × (S × V₀)) :=
  {(su₀, s'v₀) | s'v₀ = m.step su₀}

/--
Defines as a relation the set of possible next states and outputs from a fixed state and input.
-/
def Machine.step_stream {S U₀ U₁ V₁ V₀} (m : Machine S U₀ U₁ V₁ V₀) (su₀s : S × Stream' U₀) : Stream' V₀ :=
  su₀s.snd.corecMap (fun s u₀ => (m.step (s, u₀)).snd) (fun s u₀ => (m.step (s, u₀)).fst) su₀s.fst

/--
Defines a relation between initial states, input streams, and the transduced output stream.
-/
def Machine.step_stream_rel {S U₀ U₁ V₁ V₀} (m : Machine S U₀ U₁ V₁ V₀) : Set (S × Stream' U₀ × Stream' V₀) :=
  let executions := {
    ((s, u₀s, v₀s), ss) : (S × Stream' U₀ × Stream' V₀) × Stream' S |
    (ss.head, v₀s.head) = m.step (s, u₀s.head) ∧
    ∀ i, (ss.get (i + 1), v₀s.get (i + 1)) = m.step (ss i, u₀s.get (i + 1))
  }
  executions.image Prod.fst

/--
A nondeterministic machine of a given architecture.
-/
structure NMachine (S U₀ U₁ V₁ V₀) extends Architecture S U₀ U₁ V₁ V₀ where
  prog : U₁ → Set V₁

/--
Performing a step on a nondeterministic machine from a fixed state gives us the set of next states and outputs from it.
-/
def NMachine.nstep {S U₀ U₁ V₁ V₀ : Type*} (m : NMachine S U₀ U₁ V₁ V₀) (su₀ : S × U₀) : Set (S × V₀) :=
  let (s, u₀) := su₀
  let pin := m.inchan s u₀
  let pex := m.prog pin
  pex.image (fun v₁ => ⟨m.stchan s v₁, m.exchan s v₁⟩)


/--
Stepping induces a relation.
-/
def NMachine.nstep_rel {S U₀ U₁ V₁ V₀ : Type*} (m : NMachine S U₀ U₁ V₁ V₀) : Set ((S × U₀) × (S × V₀)) :=
  {(su₀, s'v₀) : (S × U₀) × (S × V₀) | s'v₀ ∈ m.nstep su₀}

/--
Defines a relation between initial states, input streams, and the transduced output stream.
-/
def NMachine.nstep_stream_rel {S U₀ U₁ V₁ V₀} (m : NMachine S U₀ U₁ V₁ V₀) : Set (S × Stream' U₀ × Stream' V₀) :=
  let executions := {
    ((s, u₀s, v₀s), ss) : (S × Stream' U₀ × Stream' V₀) × Stream' S |
    (ss.head, v₀s.head) ∈ m.nstep (s, u₀s.head) ∧
    ∀ i, (ss.get i.succ, v₀s.get i.succ) ∈ m.nstep (ss i, u₀s.get i.succ)
  }
  executions.image Prod.fst

/--
  We can convert a nondeterministic machine to a machine.
-/
def Machine.ofNMachine {S U₀ U₁ V₁ V₀ : Type*} (nm : NMachine S U₀ U₁ V₁ V₀) : (Machine (Set S) U₀ (Set (S × U₁)) (Set (S × V₁)) (Set V₀)) where
    inchan ss u₀ := ss.image (fun s => (s, nm.inchan s u₀))
    stchan ss ssv₁ := { s | ∃ s₀ ∈ ss, ∃ sv₁ ∈ ssv₁, let (s₀', v₁') := sv₁
      s₀ = s₀' ∧ s = nm.stchan s₀ v₁' }
    exchan ss ssv₁ := { v₀ | ∃ s₀ ∈ ss, ∃ sv₁ ∈ ssv₁, let (s₀', v₁') := sv₁
      s₀ = s₀' ∧ v₀ = nm.exchan s₀ v₁' }
    prog ssu₁ := ⋃ su₁ ∈ ssu₁, let (s, u₁) := su₁
      (nm.prog u₁).image (fun v₁ => (s, v₁))

def NMachine.ofMachine {S U₀ U₁ V₁ V₀ : Type*} (m : Machine S U₀ U₁ V₁ V₀) : NMachine S U₀ U₁ V₁ V₀ := {
  inchan := m.inchan,
  stchan := m.stchan,
  exchan := m.exchan,
  prog := fun u₁ => {m.prog u₁},
}

/-
class Adt (S U₀ V₀ : Type*) where
  v : S → U₀ → S × V₀
  neutral : S × V₀

instance gadget_from_adt [adt : Adt S U₀ V₀] : Gadget S U₀ U₀ U₀ V₀ where
  u _ i := i
  v s i := adt.v s i
  δ i := i
  neutral := adt.neutral

namespace Stack

variable {Γ : Type*}

notation "push" => Option.some
notation "pop" => Option.none

def v (l : List Γ) (command : Option Γ) : List Γ × Option Γ :=
  match l, command with
  | l', push x => (x :: l', none)
  | [], pop => ([], none)
  | x :: xs, pop => (xs, some x)

def neutral : List Γ × Option Γ := ([], none)

instance stack : Adt (List Γ) (Option Γ) (Option Γ) where
  v := v
  neutral := neutral

end Stack

namespace Box

variable {S : Type*}

def v (_ : Unit) (s : S) : Unit × S := (Unit.unit, s)

def neutral (s : S) := (Unit.unit, s)

instance box (init : S) : Adt Unit S S where
  v := v
  neutral := neutral init

end Box

namespace Wrapper

def u (s : S) (i : U₀) : S × U₀ := (s, i)

def δ (g : Gadget S U₀ U₁ V₁ V₀) (p : S × U₀) : S × V₀ :=
  let (s, i) := p
  step g s i

def v (_ : S) (so : S × V₀) : S × V₀ := so

def wrapper_neutral (g : Gadget S U₀ U₁ V₁ V₀) : S × V₀ := g.neutral

instance wrapper (g : Gadget S U₀ U₁ V₁ V₀) : Gadget S U₀ (S × U₀) (S × V₀) V₀ where
  u := u
  v := v
  δ := δ g
  neutral := wrapper_neutral g

end Wrapper

namespace DSM

def u (s : S) (i : U₀) : S × U₀ := (s, i)

def v (_ s : S) := (s, s)

instance dsm' : Architecture S U₀ (S × U₀) S S where
  u := u
  v := v

instance dsm (init : S) (δ : S × U₀ → S) : Gadget S U₀ (S × U₀) S S where
  δ := δ
  neutral := (init, init)

def c := dsm true (fun (p : Bool × Nat) => p.2 % 2 == 1)

#eval (step c true 1).1

end DSM

namespace Composite

def u (s : S) (i : U₀) : S × U₀ := (s, i)

def δ (g : Gadget S U₀ U₁ V₁ V₀) (p : S × U₀) : S × V₀ :=
  let (s, i) := p
  step g s i

def v (_ : S) (so : S × V₀) : S × V₀ := so

def composite_neutral (g : Gadget S U₀ U₁ V₁ V₀) : S × V₀ := g.neutral

instance composite (h : Gadget S U₀ U₁ V₁ V₀) : Gadget S U₀ (S × U₀) (S × V₀) V₀ where
  u := u
  v := v
  δ := δ g
  neutral := wrapper_neutral g

end Composite
-/
