# freerasp_brick

<p align="center">
<a href="https://github.com/felangel/mason"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge" alt="Powered by Mason"></a>
<a href="https://pub.dev/packages/freerasp"><img src="https://img.shields.io/badge/Supported%20freeRASP-%5E3.0.0-brightgreen" alt="Supported freeRASP"/></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
<a href="https://pub.dev/packages/very_good_analysis"><img src="https://img.shields.io/badge/style-very_good_analysis-B22C89.svg" alt="style: very good analysis"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

<p align="center">
A brick for configuration generation and automatic setup for <a href="https://pub.dev/packages/freerasp">freeRASP</a>.
</p>

> 🚧 This brick is experimental and not stable! Changes to API reserved. 🚧

## Overview
Setting up freeRASP can be quite tedious and repetitive. freerasp_brick provides you error-prone 
way to create configuration.

## Features 🧰
- 🛠 Configuration generation
- 🎯 Dependency check using `pub get`
- 🔧 Fix apply using `dart fix`

## How to add ➕
This brick is currently **NOT** available on [brickhub.dev](https://brickhub.dev/). 

For now, you can add via git-url:
```
mason add --git-url https://github.com/yardexx/freerasp_brick freerasp_brick
```

Globally available:
```
mason add -g --git-url https://github.com/yardexx/freerasp_brick freerasp_brick
```

## How to use 🚀

Generate configuration:
```
mason make freerasp_brick
```

Import it and call `start()`:
```dart
import 'freerasp/freerasp.g.dart';

talsec.start();
```

You can edit `freerasp_callback.g.dart` to provide own reactions or made your own `TalsecCallback`
and provide it in `freerasp.g.dart`;

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

## Hooks 🎣
| Type     | Enabled | Can be disabled |
|----------|---------|-----------------|
| pre-gen  | ✅       | ❌               |
| post-gen | ✅       | ❌               |

## Getting started with [freeRASP][freerasp-pubdev]
- [freeRASP on GitHub][freerasp-github]
- [freeRASP website][freerasp-website]
- [Medium article: freeRASP — In-App protection SDK and app security monitoring service][freerasp-medium]

## Getting started with [mason][mason-github]  🧱

If this is your first touch with mason, please refer to resources to get started:

- [Mason on GitHub][mason-github]
- [Official Mason Documentation][mason-docs]
- [Code generation with Mason Blog][mason-blog]
- [Very Good Livestream: Felix Angelov Demos Mason][mason-yt]

[mason-github]: https://github.com/felangel/mason

[mason-docs]: https://github.com/felangel/mason/tree/master/packages/mason_cli#readme

[mason-blog]: https://verygood.ventures/blog/code-generation-with-mason

[mason-yt]: https://youtu.be/G4PTjA6tpTU

[freerasp-github]: https://github.com/talsec/Free-RASP-Flutter

[freerasp-pubdev]: https://pub.dev/packages/freerasp

[freerasp-website]: https://www.talsec.app/freerasp-in-app-protection-security-talsec

[freerasp-medium]: https://medium.com/geekculture/freerasp-in-app-protection-sdk-and-app-security-monitoring-service-de12d8e49400
