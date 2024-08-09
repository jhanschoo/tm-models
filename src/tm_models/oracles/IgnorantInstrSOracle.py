from collections.abc import Iterable
import random
from typing import Never, Optional

from tm_models.oracles.SInstrOracleABC import SInstrOracleABC
from tm_models.typing import Instr

class IgnorantInstrSOracle[Gamma](SInstrOracleABC[Never, Gamma]):
    """A serial oracle that ignores the state of its host and emits a sequence of TM steps it was initialized with, and uniform samples after, up to `time`.

    >>> o = IgnorantInstrSOracle(4, ['a', 'c', 'd'], [('a', 'L'), ('d', 'N'), ('a', 'R')])
    >>> o(None)
    ('a', 'L')
    >>> o(None)
    ('d', 'N')
    >>> o(None)
    ('a', 'R')
    >>> t, u = o(None)
    >>> t in ['a', 'c', 'd'] and u in ['L', 'R', 'N']
    True
    """

    # alphabet cannet be a set, but must be a sequence type due to random.choice
    def __init__(self, time: int, alphabet: tuple[Gamma], it: Optional[Iterable[Instr[Gamma]]]) -> None:
        assert time >= 0
        self.t_bound = time
        self.t = 0
        self.alphabet = alphabet
        self.it = it.__iter__() if it else None

    def __call__(self, _input: Never) -> Instr[Gamma]:
        if self.t >= self.t_bound:
            raise StopIteration;
        self.t += 1
        if self.it:
            try:
                a, d = next(self.it)
                if (a == None or a in self.alphabet) and d in ('L', 'R', 'N'):
                    return a, d
            except StopIteration:
                self.it = None
        # no-move with probability .5 is easier to analyze as 2 steps of random walk
        return random.choice(self.alphabet), random.choice(('L', 'R', 'N', 'N'))

if __name__ == "__main__":
    import doctest
    doctest.testmod()
