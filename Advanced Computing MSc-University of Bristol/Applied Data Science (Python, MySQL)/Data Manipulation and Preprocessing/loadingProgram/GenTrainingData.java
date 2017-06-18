/*
 * By Akingbolade Shada
 * +447405820353
 * as16247@my.bristol.ac.uk
 */
package loadingProgram;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author akingboladeshada
 */
public class GenTrainingData {
    public static PrintWriter writer =null;
    //SELECT distinct  subjectid FROM ICU_BRISTOL.PATIENTS
      public static void main(String[] args) throws FileNotFoundException, UnsupportedEncodingException {
          
          try{
     writer = new PrintWriter("/Users/akingboladeshada/Desktop/ICU_TRAININGDATA.CSV", "UTF-8");
          
          
          
     ArrayList hh=null;
        ArrayList row =null;    
        int kk=0;
          DatabaseProcess dbp = new DatabaseProcess();
         try {
             //hh=dbp.getResultSetTOArrayListfromSQL("SELECT distinct  subject_id FROM ICU_BRISTOL.PATIENTS  where subject_id not in (35,21,31) ");
             hh=dbp.getResultSetTOArrayListfromSQL("SELECT distinct  subject_id FROM ICU_BRISTOL.PATIENTS   ");
                 
             
             kk=hh.size();
                row =null;
                int numberITEMS=0;
              for (int i =0; i<kk; i++)
              {
               row = (ArrayList)  hh.get(i);
               // Put elements to the map
          numberITEMS=GenTrainingData.processSubjectID(row.get(0).toString().trim());
             //to cater for writting after there is a indicator/variable...
              if(numberITEMS>0)
              {
                  writer.println( ""  );
              }
             
    
    
    
              
              System.out.println("Process:::"+ (row.get(0).toString().trim()));
              }
              writer.close();
              writer.flush();
                 
               } catch (SQLException ex) {
             Logger.getLogger(GenTrainingData.class.getName()).log(Level.SEVERE, null, ex);
         }
          
          } catch (IOException e) {
   // do something
}
                  
  }
       
    
    
       public static int processSubjectID (String strPROCSubjectid) throws FileNotFoundException {

      DatabaseProcess dbp = new DatabaseProcess();
      ArrayList hh=null;
        ArrayList row =null;
         // Create a hash map
                HashMap<String,Object> hm = new HashMap<String,Object>();
                //add the subject brief identification  to defual before it will be updated
                
                int kk=0;
            
         try {
             hh=dbp.getResultSetTOArrayListfromSQL("SELECT  lpad(ITEMID,7,'0') FROM ICU_BRISTOL.d_item_group55  order by itemid ASC  ");
                kk=hh.size();
                row =null;
              for (int i =0; i<kk; i++)
              {
               row = (ArrayList)  hh.get(i);
               // Put elements to the map
               hm.put(row.get(0).toString().trim(), 0.00);
              }
                 hm.put("A_SUBJECT_ID", 0);
                 hm.put("B_AGE", 0);
                 hm.put("B_AGEGROUP", "");
                 hm.put("C_GENDER", "M");
                 hm.put("D_EXPIRE_FLAG", 0);
                 hm.put("E_FREQUENCY_OF_ADMISSIONS", 0);
                 hm.put("F_TOTAL_ADMISSION_DAYS", 0);
 
                 
                /*
SELECT A.subject_id, COUNT(*) NUMBER_ADM, AVG(ADM_DAYS) AVERAGE_ADM_DAYS, SUM(ADM_DAYS) TOTAL_ADM_DAYS
FROM
(
SELECT subject_id,HADM_ID,datediff(DISCHTIME, ADMITTIME) ADM_DAYS FROM ICU_BRISTOL.admissions
) A
GROUP BY SUBJECT_ID
                 */ 
                 
                 
               } catch (SQLException ex) {
             Logger.getLogger(GetValues.class.getName()).log(Level.SEVERE, null, ex);
         }
         
         ////////update the hashmap now
         String strTrain= GenTrainingData.BuildSQL(strPROCSubjectid);
         try {
             hh = dbp.getResultSetTOArrayListfromSQL(strTrain);
             kk =hh.size();
             String strSubjectid ="";
             String strAge = "";
             String strGender ="";
             String strExpireFlag="";
             String strFreqAdmission="";
             String strTotalADmissionDays="";
  for (int i =0; i<kk; i++)
              {
               row = (ArrayList)  hh.get(i);
               if(i==0)
               {
             strSubjectid =row.get(1).toString().trim();
              strAge  =row.get(2).toString().trim();
              strGender =row.get(3).toString().trim();
              strExpireFlag=row.get(4).toString().trim();
              strFreqAdmission=row.get(5).toString().trim();
              strTotalADmissionDays=row.get(6).toString().trim();
              double v_age = new Double( strAge).doubleValue();
              String v_agegroup = "";
            if (v_age>=0 && v_age<=9) v_agegroup="GROUP00"  ; 
            if (v_age>=10 && v_age<=19) v_agegroup="GROUP01"  ; 
            if (v_age>=20 && v_age<=29) v_agegroup="GROUP02"  ; 
            if (v_age>=30 && v_age<=39) v_agegroup="GROUP03"  ; 
            if (v_age>=40 && v_age<=49) v_agegroup="GROUP04"  ; 
            if (v_age>=50 && v_age<=59) v_agegroup="GROUP05"  ; 
            if (v_age>=60 && v_age<=69) v_agegroup="GROUP06"  ; 
            if (v_age>=70 && v_age<=79) v_agegroup="GROUP07"  ; 
            if (v_age>=80 && v_age<=89) v_agegroup="GROUP08"  ; 
            if (v_age>=90 ) v_agegroup="GROUP09"  ; 
              
              
              
              
                 hm.put("A_SUBJECT_ID", new Integer(strSubjectid).intValue());
                 hm.put("B_AGE", new Double( strAge).doubleValue());
                 hm.put("B_AGEGROUP", v_agegroup);
                 hm.put("C_GENDER", strGender);
                 hm.put("D_EXPIRE_FLAG", new Integer(strExpireFlag).intValue());
                 hm.put("E_FREQUENCY_OF_ADMISSIONS", new Integer(strFreqAdmission).intValue());
                 hm.put("F_TOTAL_ADMISSION_DAYS", new Integer(strTotalADmissionDays).intValue());
            

               }
               
               // Put elements to the map
               hm.put(row.get(0).toString().trim(),new Double(row.get(7).toString().trim() ));
              
              }
            Map<String, Object> treeMap = new TreeMap<String, Object>(hm);
            
            //use  for training if the indicator has got a value
            if(kk>0)
              printMap(treeMap);
             
             
             
         } catch (SQLException ex) {
             Logger.getLogger(GenTrainingData.class.getName()).log(Level.SEVERE, null, ex);
   }
         
  return kk;
         
}
     
     public static String BuildSQL(String strsubjectid)
     {
       //ITEMID,   SUBJECT_ID, AGE,GENDER,EXPIRE_FLAG
         String sql = "";
sql=sql+"  SELECT    ";
sql=sql+"  lpad(c.ITEMID,7,'0')  ITEMID   ";
sql=sql+"  ,MAX(C.SUBJECT_ID)  SUBJECT_ID   ";  
sql=sql+"  ,MAX((SELECT DATE_FORMAT(FROM_DAYS(DATEDIFF((SELECT CHARTTIME FROM ICU_BRISTOL.CHARTEVENTS    ";
sql=sql+"  WHERE SUBJECT_ID=D.SUBJECT_ID LIMIT 1 ),D.DOB)), '%Y')+0 )  ) AGE   ";
sql=sql+"  ,MAX(D.GENDER)  GENDER   ";
sql=sql+"  ,MAX(D.EXPIRE_FLAG) EXPIRE_FLAG   ";
sql=sql+"   ,(SELECT NUMBER_ADM FROM ICU_BRISTOL.adm  where SUBJECT_ID=D.SUBJECT_ID LIMIT 1) FREQ_ADMISSIONS  ";
sql=sql+"   ,(SELECT TOTAL_ADM_DAYS FROM ICU_BRISTOL.adm  where SUBJECT_ID=D.SUBJECT_ID LIMIT 1) TOTAL_ADMISSION_DAYS  ";

sql=sql+"  ,ROUND(AVG(C.VALUENUM),2)  VALUENUM   ";
sql=sql+"  FROM    ";
sql=sql+"  ICU_BRISTOL.CHARTEVENTS C, ICU_BRISTOL.PATIENTS D, ICU_BRISTOL.D_ITEM_GROUP5  K   ";
sql=sql+"  WHERE    ";
sql=sql+"  D.SUBJECT_ID=C.SUBJECT_ID   ";
sql=sql+"  AND K.ITEMID=C.ITEMID   ";
sql=sql+"  and D.SUBJECT_ID="+strsubjectid+"   ";
sql=sql+"  AND C.VALUENUM <> 0   ";
sql=sql+"  GROUP BY C.ITEMID   ";
         
     return sql;
     }

     public static String BuildSQLADMISSION(String strsubjectid)
     {
       //ITEMID,   SUBJECT_ID, AGE,GENDER,EXPIRE_FLAG
         String sql = "";
sql=sql+"  SELECT    ";
sql=sql+" SELECT A.subject_id, COUNT(*) NUMBER_ADM, AVG(ADM_DAYS) AVERAGE_ADM_DAYS, SUM(ADM_DAYS) TOTAL_ADM_DAYS   ";
sql=sql+" FROM     ";
sql=sql+" (      ";
sql=sql+" SELECT subject_id,HADM_ID,datediff(DISCHTIME, ADMITTIME) ADM_DAYS FROM ICU_BRISTOL.admissions       ";
sql=sql+" ) A      ";
sql=sql+" GROUP BY SUBJECT_ID      ";
         
     return sql;
     }
     
     

public static void printMap(Map<String,Object> map) {
    Set s = map.entrySet();
    Iterator it = s.iterator();
    int k=0;
     int l=map.values().size();
    while ( it.hasNext() ) {
        
       Map.Entry entry = (Map.Entry) it.next();
       String key = (String) entry.getKey();
       String value = (String) entry.getValue().toString().trim();
     //  System.out.println(key + " => " + value);
     System.out.print( key +", ");
     if (k == l-1)
     { writer.print( value   );
      
     }
     else
       writer.print( value +","   );
     k++;
     
      
      
    }//while
    
  //  System.out.println("========================");
}//printMap


}
