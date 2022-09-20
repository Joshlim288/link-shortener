# DCUBE/ENP Tech Assessment
Url shortening webapp

# Assumptions
Privacy and potential for abuse are not currently concerns.
- Authentication can be added in an additional layer in the future
- ID (and thus base62code) generation can be made to be more random by modifying `data_access.getNexId()` in the future, at the cost of more collisions as storage nears capacitiy

# Requirements
Only Docker is currently required
