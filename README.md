# Movie-Demo
Sample iOS App using Movie Database API

![](https://img.shields.io/badge/Swift-5.0-blue.svg?style=flat)

## Overview

This project is a demo iOS application using [The Movie DB](https://developers.themoviedb.org/3/getting-started).


## Installation

Fork and then clone, or simply clone the repository:

```
$ git clone git@github.com:creitz/Movie-Demo.git
```

The necessary cocoapods are included in source. But, you will need to generate the workspace:

```
$ sudo gem install cocoapods #(if you don't have cocoapods installed)
```

Change to the correct dir:

```
$ cd Movie-DemoU/
```

Change the value for `project` in Podfile to match your local structure. You only need to replace "path/to/here" with the absolute path to wherever you cloned the project. Then, you can install the pods

```
$ pod install
```

Finally, open the newly-created `Movie Demo.xcworkspace/` in Xcode - double clicking in finder (for Macs) will do the trick. Choose a simulator (or a device if you have a team profile) in the devices list and click the play button or command + R. iOS 10 and above supported.

## Author

Charles Reitz, cgreitz@gmail.com.

## License

MIT
