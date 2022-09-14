# iCategory-NSString

`Tested on iOS 15.5 and above`

### A. Step to recurrence of EXC_BAD_ACCESS Crash on PHCollection.localizedTitle

##### 1. Open iPhone App `Photos`, switch to Albums tab

##### 2. Tap Add + icon -> New Album -> input a short album name, i.e. Abc

##### 3. Repeat the first step to create more than two albums

##### 4. Open this Project `iCategory-NSString` and `Command + R` to Run

##### 5. Grant all the photo/camera permission to App, then tap the 'Click me' button, will crash


### B. Solutions to remove the crash

##### Just uncomment the line in `NSString+Category.m`, calling the original `+initialize` method
    
    [ObjcUtil invokeOriginalMethod:self selector:_cmd];
    
        
##### Or just change `+initialize` to `+load`, do not create the `+initialize` on any `NSString` category


