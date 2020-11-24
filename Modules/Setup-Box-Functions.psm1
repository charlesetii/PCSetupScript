Import-Module $PSScriptRoot\Common-Functions.psm1 -WarningAction SilentlyContinue

function Install-MiscApps {
    Write-Host "Calibre Books"
    choco install calibre -y
    Write-Host "Discord"
    choco install discord.install -y
    Write-Host "VLC"
    choco install vlc -y
    Write-Host "Steam"
    choco install steam -y
    Write-Host "Blender"
    choco install blender -y
    #Write-Host "Kaspersky"
    #choco install kav -y # Anti-virus
    Write-Host "InkScape"
    choco install inkscape -y
    Write-Host "GIMP"
    choco install gimp -y
    #Write-Host "AVG"
    #choco install avgantivirusfree -y
    Write-Host "CCleaner"
    choco install ccleaner -y
  
    # Install office manually
    # Selenium Drivers?
}

function Install-Chocolatey {
    if (-Not(Get-Command "choco" -ErrorAction SilentlyContinue)) {
        Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) 4>&1 >> ./log.txt
    }
}

function Install-WinRM {
    reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f
    
    Set-NetConnectionProfile -NetworkCategory Private
    Enable-PSRemoting
    # winrm quickconfig
}

function Install-StandardTools {
    Write-Host "Chocolatey Extensions"
    choco install chocolatey-core.extension -y --limit-output
    Write-Host "Choco GUI"
    choco install chocolateygui -y --limit-output
    Write-Host "Paint.NET"
    choco install paint.net -y --limit-output
    Write-Host "7zip"
    choco install 7zip -y --limit-output
    Write-Host "Microsoft Teams"
    choco install microsoft-teams -y --limit-output
    Write-Host "Adobe Reader"
    choco install adobereader -y --limit-output
    Write-Host "PDF Split and Merge"
    choco install pdfsam -y --limit-output
    Write-Host "Slack"
    choco install slack -y --limit-output
    Write-Host "Remote Desktop Manager Free"
    choco install rdmfree -y --limit-output
    Write-Host "Zoom"
    choco install zoom -y --limit-output
    Write-Host "SysInternals"
    choco install sysinternals -y --limit-output
    Write-Host "CCleaner"
    choco install ccleaner -y --limit-output
    Write-Host "Windirstat"
    choco install windirstat -y --limit-output
    Write-Host "FiraCode Font"
    choco install firacode -y --limit-output
    Write-Host "Console Emulator" 
    choco install conemu -y --limit-output
    Write-Host "JRE 8"
    choco install jre8 -y --limit-output
    Write-Host "OpenSSH"
    choco install openssh -y --limit-output
    Write-Host "OpenSSL"
    choco install openssl.light -y --limit-output
    Write-Host "Autohotkey"
    choco install autohotkey -y --limit-output
    Write-Host "Autoruns"
    choco install autoruns -y --limit-output
    Write-Host "CURL"
    choco install curl -y --limit-output
    Write-Host "Wireshark"
    choco install wireshark -y --limit-output
    Write-Host "Windows Terminal"
    choco install microsoft-windows-terminal -y --limit-output
    #Write-Host "Windows 10 Power Toys"
    #choco install powertoys -y --limit-output
}

function Install-DevOpsTools {
    Write-Host "Docker Desktop"
    choco install docker-desktop -y --limit-output
    Write-Host "Helm - https://github.com/helm/helm"
    choco install kubernetes-helm -y --limit-output
    Write-Host "Vagrant"
    choco install vagrant -y --limit-output
    Write-Host "Redis 64"
    choco install redis-64 -y --limit-output
    Write-Host "Installing Go"
    Install-AppGo
    Write-Host "Terraform"
    choco install terraform -y --limit-output
    Write-Host "-- Installing terraform providers"
    Install-Terraform-Providers
    Write-Host "Kubernetes CLI"
    choco install kubernetes-cli -y --limit-output
    Write-Host "Minikube"
    choco install minikube -y --limit-output
}

function Install-Beats
{
    # Write-Host "Metric Beat"
    # choco install metricbeat -y --limit-output
    
    # Write-Host "WinLog Beat"
    # choco install winlogbeat -y --limit-output

    # Write-Host "File Beat"
    # choco install filebeat -y --limit-output

    # Write-Host "Audit Beat"
    # choco install auditbeat -y --limit-output

    # Write-Host "Packet Beat"
    # choco install packetbeat -y --limit-output
}

function Install-ELK {
    # choco install elasticsearch -y --limit-output
    # choco install logstash -y --limit-output
    # choco install kibana -y --limit-output
    # choco install grafana -y --limit-output
}

function Install-AppGo {
    Write-Host "Go Lang"

    Set-EnvironmentVariable -VariableName "GOROOT" -Value "$env:SystemDrive\Tools\go" -Target "Machine" -Append $false
    Set-EnvironmentVariable -VariableName "GOPATH" -Value "$env:UserProfile\go" -Target "Machine" -Append $false

    $installDir = "$env:SystemDrive\Tools\go";
    choco install golang -y --limit-output --installArgs "TARGETDIR=`"`"$installDir`"`" INSTALLDIR=`"`"$installDir`"`""

    Set-EnvironmentVariable -VariableName "Path" -Value "$env:SystemDrive\Tools\go\bin" -Target "Machine" -Append $true

    Refresh-Environment

    go get -v github.com/go-delve/delve/cmd/dlv
    go get -u -v github.com/ramya-rao-a/go-outline
    go get -v github.com/rogpeppe/godef
}

function Install-Terraform-Providers {

    #Install-Git-TerraformProvider -Url "https://github.com/taliesins/terraform-provider-hyperv"

    #Install-Git-TerraformProvider -Url "https://dev.azure.com/DaikinIT/hashicorp-plugins/_git/terraform.git" `
    #    -PackageName "terraform-provider-hyperv.exe" 
}

function Install-Git-TerraformProvider {
    Param(
        [Parameter(Mandatory = $true)]
        [uri]
        $Url,

        [Parameter(Mandatory = $false)]
        [string]
        $PluginPath = $null,

        [Parameter(Mandatory = $false)]
        [string]
        $PackageName = $null,

        [Parameter(Mandatory = $false)]
        [string]
        $CommitId = $null
    )

    $gitHubLoc = $Url.Authority + $Url.PathAndQuery
    Write-Host "-- Install $Url"
    Write-Host "-- Git Loc: $gitHubLoc"

    $goGitPath = "$env:GOPATH\src\$gitHubLoc"
    
    # Cleanup
    # if (Test-Path $goGitPath) {
    #     Remove-Item -Path $goGitPath -Recurse -Force
    # }

    Write-Host "go get -u $gitHubLoc"
    cmd /c "go get -u $gitHubLoc"

    $curLoc = Get-Location
    Set-Location -Path $goGitPath

    if (-Not([string]::IsNullOrEmpty($CommitId))) {
        Write-Host "Loading Commit: $CommitId"
        #cmd /c "git fetch origin master"
        #cmd /c "git checkout $CommitId"
        #cmd /c "git reset --hard $CommitId"
        #cmd /c "git clean -df"
    }

    if (-Not([string]::IsNullOrWhiteSpace($PluginPath))) {
        $gitHubLoc += "$PluginPath";
    }

    $goBuildCmd = "go build";
    $builtObject = $Url.Segments[$Url.Segments.Count - 1] + ".exe";

    if (-Not([string]::IsNullOrEmpty($PackageName))) {
        $goBuildCmd = "go build -o $PackageName";
        $builtObject = $PackageName
    }

    Write-Host $goBuildCmd
    cmd /c $goBuildCmd

    if (-Not([string]::IsNullOrEmpty($PackageName))) {
        Write-Host "Renaming package to $PackageName"
        Rename-Item -Path "$builtObject" -NewName "$PackageName"
        $builtObject = $PackageName
    }

    if (Test-Path $env:APPDATA\terraform.d\plugins\$builtObject) {
        Remove-Item -Path $env:APPDATA\terraform.d\plugins\$builtObject -Recurse -Force
    }

    Write-Host "-- Object Built: $builtObject"
    Copy-Item -Path "$builtObject" -Destination "$env:APPDATA\terraform.d\plugins\$builtObject"
    
    Remove-Item -Path $builtObject

    Set-Location $curLoc
}

function Install-WebDevelopmentTools {
    Write-Host "Postman"
    choco install postman -y --limit-output
    Write-Host "Fiddler"
    choco install fiddler -y --limit-output
    Write-Host "MITMProxy"
    choco install mitmproxy -y --limit-output
}

function Install-WindowsFeatures {
    Write-Host "IIS"
    choco install IIS-WebServer --source windowsfeatures -y --limit-output
    choco install IIS-WebServerManagementTools --source windowsfeatures -y --limit-output
    choco install IIS-WebServerRole --source windowsfeatures -y --limit-output
    choco install IIS-HttpErrors --source windowsfeatures -y --limit-output
    choco install IIS-HttpLogging --source windowsfeatures -y --limit-output
    choco install IIS-HttpRedirect --source windowsfeatures -y --limit-output
    choco install IIS-HttpTracing --source windowsfeatures -y --limit-output
    choco install IIS-ISAPIExtensions --source windowsfeatures -y --limit-output
    choco install IIS-ISAPIFilter --source windowsfeatures -y --limit-output
    choco install IIS-LoggingLibraries --source windowsfeatures -y --limit-output
    choco install IIS-ManagementConsole --source windowsfeatures -y --limit-output
    choco install IIS-ManagementScriptingTools --source windowsfeatures -y --limit-output
    choco install IIS-ManagementService --source windowsfeatures -y --limit-output
    choco install IIS-NetFxExtensibility --source windowsfeatures -y --limit-output
    choco install IIS-NetFxExtensibility45 --source windowsfeatures -y --limit-output
    choco install IIS-Performance --source windowsfeatures -y --limit-output
    choco install IIS-RequestFiltering --source windowsfeatures -y --limit-output
    choco install IIS-RequestMonitor --source windowsfeatures -y --limit-output
    choco install IIS-Security --source windowsfeatures -y --limit-output
    choco install IIS-StaticContent --source windowsfeatures -y --limit-output
    choco install IIS-URLAuthorization --source windowsfeatures -y --limit-output
    choco install IIS-WebSockets --source windowsfeatures -y --limit-output
    choco install IIS-WindowsAuthentication --source windowsfeatures -y --limit-output
    choco install WCF-HTTP-Activation --source windowsfeatures -y --limit-output
    choco install WCF-HTTP-Activation45 --source windowsfeatures -y --limit-output
    choco install WCF-Services45 --source windowsfeatures -y --limit-output
    choco install WCF-TCP-PortSharing45 --source windowsfeatures -y --limit-output

    Write-Host "Hyper-V"
    choco install Microsoft-Hyper-V --source windowsfeatures -y --limit-output
    choco install Microsoft-Hyper-V-All --source windowsfeatures -y --limit-output
    choco install Microsoft-Hyper-V-Hypervisor --source windowsfeatures -y --limit-output
    choco install Microsoft-Hyper-V-Management-Clients --source windowsfeatures -y --limit-output
    choco install Microsoft-Hyper-V-Management-PowerShell --source windowsfeatures -y --limit-output
    choco install Microsoft-Hyper-V-Services --source windowsfeatures -y --limit-output
    choco install Microsoft-Hyper-V-Tools-All --source windowsfeatures -y --limit-output

    Write-Host "Dot Net 3 & 4, ASP .NET 4.5"
    choco install Microsoft-Windows-Client-EmbeddedExp-Package --source windowsfeatures -y --limit-output
    choco install Microsoft-Windows-NetFx3-OC-Package --source windowsfeatures -y --limit-output
    choco install Microsoft-Windows-NetFx3-WCF-OC-Package --source windowsfeatures -y --limit-output
    choco install Microsoft-Windows-NetFx4-US-OC-Package --source windowsfeatures -y --limit-output
    choco install Microsoft-Windows-NetFx4-WCF-US-OC-Package --source windowsfeatures -y --limit-output
    choco install Microsoft-Windows-NetFx-VCRedist-Package --source windowsfeatures -y --limit-output
    choco install NetFx3 --source windowsfeatures -y --limit-output
    choco install NetFx4-AdvSrvs --source windowsfeatures -y --limit-output
    choco install NetFx4Extended-ASPNET45 --source windowsfeatures -y --limit-output

    Write-Host "Powershell"
    choco install MicrosoftWindowsPowerShellV2 --source windowsfeatures -y --limit-output
    choco install MicrosoftWindowsPowerShellV2Root --source windowsfeatures -y --limit-output

    Write-Host "Windows PDF/XPS Printing"
    choco install Microsoft-Windows-Printing-PrintToPDFServices-Package --source windowsfeatures -y --limit-output
    choco install Microsoft-Windows-Printing-XPSServices-Package --source windowsfeatures -y --limit-output
    choco install Printing-Foundation-Features --source windowsfeatures -y --limit-output
    choco install Printing-Foundation-InternetPrinting-Client --source windowsfeatures -y --limit-output
    choco install Printing-PrintToPDFServices-Features --source windowsfeatures -y --limit-output
    choco install Printing-XPSServices-Features --source windowsfeatures -y --limit-output

    Write-Host "Linux Subsystem on Windows"
    choco install Microsoft-Windows-Subsystem-Linux --source windowsfeatures -y --limit-output
    choco install MSRDC-Infrastructure --source windowsfeatures -y --limit-output


    choco install SearchEngine-Client-Package --source windowsfeatures -y --limit-output
    choco install SmbDirect --source windowsfeatures -y --limit-output

    Write-Host "Tools - Telnet"
    choco install TelnetClient --source windowsfeatures -y --limit-output
    choco install TFTP --source windowsfeatures -y --limit-output

    Write-Host "Windows Identity Foundation"
    choco install Windows-Identity-Foundation --source windowsfeatures -y --limit-output

    Write-Host "Windows Misc Additions"
    choco install WindowsMediaPlayer --source windowsfeatures -y --limit-output
    choco install WorkFolders-Client --source windowsfeatures -y --limit-output
    choco install Internet-Explorer-Optional-amd64 --source windowsfeatures -y --limit-output
    choco install MediaPlayback --source windowsfeatures -y --limit-output

    Write-Host "URL Rewrite"
    choco install urlrewrite -y --limit-output
}

function Install-WindowsAdminTools {
    Write-Host "Remote Server Administration Tools"
    choco install rsat -params '"/AD /GP /SM /DNS"' -y --limit-output

    Write-Host "Windows 10 SDK"
    choco install windows-sdk-10.1 -y --limit-output
}

function Install-LdapTools {
    Write-Host "Apache Directory Studio"
    choco install apache-directory-studio -y --limit-output
}

function Install-WebBrowsers {
    Write-Host "Chrome"
    choco install googlechrome -y --limit-output --ignorechecksum # Chrome checksum is a problem
    Write-Host "Firefox"
    choco install firefox -y --limit-output
    Write-Host "Brave"
    choco install brave -y --limit-output
    Write-Host "Edge"
    choco install microsoft-edge -y --limit-output
}

function Install-FtpAndSshTools {
    Write-Host "Putty"
    choco install putty -y --limit-output
    Write-Host "WinSCP"
    choco install winscp -y --limit-output
}

function Install-SourceControl {
    Write-Host "Git"
    choco install git -y --limit-output
    Write-Host "GitHub Desktop"
    choco install github-desktop -y --limit-output

    # TODO:  Team Explorer?
}

function Install-NodeDevelopment {
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("NVM", "Node")]
        $Environment
    ) 

    switch ($Environment) {
        "NVM" {
            Write-Host "NVM for NodeJS - Node Version Management"
            choco install nvm -y --limit-output

            Refresh-Environment
            
            nvm install latest

            $firstNodeVersion = Start-ProcessForOutput -Command "nvm" -Arguments "list"
            Write-Host "nvm use $firstNodeVersion"
            Start-ProcessForOutput -Command "nvm" -Arguments "use $firstNodeVersion"
        }
        "Node" {
            Write-Host "NodeJS"
            choco install nodejs -y --limit-output
        }
    }

    Write-Host "Yarn"
    choco install yarn -y --limit-output
}

function Install-MsSqlDevelopment {
    Write-Host "SQL Server Management Studio"
    choco install sql-server-management-studio -y --limit-output
}

function Install-MySqlDevelopment {
    Write-Host "MySQL Workbench"
    choco install mysql.workbench -y --limit-output
}

function Install-VSCodeDevelopment {
    Param(
        [Parameter(Mandatory = $true)]
        [string[]]
        [ValidateSet("VSCode", "VSCodeInsiders")]
        $Environments
    )

    foreach ($env in $Environments) {
        switch ($env) {
            "VSCode" {
                choco install vscode -y --limit-output
            }
            "VSCodeInsiders" {
                choco install vscode-insiders -y --limit-output
            }
        }
    }
}
function Install-DotNetDevelopment {
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("VS2017Pro", "VS2017Enterprise", "VS2019Pro", "VS2019Enterprise")]
        [string[]]
        $Environments
    )

    Write-Host "Nuget Command Line"
    choco install nuget.commandline -y --limit-output
    Write-Host "NetFX 4.5.2"
    choco install netfx-4.5.2-devpack -y --limit-output
    Write-Host "NetFX 4.6.2"
    choco install netfx-4.6.2-devpack -y --limit-output
    Write-Host "NetFX 4.7.1"
    choco install netfx-4.7.1-devpack -y --limit-output
    Write-Host "DotNetCore SDK"
    choco install dotnetcore-sdk -y --limit-output # VS 2019 Latest
    Write-Host "DotNetCore IIS Hosting"
    choco install dotnetcore-windowshosting -y --limit-output
    Write-Host "Powershell Core"
    choco install powershell-core -y --limit-output

    foreach ($env in $Environments) {
        Switch ($env) {
            "VS2017Pro" {
                Write-Host "DotNetCore 2.1.700"
                choco install dotnetcore-sdk --limit-output --allow-downgrade --version 2.1.700 -y # VS 2017 2.1
                Write-Host "DotNetCore 2.2.107"
                choco install dotnetcore-sdk --limit-output --allow-downgrade --version 2.2.107 -y # VS 2017 2.2
                Write-Host "Visual Studio 2017 Pro"
                choco install visualstudio2017pro --limit-output --package-parameters "--includeRecommended  --passive --locale en-US" -y --execution-timeout 99999
                Write-Host "Visual Studio 2017 SSDT"
                choco install visualstudio2017sql --limit-output --package-parameters "--includeRecommended --passive --locale en-US" -y --execution-timeout 99999                
            }
            "VS2017Enterprise" {
                Write-Host "DotNetCore 2.1.700"
                choco install dotnetcore-sdk --limit-output --allow-downgrade --version 2.1.700 -y # VS 2017 2.1
                Write-Host "DotNetCore 2.2.107"
                choco install dotnetcore-sdk --limit-output --allow-downgrade --version 2.2.107 -y # VS 2017 2.2
                Write-Host "Visual Studio 2017 Enterprise"
                choco install visualstudio2017enterprise --limit-output --package-parameters "--includeRecommended  --passive --locale en-US" -y --execution-timeout 99999
                Write-Host "Visual Studio 2017 SSDT"
                choco install visualstudio2017sql --limit-output --package-parameters "--includeRecommended --passive --locale en-US" -y --execution-timeout 99999
            }
            "VS2019Enterprise" {
                Write-Host "Visual Studio 2019 Enterprise"
                choco install visualstudio2019enterprise --limit-output --package-parameters "--includeRecommended --passive --locale en-US" -y --execution-timeout 99999
            }
            "VS2019Pro" {
                Write-Host "Visual Studio 2019 Enterprise"
                choco install visualstudio2019professional --limit-output --package-parameters "--includeRecommended --passive --locale en-US" -y --execution-timeout 99999
            }
        }
    }

    Write-Host "Installing Visual Studio Extensions"
    # TODO:  Handle 2019 vs 2017
    Install-VisualStudioExtras
}

function Install-VisualStudioExtras {
    #Write-Host "Resharper"
    #choco install resharper -y --limit-output
    Write-Host "DotPeek"
    choco install dotpeek -y --limit-output
    Write-Host "SonarLint"
    choco install sonarlint-vs2017 -y --limit-output
    choco install sonarlint-vs2019 -y --limit-output
    Write-Host "Codemaid"
    choco install codemaid -y --limit-output --package-parameters "/q"
}

function Install-JavaDevelopment {
    Write-Host "JDK 8"
    choco install jdk8 -y --limit-output

    Write-Host "Eclipse"
    choco install eclipse -y --limit-output
}

function Install-AndroidDevelopment {
    Install-JavaDevelopment

    Write-Host "Android Studio"
    choco install androidstudio -y --limit-output

    Write-Host "Android SDK"
    choco install android-sdk -y

    Write-Host "Android Debug Bridge"
    choco install adb -y
}

function Install-MongoDBDevelopment {
    Write-Host "MongoDB"
    choco install mongodb -y --limit-output
    choco install robo3t -y --limit-output
}

function Install-Analytics {
    Write-Host "R Studio"
    choco install r.studio -y --limit-output
}

function Install-Python {
    Write-Host "Python Latest"
    choco install python -y --limit-output
    Write-Host "Python 2"
    choco install python2 -y --limit-output 

}

function Install-AzureDevelopment {
    Write-Host "Azure CLI"
    choco install azure-cli -y --limit-output
    Write-Host "Azure Powershell"
    choco install azurepowershell -y --limit-output
}

function Install-AwsDevelopment {
    Write-Host "AWS CLI"
    choco install awscli -y --limit-output
    Write-Host "AWS Tools for Powershell"
    choco install awstools.powershell -y --limit-output
    Write-Host "AWS EKS (Kubernetes) Control"
    chocolatey install -y --limit-output eksctl aws-iam-authenticator
}