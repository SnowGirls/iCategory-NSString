# iCategory-NSString

`Tested on iOS 15.6.1`

### A. Step to recurrence of EXC_BAD_ACCESS Crash on PHCollection.localizedTitle
##### 1. Open iPhone App `Photos`, switch to Albums tab, tap Add + icon -> New Album -> input the name you want. 
##### 2. Repeat the first step to create more than two albums.
##### 3. Open this Project `iCategory-NSString` and `Command + R` to Run
##### 4. Grant all the photo/camera permission to App, then tap the 'Click me' button, will crash


### B. Step to remove the crash
##### 1. Just uncomment the line in `NSString+Extension.m`:
    
    // [NSString invokeOriginalMethod:self selector:_cmd];
        
        
##### 2. Or just change `+initialize` method to `+load` method, that is donot create the `+initialize` on any `NSString` category


