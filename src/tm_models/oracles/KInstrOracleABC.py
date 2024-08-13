from abc import abstractmethod

from tm_models.oracles.OracleABC import OracleABC
from tm_models.typing import KInstr

class KInstrOracleABC[Gamma, Rho](OracleABC[KInstr[Gamma], Rho]):
    @abstractmethod
    def __call__(self, recv: Rho) -> KInstr[Gamma]:
        pass

    @property
    @abstractmethod
    def num_heads(self) -> int:
        pass
