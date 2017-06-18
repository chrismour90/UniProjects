//InflaShoe
#include <Keypad.h>
const byte ROWS = 2; // Four rows
const byte COLS = 4; // Four columns
// Define the Keymap
char keys[ROWS][COLS] = {{'1','2','3','4'},
                         {'5','6','7','8'}};
// Connect keypad ROW0, ROW1, ROW2 and ROW3 to these Arduino pins.
byte rowPins[ROWS] = {2,11};
// Connect keypad COL0, COL1 and COL2 to these Arduino pins.
byte colPins[COLS] = {3,4,5,7};
// Create the Keypad
Keypad kpd = Keypad( makeKeymap(keys), rowPins, colPins, ROWS, COLS );
// connect motor controller pins to Arduino digital pins
// pump pins
int in1 = 9;
int in2 = 8;
//valve pins
int in4 = 6; //valve1
int in3 = 10; //valve2
char key;
char flag;
void setup()
{
  // set all the motor control pins to outputs
  pinMode(in1, OUTPUT);
  pinMode(in2, OUTPUT);
   
  pinMode(in4, OUTPUT);
  digitalWrite(in4, LOW);  //initially close valve1
   pinMode(in3, OUTPUT);
  digitalWrite(in3, LOW);  //initially close valve2
  Serial.begin(9600);
     
}
// this function will run the motor at a fixed speed to inflate
void pump_start()
{
  digitalWrite(in1, LOW);    //change motor directions to inflate
  digitalWrite(in2, HIGH);
}
 
//
void open_valve1(){
  digitalWrite(in4, HIGH);    //open valve1
  
}
void open_valve2(){
  digitalWrite(in3, HIGH);    //open valve2
 }
  
void turn_off()
{
   digitalWrite(in1, LOW);    //turn off pump
   digitalWrite(in2, LOW);
   digitalWrite(in4, LOW);    //close valve1
   digitalWrite(in3, LOW);    //close valve2
}
     
void loop()
{
   key = kpd.getKey();
   delay(10);
  if(key){
    if(key == '1'){
      flag='1';
    }
    else if(key == '2'){
      flag='2';
    }
    else if(key == '3'){
      flag='3';
    }
    else if(key == '4'){
      flag='4';
    }
     else if(key == '5'){
      flag='5';
    }
     else if(key == '6'){
      flag='6';     
    }
     else if(key == '7'){
       flag='7';
    }
  }
  //button 1 pressed, inflate both
  if(flag == '1'){
    pump_start();
    open_valve1();
    open_valve2();
    Serial.print(flag);
  } //button 2 pressed, inflate front
  else if(flag == '2'){
    pump_start();
    open_valve1();
    Serial.print(flag);
  } //button 3 pressed, inflate back
  else if(flag == '3'){
    pump_start();
    open_valve2();
    Serial.print(flag);
  } //button 4 pressed, turn off everything
  else if(flag == '4'){
    turn_off();   
    Serial.print(flag);
  } //button 5 pressed, deflate both
   else if(flag == '5'){
    open_valve1();
    open_valve2();
    
    Serial.print(flag);
  } //button 6 pressed, deflate front
   else if(flag == '6'){
    open_valve1();
    Serial.print(flag);
  } //button 7 pressed, deflate back
   else if(flag == '7'){
    open_valve2();
    Serial.print(flag);
  }
  
}