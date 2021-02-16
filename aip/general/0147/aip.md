# Sensitive fields

Sometimes APIs need to collect sensitive information such as private encryption
keys meant to be _stored_ by the underlying service but not intended to be
_read_ after writing due to the sensitive nature of the data. For this type of
data, extra consideration is required for the representation of the sensitive
data in API requests and responses.

## Guidance

If the sensitive information is _required_ for the resource as a whole to
exist, the data **should** be accepted as an [input-only field][input-only]
with no corresponding output field. Because the sensitive data must be present
for the resource to exist, users of the API may assume that existence of the
resource implies storage of the sensitive data. For example:

```typescript
interface SelfManagedKeypair {
  // The resource name of the keypair.
  name: string;

  // The public key data in PEM-encoded form.
  publicKey: Buffer;

  // The private key data in PEM-encoded form.
  set privateKey(k: Buffer): void;
}
```

If the sensitive information is _optional_ within the containing resource, an
[output-only][] boolean field with a postfix of `_set` **should** be used to
indicate whether or not the sensitive information is present. For example:

```typescript
interface Integration {
  name: string;
  uri: string;

  // A secret to be passed in the `Authorization` header of the webhook.
  set sharedSecret(secret: Buffer): void;

  // True if a `shared_secret` has been set for this Integration.
  readonly sharedSecretSet: boolean;
}
```

If it is important to be able to identify the sensitive information without
allowing it to be read back entirely, a field of the same type with an
`obfuscated_` prefix **may** be used instead of the boolean `_set` field to
provide contextual information about the sensitive information. The specific
nature of the obfuscation is outside the scope of this AIP. For example:

```typescript
interface AccountRecoverySettings {
  // An email to use for account recovery.
  set email(s: string): void;

  // An obfuscated representation of the recovery email. For example,
  // `ada@example.com` might be represented as `a**@e*****e.com`.
  readonly obfuscatedEmail: string;
}
```

[input-only]: /203#input-only
[output-only]: /203#output-only
