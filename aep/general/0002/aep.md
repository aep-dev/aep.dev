# AEP Numbering

This document describes the numbering system.

AEP provides a numbering system that:

- Groups AEPs primarily by their purpose, and secondarily by the general theme
  they are discussing.
- Allows for new AEPs to be added incrementally, without adjusting the
  numbers of existing AEPs.

## AEP Blocks

The list of blocks are:

| Range     | Name            | Description                                                                                                                                                                           |
| --------- | --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1-999     | meta topics     | topics that are not directly related to API guidance, but provide guidance or clarity for the AEPs themselves                                                                         |
| 1000-1999 | specification   | APIs which are AEP-compliant **must** adhere to these AEPs. Clients authors may read these AEPs to determine what behavior they can rely on when integrating with AEP-compliant APIs. |
| 2000-2999 | design patterns | Best practice design patterns for common API use cases. API authors should read these AEPs to help with the  design of their APIs.                                                    |
| 3000-9999 | reserved        | Reserved for future use by the AEP project.                                                                                                                                           |

## Organization-specific AEPs

Organizations **may** extend the AEPs with guidance that is relevant to them.
When doing so, they **must** use the AEP range 10000-11000.

## Rationale

Providing well delineated AEP blocks helps guide users of the AEPs to the
specific sections that are relevant to them. Providing blocks of 1000 ensures
that are a sufficient number to ensure that any future guidance may be easily
added.

Similar to [google.aip.dev](google.aip.dev), the organizations supporting the
AEP project found the need for providing organization-specific guidance that is
a superset of the open specification. By allocating a specific range,
organizations may safely extend the AEPs without concern of conflicting AEP
numbers.