import math
import unittest

from tm_models.oracles import IgnorantInstrSOracle
from tm_models.tapes import LogSTape, STape

class STapeFuzzing(unittest.TestCase):

    def test_stape_logstape_fuzz(self):
        limit = 100
        runs = 1
    
        for _ in range(runs):
            o = IgnorantInstrSOracle.IgnorantInstrSOracle(limit, ('x', 'y'))
            stape = STape.STape()
            lstape = LogSTape.LogSTape(int(math.ceil(math.log2(limit + 1))))
            # observe that == should perform deep comparison here and not identity comparison
            self.assertEqual(stape.as_dataclass(), lstape.as_dataclass())
            for t in range(limit):
                instr = o(None)
                stape.step(instr)
                lstape.step(instr)

                # observe that == should perform deep comparison here and not identity comparison
                self.assertEqual(stape.as_dataclass(), lstape.as_dataclass())
                print(stape)

if __name__ == "__main__":
    unittest.main()
