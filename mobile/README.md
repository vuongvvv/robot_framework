# Robot Framework automation for Mobile
## Installation:
[Setup Appium](https://ascendcommerce.atlassian.net/wiki/spaces/O2O/pages/562429972/How+to+install+Appium)
## Notes:
- Start Appium Server

```bash
- iOS Device: appium -p 4723 --session-override
- Android Device: appium -p 4725 --session-override
```

- Android Studio V3.1

```bash
- How to list all emulator on your local machine?
    - Run:
        - cd ~/Library/Android/sdk/tools/bin && ./avdmanager list avd
```

- How to run emulator?

```bash
- Run:
    - cd ~/Library/Android/sdk/tools &&./emulator -avd <EMULATOR NAME>
- Example:
    - cd ~/Library/Android/sdk/tools &&./emulator -avd NEXUS_5X
```

- Robot Framework

```bash
- AppiumLibrary Installation
    - Command: 
        - pip install robotframework-appiumlibrary
```

- How to run test?

```bash
- Run:
    - robot -v ENV:<TEST ENV> -v OS:<PLATFORM> -v DEVICE:<TEST_DEVICE> <TEST FILE PATH>

- Examples:
    - robot -v ENV:alpha -v OS:ANDROID -v DEVICE:NEXUS_5X /Users/nantawan.cha/o2o-mobile-demo/testcases/tsm/tutorial_test.robot
    - robot -v ENV:alpha -v OS:IOS -v DEVICE:IPHONE_X /Users/nantawan.cha/o2o-mobile-demo/testcases/tsm/tutorial_test.robot
```

- In your local machine, please create folder 'app-path' for storing the .apk and .app test files.

```bash
- Example:

o2o-automation
 - web
 - mobile
 - api
 - e2e-tests
 
app-path
 - iOS
 - Android
 
NOTE: 
- The 'app-path' folder should be in the same level with mobile folder
```
