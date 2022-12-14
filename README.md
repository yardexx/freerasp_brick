# freeRASP brick

<p align="center">
<a href="https://github.com/felangel/mason"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge" alt="Powered by Mason"></a>
<a href="https://pub.dev/packages/freerasp"><img src="https://img.shields.io/badge/Supported%20freeRASP-%5E3.0.0-brightgreen" alt="Supported freeRASP"/></a>
<a href="https://github.com/yardexx/freerasp_brick/actions/workflows/brick_workflow.yml"><img src="https://github.com/yardexx/freerasp_brick/actions/workflows/brick_workflow.yml/badge.svg"/></a>
<a href="https://codecov.io/gh/yardexx/freerasp_brick"><img src="https://codecov.io/gh/yardexx/freerasp_brick/branch/master/graph/badge.svg?token=300N5C20OB"/></a>
<a href="https://pub.dev/packages/very_good_analysis"><img src="https://img.shields.io/badge/style-very_good_analysis-B22C89.svg" alt="style: very good analysis"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p> 

<p align="center">
A brick for <a href="https://pub.dev/packages/freerasp">freeRASP</a> to generate configuration code 
and automate necessary setup.
</p>

> 🚧 This brick is experimental and not stable! Changes to API/file generation reserved.

## Overview
Setting up freeRASP can be quite tedious and repetitive. freerasp_brick provides you error-proof 
way to create configuration.

## Features 🧰
- 🛠 Configuration generation
- 🎯 Dependency check using `pub get`
- 🔧 Fix apply using `dart fix`
- 🤖 Android SDK level check and automatic update
- 🍎 iOS script insertion in Runner.xcscheme (Experimental)

## How to add ➕

### Using BrickHub.dev
You can add freerasp_brick to your project just like any other brick:
```shell
mason add freerasp_brick
```

### Using GitHub dependency
You can also add freerasp_brick to your project using `--git-url` option:
```shell
mason add --git-url https://github.com/yardexx/freerasp_brick freerasp_brick
```

> 💡 If you plan to use freeRASP in many different projects, it's useful to have freerasp_brick as global brick. You can do it by adding `--global` option.

## How to use 🚀

You can generate freeRASP configuration by running:
```shell
mason make freerasp_brick
```

After providing necessary information, freerasp_brick will generate following file structure:
```
freerasp
├── freerasp.g.dart
└── freerasp_callback.g.dart
```

Then simply import `freerasp.g.dart` in your desired file and use it:
```dart
import 'freerasp/freerasp.g.dart';

// Some other code...

talsec.start();
```

## Generated reactions 💣

Default generated reaction for every callback is `print` to console.

If you wish to change it, you can do so by editing `freerasp_callback.g.dart` file.

## Variables 📦
| Variable      | Description                   | Default         | Type   | Conditional | When            |
|---------------|-------------------------------|-----------------|--------|-------------|-----------------|
| watcher_mail  | An email for security reports | N/A             | String | false       | N/A             |
| android       | Add Android configuration     | true            | bool   | false       | N/A             |
| package_name  | Android app package name      | com.example.app | String | true        | android == true |
| signing_hash  | Android app signing hash      | N/A             | String | true        | android == true |
| update_gradle | Update build.gradle file      | true            | bool   | true        | android == true |
| ios           | Add iOS configuration         | true            | bool   | false       | N/A             |
| bundle_id     | iOS app id                    | com.example.app | String | true        | ios == true     |
| team_id       | iOS team id                   | N/A             | String | true        | ios == true     |
| update_scheme | Update Runner.xcscheme file   | true            | bool   | true        | ios == true     |

> ⚠ Since freerasp_brick is heavily dependent on hooks, using `-c` option won't skip prompts generated by hooks.

## Hooks 🎣
| Type     | Enabled | Can be disabled |
|----------|---------|-----------------|
| pre-gen  | ✅       | ❌               |
| post-gen | ✅       | ❌               |

> ⚠ Brick won't generate files correctly if you disable `pre-gen` or `post-gen` hook.

## Contribution 🤝
For issues, bugs, or feature proposals feel free to [open issue](https://github.com/yardexx/freerasp_brick/issues) 
or [create PR](https://github.com/yardexx/freerasp_brick/pulls). 

## Useful resources 📚
If this is your first touch with freeRASP or Mason, you refer to these resources to get started:

### Getting started with [freeRASP][freerasp-pubdev] 🛡
- [freeRASP on GitHub][freerasp-github]
- [freeRASP website][freerasp-website]
- [Medium article: freeRASP — In-App protection SDK and app security monitoring service][freerasp-medium]

### Getting started with [mason][mason-github]  🧱
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
