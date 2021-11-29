---
title: [tittle]
section: 1
header: [header]
footer: [footer]
date: [date]
---

# NAME 
[name]

# SYNOPSIS
**[name]** [*OPTION*]...[name]

# DESCRIPTION
**[name]** is a simply Python script meant as a reference to show how to create a MAN
page for your own program or script, written in Markdown and converted with Pandoc.

    man:
	    @cd $(MAN_SRC); for i in *.md; do \
    name=$$(basename $${i} .md); \
    pandoc $${i} -s -t man \
    --metadata title="$${name^^}"  \
    --metadata header="$${name^} Manual"  \
    --metadata footer="$${name} $(VERSION)" \
    --metadata date="$(DATE)" \
    --metadata subtitle="$${name}"  \
    --metadata author="$(AUTHOR)" \
    -o $(MAN_DST)/$${name}.1 \
    ; done

# OPTIONS
## *General Options*
**-h** 
: display help message
**-n**, -r *FORMAT* --force, \--from=*FILE* 
: name of the person to say hello to

\--strict 
: test 
    
    text indent 

# EXIT STATUS
**0**
: Success.

**1**
: Invalid directory. 

# EXAMPLES
**[name] -n Joe**
: Displays "Hello, Joe!" and then exits.

# SEE ALSO
Full documentation and sources at: <https://github.com/pragmaticlinuxblog/pandocmanpage>
