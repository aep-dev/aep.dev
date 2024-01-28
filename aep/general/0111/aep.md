# Planes

Resources and methods on an API can be divided into the _plane_ that they
reside or perform operations upon. For the context of APIs, the following
planes are defined:

- Management plane: a uniform, resource-oriented API that primarily configures
  and allows retrieval of resources.
- Data plane: a heterogenous API (ideally resource-oriented) that reads and
  write user data. Often connects to entities provisioned by the management
  plane, such as virtual machines.

The term "plane" was originally used in networking architecture. Although
system and network architecture often defines additional planes (e.g. control
plane or power planes), as the AEPs are focused on the interface, they are not
defined in this AEP.

## Guidance

### Management Plane

Management resources and methods exist primarily to provision, configure, and
audit the resources that the data plane interfaces with.

As an example, the following are considered management resources for a cloud
provider:

- virtual machines
- virtual private networks
- virtual disks
- a blob store instance
- a project or account

### Data Plane

Methods on the data plane operate on user data in a variety of data formats,
and generally interface with a resource provisioned via a management plane API.
Examples of data plane methods include:

- writing and reading rows in a table
- pushing to or pulling from a message queue
- uploading blobs to or downloading blobs from a blob store instance

Data plane APIs **may** be heterogenous across a larger API surface, due to
requirements including high throughput, low latency, or the need to adhere to
an existing interface specification (e.g. ANSI SQL).

- For convenience, resources and methods that operate on the data plane **may**
  expose themselves via resource-oriented management APIs. If so, those
  resources and methods **must** adhere to the requirements of the management
  plane as specified in the other AEPs.

### Major distinctions between management and data plane

- [Declarative clients][] operate on the management plane exclusively.
- Data planes are often on the critical path of user-facing functionality, and
  therefore:
  - Have higher availabilty requirements than management planes.
  - Are more peformance-sensitive than management planes.
  - Require higher-throughput than management planes.

[Declarative clients]: ./0003.md#declarative-clients

## Changelog

- **2024-01-27**: initial fork of this AEP from https://google.aip.dev/111.
