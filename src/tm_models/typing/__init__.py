from typing import Literal, Optional

Direction = Literal['L', 'R', 'N']
BinDirection = Literal['L', 'R']

type Instr[Gamma] = tuple[Optional[Gamma], Direction]
type KInstr[Gamma] = tuple[Instr[Gamma], ...]
