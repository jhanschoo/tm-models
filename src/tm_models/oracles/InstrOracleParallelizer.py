from tm_models.oracles.KInstrOracleABC import KInstrOracleABC
from tm_models.oracles.SInstrOracleABC import SInstrOracleABC
from tm_models.typing import KInstr


class InstrOracleParallelizer[Gamma, Mu](KInstrOracleABC[Gamma, tuple[Mu, ...]]):
    """A KInstrOracleABC oracle initialized with a list of SInstrOracleABC
    that calls each oracle one after the other with the k-tuple input. This means that you can pass
    the same SInstrOracleABC in a list to adapt it to emit k-tape instructions.

    >>> from tm_models.oracles.IgnorantInstrSOracle import IgnorantInstrSOracle

    >>> o = IgnorantInstrSOracle(4, ['a', 'c', 'd'], [('a', 'L'), ('d', 'N'), ('a', 'R')])

    >>> po = InstrOracleParallelizer([o, o])
    >>> po((None, None))
    (('a', 'L'), ('d', 'N'))
    """

    # alphabet cannet be a set, but must be a sequence type due to random.choice
    def __init__(self, oracles: list[SInstrOracleABC[Gamma, Mu]]) -> None:
        self.oracles = oracles

    def __call__(self, msg: tuple[Mu, ...]) -> KInstr[Gamma]:
        assert len(msg) == len(self.oracles)
        return tuple(o(m) for m, o in zip(msg, self.oracles))

    @property
    def num_heads(self):
        return len(self.oracles)

if __name__ == "__main__":
    import doctest
    doctest.testmod()
