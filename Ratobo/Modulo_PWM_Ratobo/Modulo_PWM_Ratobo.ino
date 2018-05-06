//Desenvolvido por Paulo Maia e Marcelo Kito

#include<stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <SoftwareSerial.h>
#include <string.h>
SoftwareSerial Bluetooth(6,7);

//Montagem:

#define IN3 2
#define IN4 4
#define PWME 3

#define IN1 8
#define IN2 12
#define PWMD 9

/*
int RED = 6;
int GREEN = 10
int BLUE = 11;
*/

//===============================SETUP==============
void setup() {

  //Configurando serial para testes
  Serial.begin(115200);
  Serial.write("Comandos:");
  Bluetooth.begin(9600);

  //Setando pinos como output
  pinMode(PWMD, OUTPUT);
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);
  pinMode(PWME, OUTPUT);
  pinMode(IN3, OUTPUT);
  pinMode(IN4, OUTPUT);
}
//=============================FUNÇÕES=============


//******************************************************* RECEBE COMANDO ***************************************************
void recebeMensagem(){
  int comando;
  if (Bluetooth.available()>0){
    while(Bluetooth.available()){
      comando = Bluetooth.read();
      Serial.print(comando);
   }
   char com[8];
   itoa(comando, com, 2);

   trataMensagem(com); // comando está formado e será tratado
  }
}

//**********************************************************TRATA COMANDO ***************************************************

void trataMensagem(char* com){
  //Serial.write(comando);
  //traduzir numero para byte
  int aux;
  aux = atoi(com);
  char comandoByte[8];
  itoa(aux,comandoByte, 2); // converte numero em cadeia de caracteres binária 
  char comandoComZero[8];

  //Preenchendo zeros
  int m;
  Serial.write("||");
  Serial.write(comandoByte);
  Serial.write(" Vira ->");
  int l = strlen(comandoByte);
  if(l==8){
    strcpy(comandoComZero,comandoByte);
  }else{
    for(m=8; m>8-(strlen(comandoByte)); m--){
      comandoComZero[m-1]=comandoByte[l-1];
      l--;
    }
  
    for(m; m>0; m--){
      comandoComZero[m-1] = '0';
    }
  }
  comandoComZero[8]='\0';
  Serial.write(comandoComZero);
  
  
  //verificando que tipo de comando será pelos dois primeiros bits

  //Caso 10: Movimentação Básica
  if(comandoComZero[0]=='0' && comandoComZero[1]=='0'){
    //Lendo 3 bits para motor esquerda e 3 bits para motor direito
    int ME, MD;
    ME=(int)(4*(comandoComZero[2]-'0') + 2*(comandoComZero[3]-'0') + 1*(comandoComZero[4]-'0'));
    MD=(int)(4*(comandoComZero[5]-'0') + 2*(comandoComZero[6]-'0') + 1*(comandoComZero[7]-'0'));
    //Tratando motor direito

    Serial.write(ME);
    switch (MD) {
      
      case 0:
        //Reverse forte
        digitalWrite(IN1, HIGH);
        digitalWrite(IN2, LOW);
        analogWrite(PWMD, 255);
      break;
      
      case 1:
        //Reverse fraco
        digitalWrite(IN1, HIGH);
        digitalWrite(IN2, LOW);
        analogWrite(PWMD, 100);
      break;
      
       case 2:
       //Parado
        digitalWrite(IN1, LOW);
        digitalWrite(IN2, LOW);
        analogWrite(PWMD, 0);
      break;
      
       case 3:
       //Forward fraco
        digitalWrite(IN1, LOW);
        digitalWrite(IN2, HIGH);
        analogWrite(PWMD, 50);
      break;
      
       case 4:
        //Forward Moderado Fraco
        digitalWrite(IN1, LOW);
        digitalWrite(IN2, HIGH);
        analogWrite(PWMD, 100);
      break;
      
       case 5:
        //Forward Moderado Forte
        digitalWrite(IN1, LOW);
        digitalWrite(IN2, HIGH);
        analogWrite(PWMD, 150);
      break;
      
       case 6:
        //Forward Forte
        digitalWrite(IN1, LOW);
        digitalWrite(IN2, HIGH);
        analogWrite(PWMD, 255);
      break;
      
       case 7:
       //Nada
      break; 
    }


    //Tratando Motor Esquerdo
    switch (ME) {
      
      case 0:
        //Reverse forte
        digitalWrite(IN3, HIGH);
        digitalWrite(IN4, LOW);
        analogWrite(PWME, 255);
      break;
      
      case 1:
        //Reverse fraco
        digitalWrite(IN3, HIGH);
        digitalWrite(IN4, LOW);
        analogWrite(PWME, 100);
      break;
      
       case 2:
       //Parado
        digitalWrite(IN3, LOW);
        digitalWrite(IN4, LOW);
        analogWrite(PWME, 0);
      break;
      
       case 3:
       //Forward fraco
        digitalWrite(IN3, LOW);
        digitalWrite(IN4, HIGH);
        analogWrite(PWME, 50);
      break;
      
       case 4:
        //Forward Moderado Fraco
        digitalWrite(IN3, LOW);
        digitalWrite(IN4, HIGH);
        analogWrite(PWMD, 100);
      break;
      
       case 5:
        //Forward Moderado Forte
        digitalWrite(IN3, LOW);
        digitalWrite(IN4, HIGH);
        analogWrite(PWME, 150);
      break;
      
       case 6:
        //Forward Forte
        digitalWrite(IN3, LOW);
        digitalWrite(IN4, HIGH);
        analogWrite(PWME, 255);
      break;
      
       case 7:
       //Nada
      break;
      
    }
   
  }

  //&&&&&&&&&&&&&&&& Fim Tratamento de movimento básico &&&&&&&&&&&&&&&&&&&&& 
}


//===============================LOOP==============
void loop() {
  recebeMensagem();
  
}






//==========================================================================================================================================
/*                        EQUIPE DE PESQUISA CARROSSEL CAIPIRA        2018
 *                       Izabele Pizzo Ferreira
 *                       Jorge Vicente Oliva Gonçalves
 *                       Luis Fernando Uzai
 *                       Marcelo Hideaki Iwata Kito
 *                       Paulo Eduardo Manzone Maia
*/
//==========================================================================================================================================


