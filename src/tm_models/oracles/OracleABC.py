from abc import ABC, abstractmethod

class OracleABC[A, B](ABC):
    @abstractmethod
    def __call__(self, msg: B) -> A:
        pass
