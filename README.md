# freerasp_brick

<p align="center">
<a href="https://github.com/felangel/mason"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge" alt="Powered by Mason"></a>
<a href="https://pub.dev/packages/freerasp"><img src="https://img.shields.io/badge/Supported%20freeRASP-%5E3.0.0-brightgreen" alt="Supported freeRASP"/></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

<p align="center">
A brick to automate configuration of freeRASP <a href="https://pub.dev/packages/freerasp">freeRASP</a>.
</p>

A brick to automate work with [freeRASP][8].

## How to use 🚀

```
mason make freerasp_brick
```

## Variables 📦
| Variable     | Description                   | Default         | Type   | Conditional | When            |
|--------------|-------------------------------|-----------------|--------|-------------|-----------------|
| watcher_mail | An email for security reports | N/A             | String | false       | N/A             |
| android      | Add Android configuration     | true            | bool   | false       | N/A             |
| package_name | Android app package name      | com.example.app | String | true        | android == true |
| signing_hash | Android app signing hash      | N/A             | String | true        | android == true |
| ios          | Add iOS configuration         | true            | bool   | false       | N/A             |
| bundle_id    | iOS app id                    | com.example.app | String | true        | ios == true     |
| team_id      | iOS team id                   | N/A             | String | true        | ios == true     |

## Hooks 🪝
| Type     | Enabled | Can be disabled |
|----------|---------|-----------------|
| pre-gen  | ✅       | ❌               |
| post-gen | ✅       | ❌               |

## Getting started with [mason][1]  🧱

If this is your first touch with mason, please refer to resources to get started:

- [Mason on pub.dev][1]
- [Official Mason Documentation][2]
- [Code generation with Mason Blog][3]
- [Very Good Livestream: Felix Angelov Demos Mason][4]

[1]: https://github.com/felangel/mason

[2]: https://github.com/felangel/mason/tree/master/packages/mason_cli#readme

[3]: https://verygood.ventures/blog/code-generation-with-mason

[4]: https://youtu.be/G4PTjA6tpTU
