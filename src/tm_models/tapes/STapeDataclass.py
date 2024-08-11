from dataclasses import dataclass
from typing import Optional

@dataclass
class STapeDataclass[Gamma]:
    L: list[Optional[Gamma]]
    R: list[Optional[Gamma]]
    head: Optional[Gamma]
    pos: int
    
    def __repr__(self) -> str:
        return "({}),{},{},{}".format(repr(self.pos), repr(self.L), repr(self.R), repr(self.head))

    def __str__(self) -> str:
        ret = ['[']
        if self.L:
            ret.append(", ".join(reversed(tuple(map(repr, self.L)))))
            ret.append(", ")
        ret.append('^' + repr(self.head) + '^')
        if self.R:
            ret.append(", ")
            ret.append(", ".join(map(repr, self.R)))
        ret.append(']')
        return "".join(ret)