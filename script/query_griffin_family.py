# Python Script for to query the RDF Graph

from rdflib import Graph, Namespace

# Load the graph
g = Graph()
g.parse("griffin_family.ttl", format="turtle")

# Namespace
fg = Namespace("http://family-griffin-graph.com/")

# SPARQL Query
query = """
PREFIX : <http://family-griffin-graph.com/>
SELECT ?parent ?child
WHERE {
    ?parent :hasChild ?child .
    ?parent a :Person .
}
"""

# Run the query
results = g.query(query)

# Print the results
print("Parent-Child Relationships in the Griffin Family")
for row in results:
    print(f"{row.parent.split('/')[-1]} -> {row.child.split('/')[-1]}")
