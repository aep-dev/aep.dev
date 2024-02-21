# Designing an API

This AEP serves as a high-level guide to designing an AEP-compliant API. AEPs.

## Process summary

1. Enumerate the use cases you would like your API to satisfy.
1. Identify resources.
1. Identify standard operations.
1. Identify custom operations.

## Enumerate use cases

The first step in designing an API is understanding precisely what operations
you would like your user to be able to perform. Enumerate these operations, attempting to
be as granular as possible.

For example, if the API is for VM management in a public cloud, the operations
may include:

- Create a VM.
- List all VMs owned by a company.
- List all VMs owned by a user.
- Restart a running VM.

Or for a multiplayer online game, operations may include:

- Proposing a trade to another player.
- Accepting a proposed trade.
- Find open trade offers containing an item.
- List items in a player's inventory.

Some best practices:

- Attempt to define granular use cases that can be composed to satisfy more
  complex use cases.

## Identify resources

Once your use cases are defined, consider how many of those can be represented
by an [API Resource Type][]: entities that are created, read, updated, and
deleted.

Examples include:

- users
- virtual machines
- load balancers
- services

One of the core concepts described by the AEPs is resource-oriented design:
this design paradigm allows for uniform standard operations that reduce the
cognitive overhead in learning about the operations and schemas exposed by your
API.

Resources can relate to each other. For example:

- A parent-child relationship defining ownership/scope (A user who created a
  VM).
- A resource dependency, where one resource depends on another to function (A
  VM depending on a disk).

See the following AEPs to learn more about resource-oriented design:

- [resource-oriented design][AEP-121]
- [resource paths][AEP-122]
- [resource types][AEP-123]

## Identify standard operations

Once the resources are defined, identify one or more standard methods for each
of those resources. Standard methods operate on the lifecycle of a resource
lifecycle: namely, they create, read, update, delete, and list resources.

Ideally all five standard methods should be exposed for every resource.

See the following AEPs to learn more about the standard methods:

- [AEP-131][]

## Identify custom operations

To accomplish some of the user journeys, resources may need to support
operations other than [Create][AEP-133], [Update][AEP-134], [AEP-135][Delete],
[AEP-131][Get], and [AEP-132][List] them. Some examples include:

- restarting a virtual machine
- triggering a CI build
- wiping a disk

Break down each of the actions into granular operations, then follow the
[custom operations][] AEP on how to design them.

[API Resource Type]: /3#api-resource-type
[custom operations]: /136
