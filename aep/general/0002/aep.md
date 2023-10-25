# AEP Numbering and Organization

This document describes the numbering system and general organization of AEPs.

AEP numbers:

- Are unique. No two AEPs share the same number.
- Indicate the order in which they are authored.

To help with organization and discovery, AEPs also have a category and a slug
to easily discovery and refer to the AEP.

See below for an example of an AEP id, category, and slug, expressed via YAML
front-matter:

```yaml
id: 11
category: 'resources'
slug: 'create'
```

## AEP Numbers

### Core AEPs

To uniquely identify an AEP, each one is assigned a permanent number as it is
merged.

- A merged AEP **must** use the next available number.
- AEPs **must** be numbered between 1 and 9999.

### Organization-specific AEPs

- Organizations **may** extend the AEPs with guidance that is relevant to them.
- Organization-specific AEPs **must** use AEP numbers 10000 or greater.

## AEP Categories

To help with discovery of an AEP, each one is assigned a category: a string
that describes a theme or grouping the AEP belongs in.

- The category of an AEP **may** change over time.

As an example, the guidance around custom methods may grow to multiple AEPs. As
such, AEPS may create a new category "custom-methods" and recategorize relevant
AEPs (mutating custom methods, retrieval custom methods) under it.

Categories are expressed in the YAML front-matter of an AEP:

```yaml
category: 'custom-methods'
```

## AEP Slugs

Each AEP is given a slug: a string by which it can be easily referenced and
accessible via an URL on the aep.dev site.

- The slug of an AEP **may** change over time, sometimes to refer to a new
  revision of an existing AEP.
- On the AEP site, the AEP is then available by with a path of the slug:
  `/{slug}`.

For example, an AEP-123 may author guidance around a design pattern for
revisions of resources, and be given the slug "revisions". If a new AEP-1340
that provides a significant change is authored, then it may be use the slug
"revisions", with AEP-123 given a slug like "revisions-deprecated".

Slugs are expressed in the YAML front-matter of an AEP:

```yaml
slug: 'create'
```

And is available via the path "/create" on the site hosting aep.dev.

## Rationale

### Why AEP Slugs

In the original aip.dev project, numbers were the primary identifier for an
AEP. However, as a number does not hint to its purpose or the guidance it
contains, conversations around AIPs were difficult to hold and often the AIPs
were be referred to by an unofficial colloquial name rather than by its number.

As such, AEPs provide the ability for a semantic slug.

### Why AEP Categories

With aip.dev, numbers were an organizational scheme, with AIPs sorted by number
in navigation. Using numbers resulted in difficulties putting a new AEP
alongside related AEPs if a number was not available.

By adding categories, new AEPs can easily be organized, as well as produce more
granular categories as the need arises.

### Why Organization-specific AEPs

Similar to [google.aip.dev](google.aip.dev), the organizations supporting the
AEP project found the need for providing organization-specific guidance that is
a superset of the open specification. By allocating a specific range,
organizations may safely extend the AEPs without concern of conflicting AEP
numbers.
