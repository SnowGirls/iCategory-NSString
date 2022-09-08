# iCategory-NSString

`Tested on iOS 15.5 and above`

### A. Step to recurrence of EXC_BAD_ACCESS Crash on PHCollection.localizedTitle
##### 1. Open iPhone App `Photos`, switch to Albums tab
##### 2. Tap Add + icon -> New Album -> input a short album name, i.e. Abc
##### 3. Repeat the first step to create more than two albums
##### 4. Open this Project `iCategory-NSString` and `Command + R` to Run
##### 5. Grant all the photo/camera permission to App, then tap the 'Click me' button, will crash


### B. Step to remove the crash
##### 1. Just uncomment the line in `NSString+Extension.m`:
    
    // [NSString invokeOriginalMethod:self selector:_cmd];
        
        
##### 2. Or just change `+initialize` method to `+load` method, that is donot create the `+initialize` on any `NSString` category


