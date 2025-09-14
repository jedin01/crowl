#!/usr/bin/env bash
# Função AWK que você já tinha
parse_nmap_output() {
  IP_ADDRESS=$(ip a | grep 192.168 | grep dynamic | awk '{print $2; exit}')
nmap -sn "$IP_ADDRESS" | awk '
  /Nmap scan report for/ {
    if (match($0, /Nmap scan report for (.+) \(([^)]+)\)/, m)) {
      name=m[1]; ip=m[2];
    } else if (match($0, /Nmap scan report for ([0-9.]+)/, m)) {
      name=""; ip=m[1];
    }
    mac="";
    hosts[++n]=name"\t"ip;
  }
  /MAC Address:/ {
    if (match($0, /MAC Address: ([0-9A-F:]+)/, mm)) {
      hosts[n]=hosts[n]"\t"mm[1]
    }
  }
  END {
    print "Dispositivos detectados: " n;
    print "Listados por ordem, nome do dispositivo, IP Adress e MAC Adress"
    for(i=1;i<=n;i++){
      split(hosts[i], a, "\t");
      printf("%d\t%s\t%s\n", i, (a[1]==""?"(unknown)":a[1]), a[2] (a[3] ? "\t" a[3] : "\t(none)"));
    }
  }
  ' 
}

# Função que garante que nmap está instalado e chama parse_nmap_output
ensure_nmap_and_parse() {
  if command -v nmap >/dev/null 2>&1; then
    echo "Espere..."
  else
    echo "nmap não encontrado. Tentando instalar..."
    if command -v apt-get >/dev/null 2>&1; then
      sudo apt-get update && sudo apt-get install -y nmap
    elif command -v dnf >/dev/null 2>&1; then
      sudo dnf install -y nmap
    elif command -v yum >/dev/null 2>&1; then
      sudo yum install -y nmap
    elif command -v pacman >/dev/null 2>&1; then
      sudo pacman -S --noconfirm nmap
    elif command -v zypper >/dev/null 2>&1; then
      sudo zypper --non-interactive install nmap
    elif command -v apk >/dev/null 2>&1; then
      sudo apk add nmap
    else
      echo "Nenhum gerenciador de pacotes suportado detectado. Instale nmap manualmente."
      return 1
    fi
  fi

  # Executa sua função AWK
  parse_nmap_output
}

# Chamada da função
ensure_nmap_and_parse
