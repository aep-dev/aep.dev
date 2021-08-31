# Resource-oriented design

Resource-oriented design is a pattern for specifying API services, based on
several high-level design principles (most of which are common to recent public
HTTP APIs):

- The fundamental building blocks of an API are individually-named _resources_
  (nouns) and the relationships and hierarchy that exist between them.
- A small number of standard _operations_ (verbs) provide the semantics for
  most common operations. However, custom operations are available in
  situations where the standard operations do not fit.
- Stateless protocol: Each interaction between the client and the server is
  independent, and both the client and server have clear roles.

Readers might notice similarities between these principles and some principles
of [REST][]; resource-oriented design borrows many principles from REST, while
also defining its own patterns where appropriate.

## Guidance

When designing an API, consider the following (roughly in logical order):

- The resources (nouns) the API will provide
- The relationships and hierarchies between those resources
- The schema of each resource
- The operations (verbs) each resource provides, relying as much as possible on
  the standard operations.

### Resources

A resource-oriented API **should** generally be modeled as a resource
hierarchy, where each node is either an individual resource or a collection of
resources.

A _collection_ contains resources of _the same type_. For example, a publisher
has the collection of books that it publishes. A resource usually has fields,
and resources may have any number of sub-resources (usually collections).

**Note:** While there is some conceptual alignment between storage systems and
APIs, a service with a resource-oriented API is not necessarily a database, and
has enormous flexibility in how it interprets resources and operations. API
designers **should not** tightly couple their API surface to their underlying
database system.

### Operations

Resource-oriented APIs emphasize resources (data model) over the operations
performed on those resources (functionality). A typical resource-oriented API
exposes a arbitrary number of resources with a small number of operations on
each resource. The operations can be either the standard operations or custom
operations.

**Note:** A custom operation in resource-oriented design does _not_ entail
defining a new or custom HTTP method. Custom operations use traditional HTTP
methods (usually `POST`) and define the custom verb in the URI. See AIP-136 for
more detail.

Resources **should** include all of the standard operations; however, resources
**may** exclude some standard operations if there is a justification for doing
so (for example, a read-only resource would exclude all write operations).

Similarly, services **should** prefer standard operations over custom
operations; the purpose of custom operations is to define functionality that
does not cleanly map to any of the standard operations. Custom operations offer
the same design freedom as traditional [RPC][] APIs, which can be used to
implement common programming patterns, such as database transactions, import
and export, or data analysis.

### Stateless protocol

As with most public APIs available today, resource-oriented APIs **must**
operate over a stateless protocol: The fundamental behavior of any individual
request is independent of other requests made by the caller.

In an API with a stateless protocol, the server has the responsibility for
persisting data, which may be shared between multiple clients, while clients
have sole responsibility and authority for maintaining the application state.

[rest]: https://en.wikipedia.org/wiki/Representational_state_transfer
[rpc]: https://en.wikipedia.org/wiki/Remote_procedure_call
