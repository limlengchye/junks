#!/bin/bash
#
# genpass   Four char classes password generator.
#   
# desc:     Generate a password consist of four character classes: 
#           lowercase, uppercase,digits and symbols. By default 
#           the minimum length is 8 characters. You can set up to 
#           40 characters. Anything beyond that will be truncated.
#
# Author:   LC on 26th Mac 2014. 
#             
# usage:    genpass <length> 
#     
# Example 1:
#           
#           genpass 
#           
#           This generates password in 8 characters length.
#
# Example 2:
#
#           genpass 12
#           
#           This generates password in 12 characters length.
# 
# Example 3:
#
#           genpass 51
#
#           This generates password in 40 characters length.  
#
# Note:     I'm still jobless. :(
#
 
passlength=8 ## Set default length to 8 
maxlength=40 ## Maximum length set to 40
symbol='!@#%^_=' ## Limit the symbols set. 


## Get a random symbol 
getsymbol(){
    </dev/urandom tr -cd $symbol | head -c 1
}

## Get a random digit
getdigit(){
    </dev/urandom tr -cd '[:digit:]' | head -c 1
}

## Get a uppercase char
getupper(){
    </dev/urandom tr -cd '[:upper:]' | head -c 1
}

## Get a lowercase char
getlower(){
    </dev/urandom tr -cd '[:lower:]' | head -c 1
}

## Get the class 4 baseline. It has to be at least a symbol, a lower, a upper and a digit.
getbaseline(){
  echo "$(getsymbol) $(getdigit) $(getupper) $(getlower)" 
}

## Get greedy - either a symbol, a lower, a upper or a digit. Just pick one.
getgreedy(){
    </dev/urandom tr -cd '[:lower:][:upper:][:digit:]'$symbol | head -c 1
}
## Get the head char. It only can be a symbol, a digit or a lower char.
gethead(){
    RET="$(getsymbol)$(getlower)$(getdigit)"
    </dev/urandom tr -cd $RET | head -c 1
}

## Get the tail char. It only can be a symbol, a lower char or a upper char.
gettail(){
    RET="$(getsymbol)$(getlower)$(getupper)"
    </dev/urandom tr -cd $RET | head -c 1
} 

## Construct the body 
getbody(){
    bodylength=$(expr $passlength - 2)
    baseloop=$(echo "$bodylength/4" |bc)
    basecounter=0
    body=""
    while [ $basecounter -lt $baseloop ]; do
            body="${body} $(getbaseline)"
            basecounter=$(expr $basecounter + 1)
    done    

    remainloop=$(echo "$bodylength%4" |bc)
    remaincounter=0
    while [ $remaincounter -lt $remainloop ];do
            body="${body} $(getgreedy)"
            remaincounter=$(expr $remaincounter + 1 )
    done
    shuf -e $body | tr -d '\n' ;echo ''    
}

#***  MAIN ****
if [ -n "$1" ];then
    arg=$(echo $1|bc)
    if [ $arg -gt $passlength ]; then
        if [ $arg -lt $maxlength ];then
            passlength=$arg
        else
            passlength=$maxlength
        fi
    fi
fi
        
echo "$(gethead)$(getbody)$(gettail)"
#**************
