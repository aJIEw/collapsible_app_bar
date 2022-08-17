# CollapsibleAppBar

A widget that has a collapsible app bar.

<details><summary>Click to view Screenshots</summary>

| Expanded                                     | Collapsed                                      |
| -------------------------------------------- | ---------------------------------------------- |
| ![expanded](./media/screenshot_expanded.png) | ![collapsed](./media/screenshot_collapsed.png) |
</details>

## Getting started

Add dependency in your `pubspec.yaml`:

```yaml
dependencies:
  collapsible_app_bar: ^0.0.1
```

Run `flutter pub get` to install the package.

## Usage

To use this widget, you need to specify `expendedHeight` property which means the app bar's height when expanded, and the `body` widget which can be any widget you want to put under the app bar, it will scroll as the app bar collapse.

```dart
CollapsibleAppBar(
  shrinkTitle: 'Page Title',
  expandedHeight: 250,
  body: const Center(child: Text('body')),
)
```

For more usage, please run the example.