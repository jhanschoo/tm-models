from abc import abstractmethod

from tm_models.oracles.OracleABC import OracleABC
from tm_models.typing import KInstr

class KInstrOracleABC[Gamma, Mu](OracleABC[KInstr[Gamma], Mu]):
    @abstractmethod
    def __call__(self, msg: Mu) -> KInstr[Gamma]:
        pass

    @property
    @abstractmethod
    def num_heads(self) -> int:
        pass
