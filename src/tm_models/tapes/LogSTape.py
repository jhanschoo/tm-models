from typing import Optional, TypedDict

from tm_models.typing import Instr

# HalfZone
type HZone[Gamma] = list[Optional[Gamma]]
# Zone = [HZone, HZone]
type Zone[Gamma] = list[HZone[Gamma]]
# HalfTape [Zone * ceil(lg T)]
type HTape[Gamma] = list[Zone[Gamma]]

class STapeDict[Gamma](TypedDict):
    tape: list[Optional[Gamma]]
    start_pos: int
    pos: int

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

    def __init__(self, time_exponent: int, msg: list[Gamma]) -> None:
        self.t_exp = time_exponent + 1
        self.t_bound = 2 ** self.t_exp
        self.t = 0
        self.Z: Optional[Gamma] = msg[0] if msg else None
        self.pos: int = 0

        self.R: HTape[Gamma] = [
            # Zone
            [
                [None] * 2 ** i
            ]
        for i in range(self.t_exp)]

        self.L: HTape[Gamma] = [
            # Zone
            [
                [None] * 2 ** i
            ]
        for i in range(self.t_exp)]

        # initialization
        i = 1
        for rz in self.R:
            if i >= min(len(msg), self.t_bound):
                break
            rhz = rz[-1]
            for j in range(len(rhz) - 1, -1, -1):
                if i >= min(len(msg), self.t_bound):
                    break
                rhz[j] = msg[i]
                i += 1

    def query(self) -> Optional[Gamma]:
        return self.Z[0]

    def step(self, instr: Instr[Gamma]) -> None:
        h, d = instr
        self.Z = h
        if d == 'N':
            return
        if d == 'R':
            self.pos += 1
            # C for coming
            C: HTape[Gamma] = self.R
            # G for going
            G: HTape[Gamma] = self.L
        #if d == 'L':
        else:
            self.pos -= 1
            C: HTape[Gamma] = self.L
            G: HTape[Gamma] = self.R
        
        i = 0
        while not C[i]:
            i += 1
        buffer: HZone[Gamma] = C[i].pop()
        i //= 2
        while len(buffer) > 1:
            C[i].append(buffer[:2 ** i])
            buffer = buffer[2 ** i:]
            i //= 2
        buffer[0], self.Z = self.Z, buffer[0]
        i = 0
        while len(G[i]) == 2:
            buffer, G[i] = G[i][0] + G[i][1], [buffer]
            i += 1
        G[i].append(buffer)


    def as_dict(self) -> STapeDict[Gamma]:
        tape: list[Optional[Gamma]] = []
        for lz in reversed(self.L):
            for hlz in lz:
                tape.extend(hlz)
        tape.append(self.Z)
        start_pos = len(tape) - self.pos
        pos = len(tape)
        for rz in self.R:
            for hlz in reversed(rz):
                tape.extend(reversed(hlz))

        return({
            "tape": tape,
            "pos": pos,
            "start_pos": start_pos
        })

    def __repr__(self):
        d = self.as_dict()
        return str(((d["start_pos"], d["pos"]), d["tape"]))

    def __str__(self):
        d = self.as_dict()
        t = d["tape"]
        elems = []
        for i in range(len(t)):
            e = str(t[i])
            if i == d["start_pos"]:
                e = '.' + e + '.'
            if i == d["pos"]:
                e = '^' + e + '^'
            elems.append(e)
        return '[' + ', '.join(elems) + ']'

if __name__ == "__main__":
    import doctest
    doctest.testmod()

