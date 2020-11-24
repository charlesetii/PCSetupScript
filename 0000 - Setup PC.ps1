Import-Module $PSScriptRoot\Modules\Common-Functions.psm1 -WarningAction SilentlyContinue
Import-Module $PSScriptRoot\Modules\Base-Windows-Functions.psm1 -WarningAction SilentlyContinue
Import-Module $PSScriptRoot\Modules\Setup-Box-Functions.psm1 -WarningAction SilentlyContinue
Import-Module $PSScriptRoot\Modules\Npm-Functions.psm1 -WarningAction SilentlyContinue
Import-Module $PSScriptRoot\Modules\VSCode-Functions.psm1 -WarningAction SilentlyContinue

function Begin-Install() {
    $config = Ask-ForConfig

    Write-Host "`n############# Installing Windows Updates"
    wuauclt.exe /updatenow

    # Clear log
    Write-Host "`n############# Clearing ./log.txt"
    Clear-Content ./log.txt

    Write-Host "`n############# Installing Chocolatey"
    Install-Chocolatey 4>&1 >> ./log.txt


    foreach ($key in $config.keys) {
        $question = $config[$key];

        if ($question.value -ne "y") {
            continue;
        }

        switch ($key) {
            "setupExplorer" {
                Write-Host "`n############# Setting up Windows Explorer"
                Initialize-Windows
            }
            "installStandard" {
                Write-Host "`n############# Installing Standard Tools"
                Install-StandardTools 4>&1 >> ./log.txt

                Write-Host "`n############# Installing Windows Admin Tools"
                Install-WindowsAdminTools 4>&1 >> ./log.txt
            
                Write-Host "`n############# Installing LDAP Tools"
                Install-LdapTools 4>&1 >> ./log.txt

                Write-Host "`n############# Installing FTP (WinSCP) and SSH"
                Install-FtpAndSshTools 4>&1 >> ./log.txt
            
                Write-Host "`n############# Installing Source Control Tools"
                Install-SourceControl 4>&1 >> ./log.txt
            
                Write-Host "`n############# Installing Web Development / Proxy Tools"
                Install-WebDevelopmentTools 4>&1 >> ./log.txt
            }
            "installBrowsers" {
                Write-Host "`n############# Installing Web Browsers"
                Install-WebBrowsers 4>&1 >> ./log.txt
            }
            "installIIS" {
                Write-Host "`n############# Installing Windows Features"
                Install-WindowsFeatures 4>&1 >> ./log.txt
            }
            "javaDev" {
                Write-Host "`n############# Installing Java Development Tools"
                Install-JavaDevelopment 4>&1 >> ./log.txt
            }
            "mssqlDev" {
                Write-Host "`n############# Installing MSSQL Development Tools"
                Install-MsSqlDevelopment 4>&1 >> ./log.txt
            }
            "mysqlDev" {
                Write-Host "`n############# Installing MySQL Development"
            }
            "mongoDev" {
                Write-Host "`n############# Installing Mongo Development Tools"
                Install-MongoDBDevelopment 4>&1 >> ./log.txt
            }
            "nodeDev" {
                Write-Host "`n############# Installing Node Development Tools"
                Install-NodeDevelopment -Environment NVM 4>&1 >> ./log.txt
                Write-Host "`n############# Installing Node Global Packages"
                Setup-NodeDevelopmentGlobalPackages 3>&1 4>&1 >> ./log.txt
            }
            "vsCode" {
                Write-Host "`n############# Installing VSCode";

                if ($null -ne $question["children"]) {
                    foreach ($key in $question["children"].keys) {
                        $subQuestion = $question["children"][$key];
                        $subQuestionValue = $subQuestion["value"];

                        switch ($key) {
                            "vscodeInsiders" {
                                if ($subQuestionValue.ToLower() -eq "y") {
                                    Write-Host "-- VS Code Insiders"
                                    Install-VSCodeDevelopment  -Environments VSCodeInsiders 4>&1 >> ./log.txt
                                    Write-Host "-- VS Code Insiders Extensions"
                                    Setup-VSCodeExtensions -Environment VSCodeInsiders 4>&1 >> ./log.txt
                                }
                                else {
                                    Write-Host "-- VS Code"
                                    Install-VSCodeDevelopment -Environments VSCode 4>&1 >> ./log.txt
                                    Write-Host "-- VS Code Extensions"
                                    Setup-VSCodeExtensions -Environment VSCode 4>&1 >> ./log.txt
                                }
                            }
                        }
                    }
                }
            }
            "netDev" {
                Write-Host "`n############# Installing .NET Development";

                if ($null -ne $question["children"]) {
                    foreach ($key in $question["children"].keys) {
                        $subQuestion = $question["children"][$key];
                        $subQuestionValue = $subQuestion["value"];

                        switch ($key) {
                            "vsEnt" {
                                if ($subQuestionValue.ToLower() -eq "y") {
                                    Write-Host "-- 2017/2019 Enterprise"
                                    Install-DotNetDevelopment -Environments VS2017Enterprise, VS2019Enterprise 4>&1 >> ./log.txt
                                }
                                else {
                                    Write-Host "-- 2017/2019 Professional"
                                    Install-DotNetDevelopment -Environments VS2017Pro, VS2019Pro 4>&1 >> ./log.txt
                                }
                            }
                        }
                    }
                }
            }
            "androidDev" {
                Write-Host "`n############# Installing Android Development Tools"
                Install-AndroidDevelopment 4>&1 >> ./log.txt
            }
            "awsDev" {
                Write-Host "`n############# Installing AWS Development Tools"
                Install-AwsDevelopment 4>&1 >> ./log.txt
            }
            "devOpsDev" {
                Write-Host "`n############# Installing DevOps Development Tools"
                Install-DevOpsTools 4>&1 >> ./log.txt
            }
            "analyticsDev" {
                Write-Host "`n############# Installing Analytics Development Tools"
                Install-Analytics 4>&1 >> ./log.txt
            }
            "personalMachine" {
                Write-Host "`n############# Installing Personal Tools"
                Install-MiscApps 4>&1 >> ./log.txt
            }
            "winRMSetup" {
                Write-Host "`n############# Setting up Remote Dev User";
                if ($null -ne $question["children"]) {
                    foreach ($key in $question["children"].keys) {
                        $subQuestion = $question["children"][$key];
                        $subQuestionValue = $subQuestion["value"];

                        switch ($key) {
                            "remoteDev" {
                                $pass = ConvertTo-SecureString $subQuestion["value"] -AsPlainText -Force
                                New-LocalUser -Name "RemoteDev" `
                                    -Password $pass `
                                    -FullName "Remote Dev" `
                                    -Description "Used for WinRM fun"
                
                                Add-LocalGroupMember -Group "Administrators" -Member "RemoteDev"

                                Set-NetConnectionProfile -NetworkCategory Private
                                Enable-PSRemoting
                            }
                        }
                    }
                }
            }
            "azureDev" {
                Write-Host "`n############# Setting up Azure Dev";
                Install-AzureDevelopment
            }
            "beats" {
                Write-Host "`n############# Setting up Beats";
                Install-Beats
            }
        }
    }
}


function Ask-ForConfig() {
    $questions = [ordered]@{
        setupExplorer   = @{ question = 'Setup Windows Explorer'; value = $null; };
        installStandard = @{ question = 'Install standard tools'; value = $null; };
        installBrowsers = @{ question = 'Install browsers'; value = $null; };
        installIIS      = @{ question = 'Install IIS?'; value = $null; };
        javaDev         = @{ question = 'Are you a java developer'; value = $null; };
        mysqlDev        = @{ question = 'Are you a MySQL developer'; value = $null; };
        mssqlDev        = @{ question = 'Are you a MSSQL developer'; value = $null; };
        mongoDev        = @{ question = 'Are you a mongoDB developer'; value = $null; };
        nodeDev         = @{ question = 'Are you a node developer'; value = $null; };
        netDev          = @{ 
            question = 'Are you a .NET developer'; 
            value    = $null; 
            children = [ordered]@{
                vsEnt = @{ question = '-- Install Visual Studio Enterprise'; value = $null };
                
            }
        };
        vsCode          = @{
            question = 'Do you use VS Code';
            value    = $null;
            children = [ordered]@{
                vscodeInsiders = @{ question = '-- Install VSCode Insiders'; value = $null };
            }
        }
        androidDev      = @{ question = 'Are you an Android developer'; value = $null; };
        awsDev          = @{ question = 'Are you an AWS developer'; value = $null; };
        azureDev        = @{ question = 'Are you an azure developer'; value = $null };
        devOpsDev       = @{ question = 'Do you use DevOps'; value = $null; };
        analyticsDev    = @{ question = 'Do you use Analytics (R)'; value = $null; };
        beats           = @{ question = 'Install elastic beats'; value = $null; };
        winRMSetup      = @{ 
            question = 'Enable remote powershell (for devops)'; 
            value    = $null;
            children = [ordered]@{
                remoteDev = @{ 
                    question = 'Creating a RemoteDev User, please enter password: '; 
                    value    = $null; 
                    secure   = $true ;
                }
            };
        };
        personalMachine = @{ question = 'Are you a personal machine'; value = $null; };
    }

    Write-Host "#-#-#-#-# Getting Configuration #-#-#-#-#"
    foreach ($question in $questions.Values) {
        Read-QuestionInput -Question $question

        if (($question["value"].ToLower() -eq "y") -and ($null -ne $question["children"])) {
            foreach ($subQuestion in $question["children"].Values) {
                Read-QuestionInput -Question $subQuestion
            }
        }
    }
    
    return $questions
}

function Read-QuestionInput {
    Param(
        [Parameter(Mandatory = $true)]
        [hashtable]
        $Question
    )

    $prompt = $question['question'];

    if ($Question["secure"]) {
        $Question["value"] = Read-Host -AsSecureString
    }
    else {
        $Question["value"] = Read-Host -Prompt "$prompt (y/N)?"
    }
}


## Main
Begin-Install
Write-Host " ## Install Complete - Log at ./log.txt ##"