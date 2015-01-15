xquery version "1.0";
<query6>
{
let $seq := doc("company.xml")//WorksFor/empID
for $mostdivs in max(for $divs in distinct-values($seq)
return count(index-of($seq,$divs )))
return 
doc("company.xml")//Employee[empID = distinct-values($seq)[count(index-of($seq, .)) eq $mostdivs]]

}
</query6>
