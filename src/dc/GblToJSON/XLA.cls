Class dc.GblToJSON.XLA
{

ClassMethod export(gref As %String = "^%",file = "gbl.json") As %String
{
	new %gref,%file
	set %gref=gref,%file=file
	if $l(file)>1 open %file:("WNS"):1 else  quit "File failed to create"
	if $d(@%gref) do ..node()
	write !!
	close %file 
	quit "File "_%file_" created"
}

ClassMethod node(d = "") As %String
{
	use %file
	set d=$d(@$ZR,val)
	set sub=$QS($zr,$Ql($zr))
	if '$isvalidnum(sub) set sub=""""_$ZCVT(sub,"O","JSON")_""""
	if d write "{""node"":",sub
	if d#2 {
		if $lv(val) set val=..lb(val)
		if '$isvalidnum(val) set val=""""_$ZCVT(val,"O","JSON")_""""
		write !,",""val"":",val 
		}
 	if d>2 {
	 	new %zo,%zr
		write !,",""sub"":[",!
	 	set %zo=""
	 	set %zr=$ZR
	 	for c=0:1 { 
	 		set %zo=$o(@%zr@(%zo))
			quit:%zo=""
			if c write ",",!
		 	set sub=..node()
	 		}
	 	write !,"]"
		}
	use %file	
	write !,"}"  
	quit 1
}

ClassMethod lb(val = "") As %String
{
#define topspool 99999
	new %zsp
	set %zsp=$zr
	open 2:$$$topspool use 2 zwrite val close 2
	set lb=^SPOOL($$$topspool,1)
	set lb=$replace(lb,$c(27)_"[22m","")
	set lb=$replace(lb,$c(27)_"[1m","")
	set lb=$tr(lb,$c(13,10))
	set lb=$e(lb,5,*)
	if $d(@%zsp)
	use %file
	quit lb
}

ClassMethod show(file = "gbl.json") As %String
{
	open file:("R"):1
	else  quit "File not found"
	set $ZT="end"
	for { 
		use file read line
		use 0 write line,!
		if line="" quit
		
		}
end
	close file	
	quit "***** "_file_" *****"
}

ClassMethod import(file = "gbl.json",test = 0) As %String
{
	new %node,%file
	set %file=file,%node=""
	open %file:("R"):1  
	else  quit "File not found"
	set sc=..line("",test)	
	close %file	
	quit:sc "Global "_$qs($zr,0)_" loaded"
	if %node  ;;;; just to satisfy the dammned Code Quality that doesn'understand % varibales!!!!
	quit "Global load broken"
}

ClassMethod line(nod,test) as %String
{
#define nod "{""node"":"	
#define val ",""val"":"
#define sub ",""sub"":"
	new %do
	set sc=1
	for i=0:1 {
		use %file read line
		quit:line="" 
		if $l(line,$$$nod)=2 {
			set node=$replace(line,$$$nod,"")
			if ($e(node,2)="^") set ref=$e(node,2,*-1)
			else  set ref=nod_$s(nod["(":",",1:"(")_node
			continue
		}
		if $l(line,$$$val)=2 {
			set val=$p(line,$$$val,2)
			if ($e(val,1,2)="""{")&&($e(val,*-1,*)="}""") {
				set val=$replace(val,"\""","""""")
				}
			if '$isvalidnum(val) {
				set val=$zcvt(val,"I","JSON")
				if $l(val,"""$lb(")=2 s val=$e(val,2,*-1)
				}
			if 0,($e(val,1,2)="""{")&&($e(val,*-1,*)="}""") {
				set val=$e(val,2,*-1)
				if 0,$l(val)>2 set %do={}.%FromJSON(val), val="%do"
				if %do
				}	
			set %node=ref_$s(ref["(":")=",1:"=")_val
			set:test %node=$replace(%node,"^","^||")
			set @%node 
			continue
		}
		if $l(line,$$$sub)=2 {
			set sc=..line(ref,test) 
			continue
		}
		if $e(line)="}" {continue   }
		if $e(line)="]" {quit   }
			
		else  {
			set sc=0  break 
			}
	}
	quit sc
}

}
