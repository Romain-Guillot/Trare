# Contributing

**A branch cannot be merged with master IT IT DOES NOT follow the following code documentation conventions.**

## Git
###### Branches

```
master  // main stable branch DO NOT work here, never
sprint1  // main (as stable as possible) branch for the current sprint
sprint1_dev_username  // working branch for username
```

Branch naming are very important as the CI/CD tool (CodeMagic) use branch name pattern to do appropriate workflow.

###### Merge
Integrate the changes from the master branch (of the origin remote) on your local branch (then fix conflicts if any) then merge the master with your updated branch.
```
git(???)      $ git checkout mybranch   // go to your branch
git(mybranch) $ git pull origin master  // fetch master and merge with your branch
git(mybranch) $ git checkout master     // go to master
git(master)   $ git merge mybranch      // merge master with your updated branch
```

Note: `git pull` = `git fetch` + `git merge`

###### Commit
USE english language, **short and concise** message : preferably begins with a verb and DO NOT finished with a period (useless)

Example:
```
5ba3db6 Fix failing CompositePropertySourceTests
84564a0 Rework @PropertySource early parsing logic
e142fd1 Add tests for ImportSelector meta-data
887815f Update docbook dependency and generate epub
ac8326d Polish mockito usage
```
Source : https://chris.beams.io/posts/git-commit/

## Documentation
Following components MUST always be commented
- Repository : class, methods and public fields
- Provider : at least class and methods (preferably public fields, or at least in the class level documentation)
- UI :
    - Main pages have to be commented (at least the class, preferably methods and optionally fields)
    - Shared widget have to be commented (at least the class, preferably methods and optionally fields)
    - Widget component have to be commented (at least the class, preferably methods and optionally fields)

READ this guide : https://dart.dev/guides/language/effective-dart/documentation

## UI
- DOESN'T use hard corded string or values, use `ui > shared > strings.dart` or `ui > shared > dimens.dart`
- HAVE a file for each page
- CONSIDER writing small widget (not very deep tree) to have reusable widget, **ONE widget = ONE scope / responsability** (hint: a maximum depth of 4 or 5, the build method has to be visible in a normal sceen <50 lines)
- KEEP main page short (just call your reusable widgets)
- USE app theme color and font (not hard coded)
- PREFER shadow over elevation
- KEEP stateful widget small as possible
- DO NOT include processes in you build method (delegate to another function) (`onPressed: myHandlerFunction`)

READ https://flutter.dev/docs/perf/rendering/best-practices 

## Coding conventions

###### Components
- Suffix repositories with **"Repository"** and place them in `lib/repositories/`
- Suffix providers with **"Provider"** and place them in `lib/logic/`
- Suffix UI pages (widget that containes the Scaffold) with **"Page"** and place them in `lib/ui/<my_feature>/`

###### Naming
Source : https://dart.dev/guides/language/effective-dart/style
- DO name types using UpperCamelCase (`class MyClass`, `enum MyEnum`, ...)
- DO name other identifiers (methods, fields, ...) and constants using lowerCamelCase (`var myField` , `bool myMethod(int myParam)`)
- DO capitalize acronyms and abbreviations longer than two letters like words (`HttpConnectionInfo`, `IOStream`)
- DO name source files using lowercase_with_underscores (`my_file.dart`)

###### Ordering
Organize your classes in this order :
1. Static fields
1. Fields
1. Constructors
1. Overridden methods
1. Methods

###### Blank lines
Insert blank lines in the following cases :
- ONE between class declaration and fields
- ONE between static fields and others
- ONE between methods
- THREE between two classes

```dart
class MyClass {

    int myField;
    bool myBool;

    MyClass(this.myField, this.myBool);

    bool myMethod() {

    }

    bool mySecondMethod(String myParam) {

    }
}
```

Some blank lines are also accepted depending on the situation, use your common sense.


###### Others
- AVOID lines longer than 80 characters (certain cases are accepted)
- DON’T use .length to see if a collection is empty (use `myCollec.isEmpty` or `myCollex.isNotEmpty`)
- PREFER named-parameters in constructors (`MyClass({this.myField, bool otherField})`)
- PREFER direct cosntructore initialization with `this` keyword (`MyClass({this.myField})` and NOT `MyClass(int myField) { this.myField = myField}`)
- Use implicit typing for local variables when the type of the variable is obvious (`var myObject = MyClass()`)
- DON'T use `new` keyword (`var myObject = MyClass()` NOT `var myObject = new MyClass()`)
- CONSIDER using => for short members whose body is a single return statement (`etState(() => _image = image);` , `(val) => val.isEmpty ? errorMessage : null`)
