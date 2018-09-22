# ReactiveButton

A Widget that mimics the Facebook Reaction Button in Flutter.

<img src="https://www.didierboelens.com/images/reactive_button.gif" width="220" alt="Flutter ReactiveButton" />
<br/><br/>

---
## Step by step explanation

A full explanation on how to build such Widget may be found on my blog:

* in English, click [here](https://www.didierboelens.com/2018/09/reactive-button/)
* in French, click [here](https://www.didierboelens.com/fr/2018/09/reactive-button/)

---
## Getting Started

You should ensure that you add the following dependency in your Flutter project.
```yaml
dependencies:
 flutter_reactive_button: "^1.0.0"
```

You should then run `flutter packages upgrade` or update your packages in IntelliJ.

In your Dart code, to use it:
```dart
import 'package:flutter_reactive_button/flutter_reactive_button.dart';
```

---
## Icons

Icons should be defined as assets and passed to the ReactiveButton Widget, via the **icons** property, which accepts a **List < ReactiveIconDefinition >**.

For your convenience, you will find the images that are used in the sample, in the file '*images.zip*', please read the '*README.md*', included in the ZIP file, for further instructions on how to use these images in your project.

---
## Example

An example can be found in the `example` folder.  Check it out.

