# AEP Numbering and Organization

This document describes the numbering system and general organization of AEPs.

AEP numbers:

- Are unique. No two AEPs share the same number.
- Indicate the order in which they are authored.

To help with organization and discovery, AEPs also have a category and a slug
to easily discovery and refer to the AEP.

## AEP Numbers

### Core AEPs

To uniquely identify an AEP, each one is assigned a permanent number once it
has been merged into the aep.dev repository. The AEP number assigned **must**
be the next available number. AEPs **must** be numbered between 1 and 9999.

### Organization-specific AEPs

Organizations **may** extend the AEPs with guidance that is relevant to them.
When doing so, they **must** use AEP numbers 10000 or greater.

## AEP Categories

To help with discovery of an AEP, each one is assigned a category: a string the
describes a theme or grouping the proposal belongs in. The category of a
proposal **may** change over time.

## AEP Slugs

Each AEP is given a slug: a string by which it can be easily referred to. The
slug of an AEP **may** change over time, sometimes to refer to a new revision
of an existing AEP.

## Rationale

### Why AEP Slugs

In the original aip.dev project, numbers were the primary identifier for a
proposal. However, as a number does not hint to its purpose or the guidance it
contains, conversations around AIPs were difficult to hold and often the AIPs
were be referred to by an unofficial colloquial name rather than by its number.

As such, AEPs provide the ability for a semantic slug.

### Why AEP Categories

With aip.dev, numbers were an organizational scheme, with AIPs sorted by number
in navigation. Using numbers resulted in difficulties putting new proposals
alongside related proposals if a number was not available.

By adding categories, AEPs can easily organize new proposals, as well as
produce more granular categories as the need arises.

### Why Organization-specific AEPs

Similar to [google.aip.dev](google.aip.dev), the organizations supporting the
AEP project found the need for providing organization-specific guidance that is
a superset of the open specification. By allocating a specific range,
organizations may safely extend the AEPs without concern of conflicting AEP
numbers.
