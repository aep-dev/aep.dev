# Resource types

Most APIs expose _resources_ (their primary nouns) which users are able to
create, retrieve, and manipulate. APIs are allowed to name their resource types
as they see fit, and are only required to ensure uniqueness within that API.
This means that it is possible (and often desirable) for different APIs to use
the same type name. For example, a Memcache and Redis API would both want to
use `Instance` as a type name.

When mapping the relationships between APIs and their resources, however, it
becomes important to have a single, globally-unique type name. Additionally,
tools such as Kubernetes or GraphQL interact with APIs from multiple providers.

## Guidance

APIs **must** define a resource type for each resource in the API, according to
the following pattern: `{API Name}/{Type Name}`. The type name:

- **must** Only contain ASCII alphanumeric characters.
- **must** Start with a lowercase letter.
- **must** Be of the singular form of the noun.
- **must** Use kebab case.
- For Kubernetes, the type name when converted to UpperCamelCase **must** match
  the [object][] name.
- For OpenAPI, the type name when converted to UpperCamelCase **must** match
  the name of the schema representing the object.
- For protobuf, the type name when converted to UpperCamelCase **must** match
  the name of the protobuf message.

### Examples

Examples of resource types include:

- `networking.istio.io/instance`
- `pubsub.example.com/topic`
- `pubsub.example.com/subscription`
- `spanner.example.com/database`
- `spanner.example.com/instance`
- `apis.example.com/user/user-event`

### Annotating resource types

APIs **must** annotate the resource types for each resource in the API

{% tab proto %}

For protobuf, use the [`google.api.resource`][resource] annotation:

```proto
// A representation of a user event.
message Topic {
  option (google.api.resource) = {
    type: "user.example.com/user-event"
    singular: "user-event"
    plural: "user-events"
    // define one or more patterns, e.g. if a resource has more than one parent.
    pattern: "projects/{project}/user-events/{user-event}"
    pattern: "folder/{folder}/user-events/{user-event}"
    pattern: "users/{user}/events/{user-event}"
  };

  // Name and other fields...
```

{% tab oas %}

For OpenAPI 3.0, use the `x-aep-resource` extension:

```json
{
  "type": "object",
  "x-aep-resource": {
    "singular": "user-event",
    "plural": "user-events",
    "patterns": [
      "projects/{project}/user-events/{user-event}",
      "folder/{folder}/user-events/{user-event}",
      "users/{user}/events/{user-event}"
    ]
  }
}
```

{% endtabs %}

- The `singular` field **must** be the kebab-case singular type name.
- The `plural` field **must** be the kebab-case plural of the singular.

The `pattern` field **must** match the `pattern` rule in the following grammar,
expressed as [EBNF][EBNF]:

```ebnf
pattern = element, { "/", element };
element = variable | literal;
variable = "{", literal, "}";
```

Where `literal` matches the regex `[a-z][a-z0-9\-]*[a-z0-9]`.

- Patterns **must** match the possible [resource paths][resource-paths] of the
  resource.
- Pattern variables (the segments within braces) **must** match the singular of
  the resource whose id is being matched by that value.

#### Pattern uniqueness

If multiple patterns are defined within a resource, the patterns defined **must
not** overlap in the set of resource paths that they can match. In other words,
a resource path may match at most one of the patterns.

For example, the following two patterns would not be valid for the same
resource:

- `user/{user}`
- `user/{user_part_1}~{user_part_2}`

## Rationale

### Singular and Plural

Well-defined singular and plurals of a resource enable clients to determine the
proper name to use in code and documentation.

google.aip.dev uses UpperCamelCase for resource types, while aep.dev uses
kebab-case. This is to enforce better consistency in the representation of
various multipart strings, as collection identifiers use kebab case.

<!-- prettier-ignore-start -->
[resource-paths]: /resource-paths
[API Group]: https://kubernetes.io/docs/concepts/overview/kubernetes-api/#api-groups
[nested collections]: ./0122.md#collection-identifiers
[Object]: https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api-conventions.md#types-kinds
[resource]: https://github.com/googleapis/googleapis/blob/master/google/api/resource.proto
[service configuration]: https://github.com/googleapis/googleapis/blob/master/google/api/service.proto
[EBNF]: https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_form
<!-- prettier-ignore-end -->

## Changelog
