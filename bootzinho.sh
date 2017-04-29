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
      $info --text="Voce ja possui todas as dependencias para o Bootizinho"
    else
      $info --text="Voce precisa instalar o pacote PV para funcionamento correto do Bootizinho.\nDigite 'sudo apt-get install pv' em seu terminal\nDepois volte a executar o Bootizinho."
    fi
}

#Verificando a dependência
dependencias=$(dpkg -l | grep "pv");
verificarDependencia
$info --text="Bootizinho, facil e gratuito"
sair
$info --text="Primeiro escolha o pendrive!. Procure no terminal e siga o exemplo."
sair
clear
sudo fdisk -l
echo -e " \033[1;37mLOCALIZE O SEU PENDRIVE ACIMA\033[1;37m!"
pendrive=$(zenity --entry --title="$titulo" --text="Digite o caminho do seu pendrive" --entry-text="Ex: /dev/sdb1");
sair
clear
$info --text="Escolha a imagem ISO que deseja utilizar!"
sair
clear
imagemISO=$(zenity --title="$titulo" --file-selection);
sair
clear
zenity --warning --title="$titulo - Confirmando informacoes" --text="Confira suas informacoes:\nImagem ISO: $imagemISO\nPendrive: $pendrive." --ellipsize
zenity --question --title="$titulo" --text="As informacoes estao corretas e deseja continuar?"
sair

case  $? in
	0) Continuar ;;
	1) Voltar ;;
	*) exit ;;
	esac
}

Voltar(){
	zenity --question --text="Deseja encerrar o programa?"
	if [ "$?" -eq "0" ]; then
	  exit
  elif [ "$?" -q "1" ]; then
    Main
	fi

}

Continuar(){
	zenity --question --text="Deseja formatar o pendrive no formato fat 32?"
	if [ "$?" -eq 0 ]; then
		echo "formatando.. $pendrive"
		sudo umount $pendrive
		sudo mkfs.vfat -I $pendrive | zenity --progress --title='Progresso' --text="Formatando..." --percentage=0 --pulsate
		Gravar
	else
		Gravar
	fi

Main
}

Gravar(){
	zenity --question --text="Deseja iniciar a gravacao da imagem ISO no pendrive: $pendrive ?"
	if [ "$?" -eq 0 ]; then
		sudo umount $pendrive
    clear
    zenity --info --title="$titulo" --text="Nao feche o seu terminal! O processo pode ser demorado, o Bootzinho ira avisa-lo assim que terminar!"
		pv $imagemISO | sudo dd of=$pendrive && sync | zenity --progress --title="Progresso" --text="Concluido" --percentage=0 --pulsate
    Voltar
  else
		Voltar
	fi

Exit
}
Main
