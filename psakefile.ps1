Properties{
    $SourceFolder = [System.IO.DirectoryInfo](join-path $psake.build_script_dir "Source")
    $ModuleName = gci $psake.build_script_dir '*.psm1'|select -ExpandProperty basename
    $Date = [datetime]::Now
    $Version = [version]"0.$($Date.ToString("yyMM")).1"
}

task default -depends CreateManifest,test

task updateSource -depends DownloadSource,test
#DownloadSource,Test,

task test{
    ipmo (join-path $psake.build_script_dir "$ModuleName.psd1") -Force
    Invoke-Pester -Script $psake.build_script_dir
}

task DownloadSource -preaction {
    #devlock file is used to force the module to download files firectoy to the module folder.
    new-item -Path $psake.build_script_dir -Name "dev.lock" -ItemType File -Force|Out-Null
} -action {
    ipmo (join-path $psake.build_script_dir "$ModuleName.psd1")  -Force
    Update-UnicodeData
} -postaction {
    gci $psake.build_script_dir -Filter "dev.lock"|Remove-Item
}

task replaceVariableScope{
    #replace $global: with $script:
    # gci $ps
}

task CreateManifest{
    $OfficialVersion = Find-Module $ModuleName
    $ClassFiles = gci (join-path $psake.build_script_dir "code") -Filter "*.class.ps1" -Recurse
    $ExportCmdlets = get-command -Module unicode|?{$_.ScriptBlock.file -like "*/public/*"}

    $param = @{
        Path =  Join-Path $psake.build_script_dir "$ModuleName.psd1"
        Guid = "fef3998b-235d-40e9-8998-9750ada1a938"
        Author = 'Philip Meholm/Withholm'
        CompanyName = 'Witholm'
        Copyright = '(c) Philip Meholm/Withholm. All rights reserved.'
        Description = 'Gets information on unicode characters'
        # ScriptsToProcess = $ClassFiles|%{$_.FullName.Replace($psake.build_script_dir,"")}|%{$_.substring(1)}
        RootModule = "$ModuleName.psm1"
        ModuleVersion = $Version
        FunctionsToExport = $ExportCmdlets
        # ModuleList = $ClassFiles.BaseName
    }
    Write-host "exporting to '$($param.path)'"
    New-ModuleManifest @param

    Write-host "Testing import of module '$ModuleName'"
    ipmo $($param.path) -Force -ErrorAction Stop
    $module = get-module $ModuleName
    if($module)
    {
        Write-host "module loaded"
    }
    else {
        Throw "Module '$modulename' did not load"
    }

    Write-Host "Removing module '$modulename'"
    $module|remove-module

    if($module|Get-Module)
    {
        Throw "Main module not unloaded"
    }
    if($module.ModuleList)
    {
        foreach($mod in $module.ModuleList)
        {
            get-module
            if(get-module $mod.name)
            {
                Throw "Did not unload sub module '$($mod.name)'"
            }
        }
    }
}