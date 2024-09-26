import Lake
open Lake DSL

package "tm-models" where
  version := v!"0.1.0"
  keywords := #["math"]
  leanOptions := #[
    ⟨`pp.unicode.fun, true⟩ -- pretty-prints `fun a ↦ b`
  ]

require "leanprover-community" / "mathlib"

-- checkdecls is used by leanblueprint
require checkdecls from git "https://github.com/PatrickMassot/checkdecls.git"

meta if get_config? env = some "dev" then -- dev is so not everyone has to build it
  require "leanprover" / "doc-gen4"

@[default_target]
lean_lib «TmModels» where
  -- add any library configuration options here
