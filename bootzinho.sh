#!/bin/bash
export titulo=Bootzinho

Main(){
sair () {
if [ "$?" -eq 1 ]; then
        exit
fi
}
#$titulo="Bootzinho"
zenity --info --title="$titulo" --text="Bootizinho, fácil e gratuito"
sair
zenity --info --title="$titulo" --text="Primeiro escolha o pendrive!. Procure no terminal e siga o exemplo."
sair
clear
sudo fdisk -l
echo -e " \033[1;37mLOCALIZE O SEU PENDRIVE ACIMA\033[1;37m!"
pendrive=$(zenity --entry --title="$titulo" --text="Digite o caminho do seu pendrive" --entry-text="Ex: /dev/sdb1");
sair
clear
zenity --info --title="$titulo" --text="Escolha a imagem ISO que deseja utilizar!"
sair
clear
imagemISO=$(zenity --title="$titulo" --file-selection);
sair
clear
zenity --title="$titulo - Confira as informações" --question --text="Imagem ISO: $imagemISO, Pendrive: $pendrive, escolhidos com sucesso, deseja continuar?"
sair

case  $? in
	0) Continuar ;;
	1) Voltar ;;
	*) exit ;;
	esac
}

Voltar(){

	zenity --question --text="Deseja encerrar o programa?"
	if [ "$?" -eq 0 ]; then
		exit
	else
		Main
	fi

	Main
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
	zenity --question --text="Deseja iniciar a gravação da imagem ISO no pendrive: $pendrive ?"
	if [ "$?" -eq 0 ]; then

		sudo umount $pendrive
    clear
    zenity --info --title="$titulo" --text="Não feche o seu terminal! O processo pode ser demorado, o Bootzinho irá avisa-lo assim que terminar!"
		sudo dd if=$imagemISO of=$pendrive && sync | zenity --progress --title="Progresso" --text="Gravando..." --percentage=0 --pulsate
    Voltar
  else
		Voltar
	fi
	Exit

}

Main
