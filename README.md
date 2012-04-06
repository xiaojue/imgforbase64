###ImgForBase64 by actionscript
  
##example
  
```javascript
function imgforbase64(str){
        var id = 'J_preview',
            img;
            if(!document.getElementById(id)){
              img = document.createElement('img');
              img.id = id;
              img.src = 'data:image/png;base64,'+str;
              document.body.appendChild(img);
            }else{
              img  = document.getElementById(id);
              img.src = 'data:image/png;base64,'+str;
            }
        console.log(str);
      }
```
  
use global function imgforbase64,other details your can find in test.html

Supported directory

###some dependent
    swfobject 2.2 
    flashplay 9.0.0 
    flashSDK 10.0.0
