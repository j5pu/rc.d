# shellcheck shell=sh

#######################################
# Set color globals
# https://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html
# Contain the unicode Ansi escapes (\u001b) to be used in any language, e.g. Java, Python and Javascript).
# Global vars
#   <Name>                 Color foreground.
#   <Name>Bg               Color background.
#   <Name>Bold             Color bold/bright.
#   <Name>Dim              Color dimmed.
#   <Name>Under            Color underscored.
#   COLORS                 All color (Black Red Green Yellow Blue Magenta Cyan White) combinations.
#   Reset                  Reset color.
# Arguments:
#   None
# ######################################
c() { [ "${COLORS-}" ] && s=" "; COLORS="${COLORS}${s}${1}"; eval "export ${1}='\033[${2}${3}'"; unset s; }
c "Reset" "0" "m"
i="0"
for n in Black Red Green Yellow Blue Magenta Cyan Grey; do
  c "${n}" "3${i}" "m"
  c "${n}Bold" "3${i}" ";1m"
  c "${n}Dim" "3${i}" ";2m"
  c "${n}Under" "3${i}" ";4m"
  c "${n}Invert" "3${i}" ";7m"
  c "${n}Bg" "4${i}" "m"
  i="$((i+1))"
done; unset i n; unset -f c

export COLORS
