# GlobalToJSON-XL-Academic
This package offers a utility to export an XLarge Global into a JSON object file and to show or import it again.    
In a previous example, this all was processed in memory. But if this is a large Global you may either   
experience \<MAXSTRING> or an \<STORE> error if the generated JSON structure exceeds available memory.   

![](https://raw.githubusercontent.com/rcemper/GlobalToJSON-XLA/master/globals.jpg)     
***Academic*** refers to the structure created.  
- each node of the Global including the top node is represented as a JSON object   
- **{"node":\<node name>,"val":\<value stored>,"sub":[\<JSON array of subscript objects>]}**  
- value and subscript are optional but one of them always exists for a valid node   
- the JSON object for the lowest level subscript has only value but no further subscript.   
  
So this is basically a 1:1 image of your global and it's exported to a file (default: gbl.json)          
In addition to the export, a show method displays the generated file.   
The tricky part is the import from file. It is a customize JSON parser as all others just   
operate in memory. this fails with a reasonable-sized Global   
(eg. ^oddDEF with ~ 1.7 million nodes takes ~ 78MB JSON file.)    
  
 ## Prerequisites    
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.   
## Installation   
Clone/git pull the repo into any local directory     
```
git clone https://github.com/rcemper/GlobalToJSON-XLA.git    
```
Run the IRIS container with your project:    
```
docker-compose up -d --build
```
## How to Test it
This is the pre-loaded Global **^dc.MultiD** for testing.    
![]()
<img src="https://raw.githubusercontent.com/rcemper/GlobalToJSON-XLA/master/Global.JPG" width="600">

There are 3 methods available    
- ClassMethod export(gref As %String = "^%",	file = "gbl.json") As %String     
  file = 0  >>> display to terminal
- ClassMethod show(file = "gbl.json") As %String   
- ClassMethod import(	file = "gbl.json", test = 0) As %String     
  test = 1  >>> load into a PPG   
  
Open IRIS terminal
```
$ docker-compose exec iris iris session iris

USER>write ##class(dc.GblToJSON.XLA).export("^dc.MultiD")
File gbl.json created

USER>write ##class(dc.GblToJSON.XLA).export("^dc.MultiD",0)
{"node":"^dc.MultiD"
,"val":5
,"sub":[
{"node":1
,"val":"$lb(\"Braam,Ted Q.\",51353)"
,"sub":[
{"node":"mJSON"
,"val":"{}"
}
---  truncated ---

USER>>write ##class(dc.GblToJSON.XLA).show()
{"node":"^dc.MultiD"
,"val":5
,"sub":[
{"node":1
,"val":"$lb(\"Braam,Ted Q.\",51353)"
---  truncated ---  
```
**validated JSON object**     
<img src="https://raw.githubusercontent.com/rcemper/GlobalToJSON-XLA/master/Validate.jpg" width="80%">    

Now we want to verify the load function as a test into a PPG       
```
USER>write ##class(dc.GblToJSON.XLA).import(,1)
Global ^||dc.MultiD loaded

USER>zwrite ^||dc.MultiD
^||dc.MultiD=5
^||dc.MultiD(1)=$lb("Braam,Ted Q.",51353)
^||dc.MultiD(1,"mJSON")="{}"
^||dc.MultiD(2)=$lb("Klingman,Uma C.",62459)
^||dc.MultiD(2,2,"Multi","a")=1
^||dc.MultiD(2,2,"Multi","rob",1)="rcc"
^||dc.MultiD(2,2,"Multi","rob",2)=2222
^||dc.MultiD(2,"Multi","a")=1
^||dc.MultiD(2,"Multi","rob",1)="rcc"
^||dc.MultiD(2,"Multi","rob",2)=2222
^||dc.MultiD(2,"mJSON")="{""A"":""ahahah"",""Rob"":""VIP"",""Rob2"":1111,""Rob3"":true}"
^||dc.MultiD(3)=$lb("Goldman,Kenny H.",45831)
^||dc.MultiD(3,"mJSON")="{}"
^||dc.MultiD(4)=$lb("","")
^||dc.MultiD(4,"mJSON")="{""rcc"":122}"
^||dc.MultiD(5)=$lb("","")
^||dc.MultiD(5,"mJSON")="{}"
 
USER>
```
**q.a.d.**   

[Video](https://youtu.be/8Fz2537FHzc)

[Online Demo Terminal](https://gbl-to-json-xla.demo.community.intersystems.com/terminal/)      
[Online Demo SMP](https://gbl-to-json-xla.demo.community.intersystems.com/csp/sys/%25CSP.Portal.Home.zen)   

[Article in DC](https://community.intersystems.com/post/globaltojson-xl-academic)

**Code Quality** in SCREENSHOTS
