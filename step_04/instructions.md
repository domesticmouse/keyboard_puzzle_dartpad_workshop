# Actions

> REMINDER: If you are doing this workshop on the Dartpad website, be sure to click on the application output once the app is running and double check if it is focused.

Now that you have set up your shortcuts. Let's add the actions for it.

You can add the actions in two different ways. As you remember from the previous page, Actions allow for the definition of operations that the application can perform by invoking them with an Intent.

You can either create your own Action type or, use `CallbackAction` and pass your variable. Let's learn about both of them now.

## Create your own Action type

You can create your own type of action by extending the `Action` class.

```dart
// Defines an action to remove the texts bound to the `TextEditingController` 
// if it is not empty and if it is empty, it unfocuses from the field. You can 
// see that you bound this action into your `ClearIntent`.
class ClearTextAction extends Action<ClearIntent> {
  ClearTextAction(
    this.controller,
    this.focusNode,
  );

  final TextEditingController controller;
  final FocusNode focusNode;

  // The `invoke` function is triggered each time the related intent is 
  // triggered by the Shortcuts widget.
  @override
  void invoke(covariant ClearIntent intent) {
    if (controller.text.isNotEmpty) {
      controller.clear();
    } else {
      focusNode.unfocus();
    }
  }
}
```

But, your widget tree still does not know which actions are available for the page that you are in. For that purpose, you will use `Actions` widget and pass this action into it.

First let's create your map like you did with shortcuts.

```dart
class _LoginPageState extends State<LoginPage> {
  late final FocusNode _focusNode;
  late final Map<LogicalKeySet, Intent> _shortcuts;
  late final Map<Intent, Action<Intent>> _actions;
  ...
}
```

Now, you assign the variable.

```dart
class _LoginPageState extends State<LoginPage> {
  ...
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(debugLabel: 'LoginPageNameFieldFocusNode');
    _shortcuts = <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.escape): const ClearIntent(),
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.enter):
          const CheckFieldValidity(),
    };
    _actions = <Type, Action<Intent>>{
      ClearIntent: ClearTextAction(
        _controller,
        _focusNode,
      ),
    };
  }
  ...
}
```

```dart
class _LoginPageState extends State<LoginPage> {
  ...
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: _shortcuts,
      child: Actions(
        actions: _actions,
        child: DecoratedBox(...),
      ),
    );
  }
  ...
}
```

You can see that under the `Shortcuts` now you have an `Actions` widget to call your actions from. It accepts a map of actions with intents to be able to use them.

If you run the application now, you can see that with the Escape button click, the text is cleared from the field.

## CallbackAction

Let's learn about the second way of creating an action using a `CallbackAction`.

```dart
class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    ...
    super.initState();
    _actions = <Type, Action<Intent>>{
      ClearIntent: ClearTextAction(
        _controller,
        _focusNode,
      ),
      CheckFieldValidity: CallbackAction(
        onInvoke: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _controller.text.isEmpty
                    ? 'Field should not be empty'
                    : 'Field is valid',
              ),
            ),
          );
        },
      ),
    };
  }
}
```

You can see that, `CallbackAction` gives us a chance to write the function directly where it belongs to. You can use it for calling your business logic or calling side effects. In the explanation above, you are adding a `SnackBar` to tell users if the field is empty or not.

Let's see how the implementation looks like in action:

![Step 4 Result](https://raw.githubusercontent.com/salihgueler/keyboard_puzzle_dartpad_workshop/main/step_04/output.gif)

Now that you have what you need. Let's move on to the game page to play the game!

>📝 Homework time! Now that you know, how to do keyboard shortcuts functioning, add a new intent called `SubmitFieldIntent` for `Enter` keyboard key. You will use it to navigate to the next Game Page.
