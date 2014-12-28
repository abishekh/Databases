xquery version "1.0";
<query2>
{
let $w1 := doc("company.xml")//WorksFor[empID=1]/divID
let $w2 := doc("company.xml")//WorksFor[empID=2]/divID
let $w3 := doc("company.xml")//WorksFor[empID=3]/divID
let $w4 := doc("company.xml")//WorksFor[empID=4]/divID
let $w5 := doc("company.xml")//WorksFor[empID=5]/divID
let $w6 := doc("company.xml")//WorksFor[empID=6]/divID
let $w7 := doc("company.xml")//WorksFor[empID=7]/divID
let $w8 := doc("company.xml")//WorksFor[empID=8]/divID

for $e in distinct-values(distinct-values(distinct-values(distinct-values(distinct-values(distinct-values( distinct-values($w1 [.= $w2])[. =$w3])[. =$w4])[. =$w5])[. =$w6])[. =$w7])[. =$w8]) 

return <Division><divName>{ doc("company.xml")//Division[divID = $e]/divName/text() }</divName></Division>

}
</query2>
