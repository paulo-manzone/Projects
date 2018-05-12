import { Component } from '@angular/core';
import { NavController } from 'ionic-angular';
import { BluetoothSerial } from '@ionic-native/bluetooth-serial';

@Component({
  selector: 'page-about',
  templateUrl: 'about.html'
})
export class AboutPage {

  value: String = "";
  senha: String = "";

  byte1: byte; 
  byte2: byte;

  constructor(public navCtrl: NavController) {

  }

  addSenha0() {
    this.value += "0";
  }

  addSenha1() {
    this.value += "1";
  }

  addSenha2() {
    this.value += "2";
  }

  addSenha3() {
    this.value += "3";
  }

  addSenha4() {
    this.value += "4";
  }

  addSenha5() {
    this.value += "5";
  }

  addSenha6() {
    this.value += "6";
  }

  addSenha7() {
    this.value += "7";
  }

  addSenha8() {
    this.value += "8";
  }
  addSenha9() {
    this.value += "9";
  }

  limpar() {
    this.value = "";
  }

  enviar() {
    //Senha = 4 números de 0 a 9
    //Será dividida em 2 bytes, sendo cada 4 bits um dos 4 números da senha

    //Le senha
    this.senha = this.value;

   //Zera valor do input através da variável bindada 
    this.value = "";

    //Montagem dos bytes

    //Primeiro digito
    if(this.senha[0] == "0") this.byte1 = 0 *16;
    if(this.senha[0] == "1") this.byte1 = 1 *16;
    if(this.senha[0] == "2") this.byte1 = 2 *16;
    if(this.senha[0] == "3") this.byte1 = 3 *16;
    if(this.senha[0] == "4") this.byte1 = 4 *16;
    if(this.senha[0] == "5") this.byte1 = 5 *16;
    if(this.senha[0] == "6") this.byte1 = 6 *16;
    if(this.senha[0] == "7") this.byte1 = 7 *16;
    if(this.senha[0] == "8") this.byte1 = 8 *16;
    if(this.senha[0] == "9") this.byte1 = 9 *16;

    //Segundo Digito
    if(this.senha[1] == "0") this.byte1 += 0;
    if(this.senha[1] == "1") this.byte1 += 1;
    if(this.senha[1] == "2") this.byte1 += 2;
    if(this.senha[1] == "3") this.byte1 += 3;
    if(this.senha[1] == "4") this.byte1 += 4;
    if(this.senha[1] == "5") this.byte1 += 5;
    if(this.senha[1] == "6") this.byte1 += 6;
    if(this.senha[1] == "7") this.byte1 += 7;
    if(this.senha[1] == "8") this.byte1 += 8;
    if(this.senha[1] == "9") this.byte1 += 9;

    //Terceiro digito
    if(this.senha[2] == "0") this.byte2 = 0 *16;
    if(this.senha[2] == "1") this.byte2 = 1 *16;
    if(this.senha[2] == "2") this.byte2 = 2 *16;
    if(this.senha[2] == "3") this.byte2 = 3 *16;
    if(this.senha[2] == "4") this.byte2 = 4 *16;
    if(this.senha[2] == "5") this.byte2 = 5 *16;
    if(this.senha[2] == "6") this.byte2 = 6 *16;
    if(this.senha[2] == "7") this.byte2 = 7 *16;
    if(this.senha[2] == "8") this.byte2 = 8 *16;
    if(this.senha[2] == "9") this.byte2 = 9 *16;

    //Quarto Digito
    if(this.senha[3] == "0") this.byte2 += 0;
    if(this.senha[3] == "1") this.byte2 += 1;
    if(this.senha[3] == "2") this.byte2 += 2;
    if(this.senha[3] == "3") this.byte2 += 3;
    if(this.senha[3] == "4") this.byte2 += 4;
    if(this.senha[3] == "5") this.byte2 += 5;
    if(this.senha[3] == "6") this.byte2 += 6;
    if(this.senha[3] == "7") this.byte2 += 7;
    if(this.senha[3] == "8") this.byte2 += 8;
    if(this.senha[3] == "9") this.byte2 += 9;

    console.log(this.byte1);
    console.log(this.byte2);
  }

}
