xquery version "1.0";
<query3>
{
let $deptNames :=doc("company.xml")//Department/deptName
 let $PSmithID := doc("company.xml")//Employee[empName="PSmith"]/empID
let $WongID :=doc("company.xml")//Employee[empName="Wong"]/empID

let $wongsdivs := distinct-values(doc("company.xml")//Division[managerEmpID = $WongID]/divName)

let $PSmithsdivs :=doc("company.xml")//Division[managerEmpID = $PSmithID]/divName

let $PSmithhousedDep := distinct-values(doc("company.xml")//Division[divName = $PSmithsdivs]/housedDeptID)
let $PSmithsdeptnames := distinct-values(doc("company.xml")//Department[deptID = $PSmithhousedDep]/deptName)

let $wongsdivs := distinct-values(doc("company.xml")//Division[managerEmpID = $WongID]/divName)
let $wongshousedDep := distinct-values(doc("company.xml")//Division[divName = $wongsdivs]/housedDeptID)
let $wongsdeptnames := distinct-values(doc("company.xml")//Department[deptID = $wongshousedDep]/deptName)

for $answer in ($deptNames [.= $PSmithsdeptnames])[. != $wongsdeptnames]
return<Department> <DeptName> {$answer/text() }</DeptName></Department>


}

</query3>
