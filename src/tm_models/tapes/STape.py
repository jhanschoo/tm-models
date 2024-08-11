from typing import Optional

from tm_models.tapes import STapeDataclass
from tm_models.tapes.STapeDataclass import STapeDataclass
from tm_models.typing import Instr

type Stack[Gamma] = tuple[Optional[Gamma], Stack[Gamma]] | tuple[()]
type TStack[Gamma] = tuple[Stack[Gamma], Optional[Gamma], Stack[Gamma]]

class STape[Gamma]:
    """A class modeling a blank-agnostic TM Tape.

    >>> t = STape[str]()
    >>> t.step(('a', 'L'))
    >>> t
    ((1, 0), [None, 'a'])
    >>> t.step(('d', 'N'))
    >>> t
    ((1, 0), ['d', 'a'])
    >>> t.step(('c', 'R'))
    >>> t
    ((1, 1), ['c', 'a'])
    """

    def __init__(self, keep_history=False) -> None:
        self.state: TStack[Gamma] = tuple(), None, tuple()
        self.pos: int = 0

        self.history = self.state if keep_history else None

    def query(self) -> Optional[Gamma]:
        _, h, _ = self.state
        return h

    def step(self, instr: Instr[Gamma]) -> None:
        if self.history:
            self.history = (self.state, self.history)
        left, _, right = self.state
        h, d = instr
        if d == 'L':
            if left:
                self.state = left[1], left[0], (h, right)
            else:
                self.state = tuple(), None, (h, right)
            self.pos -= 1
        if d == 'R':
            if right:
                self.state = (h, left), right[0], right[1]
            else:
                self.state = (h, left), None, tuple()
            self.pos += 1
        if d == 'N':
            self.state = left, h, right

    def as_dataclass(self) -> STapeDataclass[Gamma]:
        left, h, right = self.state
        L: Optional[Gamma] = []
        while left:
            L.append(left[0])
            left = left[1]
        R: Optional[Gamma] = []
        while right:
            R.append(right[0])
            right = right[1]
        return STapeDataclass(L, R, h, self.pos)

    def __repr__(self):
        return repr(self.as_dataclass())

    def __str__(self):
        return str(self.as_dataclass())

if __name__ == "__main__":
    import doctest
    doctest.testmod()
