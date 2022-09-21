# DCUBE/ENP Tech Assessment
Url shortening webapp

# Assumptions/Design Considerations
Privacy and potential for abuse are not currently concerns.
- Authentication can be added in an additional layer in the future
- ID (and thus base62code) generation can be made to be more random by modifying `data_access.getNexId()` in the future, at the cost of more collisions as storage nears capacitiy

A NoSQL database (mongoDB) was chosen instead of a relational database as the records are standalone documents with no relations between them.
A NoSQL database would thus be more scalable, with more efficient retrieval.
# Requirements
Only Docker is currently required
You may need to disable popup blockers for the redirection to work

# Running the application
The app has been deployed to Netlify and can be accessed [here](https://dcube-enp-url-shortener.netlify.app/#/) 

## Local run
1. Navigate to `DcubeENP` directory and run `Docker compose up`
2. Webapp can then be accessed at `localhost:8080`
