# Bash tab completion for svn-switch <https://github.com/westonruter/misc-cli-tools/blob/master/svn-switch>
# by Weston Ruter (@westonruter), X-Team <http://x-team.com/>
# Results are cached in the global $_svn_switch_completion and are cleared
# whenever you run svn-switch in another repo.
# URL: https://github.com/westonruter/misc-cli-tools/blob/master/bash_completion_svn_switch.sh
#
# Load this file in your .bashrc/.profile:
# source ~/bash_completion_svn_switch.sh
#
# For general SVN Bash tab completion, see a script like:
# http://worksintheory.org/files/misc/bash_completion_svn
#
# Usage:
# $ svn-switch <tab>
# > (all branches, tas, and trunk)
# svn-switch branch<tab>
# > (all branches)
# svn-switch branches/a<tab>
# > (all branches starting with "a")
# svn-switch tr<tab>
# > (trunk)

_svn_switch_completion ()
{
    local repo_root_url=`svn info | perl -ne 'print $1 if s{^URL: (.*)/(trunk|branches/[^/]+|tags/[^/]+)}{\1}'`

    # if a name has already been provided, abort since it only makes sense to have one
    # @todo Allow options
    if [ $COMP_CWORD -gt 1 ]; then
        return
    fi

    word=${COMP_WORDS[COMP_CWORD]}

    if [ ${#_svn_switch_cache} -eq 0 -o "$_svn_switch_last_repo_root" != "$repo_root_url" ]; then
        echo -n '.'
        _svn_switch_cache=( 'trunk/' )
        echo -n '.'
        _svn_switch_cache=( "${_svn_switch_cache[@]}" `svn ls $repo_root_url/branches 2>/dev/null | sed 's:^:branches/:'` )
        echo -n '.'
        _svn_switch_cache=( "${_svn_switch_cache[@]}" `svn ls $repo_root_url/tags 2>/dev/null | sed 's:^:tags/:'` )
        echo -n -e "\b\b\b   \b\b\b" # ^H^H^H
    fi

    # @todo Why is the echo needed in this??
    COMPREPLY=(${COMPREPLY[@]:-} $(compgen -W "`echo ${_svn_switch_cache[@]}`" -- "$word"))

    _svn_switch_last_repo_root="$repo_root_url"
}
complete -o default -F _svn_switch_completion svn-switch
