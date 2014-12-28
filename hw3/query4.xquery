xquery version "1.0";
<query4>
{

let $e := distinct-values( doc("company.xml")//Employee/empID)
let  $managers := distinct-values(doc("company.xml")//Division/managerEmpID)

for $notmanagers in $e [not(. = $managers)]
for $result in doc("company.xml")//Employee[empID = $notmanagers]
order by $result/empName descending
return <notmanagers>
<empID>{ $result/empID/text()}</empID>
<empName>{ $result/empName/text()}</empName>
<empPhone>{ $result/empPhone/text()}</empPhone>
<Office>{ $result/empOffice/text()}</Office>
</notmanagers>

}
</query4>
