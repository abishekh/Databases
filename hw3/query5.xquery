xquery version "1.0";
<query5>
{
let $totalemp := count( doc("company.xml")//Employee/empID)
let $temp := 0

let $empID := doc("company.xml")//Employee/empID
let $divcount := count(doc("company.xml")//WorksFor[empID =$empID]/empID)


return <avgDivs>{$divcount div $totalemp}</avgDivs>

}

</query5>
