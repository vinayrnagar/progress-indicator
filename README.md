# Progress Indicator
Minimalistic webapp using Express, AngularJS, D3.js to demostrate a progress indicator directive

## Demo
![alt tag](http://s18.postimg.org/pcpnpbnl5/progress_indicator.gif)

## Installation

```sh
$ npm install
```

## Build to serve static files
```sh
$ grunt build
```

## Run server
```sh
$ node index.js
```

## Run tests
Run unit tests using Karma test runner
```sh
$ grunt test
```

## View code coverage
Once the tests are run, navigate to `/coverage` directory to view code coverage results

## Playground
Playground lets you run components independent of the the application's logic. It sets up components with their names as routes that server `index.html` under the components' playground directory. (eg: http://localhost:5566/progress-indicator)

```sh
$ cd app/playground
$ node index.js
```
