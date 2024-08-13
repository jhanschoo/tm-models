from tm_models.oracles.KInstrOracleABC import KInstrOracleABC
from tm_models.oracles.SInstrOracleABC import SInstrOracleABC
from tm_models.typing import KInstr

class InstrOracleSerializer[Gamma, Rho](SInstrOracleABC[Gamma, Rho]):
    """An oracle initialized with a KInstrOracleABC that converts it into a
    SInstrOracleABC, reading recv for the first of each `k` calls

    >>> from tm_models.oracles.IgnorantInstrSOracle import IgnorantInstrSOracle
    >>> from tm_models.oracles.InstrOracleParallelizer import InstrOracleParallelizer

    >>> o = IgnorantInstrSOracle(4, ['a', 'c', 'd'], [('a', 'L'), ('d', 'N'), ('a', 'R')])
    >>> po = InstrOracleParallelizer([o, o])
    >>> so = InstrOracleSerializer(po)
    >>> so((None, None))
    ('a', 'L')
    >>> so((None, None))
    ('d', 'N')
    """

    def __init__(self, oracle: KInstrOracleABC[Gamma, Rho]) -> None:
        self.oracle = oracle
        self.buffer: KInstr[Gamma] = tuple()
        self.pointer: int = 0

    def __call__(self, recv: Rho):
        if self.pointer >= len(self.buffer):
            self.buffer = self.oracle(recv)
            self.pointer = 0
        assert self.buffer
        self.pointer += 1
        return self.buffer[self.pointer - 1]

if __name__ == "__main__":
    import doctest
    doctest.testmod()

