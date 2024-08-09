from abc import abstractmethod

from tm_models.oracles.OracleABC import OracleABC
from tm_models.typing import Instr

class SInstrOracleABC[Gamma, Mu](OracleABC[Instr[Gamma], Mu]):
    @abstractmethod
    def __call__(self, msg: Mu) -> Instr[Gamma]:
        pass
