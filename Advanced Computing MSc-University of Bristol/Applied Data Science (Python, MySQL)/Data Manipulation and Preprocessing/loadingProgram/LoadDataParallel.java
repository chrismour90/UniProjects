/*
 * By Akingbolade Shada
 * +447405820353
 * as16247@my.bristol.ac.uk
 */
package loadingProgram;

/**
 *
 * @author akingboladeshada
 */
//split CHARTEVENTS.csv to 10000000  rows in each splitt
//split -l  "10000000"     CHARTEVENTS.csv
import java.io.FileWriter;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Locale;
import java.io.File;
import java.io.IOException;
import java.text.*;
import java.util.*;
import java.util.HashMap;
import java.util.concurrent.Callable;

public class LoadDataParallel {
    @SuppressWarnings("static-access")
public static void main( String[] args )
    {

        LoadMyData et100 = new LoadMyData("NOTEEVENTS","NOTEEVENTS.CSV","1" );
       // LoadMyData et101 = new LoadMyData("NOTEEVENTS_CV","NOTEEVENTS_CV.CSV","1" );
        LoadMyData et102 = new LoadMyData("LABEVENTS","LABEVENTS.CSV","1" );
        
        LoadMyData et1 = new LoadMyData("MICROBIOLOGYEVENTS","MICROBIOLOGYEVENTS.CSV","1" );
        LoadMyData et2 = new LoadMyData("TRANSFERS","TRANSFERS.CSV","1" );
        LoadMyData et3 = new LoadMyData("DRGCODES","DRGCODES.CSV","1" );
        LoadMyData et4 = new LoadMyData("SERVICES","SERVICES.CSV","1" );
        LoadMyData et5 = new LoadMyData("INPUTEVENTS_MV","INPUTEVENTS_MV.CSV","1" );
        LoadMyData et6 = new LoadMyData("DIAGNOSES_ICD","DIAGNOSES_ICD.CSV","1" );
        LoadMyData et7 = new LoadMyData("PROCEDURES_ICD","PROCEDURES_ICD.CSV","1" );
        LoadMyData et8 = new LoadMyData("DATETIMEEVENTS","DATETIMEEVENTS.CSV","1" );
        LoadMyData et9 = new LoadMyData("PROCEDUREEVENTS_MV","PROCEDUREEVENTS_MV.CSV","1" );
        LoadMyData et10 = new LoadMyData("ICUSTAYS","ICUSTAYS.CSV","1" );
        LoadMyData et11 = new LoadMyData("CPTEVENTS","CPTEVENTS.CSV","1" );
        LoadMyData et12 = new LoadMyData("PRESCRIPTIONS","PRESCRIPTIONS.CSV","1" );
        LoadMyData et13 = new LoadMyData("D_LABITEMS","D_LABITEMS.CSV","1" );
        LoadMyData et14 = new LoadMyData("PATIENTS","PATIENTS.CSV","1" );
        LoadMyData et15= new LoadMyData("D_ITEMS","D_ITEMS.CSV","1" );
        LoadMyData et16 = new LoadMyData("CAREGIVERS","CAREGIVERS.CSV","1" );
        LoadMyData et17 = new LoadMyData("OUTPUTEVENTS","OUTPUTEVENTS.CSV","1" );
        LoadMyData et18 = new LoadMyData("D_ICD_PROCEDURES","D_ICD_PROCEDURES.CSV","1" );
        LoadMyData et19 = new LoadMyData("CALLOUT","CALLOUT.CSV","1" );
        LoadMyData et20 = new LoadMyData("D_ICD_DIAGNOSES","D_ICD_DIAGNOSES.CSV","1" );
        LoadMyData et21 = new LoadMyData("ADMISSIONS","ADMISSIONS.CSV","1" );
       
LoadMyData et22=new LoadMyData("CHARTEVENTS","xaa","1");
LoadMyData et23=new LoadMyData("CHARTEVENTS","xae","0");
LoadMyData et24=new LoadMyData("CHARTEVENTS","xai","0");
LoadMyData et25=new LoadMyData("CHARTEVENTS","xam","0");
LoadMyData et26=new LoadMyData("CHARTEVENTS","xaq","0");
LoadMyData et27=new LoadMyData("CHARTEVENTS","xau","0");
LoadMyData et28=new LoadMyData("CHARTEVENTS","xay","0");
LoadMyData et29=new LoadMyData("CHARTEVENTS","xbc","0");
LoadMyData et30=new LoadMyData("CHARTEVENTS","xbg","0");
LoadMyData et31=new LoadMyData("CHARTEVENTS","xab","0");
LoadMyData et32=new LoadMyData("CHARTEVENTS","xaf","0");
LoadMyData et33=new LoadMyData("CHARTEVENTS","xaj","0");
LoadMyData et34=new LoadMyData("CHARTEVENTS","xan","0");
LoadMyData et35=new LoadMyData("CHARTEVENTS","xar","0");
LoadMyData et36=new LoadMyData("CHARTEVENTS","xav","0");
LoadMyData et37=new LoadMyData("CHARTEVENTS","xaz","0");
LoadMyData et38=new LoadMyData("CHARTEVENTS","xbd","0");
LoadMyData et39=new LoadMyData("CHARTEVENTS","xbh","0");
LoadMyData et40=new LoadMyData("CHARTEVENTS","xac","0");
LoadMyData et41=new LoadMyData("CHARTEVENTS","xag","0");
LoadMyData et42=new LoadMyData("CHARTEVENTS","xak","0");
LoadMyData et43=new LoadMyData("CHARTEVENTS","xao","0");
LoadMyData et44=new LoadMyData("CHARTEVENTS","xas","0");
LoadMyData et45=new LoadMyData("CHARTEVENTS","xaw","0");
LoadMyData et46=new LoadMyData("CHARTEVENTS","xba","0");
LoadMyData et47=new LoadMyData("CHARTEVENTS","xbe","0");
LoadMyData et48=new LoadMyData("CHARTEVENTS","xad","0");
LoadMyData et49=new LoadMyData("CHARTEVENTS","xah","0");
LoadMyData et50=new LoadMyData("CHARTEVENTS","xal","0");
LoadMyData et51=new LoadMyData("CHARTEVENTS","xap","0");
LoadMyData et52=new LoadMyData("CHARTEVENTS","xat","0");
LoadMyData et53=new LoadMyData("CHARTEVENTS","xax","0");
LoadMyData et54=new LoadMyData("CHARTEVENTS","xbb","0");
LoadMyData et55=new LoadMyData("CHARTEVENTS","xbf","0");       
        
       
        
Thread t100 = new Thread( et100 );
//Thread t101 = new Thread( et101 );
Thread t102 = new Thread( et102 );

        Thread t1 = new Thread( et1 );
        Thread t2 = new Thread( et2 );
         Thread t3 = new Thread( et3 );
        Thread t4 = new Thread( et4 );
         Thread t5 = new Thread( et5 );
        Thread t6 = new Thread( et6 );
         Thread t7 = new Thread( et7 );
        Thread t8 = new Thread( et8 );
         Thread t9 = new Thread( et9 );
        Thread t10 = new Thread( et10 );
         Thread t11 = new Thread( et11 );
        Thread t12 = new Thread( et12 );
         Thread t13 = new Thread( et13 );
        Thread t14 = new Thread( et14 );
          Thread t15 = new Thread( et15 );
             Thread t16 = new Thread( et16 );
        Thread t17 = new Thread( et17 );
         Thread t18 = new Thread( et18 );
        Thread t19 = new Thread( et19 );
          Thread t20 = new Thread( et20 );
          Thread t21 = new Thread( et21 );

          Thread t22 =new Thread(	et22	);
Thread t23 =new Thread(	et23	);
Thread t24 =new Thread(	et24	);
Thread t25 =new Thread(	et25	);
Thread t26 =new Thread(	et26	);
Thread t27 =new Thread(	et27	);
Thread t28 =new Thread(	et28	);
Thread t29 =new Thread(	et29	);
Thread t30 =new Thread(	et30	);
Thread t31 =new Thread(	et31	);
Thread t32 =new Thread(	et32	);
Thread t33 =new Thread(	et33	);
Thread t34 =new Thread(	et34	);
Thread t35 =new Thread(	et35	);
Thread t36 =new Thread(	et36	);
Thread t37 =new Thread(	et37	);
Thread t38 =new Thread(	et38	);
Thread t39 =new Thread(	et39	);
Thread t40 =new Thread(	et40	);
Thread t41 =new Thread(	et41	);
Thread t42 =new Thread(	et42	);
Thread t43 =new Thread(	et43	);
Thread t44 =new Thread(	et44	);
Thread t45 =new Thread(	et45	);
Thread t46 =new Thread(	et46	);
Thread t47 =new Thread(	et47	);
Thread t48 =new Thread(	et48	);
Thread t49 =new Thread(	et49	);
Thread t50 =new Thread(	et50	);
Thread t51 =new Thread(	et51	);
Thread t52 =new Thread(	et52	);
Thread t53 =new Thread(	et53	);
Thread t54 =new Thread(	et54	);
Thread t55 =new Thread(	et55	);

t100.start();
//t101.start();
t102.start();


t1.start();
t2.start();
t3.start();
t4.start();
t5.start();
t6.start();
t7.start();
t8.start();
t9.start();
t10.start();
t11.start();
t12.start();
t13.start();
t14.start();
t15.start();
t16.start();
t17.start();
t18.start();
t19.start();
t20.start();
t21.start();
t22.start();
t23.start();
t24.start();
t25.start();
t26.start();
t27.start();
t28.start();
t29.start();
t30.start();
t31.start();
t32.start();
t33.start();
t34.start();
t35.start();
t36.start();
t37.start();
t38.start();
t39.start();
t40.start();
t41.start();
t42.start();
t43.start();
t44.start();
t45.start();
t46.start();
t47.start();
t48.start();
t49.start();
t50.start();
t51.start();
t52.start();
t53.start();
t54.start();
t55.start();




        // t1.interrupt();
    }
}

