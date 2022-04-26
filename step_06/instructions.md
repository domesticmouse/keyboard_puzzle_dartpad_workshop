# Game Page Actions

> REMINDER: If you are doing this workshop on the Dartpad website, be sure to click on the the letter boxes once the app is running and it gets the initial focus.

In the previous step, you added the steps to have a functioning keyboard navigation. Let's make it actually work.

## Horizontal Navigation

First, you will decide on the strategy to follow to keep track of the indexes.

You have two sets of horizontal layout to interact with. You will keep track of the index in the horizontal position and decide on which vertical layout you belong by using `FocusNode`s.

Let's start by defining the layout.

```dart
class _GameState extends State<Game> {
  late final Map<LogicalKeySet, Intent> _shortcuts;
  late final Map<Type, Action<Intent>> _actions;
  late final FocusNode _focusNode;
  int _selectedIndex = 0;
  ...
}
```

`_selectedIndex` is stationed at 0 to give us a chance to have a starting point.

Now it is time to add functionality to it:

```dart
class _GameState extends State<Game> {
  ...
  void _moveLeft() {
    if (_selectedIndex > 0) {
      setState(() {
        _selectedIndex--;
      });
    }
  }

  void _moveRight() {
    setState(() {
      _selectedIndex++;
    });
  }
  ...
}
```

This way you can move your cursor left and right and actually add an affect to it on the screen on the UI.

> 📝 New homework time! Add a way to change the border color of the box to `Colors.redAccent` when it is focused and keep it as it is when it is not focused.

## Vertical Navigation

Next, you need to add the vertical navigation.

For that, you will add two `FocusNode`s and add them to the root widgets of the horizontal navigated widgets, which is the `Wrap` widgets.

```dart
class _GameState extends State<Game> {
  late final Map<LogicalKeySet, Intent> _shortcuts;
  late final Map<Type, Action<Intent>> _actions;
  late final FocusNode _focusNode;
  late final FocusNode _resultFocusNode;
  late final FocusNode _lettersFocusNode;
  ...
  @override
  void initState() {
    super.initState();
    ...
    _focusNode = FocusNode(debugLabel: 'GamePageFocusNode')..requestFocus();
    _resultFocusNode = FocusNode(debugLabel: 'GamePageResultFocusNode');
    _lettersFocusNode = FocusNode(debugLabel: 'GamePageLettersFocusNode')..requestFocus();
  }

  ...

  @override
  void dispose() {
    _focusNode.dispose();
    _resultFocusNode.dispose();
    _lettersFocusNode.dispose();
    super.dispose();
  }
```

You created the `FocusNode`s as you created them before. Now you will add them to the `Wrap` widget and to make it part of the Widget tree. For that, you will use `Focus` widget. Focus is a widget that manages a `FocusNode` to allow keyboard focus to be given to this widget and its descendants.

Let's wrap your `Wrap` widgets with Focus and assign the `FocusNode`s created for them.

```dart
class _GameState extends State<Game> {
  ...
  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      shortcuts: _shortcuts,
      actions: _actions,
      focusNode: _focusNode,
      child: Column(
        children: [
          Focus(
            focusNode: _resultFocusNode,
            child: Wrap(...),
          ),
          const SizedBox(height: 50),
          Focus(
            focusNode: _lettersFocusNode,
            child: Wrap(...),
          ),
        ],
      ),
    );
  }
  ...
}
```

Lastly you will add your logic to focus and unfocus to the vertical elements with keyboard navigation.

Flutter always expects you to focus on at least one element. But, the focus hierarchy is something that should be controlling. For making the controlling mechanism easier, `FocusNode` has helper functions called `previousFocus` and `nextFocus`. These helps you go through your focus elements without troubling you. But these are not useful in your case. You have 3 different `FocusNodes` and only want to travel between the two of them. That is why you will be using `requestFocus` and `unfocus` funcsions of the `FocusScope` and follow the rule of focusing at least one element all the time.

```dart
class _GameState extends State<Game> {
  ...
  @override
  void initState() {
    super.initState();
    ...
    _actions = <Type, Action<Intent>>{
      MoveLeftIntent: CallbackAction(onInvoke: (_) => _moveLeft()),
      MoveRightIntent: CallbackAction(onInvoke: (_) =>_moveRight()),
      MoveDownIntent: CallbackAction(onInvoke: (_) => _moverVertically()),
      MoveUpIntent: CallbackAction(onInvoke: (_) => _moverVertically()),
    };
    ...
  }

  void _moverVertically() {
    if (_lettersFocusNode.hasFocus) {
      _lettersFocusNode.unfocus();
      _resultFocusNode.requestFocus();
    } else {
      _resultFocusNode.unfocus();
      _lettersFocusNode.requestFocus();
    }
    setState(() {});
  }
  ...
}
```

You removed the up and down functions and combined them into one move vertically function. It checks if one of the nodes has focus and acts accordingly.

Now the current functionality looks like following:
![Step 6 Result](https://raw.githubusercontent.com/salihgueler/keyboard_puzzle_dartpad_workshop/main/step_06/output.gif)

Let's add the last gaming logic to the page and wrap it up!
