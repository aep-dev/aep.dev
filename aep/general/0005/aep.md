# Designing an API

This AEP serves as a high-level guide on designing an API that adheres to the
AEPs.

## Process summary

1. enumerate the user case would like your API to satisfy.
1. identify resources and add them to your API.
1. identify standard operations and add them to your API.
1. identify custom operations and add them to your API.

## Enumerate use cases

The first step in designing an API is understanding precisely what you would
like your user to be able to accomplish your API.

Enumerate one or more use cases to clarify what precisel

For example:

- Create a VM.
- List all VMs owned by a company.
- List all VMs owned by a user.
- Restart a running VM.
- Trade an in-game item with another player.

Some best practices:

- Attempt to define granular use cases that can be composed to
  satisfy more complex use cases.

## Identify resources

Once your use cases are defined, consider how many of those can be accomplished
by represented by an [API Resource Type][]: similar to object-oriented
programming, these are use cases that can be represented by entities that are
created, read, updated, and deleted.

Examples include:

- users
- virtual machine
- load balancers
- services

The core of the AEPs is resource-oriented design: this design paradigm allows
for uniform standard operations that reduce the cognitive overhead in learning
about the operations and schemas exposed by your API.

Resources can relate to each other, either as a parent-child relationship
defining ownership, or via references that defines the resources usage of
another resource in it's operations (e.g. a vm depending on a private network).

See the following AEPs to learn more about resource-oriented design:

- [resource paths][AEP-122]

## Identify standard operations

Once the resources are defined, identify one or more standard methods for each
of those resources. Standard methods operate on the lifecycle of a resource
lifecycle: namely, they create, read, update, delete, and list resources.

Ideally all 5 standard methods should be exposed for every resource.

See the following AEPs to learn more about the standard operations:

- [AEP-131][]

## Identify custom operations

To accomplish some of the user journeys, resources may need to support more
than just operations to create, read, update, delete, and list them. Some
examples include:

- restarting a virtual machine.
- cleaning a disk.

Break down each of the actions into granular operations, then follow the
[custom operations][] AEP on how to design them.

[API Resource Type]: /3#api-resource-type
[custom operations]: /136
