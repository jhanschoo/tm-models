from abc import abstractmethod

from tm_models.oracles.OracleABC import OracleABC
from tm_models.typing import Instr

class SInstrOracleABC[Gamma, Rho](OracleABC[Instr[Gamma], Rho]):
    @abstractmethod
    def __call__(self, recv: Rho) -> Instr[Gamma]:
        pass
