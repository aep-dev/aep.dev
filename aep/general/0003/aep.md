# Glossary

This AEP defines common terminology.

## Guidance

The following terminology **must** be used consistently throughout AEPs.

### API

Application Programming Interface. This can be a local interface (such as an
SDK) or a Network API (defined below).

### API Backend

A set of servers and related infrastructure that implements the business logic
for an API Service.

### API Client

An API Client is a program or library that perform a specific tasks by calling
an API or generic tools, such as CLIs, that expose the API in a user-accessible
fashion or operate on resource data at rest.

Examples of clients include the following:

- Command line interfaces
- Libraries, such as an SDK for a particular programming language
- Scripts that operates on a JSON representation of a resource after reading it
  from an API
- Tools, such as a [Declarative client][]
- Visual UIs, such as a web application

### API Definition

A well-structured representation of an API Service.

### API Endpoint

Refers to a network address that an API Service uses to handle incoming API
Requests. One API Service may have multiple API Service Endpoints, such as
`https://pubsub.example.com` and `https://content-pubsub.example.com`.

### API Gateway

One or more services that together provide common functionality across API
Services, such as load balancing and authentication.

### API Method

An individual operation within an API. It is typically represented in Protocol
Buffers by an `rpc` definition, or in HTTP via a `method` and a `path`.

### API Request

A single invocation of an API Method. It is often used as the unit for billing,
logging, monitoring, and rate limiting.

### API Resource

An object upon which one or more API methods operate.

### API Resource Type

An API resource type represents a category of that consumes and API,

### Consumer

Either a programmatic client or a user that consumes an API. This term should
be used when a statement refers broadly to both programs and users.

### Declarative Clients

Declarative Clients, also known as Infrastructure as Code (IaC), describes a
category of clients that consumes a markup language or code that represents
resources exposed by an API, and executes the appropriate imperative actions to
drive the resource to that desired state. To determine what changes to make and
if a set of updates was successful a declarative client compares server side
resource attributes with client defined values. The comparison feature ensures
accuracy of a creation or an update but it requires services to treat the
client set fields as read-only and diligently preserve those values.

Examples of complexities that declarative clients abstract away include:

- Determing the appropriate imperative action (create / update / delete) to
  achieve desired state.
- Ordering of these imperative actions.

[Terraform][] is an example of such a client.

### User

A human being which is using an API directly, such as with cURL. This term is
defined to differentiate usage in the AIPs between a human _user_ and a
programmatic _client_.

### Network API

An API that operates across a network of computers. Network APIs communicate
using network protocols including HTTP, and are frequently produced by
organizations separate from those that consume them.

[declarative clients]: #declarative-clients
[terraform]: https://www.terraform.io/

## Changelog
