#!/bin/sh

# funcao para executar os comandos e identificar erros
run() {
  echo "Executando comando:# $*"
  "$@"
    while [ $? -ne 0 ]; do
      echo "O comando *'$*'* falhou!"
      echo "Deseja acessar o terminal para correções? (s/n)"
      read opcao
        if [ "$opcao" = "s" ]; then
          echo "Digite 'exit' se quiser continuar o script."
          $SHELL
        fi 
      echo "Deseja repetir o comando que falhou? (s/n)"
      read resposta
        if [ "$resposta" = "s" ]; then
          echo "Repetindo o comando:# $*"
          "$@"
        else
          echo "Continuando script..."
        fi
    done  
  echo "## Sucesso ##"
}

echo "Configurando Git e GitHub..."
read -p "Informe seu user name: " user_name
run git config --global user.name "$user_name"
read -p "Informe seu e-mail: " email
run git config --global user.email "$email"
run git config --global init.defaultBranch main
run git config --global core.editor "vim"
run git config --global trailer.changeid.key "Change-Id"
run git lfs install
run ssh-keygen -t ed25519 -C "$email"
read -p "Informe usuario de destino: " usuario
read -p "Informe ip de destino: " ip
run scp -P 8022 ~/.ssh/id_ed25519.pub $usuario@$ip:~/
echo "Configuracao concluida!"
echo "Adicione a chave publica transferida nas configurações do github e clone o repositório de configuração do sistema para continuar!"