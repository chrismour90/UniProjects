/*
 * By Akingbolade Shada
 * +447405820353
 * as16247@my.bristol.ac.uk
 */
package loadingProgram;

import java.io.FileWriter;
import java.io.PrintWriter;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Locale;
import java.io.File;
import java.io.IOException;
import java.sql.DriverManager;
import java.sql.Statement;
import java.text.*;
import java.util.*;
import java.util.HashMap;
import java.util.concurrent.Callable;
import java.util.logging.Level;
import java.util.logging.Logger;

public class LoadMyData extends Thread   {
      private String TABLENAME1;
      private String  filename1;
      private String  IGNORELINES1;
    public LoadMyData(String TABLENAME,String filename, String IGNORELINES) {
   TABLENAME1=TABLENAME;
   filename1=filename;
   IGNORELINES1=IGNORELINES ;
    }
 
     public  void  LoadMyDataagent(String TABLENAME,String filename, String IGNORELINES) throws SQLException {
 Statement stmt = null;
        String query="";
        Connection conn= null;
        try
        {
             conn= getDBConnection();
            try {
                 stmt = conn.createStatement();
      
            } catch (SQLException ex) {
                Logger.getLogger(LoadData.class.getName()).log(Level.SEVERE, null, ex);
            }
      Calendar cal = Calendar.getInstance();
       //SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
       // System.out.println("STARTED @ " + sdf.format(cal.getTime()));
 stmt.executeUpdate( "LOAD DATA LOCAL INFILE '/Users/akingboladeshada/Desktop/mimic_Data/"+filename+"' INTO TABLE  "+TABLENAME+" FIELDS TERMINATED BY ',' LINES TERMINATED BY '\\n'   IGNORE "+IGNORELINES+" LINES ");
         
       if (stmt != null) {
        	      try { stmt.close(); } catch (SQLException e) { ; }
        	      stmt = null;
        	    }
        	    if (conn != null) {
        	      try { conn.close(); } catch (SQLException e) { ; }
        	      conn = null;
        	    }
        
        }finally {
        	 if (stmt != null) {
        	      try { stmt.close(); } catch (SQLException e) { ; }
        	      stmt = null;
        	    }
        	    if (conn != null) {
        	      try { conn.close(); } catch (SQLException e) { ; }
        	      conn = null;
        	    }

        }
	}
 
    @Override
      public void run(){
       System.out.println("********Started Loading :"+filename1+"");

          try {
              LoadMyDataagent(TABLENAME1, filename1,  IGNORELINES1 );
          } catch (SQLException ex) {
              Logger.getLogger(LoadMyData.class.getName()).log(Level.SEVERE, null, ex);
          }

       System.out.println("*******Finished Loading :"+filename1+"");

    }

      
       public Connection getDBConnection() {

        Connection conn=null;

        Properties props = new Properties();
 	   try{
 	        String strUrl ="jdbc:mysql://127.0.0.1:3306/ICU_BRISTOL";
 	   props.put("user", "root");
 	   props.put("password","AnuIfe2014$");
 	       try{
 	    System.out.println("****ABOUT to make MYSQL CONNECTION SUCCESSFUL****");
 	    Class.forName("com.mysql.jdbc.Driver").newInstance();
 	conn = DriverManager.getConnection(strUrl, props); 
 	conn.setTransactionIsolation( Connection.TRANSACTION_READ_UNCOMMITTED );
 	System.out.println("****MYSQL  CONNECTION SUCCESSFUL****");
 	       }catch(Exception ex){
 	           System.out.println("ERROR in Driver:"+ ex.getMessage());
 	           ex.printStackTrace();
 	       }

 	   }catch(Exception ex){System.out.println("ERROR in Driver:"+ ex.getMessage());
 	   }
 	   return conn;

    }
    
     
}

