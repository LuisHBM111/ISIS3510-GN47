import djikstra as di
import Backend.auxiliary as wo

import pandas as pd

'''
data = {
    'from': ['A','A','C','B','C'],
    'to':   ['B','C','B','D','D'],
    'time': [5,2,1,4,7]
}

df = pd.DataFrame(data)
'''

desp = pd.read_excel("Backend/move.xlsx")

path, total_time = di.dijkstra_route(desp, 'ML 2', 'W 3')
print(path)
