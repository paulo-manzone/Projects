var a,b,z, erro, res;

var textoSobre = "Trabalho desenvolvido para a disciplina de Pesquisa Operacional 2\nProblema de Minimimização Monovariável sem o uso de Derivada\nProfª: Andréa Carla Gonçalves Vianna\n\n\nPaulo Eduardo Manzone Maia - 161022261\nGitHub: https://github.com/paulo-manzone\nRodney Renato de Souza Silva - 161025021\nGitHub: https://github.com/yendorr\n\nUNESP Bauru - Faculdade de Ciências - Departamento de Computação\n"


$(document).ready(function(){

    //Evento clique botão limpar
    $("#limpa").click(function(){
        $("#a").val("");
        $("#b").val("");
        $("#funcao").val("");
        $("#erro").val("");
        $("#result").text("");
    });

    //Evento clique botão Problema pronto
    $("#caso").click(function(){
        $("#a").val("-1");
        $("#b").val("1");
        $("#funcao").val("x*x+3");
        $("#erro").val("0.0001");
    });

    $("#sobre").click(function(){
        window.alert(textoSobre);
    });



   // Evento clique botão calcular 
    $("#calcula").click(function(){

    	//Verifica erro

    	if($("#a").val() == "" || $("#b").val() == "" || $("#funcao").val() == "" || $("#erro").val() == ""){
    		window.alert("Preencha corretamente os campos!");
    		return;
    	}


    	//Entrada de parâmetros

        a = $("#a").val();
        b = $("#b").val();
        z = $("#funcao").val();
        erro = $("#erro").val();

        //Selecionando Método

        if($("#buscaUniforme").is(":checked")){
        	res=Uniforme(a,b,z,erro);
        }

        else if($("#buscaDicotomica").is(":checked")){
        	res=Dicotomica(a,b,z,erro);
        }

        else if($("#buscaAurea").is(":checked")){
        	res=Aurea(a,b,z,erro);
        }

        else if($("#buscaFibonacci").is(":checked")){
        	res=Fibonacci(a,b,z,erro);
        }
        else {
        	window.alert("Erro!");
        	return;
        } 

        // Mostrando valor na tela

        $("#result").text(res);

    });
});

//=================================================================================================================
//												BUSCA UNIFORME
//=================================================================================================================

function Uniforme(a,b,z,erro){
	var p,q,delta, fp, fq, x;
	delta = parseFloat(erro);
	p=parseFloat(a);
	q=p+delta;
    console.log(p + "" + q);
	while(q<b){
		//Encontrando fp e fq
		x = p;
		fp = eval(z);
		x = q;
		fq = eval(z);

        //avaliando se é minimo
		if(fp<fq){
			if (p==a)return a;
			return (p+q)/2 
		}

        //andando com o p e q
		p=q;
		q=p+delta;
	}
	return b;
}

//=================================================================================================================
//												BUSCA DICOTÔMICA
//=================================================================================================================

function Dicotomica(a,b,z,erro){
    var ax, bx, p, q, fp, fq, delta, meio, x;
    delta = parseFloat(erro)/10;
    ax = parseFloat(a);
    bx = parseFloat(b);
    while((bx-ax) > erro){

        //calculando p e q
        meio = (bx+ax)/2;
        p = meio - delta;
        q = meio + delta;

        //calculando fp  
        x = p;
        fp = eval(z);

        //calculando fq
        x = q
        fq = eval(z);

        //definindo novo intervalo
        if(fp < fq) bx = q;
        else ax = p;
    }

    return (ax+bx)/2;

	
}



//=================================================================================================================
//												MÉTODO SEÇÃO ÁUREA
//=================================================================================================================

function Aurea(a,b,z,erro){
    var ax, bx, p, q, fp, fq, x, alfa, beta;
    alfa= 0.618;
    beta = 1-alfa;

    ax = parseFloat(a);
    bx = parseFloat(b);
    while((bx-ax) > erro){

        //calculando p e q
        p = ax+beta*(bx-ax);
        q = ax+alfa*(bx-ax);

        //calculando fp  
        x = p;
        fp = eval(z);

        //calculando fq
        x = q
        fq = eval(z);

        //definindo novo intervalo
        if(fp < fq) bx = q;
        else ax = p;
    }

    return (ax+bx)/2;

}

//=================================================================================================================
//												BUSCA FIBONACCI
//=================================================================================================================



//Função calculo fibonacci
function fibok(k){
    if(k==1 || k==2) return 1;
    return fibok(k-2)+fibok(k-1);
}


//Função resolução usando fibonacci
function Fibonacci(a,b,z,erro){
    var ax, bx, p, q, fp, fq, k;
    var fibo = [];

    ax = parseFloat(a);
    bx = parseFloat(b);
    k = 1;

    //criando vetor seq fibo
    while(fibok(k)<(bx-ax)/erro){
        fibo[k] = fibok(k);
        k++;
    }
    fibo[k] = fibok(k);



    while(bx-ax>erro){

        //calculando p e q
        p = ax + ((fibo[k-2])/(fibo[k]))*(bx-ax);
        q = ax + ((fibo[k-1])/(fibo[k]))*(bx-ax);

        //calculando fp  
        x = p;
        fp = eval(z);

        //calculando fq
        x = q;
        fq = eval(z);

        //definindo novo intervalo
        if(fp < fq) bx = q;
        else ax = p;

        k--;
    }

    return (ax+bx)/2;
	
}


//=================================================================================================================
//                                              Desenvolvido por Paulo Maia
//=================================================================================================================

