# ~/.zshrc - Configuración de Zsh

# ==============================
# Opciones y configuraciones
# ==============================

# Configuraciones generales
setopt autocd              # Cambiar de directorio solo escribiendo su nombre
#setopt correct            # Corrección automática de errores tipográficos
setopt interactivecomments # Permitir comentarios en modo interactivo
setopt magicequalsubst     # Expansión de nombres de archivo para argumentos tipo 'algo=expresión'
setopt nonomatch           # Ocultar mensaje de error si no hay coincidencias para el patrón
setopt notify              # Reportar el estado de trabajos en segundo plano inmediatamente
setopt numericglobsort     # Ordenar archivos numéricamente cuando tenga sentido
setopt promptsubst         # Permitir sustitución de comandos en el prompt

WORDCHARS=${WORDCHARS//\/} # No considerar ciertos caracteres como parte de la palabra

# Ocultar signo de fin de línea ('%')
PROMPT_EOL_MARK=""

# ==============================
# Keybindings
# ==============================

bindkey -e                                        # Atajos de teclado de emacs
bindkey ' ' magic-space                           # Expansión del historial al presionar espacio
bindkey '^U' backward-kill-line                   # Ctrl + U
bindkey '^[[3;5~' kill-word                       # Ctrl + Supr
bindkey '^[[3~' delete-char                       # Supr
bindkey '^[[1;5C' forward-word                    # Ctrl + ->
bindkey '^[[1;5D' backward-word                   # Ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # Page Up
bindkey '^[[6~' end-of-buffer-or-history          # Page Down
bindkey '^[[H' beginning-of-line                  # Inicio
bindkey '^[[F' end-of-line                        # Fin
bindkey '^[[Z' undo                               # Shift + Tab deshace la última acción

# ==============================
# Configuración de autocompletado
# ==============================

# Habilitar características de completado
autoload -Uz compinit
compinit -d ~/.cache/zcompdump

# Estilos de completado
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'especifique: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completando %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SEn %p: Presione TAB para más opciones, o el carácter para insertar%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SDesplazamiento activo: selección actual en %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# ==============================
# Configuración del historial
# ==============================

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

# Opciones del historial
setopt hist_expire_dups_first # Eliminar duplicados primero cuando HISTFILE excede HISTSIZE
setopt hist_ignore_dups       # Ignorar comandos duplicados en el historial
setopt hist_ignore_space      # Ignorar comandos que comienzan con espacio
setopt hist_verify            # Mostrar comando con expansión de historial antes de ejecutarlo
#setopt share_history         # Compartir datos del historial de comandos

# Forzar a zsh a mostrar el historial completo
alias history="history 0"

# Configurar formato de `time`
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# ==============================
# Configuración del prompt
# ==============================

# Identificar chroot si existe
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Configuración de colores en el prompt
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Función para configurar el prompt
configure_prompt() {
    prompt_symbol=㉿
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PROMPT=$'%F{%(#.blue.green)}┌──${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n'$prompt_symbol$'%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
            ;;
        oneline)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{%(#.red.blue)}%n@%m%b%F{reset}:%B%F{%(#.blue.green)}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
        backtrack)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{red}%n@%m%b%F{reset}:%B%F{blue}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
    esac
    unset prompt_symbol
}

# Variables de configuración del prompt
PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes

if [ "$color_prompt" = yes ]; then
    VIRTUAL_ENV_DISABLE_PROMPT=1
    configure_prompt

    # Habilitar resaltado de sintaxis
    if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
        # Estilos de resaltado
        ZSH_HIGHLIGHT_STYLES[default]=none
        ZSH_HIGHLIGHT_STYLES[unknown-token]=underline
        # (Resto de estilos...)
    fi
else
    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%(#.#.$) '
fi
unset color_prompt force_color_prompt

# Función para alternar el prompt de una o dos líneas
toggle_oneline_prompt(){
    if [ "$PROMPT_ALTERNATIVE" = oneline ]; then
        PROMPT_ALTERNATIVE=twoline
    else
        PROMPT_ALTERNATIVE=oneline
    fi
    configure_prompt
    zle reset-prompt
}
zle -N toggle_oneline_prompt
bindkey ^P toggle_oneline_prompt

# Configuración del título del terminal
case "$TERM" in
    xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
        TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'
        ;;
    *)
        ;;
esac

# Función precmd para acciones antes del prompt
precmd() {
    # Mostrar el título configurado
    print -Pnr -- "$TERM_TITLE"

    # Añadir nueva línea antes del prompt
    if [ "$NEWLINE_BEFORE_PROMPT" = yes ]; then
        if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
            _NEW_LINE_BEFORE_PROMPT=1
        else
            print ""
        fi
    fi
}

# ==============================
# Alias y funciones
# ==============================

# Soporte de color para comandos comunes
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # Color para carpetas con permisos 777

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # Inicio de blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # Inicio de negrita
    export LESS_TERMCAP_me=$'\E[0m'        # Reset de negrita/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # Inicio de video inverso
    export LESS_TERMCAP_se=$'\E[0m'        # Reset de video inverso
    export LESS_TERMCAP_us=$'\E[1;32m'     # Inicio de subrayado
    export LESS_TERMCAP_ue=$'\E[0m'        # Reset de subrayado

    # Aprovechar $LS_COLORS para el completado
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# Autosugerencias basadas en el historial
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999' # Cambiar color de sugerencia
fi

# Habilitar command-not-found si está instalado
if [ -f /etc/zsh_command_not_found ]; then
    source /etc/zsh_command_not_found
fi

# ==============================
# Funciones personalizadas
# ==============================

# Obtener nombre de usuario
user=$(whoami)

# Cargar temas y plugins
source ~/powerlevel10k/powerlevel10k.zsh-theme
source /usr/share/zsh-sudo/sudo.plugin.zsh

# Función para crear directorios estándar
function mkt(){
    mkdir {nmap,content,exploits,scripts}
}

# Función para extraer puertos de un escaneo
function extractPorts(){
    ports="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
    ip_address="$(cat $1 | grep -oP '\d{1,3}(\.\d{1,3}){3}' | sort -u | head -n 1)"
    echo -e "\n[*] Extrayendo información...\n"
    echo -e "\t[*] Dirección IP: $ip_address"
    echo -e "\t[*] Puertos abiertos: $ports\n"
    echo $ports | tr -d '\n' | xclip -sel clip
    echo -e "[*] Puertos copiados al portapapeles\n"
}

# Función para eliminar archivos de forma segura
function rmk(){
    scrub -p dod $1
    shred -zun 10 -v $1
}

# Función para establecer el objetivo
function settarget(){
    if [ $# -eq 1 ]; then
        echo $1 > ~/.config/polybar/cuts/scripts/target
    elif [ $# -gt 2 ]; then
        echo "Uso: settarget [IP] [NOMBRE] | settarget [IP]"
    else
        echo $1 $2 > ~/.config/polybar/cuts/scripts/target
    fi
}

# Función personalizada con fzf
function fzf-lovely(){
    if [ "$1" = "h" ]; then
        fzf -m --reverse --preview-window down:20 --preview '[[ $(file --mime {}) =~ binary ]] &&
            echo {} es un archivo binario ||
            (bat --style=numbers --color=always {} ||
            highlight -O ansi -l {} ||
            coderay {} ||
            rougify {} ||
            cat {}) 2> /dev/null | head -500'
    else
        fzf -m --preview '[[ $(file --mime {}) =~ binary ]] &&
            echo {} es un archivo binario ||
            (bat --style=numbers --color=always {} ||
            highlight -O ansi -l {} ||
            coderay {} ||
            rougify {} ||
            cat {}) 2> /dev/null | head -500'
    fi
}

# ==============================
# Alias personalizados
# ==============================

alias lock="i3lock"
alias img="kitty +kitten icat"
alias ll='lsd -lh --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias l='lsd --group-dirs=first'
alias lla='lsd -lha --group-dirs=first'
alias ls='lsd --group-dirs=first'
alias cat='batcat'
alias catn="/usr/bin/cat"
alias clock="tty-clock -sxc -C 2"
alias pipes="cd /home/${user}/scripts/pipes.sh && ./pipes.sh -t 9"
alias clsram="sudo sync && sudo sysctl -w vm.drop_caches=3"
alias cachefont="fc-cache -fv"
alias colorscript="bash /home/${user}/scripts/shell-color-scripts/colorscript.sh -r"

# Ejecutar colorscript al iniciar la terminal
bash /home/${user}/scripts/shell-color-scripts/colorscript.sh -r

# ==============================
# Configuración de Powerlevel10k
# ==============================

# Finalizar prompt instantáneo de Powerlevel10k (debe estar al final)
(( ! ${+functions[p10k-instant-prompt-finalize]} )) || p10k-instant-prompt-finalize

# Habilitar prompt instantáneo de Powerlevel10k (debe estar al inicio)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Cargar configuración de Powerlevel10k si existe
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
