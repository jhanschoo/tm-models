from abc import abstractmethod

from tm_models.oracles.OracleABC import OracleABC
from tm_models.typing import StdStatus

class StdOracleABC[Rho](OracleABC[StdStatus, Rho]):
    @abstractmethod
    def __call__(self, recv: Rho) -> StdStatus:
        pass
