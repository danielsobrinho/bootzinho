#!/bin/bash
export titulo=Bootzinho
export info="zenity --info --title=$titulo"
Main(){
#Função Sair - Utilizada para indificar quando clicado no botão de fechar e assim encerrar o script.
sair () {
if [ "$?" -ne "0" ]; then
        exit
fi
}
#Função de verificar dependência - Usada para verificar se o pacote pv encontra-se instalado no sistema.
verificarDependencia(){
    if [ -n "$dependencias" ]; then
      $info --text="Voce ja possui todas as dependencias para o Bootizinho" 2> /dev/null
    else
      $info --text="Voce precisa instalar o pacote PV para funcionamento correto do Bootizinho.\nDigite 'sudo apt-get install pv' em seu terminal\nDepois volte a executar o Bootizinho." 2> /dev/null
    fi
}

#Verificando a dependência
dependencias=$(whereis pv | grep "pv" | cut -d':' -f1);
verificarDependencia
$info --text="Bootizinho, facil e gratuito" 2> /dev/null
sair
$info --text="Primeiro escolha o pendrive!. Procure no terminal e siga o exemplo." 2> /dev/null
sair
clear
sudo fdisk -l
echo -e " \033[1;37mLOCALIZE O SEU PENDRIVE ACIMA\033[1;37m!"
pendrive=$(zenity --entry --title="$titulo" --text="Digite o caminho do seu pendrive" --entry-text="Ex: /dev/sdb1" 2> /dev/null);
sair
clear
$info --text="Escolha a imagem ISO que deseja utilizar!" 2> /dev/null
sair
clear
imagemISO=$(zenity --title="$titulo" --file-selection 2> /dev/null);
sair
clear
zenity --warning --title="$titulo - Confirmando informacoes" --text="Confira suas informacoes:\nImagem ISO: $imagemISO\nPendrive: $pendrive." --ellipsize 2> /dev/null
zenity --question --title="$titulo" --text="As informacoes estao corretas e deseja continuar?" 2> /dev/null
sair

case  $? in
	0) Continuar ;;
	1) Voltar ;;
	*) exit ;;
	esac
}

Voltar(){
	zenity --question --text="Deseja encerrar o programa?" 2> /dev/null
	if [ "$?" -eq "0" ]; then
	  exit
  elif [ "$?" -q "1" ]; then
    Main
	fi

}

Continuar(){
	zenity --question --text="Deseja formatar o pendrive no formato fat 32?" 2> /dev/null
	if [ "$?" -eq 0 ]; then
		echo "formatando.. $pendrive"
		sudo umount $pendrive
		sudo mkfs.vfat -I $pendrive | zenity --progress --title='Progresso' --text="Formatando..." --percentage=0 --pulsate 2> /dev/null
		Gravar
	else
		Gravar
	fi

Main
}

Gravar(){
	zenity --question --text="Deseja iniciar a gravacao da imagem ISO no pendrive: $pendrive ?" 2> /dev/null
	if [ "$?" -eq 0 ]; then
		sudo umount $pendrive
    clear
    zenity --info --title="$titulo" --text="Nao feche o seu terminal! O processo pode ser demorado, o Bootzinho ira avisa-lo assim que terminar!" 2> /dev/null
		pv $imagemISO | sudo dd of=$pendrive && sync | zenity --progress --title="Progresso" --text="Concluido" --percentage=0 --pulsate 2> /dev/null
    Voltar
  else
		Voltar
	fi

Exit
}
Main
