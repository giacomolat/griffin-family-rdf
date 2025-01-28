# griffin-family-rdf
This project represents an RDF graph of the Griffin family (Family Guy) and their relationships. It contains data about people, family relationships, pets, and additional connections, using various formats and query languages.

## Repository contents
- **`griffin_family.ttl`**: RDF graph in Turtle format, containing master data.
- **`griffin_family.trig`**: Version of the graph in TriG format, useful for handling named graphs (named graphs).
- **`griffin_family.cypher`**: File containing Cypher queries for using the graph in Neo4j databases.
- **`query_griffin_family.py`**: Python script using `rdflib` to query the RDF graph.
- **`query_examples.rq`**: Examples of SPARQL queries with various levels of complexity, including advanced filters and property paths.
- **`requirements.txt`**: File containing required Python dependencies.

## Instructions for use
### 1. Clone the repository
 ```bash
 git clone https://github.com/tuo-username/griffin-family-rdf.git
 cd griffin-family-rdf
```

### 2. Install dependencies
Use the requirements.txt file to install all necessary dependencies:
```bash
pip install -r requirements.txt
```

Alternatively, install **rdflib** manually:
```bash
pip install rdflib
```

### 3. Run the Python script
Query the RDF graph by running the Python file:
```bash
python query_griffin_family.py
```

### 4. Query the RDF graph with other tools
* **SPARQL**: Use **.ttl** or **.trig** files with tools such as BlazeGraph
* **Cypher**: It imports the **.cypher** file into Neo4j and uses the Cypher language to query the data.

### 5. Run custom queries
See the **query_examples.rq** file for examples of SPARQL queries and adapt them to your needs.

## Output
### Graph DB throught Neo4J
Shows all nodes and relationships:
```cypher
MATCH (n)-[r]->(m) RETURN n, r, m
```
or
```cypher
MATCH (n) RETURN n
```
![graph](https://github.com/user-attachments/assets/9c4675f6-6401-4e60-ad94-496bfc6581f7)

### SPARQL Query throught BlazeGRaph
PREFIX : <http://family-griffin-graph.com/> 

#### SELECT Queries
##### Find all people
```sql
SELECT ?person 
WHERE {
    ?person a :Person .
} 
LIMIT 10
```
<img width="212" alt="1" src="https://github.com/user-attachments/assets/f0f619f2-b7c3-4124-b6a8-e0fb1f89e922" />

##### Find all parent-child pairs
```sql
SELECT DISTINCT ?parent ?child 
WHERE {
    ?parent :hasChild ?child .
} 
ORDER BY ?parent
```
<img width="419" alt="2" src="https://github.com/user-attachments/assets/53dd8e47-596d-464c-a4ef-b3c952c9532d" />

##### Find the number of children for each parent
```sql
SELECT ?parent (COUNT(?child) AS ?numChildren) 
WHERE {
    ?parent :hasChild ?child .
} 
GROUP BY ?parent
```
<img width="264" alt="3" src="https://github.com/user-attachments/assets/be644d7c-0bc7-4d17-a8eb-3b17cbcf98cd" />

#### CONSTRUCT, ASK, DESCRIBE
##### Construct a graph with all parent-child relationships
```sql
CONSTRUCT { 
	?parent :hasChild ?child . 
} 
WHERE {
    ?parent :hasChild ?child .
}
```
<img width="605" alt="4" src="https://github.com/user-attachments/assets/59766d37-05a6-4c30-b839-9818d2a9c3d2" />

##### Ask if Peter has a son
```sql
ASK 
WHERE {
    :PeterGriffin :hasChild ?child .
}
```
<img width="29" alt="5" src="https://github.com/user-attachments/assets/66066bb9-03fe-4273-a023-54feda2cfc71" />

##### Describe all the information about Peter
```sql
DESCRIBE :PeterGriffin
```
<img width="610" alt="6" src="https://github.com/user-attachments/assets/afe8f190-516a-4d7e-afa6-0dce612c06c6" />

#### OPTIONAL and FILTER
##### Find all people and, if possible, their spouses
```sql
SELECT ?person ?spouse 
WHERE {
    ?person a :Person .
    OPTIONAL { ?person :marriedTo ?spouse . }
}
```
<img width="415" alt="7" src="https://github.com/user-attachments/assets/90ed3dee-42fa-436d-9ea9-76dea813beb6" />

##### Find people with children, filtering only those with at least one specific child
```sql
SELECT ?person 
WHERE {
    ?person :hasChild ?child .
    FILTER (?child = :StewieGriffin)
}
```
<img width="209" alt="8" src="https://github.com/user-attachments/assets/6dd5496d-8c92-42f4-ab42-b7f8a512a0b8" />

##### Find parents without spouses
```sql
SELECT ?parent 
WHERE {
    ?parent :hasChild ?child .
    FILTER NOT EXISTS { ?parent :marriedTo ?spouse . }
}
```
<img width="205" alt="9" src="https://github.com/user-attachments/assets/3afacf8d-fe50-4d7e-8b5c-7cce17cc02ee" />

#### Property Paths
###### Find anyone connected through any relationship to Lois
```sql
SELECT ?connected 
WHERE {
    :LoisGriffin (:|!:)* ?connected .
}
```
<img width="212" alt="10" src="https://github.com/user-attachments/assets/a838bfe1-a2b7-44f2-a7c9-8767cbde9d1c" />

##### Find children and grandchildren of Peter
```sql
SELECT ?descendant 
WHERE {
    :PeterGriffin :hasChild/:hasChild ?descendant .
}
```
<img width="54" alt="11" src="https://github.com/user-attachments/assets/aefe0404-b0c6-4f94-ae5c-c92f72cb0c61" />

##### Finds all reachable people starting with Peter through a recursive relationship (one or more times)
```sql
SELECT DISTINCT ?reachable 
WHERE {
    :Peter (:hasChild)+ ?reachable .
}
```
<img width="50" alt="12" src="https://github.com/user-attachments/assets/7221380f-cd66-4a7d-a939-e5331b7383c7" />

#### Insiemistic Operators (UNION, MINUS)
##### Find all people who have children or are spouses, but exclude those who are children (are under 18 years old):
```sql
SELECT DISTINCT ?person 
WHERE {
    {
        ?person :hasChild ?child .
    } UNION {
        ?person :hasSpouse ?spouse .
    }
    MINUS {
        ?person :age ?age .
        FILTER (?age < 18) .
    }
}
```
<img width="209" alt="13" src="https://github.com/user-attachments/assets/684f53d8-0699-482c-9fd2-35d49d546024" />

#### BIND & COALESCE(IF..)) + RDF Terms Function
##### SPARQL Query with Turtle Serialization Format RDF Graph
##### Find all people and assign them a custom label based on their role. If the role is not defined, assign “Unknown Role.” Also, check whether the name is an IRI or a literal:
```
SELECT ?person ?label ?isLiteral 
WHERE {
    ?person a :Person ;
            :role ?role ;
            :name ?name .
  
    BIND(COALESCE(IF(?role = "father", "Father", 1/0),
                  IF(?role = "mother", "Mother", 1/0),
                  IF(?role = "son", "Son", 1/0),
                  IF(?role = "daughter", "Daughter", 1/0), 
                  "Unknown Role"
                 ) AS ?label
        )
    
    BIND(isLiteral(?name) AS ?isLiteral)
}
```
<img width="320" alt="14-15" src="https://github.com/user-attachments/assets/6da897a0-27b2-435f-9502-7150cfa4fd13" />

##### SPARQL Query with TriG Serialization Format RDF Graph
##### Find all people and assign them a custom label based on their role. If the role is not defined, assign “Unknown Role.” Also, check whether the name is an IRI or a literal:
```sql
SELECT ?person ?label ?isLiteral 
FROM :FamilyGriffin 
WHERE {
    ?person a :Person ;
            :role ?role ;
            :name ?name .
  
    BIND(COALESCE(IF(?role = "father", "Father", 1/0),
                  IF(?role = "mother", "Mother", 1/0),
                  IF(?role = "son", "Son", 1/0),
                  IF(?role = "daughter", "Daughter", 1/0), 
                  "Unknown Role"
                 ) AS ?label
        )
    
    BIND(isLiteral(?name) AS ?isLiteral)
}
```
<img width="320" alt="14-15" src="https://github.com/user-attachments/assets/2e27e854-a863-4102-b812-a0264344000f" />

## License
This project is distributed under the **Apache 2.0 License**. See the **LICENSE** file for further details.

*Note**: Feel free to contribute to the project! Submit a pull request or open an issue for improvements or suggestions.
