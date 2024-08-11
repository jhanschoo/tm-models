from collections import UserList
from typing import Optional, TypedDict

from tm_models.tapes.STapeDataclass import STapeDataclass
from tm_models.typing import Instr

# Tagged
type Wrapped[Gamma] = tuple[Optional[Gamma]]
# HalfZone
type HZone[Gamma] = list[Optional[Wrapped[Gamma]]]
# Zone = [HZone, HZone]
type Zone[Gamma] = list[HZone[Gamma]]
# HalfTape [Zone * ceil(lg T)]
type HTape[Gamma] = list[Zone[Gamma]]

class _HZone[Gamma](UserList[Gamma]):
    def __repr__(self):
        return "_HZone{}".format(super().__repr__())

class _Zone[Gamma](UserList[_HZone[Gamma]]):
    def __repr__(self):
        return "_Zone{}".format(super().__repr__())
    pass

class _HTape[Gamma](UserList[_Zone[Gamma]]):
    def __repr__(self):
        return "_HTape{}".format(super().__repr__())

class LogSTape[Gamma]:
    """A data structure modeling the tape of the standard O(n lg n)-time
    universal TM. Methods exist that retrieve the emulated state
    as well as the host state

    >>> t = LogSTape[str](1, list())
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

    def __init__(self, time_exponent: int, msg: list[Gamma] = []) -> None:
        self.t_exp = time_exponent + 1
        self.t_bound = 2 ** self.t_exp
        self.t = 0
        self.Z: Optional[Gamma] = msg[0] if msg else None
        self.pos: int = 0

        self.R: _HTape[Gamma] = _HTape(
            _Zone([_HZone([None] * 2 ** i)])
            for i in range(self.t_exp))
        self.L: _HTape[Gamma] = _HTape(
            _Zone([_HZone([None] * 2 ** i)])
            for i in range(self.t_exp))

        # initialization
        i = 1
        # rz: Zone[Gamma]
        for rz in self.R:
            if i >= min(len(msg), self.t_bound):
                break
            # rhz: HZone[Gamma]
            rhz = rz[-1]
            for j in range(len(rhz) - 1, -1, -1):
                if i >= min(len(msg), self.t_bound):
                    break
                # rhz[int]: Optional[Wrapped[Gamma]]
                rhz[j] = (msg[i],)
                i += 1
        #self._assert_self()

    def query(self) -> Optional[Gamma]:
        return self.Z

    def step(self, instr: Instr[Gamma]) -> None:
        h, d = instr
        # self.Z: Optional[Gamma]
        self.Z = h
        if d == 'N':
            return
        if d == 'R':
            self.pos += 1
            # C for coming
            C = self.R
            # G for going
            G = self.L
        #if d == 'L':
        else:
            self.pos -= 1
            C = self.L
            G = self.R
        
        i = 0
        # C[int]: Zone[Gamma]
        while not C[i]:
            i += 1
        buffer = C[i].pop()
        i //= 2
        while len(buffer) > 1:
            C[i].append(buffer[:2 ** i])
            buffer = buffer[2 ** i:]
            i //= 2
        # buffer[int]: Optional[Wrapped[Gamma]]
        buffer[0], self.Z = (self.Z,), (buffer[0][0] if buffer[0] else None)
        i = 0
        # G[int]: Zone[Gamma]
        # G[int][int]: HZone[Gamma]
        while len(G[i]) == 2:
            buffer, G[i] = G[i][0] + G[i][1], _Zone([buffer])
            i += 1
        G[i].append(buffer)

    def _assert_self(self):
        for lz in self.L:
            for hlz in lz:
                assert isinstance(hlz, _HZone)
            assert isinstance(lz, _Zone)
        assert isinstance(self.L, _HTape)

        for rz in self.R:
            for hrz in rz:
                assert isinstance(hrz, _HZone)
            assert isinstance(rz, _Zone)
        assert isinstance(self.R, _HTape)

    def as_dataclass(self) -> STapeDataclass[Gamma]:
        L: list[Optional[Gamma]] = []
        for lz in self.L:
            for hlz in reversed(lz):
                g = reversed(tuple(map(lambda x: x[0], filter(lambda x: x, hlz))))
                L.extend(g)
        R: list[Optional[Gamma]] = []
        for rz in self.R:
            for hrz in reversed(rz):
                g = reversed(tuple(map(lambda x: x[0], filter(lambda x: x, hrz))))
                R.extend(g)

        return STapeDataclass(L, R, self.Z, self.pos)

    def raw_as_dataclass(self) -> STapeDataclass[Wrapped[Gamma]]:
        L: list[Optional[Wrapped[Gamma]]] = []
        for lz in reversed(self.L):
            for hlz in lz:
                L.extend(hlz)
        R: list[Optional[Gamma]] = []
        for rz in self.R:
            for hlz in reversed(rz):
                R.extend(reversed(hlz))

        return STapeDataclass(L, R, self.Z, self.pos)


    def __repr__(self):
        return repr(self.as_dataclass())

    def __str__(self):
        return str(self.as_dataclass())

if __name__ == "__main__":
    import doctest
    doctest.testmod()
