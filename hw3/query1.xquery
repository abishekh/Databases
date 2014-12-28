xquery version "1.0";
<query1>

{
for $q in doc("company.xml")//Employee[empName="PSmith" or empName="Jack"]/empID
for $w in doc("company.xml")//WorksFor[empID=$q/text() and PercentTime >= 50]/divID
for $e in doc("company.xml")//Division[divID=$w/text()]/housedDeptID
for $r in doc("company.xml")//Department[deptID=$e/text()]/deptName

return<Department> <deptName> {$r/text()}</deptName></Department>


}

</query1>

