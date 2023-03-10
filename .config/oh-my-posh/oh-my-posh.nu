let-env POWERLINE_COMMAND = 'oh-my-posh'
let-env POSH_THEME = "/var/home/lich/.cache/oh-my-posh/config.omp.json"
let-env PROMPT_INDICATOR = ""
# By default displays the right prompt on the first line
# making it annoying when you have a multiline prompt
# making the behavior different compared to other shells
let-env PROMPT_COMMAND_RIGHT = {''}
let-env NU_VERSION = (version | get version)

# PROMPTS
let-env PROMPT_MULTILINE_INDICATOR = (^"/var/usrlocal/bin/oh-my-posh" print secondary $"--config=($env.POSH_THEME)" --shell=nu $"--shell-version=($env.NU_VERSION)")

let-env PROMPT_COMMAND = {
    let width = (term size -c | get columns | into string)
    ^"/var/usrlocal/bin/oh-my-posh" print primary $"--config=($env.POSH_THEME)" --shell=nu $"--shell-version=($env.NU_VERSION)" $"--execution-time=($env.CMD_DURATION_MS)" $"--error=($env.LAST_EXIT_CODE)" $"--terminal-width=($width)"
}
