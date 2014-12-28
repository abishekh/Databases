public class HW2test {

    private Connection conn=null;
    private final String connection;
    private final String username;
    private final String password; 
    private Statement stmt = null;

    HW2test(String username,String password,String connection) {
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
            System.out.println("Connection Succeeded.");
        } else {
            System.out.println("Connection failed.");
        }
    }
    
  /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        HW2test obj = new HW2test("<Username>", "<Password>", "jdbc:oracle:thin:@localhost:1521:orcl");
        obj.getDBConnection();
        System.out.println("Test Exit.");
    }
}