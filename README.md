# react-native-signature-capture

## About this
React Native library for drawing signature

### iOS
<img src="http://i.giphy.com/3oEduIyWb48Ws3bSuc.gif" />

### Android
<img src="http://i.giphy.com/xT0GUKJFFkdDv25FNC.gif" />

## Install

First you need to install react-native-signature-capture:

```sh
npm install react-native-signature-capture --save
```

Second you need to link react-native-signature-capture:

```sh
react-native link react-native-signature-capture
```

Use above `react-native link` command to automatically complete the installation, or link manually like so:

### iOS

1. In the XCode's "Project navigator", right click on your project's Libraries folder ➜ Add Files to <...>
2. Go to node_modules ➜ react-native-signature-capture ➜ ios ➜ select RSSignatureCapture.xcodeproj
3. Add libRSSignatureCapture.a to Build Phases -> Link Binary With Libraries
4. Compile and have fun

### Android

Add these lines in your file: android/settings.gradle

```
...

include ':reactnativesignaturecapture',':app'
project(':reactnativesignaturecapture').projectDir = new File(settingsDir, '../node_modules/react-native-signature-capture/android')
```

Add line in your file: android/app/build.gradle

```
...

dependencies {
    ...
    compile project(':reactnativesignaturecapture') // <-- add this line
}
```

Add import and line in your file: android/app/src/main/java/<...>/MainApplication.java

```java
...

import com.rssignaturecapture.RSSignatureCapturePackage; // <-- add this import

public class MainApplication extends Application implements ReactApplication {

    private final ReactNativeHost mReactNativeHost = new ReactNativeHost(this) {

        @Override
        protected List<ReactPackage> getPackages() {
            return Arrays.<ReactPackage>asList(
                new MainReactPackage(),
                new RSSignatureCapturePackage() // <-- add this line
            );
        }
  }

...
}
```

## Usage

Then you can use SignatureCapture component in your react-native's App, like this:
```javascript
...
import React, {Component} from 'react';
import SignatureCapture from 'react-native-signature-capture';

class CustomComponent extends Component {

  ...
  render() {
    return (
      <SignatureCapture
        {...someProps}
      />
    );
  }
}
```

### Properties


### Methods

+ **resetImage()** : when called it will clear the image on the canvas

### Callback Props

+ **onDragEvent** : Triggered when user marks his signature on the canvas. This will not be called when the user does not perform any action on canvas.


### Example

```javascript
/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */

var React = require('react');
var ReactNative = require('react-native');

var {Component} = React;

var {
    AppRegistry,
    StyleSheet,
    Text,
    View, TouchableHighlight
} = ReactNative;

import SignatureCapture from 'react-native-signature-capture';

class RNSignatureExample extends Component {
    render() {
        return (
            <View style={{ flex: 1, flexDirection: "column" }}>
                <Text style={{alignItems:"center",justifyContent:"center"}}>Signature Capture Extended </Text>
                <SignatureCapture
                    style={[{flex:1},styles.signature]}
                    ref="sign"
                    onDragEvent={this._onDragEvent}

                <View style={{ flex: 1, flexDirection: "row" }}>
                    <TouchableHighlight style={styles.buttonStyle}
                        onPress={() => { this.resetSign() } } >
                        <Text>Reset</Text>
                    </TouchableHighlight>

                </View>

            </View>
        );
    }

    resetSign() {
        this.refs["sign"].resetImage();
    }

    _onDragEvent() {
         // This callback will be called when the user enters signature
        console.log("dragged");
    }
}

const styles = StyleSheet.create({
    signature: {
        flex: 1,
        borderColor: '#000033',
        borderWidth: 1,
    },
    buttonStyle: {
        flex: 1, justifyContent: "center", alignItems: "center", height: 50,
        backgroundColor: "#eeeeee",
        margin: 10
    }
});

AppRegistry.registerComponent('RNSignatureExample', () => RNSignatureExample);
```

-------------

Please checkout the example folder (iOS/Android):
https://github.com/RepairShopr/react-native-signature-capture/tree/master/Example

Library used:

https://github.com/jharwig/PPSSignatureView

https://github.com/gcacace/android-signaturepad


How to contribute
-----------------
Submit a PR - also please don't be shy and email me. Lastly, I love to see how this project is doing in the wild! please email me screenshot of your app - jed.tiotuico@gmail.com (I will disclose the info, I will not tell anyone about it, I will not blog nor tweet it)
