function Setup-VSCodeExtensions {
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("VSCode", "VSCodeInsiders")]
        [string[]]
        $Environment
    )

    $extensions = @(
        'alefragnani.jenkins-status', # Jenkins Status
        'tabeyti.jenkins-jack', # Jenkins Plugin
        'alexiv.vscode-angular2-files',
        'amazonwebservices.aws-toolkit-vscode',
        #'azuredevspaces.azds',
        'bewhite.dokd-vscode-preview', # DevOps Desired State Config
        'christian-kohler.path-intellisense', # Path intellisense
        'CoenraadS.bracket-pair-colorizer', # Bracket Colors
        #'cstuder.gitlab-ci-validator',
        'DavidAnson.vscode-markdownlint', # Markdown
        'dbaeumer.jshint',
        'dbaeumer.vscode-eslint',
        'dracula-theme.theme-dracula',
        'eamodio.gitlens',
        'eg2.vscode-npm-script',
        'ego-digital.vscode-powertools',
        'erd0s.terraform-autocomplete',
        'esbenp.prettier-vscode',
        #'fatihacet.gitlab-workflow',
        'Leopotam.csharpfixformat', # C# Formatter
        'FelschR.extbundles-csharp',
        'fireside21.cshtml', # Razor CS HTML
        'formulahendry.auto-close-tag',
        'formulahendry.code-runner',
        'formulahendry.github-actions',
        'Fr43nk.seito-openfile',
        'Fudge.auto-using',
        #'googlecloudtools.cloudcode',
        'humao.rest-client',
        'idleberg.icon-fonts',
        'ipatalas.vscode-sprint-planner',
        'ipedrazas.kubernetes-snippets',
        #'jasonn-porch.gitlab-mr',
        'johnpapa.angular-essentials',
        'johnpapa.vscode-peacock',
        'johnpapa.winteriscoming',
        'johnpapa.vscode-cloak', # Hide secrets
        'johnpapa.pwa-tools',
        'johnpapa.winteriscoming', # Theme
        'k--kato.docomment', # C# style comment documentation
        'KevinRose.vsc-python-indent',
        #'logerfo.gitlab-notifications',
        'mauve.terraform',
        'mgesbert.python-path',
        'ms-azure-devops.azure-pipelines',
        'ms-azuretools.vscode-apimanagement',
        'ms-azuretools.vscode-azureappservice',
        'ms-azuretools.vscode-azurefunctions',
        'ms-azuretools.vscode-azurestorage',
        'ms-azuretools.vscode-azureterraform',
        'ms-azuretools.vscode-cosmosdb',
        'ms-azuretools.vscode-docker',
        'ms-kubernetes-tools.vscode-aks-tools',
        'ms-kubernetes-tools.vscode-kubernetes-tools',
        'ms-mssql.mssql',
        'ms-python.python',
        'ms-vscode-remote.remote-wsl',
        'ms-vscode.azure-account',
        'ms-vscode.azurecli',
        'ms-vscode.csharp',
        'ms-vscode.powershell',
        'ms-vscode.vs-keybindings',
        'ms-vscode.vscode-node-azure-pack',
        'ms-vsts.team',
        'msazurermtools.azurerm-vscode-tools',
        'msjsdiag.debugger-for-chrome',
        'mwiedemeyer.devops-build-status',
        #'natewallace.angular2-inline',
        #'neilbarkhina.gitdownloadazurerepos',  // Not a good extension
        'nrwl.angular-console',
        'octref.vetur',
        'pflannery.vscode-versionlens',
        'PKief.material-icon-theme',
        #'ppgee.gitlab-mr-notice-vscode',
        'qezhu.gitlink',
        'redhat.vscode-yaml',
        'ritwickdey.LiveServer',
        'ronnidc.nunjucks',
        #'rrivera.vscode-gitlab-explorer',
        'run-at-scale.terraform-doc-snippets',
        'Shan.code-settings-sync',
        'shanoor.vscode-nginx',
        'shd101wyy.markdown-preview-enhanced',
        #'sketchbuch.vsc-quokka-statusbar',
        'steoates.autoimport',
        'streetsidesoftware.code-spell-checker',
        'tintoy.msbuild-project-tools',
        'tushortz.python-extended-snippets',
        'vsciot-vscode.azure-iot-toolkit',
        'vscode-icons-team.vscode-icons',
        'walkme.devops-extension-pack',
        'WallabyJs.quokka-vscode',
        'yzane.markdown-pdf',
        'yzhang.markdown-all-in-one',
        'Zignd.html-css-class-completion',
        'ms-vscode-remote.remote-wsl', # Remote Windows Subsystem on Linux
        'wayou.vscode-todo-highlight', # TODO Highlighter
        'ms-vscode-remote.remote-ssh', # Remote SSH
        'joelday.docthis', # Javascript/Tyescript JSDoc
        'ms-vscode-remote.remote-containers', # Run on remote container
        'ms-kubernetes-tools.vscode-kubernetes-tools', # Kubernetes
        'VisualStudioExptTeam.vscodeintellicode', # AI Intellisense
        'quicktype.quicktype', # Paste JSON as Code
        'ms-vscode.Go', # Go lang
        '766b.go-outliner', # Go outliner
        'Lourenci.go-to-spec' # Go spec

    )

    switch ($Environment) {
        "VSCode" {
            foreach ($ext in $extensions) {
                cmd /c "code --install-extension $ext"
            }
        }
        "VSCodeInsiders" {
            foreach ($ext in $extensions) {
                cmd /c "code-insiders --install-extension $ext"
            }
        }
    }
}