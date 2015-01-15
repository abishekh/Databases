


import org.apache.commons.cli.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;



public class hw2 {

	private Connection conn=null;
	private final String connection;
	private final String username;
	private final String password; 



	hw2(String username,String password,String connection) {
		this.username = username;
		this.password = password;
		this.connection = connection;
	}

	void getDBConnection() {
		try {
			DriverManager.registerDriver(

					new oracle.jdbc.OracleDriver());
		} catch (SQLException ex) {
			System.out.println("Please install Oracle Driver.");
			return;
		}
		try {
			conn = DriverManager.getConnection(connection, username, password);
		} catch (SQLException e) {
			System.out.println(e);
			return;
		}
		if (conn != null) {
			System.out.println("db Connection Succeeded.");
		} else {
			System.out.println("db Connection failed.");
		}
	}


	public static ResultSet withinquery(String tablenameA,String tablenameB,String idcol,String geoname,String geoname2,String refid,String pkey,String distance,Connection conn) throws SQLException{

		ResultSet rs;

		String withinquery = "SELECT A."+idcol+" FROM "+tablenameA+" A, "+tablenameB+" B"+
				" WHERE B."+refid+"='"+pkey+"' AND SDO_WITHIN_DISTANCE( A."+geoname+", B."+geoname2+", 'distance="+distance+"') = 'TRUE' ORDER BY +TO_NUMBER(REGEXP_REPLACE("+idcol+", '\\D'))";

		PreparedStatement ptstmt= conn.prepareStatement(withinquery);
		rs = ptstmt.executeQuery(withinquery);
		return rs;
	}


	public static String getgeometryquery(String refid,String tableforgeom,String colforgeom){

		String getgeometryquery="SELECT "+ colforgeom +" FROM "+ tableforgeom +" WHERE bID = '"+refid+"'";
		return getgeometryquery;
	}




	public static void main(String[] args) {

		System.out.println("--------------------------------------------------------------");
		hw2 obj = new hw2("SYSTEM", "CSCI585hw", "jdbc:oracle:thin:@localhost:1521:csci585");
		obj.getDBConnection();
		System.out.println("Test Complete.");
		System.out.println("--------------------------------------------------------------");



		//Parsing begins 

		CommandLineParser parser = new BasicParser();

		Options options = new Options();

		//Option 1
		Option windowoption = new Option("window",true,"Perform a window query.For finding all objects within a window");
		windowoption.setArgs(5);
		windowoption.setValueSeparator(' ');
		options.addOption(windowoption);

		//Option 2
		Option withinoption =new Option("within",true,"Perform a within distance query.For finding all buildings and tramstops within a give distance of a student");
		withinoption.setArgs(2);
		withinoption.setValueSeparator(' ');
		options.addOption(withinoption);

		//Option 3
		Option nearest_neighbor =new Option("nearest_neighbor",true,"Perform a nearest neighbor query.For finding nearest K objects to a given object");
		nearest_neighbor.setArgs(3);
		nearest_neighbor.setValueSeparator(' ');
		options.addOption(nearest_neighbor);


		//Option 4
		Option fixed =new Option("fixed",true,"Hardcoded queries");
		fixed.setArgs(1);
		fixed.setValueSeparator(' ');
		options.addOption(fixed);


		try{
			CommandLine commandline = parser.parse(options,args);


			if (commandline.hasOption("within")){

				String[] commandchain = commandline.getOptionValues("within");

				String tablenameA=null;
				String tablenameA2=null;
				String tablenameB=null;
				String idcol1=null;
				String idcol2=null;
				String geoname00=null;
				String geoname01=null;
				String geoname2=null;
				String refid=null;
				switch(commandchain[0].charAt(0)){
				case 'p':
					//around a student
					tablenameA="building";
					tablenameB ="student";
					tablenameA2="tramstop";
					refid="stuID";
					idcol1="bID";
					idcol2="tramstopID";
					geoname2="location";
					geoname00="bshape";
					geoname01="geometery";
					break;

				case 'b':
					//around a building
					tablenameA="tramstop";
					tablenameA2="student";
					tablenameB="building";
					refid="bID";
					idcol1="tramstopID";
					idcol2="stuID";
					geoname2="bshape";
					geoname00="geometery";
					geoname01="location";
					break;

				case 't':
					//around a tramstop
					tablenameA="student";
					tablenameA2="building";
					tablenameB="tramstop";
					refid="tramstopID";
					idcol1="stuID";
					idcol2="bID";
					geoname2="geometery";
					geoname00="location";
					geoname01="bshape";
					break;

				}


				try{
					ResultSet rs1 = withinquery(tablenameA,tablenameB,idcol1,geoname00,geoname2,refid,commandchain[0],commandchain[1],obj.conn);
					ResultSet rs2 = withinquery(tablenameA2,tablenameB,idcol2,geoname01,geoname2,refid,commandchain[0],commandchain[1],obj.conn);

					System.out.println("-_-_-_-_-_-_-_-_QUERY RESULTS-_-_-_-_-_-_-_-_\n");
					System.out.println(idcol1);
					int count =0;


					while(rs1.next()){
						System.out.println(rs1.getString(idcol1));
						count++;
					}
					System.out.println(idcol2);
					while(rs2.next()){
						System.out.println(rs2.getString(idcol2));
						count++;

					}
					System.out.println("");
					System.out.println(count+" Rows Selected.");
				}
				catch(SQLException e){
					e.printStackTrace();

				}
				/*
			for(String s: commandchain)
			{
				System.out.println(s);
			}*/

			}

			if (commandline.hasOption("window")){
				String tablename = null;
				String geomname = null;
				String IDcolumn = null;
				String coordinates =null;

				String[] commandchain = commandline.getOptionValues("window");

				switch(commandchain[0]){
				case "student" :
					tablename = "student";
					geomname ="location";
					IDcolumn="stuID";
					break;
				case "tramstop":
					tablename = "tramstop";
					geomname ="geometery";
					IDcolumn="tramstopID";
					break;
				case "building":
					tablename = "building";
					geomname ="bshape";
					IDcolumn="bID";
					break;	
				}
				coordinates = commandchain[1]+","+commandchain[2]+","+commandchain[3]+","+commandchain[4];

				try {

					//String query="Select A."+IDcolumn+" FROM "+tablename+" A WHERE SDO_FILTER(A."+geomname+", mdsys.sdo_geometry(2003,NULL,NULL,mdsys.sdo_elem_info_array(1,1003,3),mdsys.sdo_ordinate_array("+coordinates+")),'querytype=WINDOW') = 'TRUE' Order by A."+IDcolumn;

					String queryinside="Select A."+IDcolumn+" FROM "+tablename+" A WHERE SDO_INSIDE(A."+geomname+", mdsys.sdo_geometry(2003,NULL,NULL,mdsys.sdo_elem_info_array(1,1003,3),mdsys.sdo_ordinate_array("+coordinates+")) ) = 'TRUE' ORDER BY +TO_NUMBER(REGEXP_REPLACE("+IDcolumn+", '\\D'))";
					PreparedStatement pstmt =  obj.conn.prepareStatement(queryinside);
					ResultSet rs = pstmt.executeQuery(queryinside);
					System.out.println("-_-_-_-_-_-_-_-_QUERY RESULTS-_-_-_-_-_-_-_-_\n");
					System.out.println(IDcolumn);
					int count=0;
					while(rs.next()){

						System.out.println(rs.getString(IDcolumn));
						count++;
					}
					System.out.println("");
					System.out.println(count+" Rows Selected.");

				} catch (SQLException e) {

					e.printStackTrace();
				}
			}

			if (commandline.hasOption("nearest_neighbor")){

				String[] commandchain = commandline.getOptionValues("nearest_neighbor");
				String geom1=null;
			//	String geom2=null;
				int plusone =Integer.parseInt(commandchain[2]) + 1;
				String numberofresults=Integer.toString(plusone);
				String tablename=null;
				String indexname=null;
				String idcol=null;
				String tableforgeom=null;
				String colforgeom=null;
				String refid=commandchain[1];
				String idforgeom=null;

				switch(commandchain[0]){

				case "building":
					geom1="bshape";
					indexname="building_idx";
					idcol="bID";
					tablename="building";
					break;

				case"tramstop":
					geom1="geometery";
					indexname="tram_idx";
					idcol="tramstopID";
					tablename="tramstop";
					break;

				case"student":
					geom1="location";
					indexname="student_idx";
					idcol="stuID";
					tablename="student";
					break;


				}
				try{
					switch(commandchain[1].charAt(0)){
					case 'b':
						tableforgeom="building";
						colforgeom="bshape";
						idforgeom="bID";
						break;

					case 't':
						tableforgeom="tramstop";
						colforgeom="geometery";
						idforgeom="tramstopID";
						break;

					case 'p':
						tableforgeom="student";
						colforgeom="location";
						idforgeom="stuID";
						break;
					}

					//String nnQ = "SELECT /*+ INDEX(" + tablename + " "+indexname+") */ c."+idcol+" FROM "+tablename+" c  WHERE SDO_NN(c."+geom1+", "+geom2+" ,  'sdo_num_res="+numberofresults+"') = 'TRUE'";
					String test = "SELECT /*+ INDEX("+tablename+" "+indexname+") */ c."+idcol+" FROM "+tablename+" c  WHERE SDO_NN(c."+geom1+",(SELECT "+colforgeom+" FROM "+tableforgeom+" WHERE "+idforgeom+" = '"+refid+"'),'sdo_num_res="+numberofresults+"') = 'TRUE' AND c."+idcol+" <> '"+refid+"' ORDER BY +TO_NUMBER(REGEXP_REPLACE("+idcol+", '\\D'))";

					PreparedStatement ptstmt= obj.conn.prepareStatement(test);
					ResultSet idrs;
					idrs = ptstmt.executeQuery(test);

					System.out.println("-_-_-_-_-_-_-_-_QUERY RESULTS-_-_-_-_-_-_-_-_\n");
					System.out.println(idcol);
					int count=0;
					while(idrs.next()){

						System.out.println(idrs.getString(idcol));
						count++;
					}
					System.out.println("");
					System.out.println(count+" Rows Selected.");

				}
				catch(SQLException e){
					e.printStackTrace();
				}

				catch(Exception e){
					e.printStackTrace();
				}

			}


			if (commandline.hasOption("fixed")){



				//Insert Switch case here
				switch(Integer.parseInt(commandline.getOptionValue("fixed"))){
				case 1:
					System.out.print("Executing Fixed query 1 \n");
					/*
					 * Find the ids of all the students and buildings cover
					 *  by tram stops: t2ohe and t6ssl.
					 */
					String q1="Select A.stuID from student A, tramstop B where SDO_RELATE (A.location,(select geometery from tramstop where tramstopID='t2ohe'),'mask=touch+coveredby')='TRUE' intersect "
							+"Select A.stuID from student A, tramstop B where SDO_RELATE (A.location,(select geometery from tramstop where tramstopID='t6ssl'),'mask=touch+coveredby')='TRUE'";


					String q2="Select A.bID from building A, tramstop B where SDO_RELATE (A.bshape,(select geometery from tramstop where tramstopID='t2ohe'),'mask=touch+coveredby')='TRUE' intersect "
							+"Select A.bID from building A, tramstop B where SDO_RELATE (A.bshape,(select geometery from tramstop where tramstopID='t6ssl'),'mask=touch+coveredby')='TRUE'";
					try{
						PreparedStatement pstmt1 =  obj.conn.prepareStatement(q1);
						PreparedStatement pstmt2 =  obj.conn.prepareStatement(q2);
						ResultSet rs1 = pstmt1.executeQuery(q1);
						ResultSet rs2 = pstmt2.executeQuery(q2);
						System.out.println("-_-_-_-_-_-_-_-_QUERY RESULTS-_-_-_-_-_-_-_-_\n");


						int count=0;
						while(rs1.next()){

							System.out.println(rs1.getString(1));
							count++;
						}

						while(rs2.next()){
							System.out.println(rs1.getString(1));
							count++;

						} 
						System.out.println("");
						System.out.println(count+" Rows Selected.");
					}
					catch(SQLException e)
					{
						e.printStackTrace();
					}



					break;
				case 2:

					/*
					 * For each student, list the ID’s of the 2 nearest tram stops.
					 */
					System.out.print("Executing Fixed query 2\n\n");


					String q3="select A.stuID,B.tramstopID from student A,trampoint B where SDO_NN(B.geometry,A.location,'sdo_num_res=2') = 'TRUE' ORDER BY +TO_NUMBER(REGEXP_REPLACE(A.stuID, '\\D')) ";



					try{
						PreparedStatement pstmt1 =  obj.conn.prepareStatement(q3);

						ResultSet rs1 = pstmt1.executeQuery(q3);

						System.out.println("-_-_-_-_-_-_-_-_QUERY RESULTS-_-_-_-_-_-_-_-_\n");
						System.out.println("Student ID | Tramstop 1	 | 	Tramstop2 |");
						List<String> ID = new ArrayList<String>();

						List<String> t1 = new ArrayList<String>();
						List<String> t2 = new ArrayList<String>();

						int count=0;

						while(rs1.next()){

							if(count%2 > 0 ){
								t2.add(rs1.getString(2));
								ID.add(rs1.getString(1));
							}
							else if (count%2 == 0)
								t1.add(rs1.getString(2));

							count++;

						}
						for(int x=0 ; x<=79 ; x++){
							System.out.println(ID.get(x) + " 		 " + t1.get(x) +"		"+t2.get(x));

						}

						System.out.println("");
						System.out.println(ID.size()+" Rows Selected.");
					}
					catch(SQLException e)
					{
						e.printStackTrace();
					}

					break;
				case 3:

					/*We say a tram stop covers a building if it is within distance 250 to that building.
					Find the ID’s of the tram stop that cover the most buildings.
					 * 
					 */
					System.out.print("Executing Fixed query 3\n\n");
					String q4 ="select t.tramstopID , count(b.bID) AS numberofbuildings from trampoint t,building b where SDO_WITHIN_DISTANCE(b.bshape,t.geometry,'distance=250')= 'TRUE' group by t.tramstopID order by count(b.bID) DESC";
					try{
						PreparedStatement pstmt1 =  obj.conn.prepareStatement(q4);

						ResultSet rs1 = pstmt1.executeQuery(q4);

						System.out.println("-_-_-_-_-_-_-_-_QUERY RESULTS-_-_-_-_-_-_-_-_\n");
						System.out.println("Tramstop ID | Number of buildings |");

						rs1.next();	
						System.out.println(rs1.getString(1)+"		"+rs1.getString(2));


					}
					catch(SQLException e){
						e.printStackTrace();

					}


					break;
				case 4:

					/*  We say a student is called a reverse nearest neighbor of a building if it is that
					building’s nearest student. Find the ID’s of the top 5 students that have the most reverse nearest neighbors 
					together with their number of reverse nearest neighbors.
					 * 
					 */
					System.out.print("Executing Fixed query 4\n\n");

					String q5 ="  select x.stuID,count(b.bID) as numberofreverseneighbors from student x,building b  where SDO_NN(x.location,b.bshape,'sdo_num_res=1') ='TRUE' group by x.stuID order by count(b.bID) DESC";
					try{
						PreparedStatement pstmt1 =  obj.conn.prepareStatement(q5);

						ResultSet rs1 = pstmt1.executeQuery(q5);

						System.out.println("-_-_-_-_-_-_-_-_QUERY RESULTS-_-_-_-_-_-_-_-_\n");
						System.out.println("Student ID | Reverse Neighbors |");

						for(int i=1;i<=5;i++){
							rs1.next();
							System.out.println(	rs1.getString(1)+ " 		 "+rs1.getString(2));

						}


					}
					catch(SQLException e){
						e.printStackTrace();

					}


					break;
				case 5:


					/*
					 * Find the coordinates of the lower left and upper right vertex of the MBR that
					 *  fully contains all buildings whose names are of the form ’SS%’. 
					 *  Note that you cannot manually figure out these buildings in your program.
					 */
					System.out.print("Executing fixed query 5\n\n");


					String q6= "SELECT MIN(sdo_geom.sdo_min_mbr_ordinate(bshape,1)) as MINX,MAX(sdo_geom.sdo_max_mbr_ordinate(bshape,1)) as MAXX,MIN(sdo_geom.sdo_min_mbr_ordinate(bshape,2)) as MINY,MAX(sdo_geom.sdo_max_mbr_ordinate(bshape,2)) as MAXY FROM building WHERE bNAME like 'SS%'";


					try{
						PreparedStatement pstmt1 =  obj.conn.prepareStatement(q6);

						ResultSet rs1 = pstmt1.executeQuery(q6);
						ResultSetMetaData rsmd =rs1.getMetaData();
						System.out.println("-_-_-_-_-_-_-_-_QUERY RESULTS-_-_-_-_-_-_-_-_\n");
						System.out.println(rsmd.getColumnName(1)+" "+rsmd.getColumnName(2)+" "+rsmd.getColumnName(3)+" "+rsmd.getColumnName(4));

						while(rs1.next()){
							
							System.out.println(rs1.getString(1)+"  "+rs1.getString(2)+"  "+rs1.getString(3)+"  "+rs1.getString(4));
						}


					}
					catch(SQLException e){
						e.printStackTrace();

					}

					break;

				}


			}

		}

		catch (ParseException e)
		{
			e.printStackTrace();
		}

		catch(NullPointerException e){
			System.out.println(" Bad argument . Please refer to README.");
			e.printStackTrace();
		}



	}
}