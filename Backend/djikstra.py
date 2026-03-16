import pandas as pd
import heapq

def dijkstra_route(df, start, end):
    # Build adjacency list
    graph = {}
    for _, row in df.iterrows():
        graph.setdefault(row['from'], []).append((row['to'], row['time']))
        graph.setdefault(row['to'], [])  # ensure node exists

    # Priority queue (time, node, path)
    pq = [(0, start, [])]
    visited = set()

    while pq:
        time, node, path = heapq.heappop(pq)

        if node in visited:
            continue

        path = path + [node]
        visited.add(node)

        if node == end:
            return path, time

        for neighbor, weight in graph.get(node, []):
            if neighbor not in visited:
                heapq.heappush(pq, (time + weight, neighbor, path))

    return None, float("inf")

desp = pd.read_excel("Backend/move.xlsx")

#path, total_time = dijkstra_route(desp, 'ML 5', 'RGD 2')

#print("Route:", path)
#print("Total time:", total_time, "Segundos")