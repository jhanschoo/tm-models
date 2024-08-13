from typing import Literal, Optional

Direction = Literal['L', 'R', 'N']
BinDirection = Literal['L', 'R']

StdStatus = Literal[
    # Active. Unless otherwise specified,
    #   the host should be ready for 'A', 'T', 'F', or 'W' to be reported next tick.
    #   The program may expect the host to continue passing it while it reports 'A'; it may
    #   report 'W' next step if it expects more information.
    #
    #   Additionally, for counter programs, adds one to the count.
    'A',
    # True. Reports success. It may indicate success in reading input from the host, or success in the primary function that the host expects of it.
    # 
    # May transition to 'R' or 'W'
    'T',
    # False. Reports failure. It may indicate failure in reading input from the host, or failure in the primary function that the host expects of it.
    #
    # May transition to 'R' or 'W'
    'F',
    # Recovery. Reports recovery state. The program is cleaning up.
    # 
    # May transition to 'R' or 'W'.
    'R',
    # Waiting. Reports that it is waiting on the host.
    #
    # On valid input, transitions to 'A', 'T', or 'F'.
    # Otherwise remains in 'W'.
    'W',
    # Quit. Reports that the program has exited. Next step must be 'Q'
    'Q',
    # Error. Reports an unrecoverable error state. Next step must be 'E'
    'E'
]

type Instr[Gamma] = tuple[Optional[Gamma], Direction]
type KInstr[Gamma] = tuple[Instr[Gamma], ...]
