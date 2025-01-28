CREATE (:Person {name: "Peter Griffin", age: 43, gender: "male", role: "father"});
CREATE (:Person {name: "Lois Griffin", age: 42, gender: "female", role: "mother"});
CREATE (:Person {name: "Meg Griffin", age: 18, gender: "female", role: "daughter"});
CREATE (:Person {name: "Chris Griffin", age: 16, gender: "male", role: "son"});
CREATE (:Person {name: "Stewie Griffin", age: 1, gender: "male", role: "baby"});
CREATE (:Animal {name: "Brian Griffin", species: "dog", role: "pet"});

MATCH (peter:Person {name: "Peter Griffin"}), (lois:Person {name: "Lois Griffin"})
CREATE (peter)-[:MARRIED_TO]->(lois);

MATCH (peter:Person {name: "Peter Griffin"}), (meg:Person {name: "Meg Griffin"})
CREATE (peter)-[:HAS_CHILD]->(meg);

MATCH (lois:Person {name: "Lois Griffin"}), (meg:Person {name: "Meg Griffin"})
CREATE (lois)-[:HAS_CHILD]->(meg);

MATCH (peter:Person {name: "Peter Griffin"}), (chris:Person {name: "Chris Griffin"})
CREATE (peter)-[:HAS_CHILD]->(chris);

MATCH (lois:Person {name: "Lois Griffin"}), (chris:Person {name: "Chris Griffin"})
CREATE (lois)-[:HAS_CHILD]->(chris);

MATCH (peter:Person {name: "Peter Griffin"}), (stewie:Person {name: "Stewie Griffin"})
CREATE (peter)-[:HAS_CHILD]->(stewie);

MATCH (lois:Person {name: "Lois Griffin"}), (stewie:Person {name: "Stewie Griffin"})
CREATE (lois)-[:HAS_CHILD]->(stewie);

MATCH (brian:Animal {name: "Brian Griffin"}), (peter:Person {name: "Peter Griffin"})
CREATE (brian)-[:OWNED_BY]->(peter);

MATCH (brian:Animal {name: "Brian Griffin"}), (lois:Person {name: "Lois Griffin"})
CREATE (brian)-[:OWNED_BY]->(lois);

MATCH (meg:Person {name: "Meg Griffin"}), (chris:Person {name: "Chris Griffin"})
CREATE (meg)-[:SIBLING_OF]->(chris);

MATCH (meg:Person {name: "Meg Griffin"}), (stewie:Person {name: "Stewie Griffin"})
CREATE (meg)-[:SIBLING_OF]->(stewie);

MATCH (chris:Person {name: "Chris Griffin"}), (stewie:Person {name: "Stewie Griffin"})
CREATE (chris)-[:SIBLING_OF]->(stewie);