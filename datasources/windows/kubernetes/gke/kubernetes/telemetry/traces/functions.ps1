#################################################################################################################################
################################################## WINDOWS Traces Functions #####################################################
#################################################################################################################################

# Gets Logz.io traces token
# Input:
#   ---
# Output:
#   TracesToken - Logz.io traces token
function Get-LogzioTracesToken {
    $local:ExitCode = 1
    $local:FuncName = $MyInvocation.MyCommand.Name

    $local:Message = 'Getting Logz.io traces token ...'
    Send-LogToLogzio $script:LogLevelDebug $Message $script:LogStepTraces $script:LogScriptTraces $FuncName $script:AgentId $script:Platform $script:Subtype $script:CurrentDataSource
    Write-Log $script:LogLevelDebug $Message

    $local:Err = Get-JsonFileFieldValue $script:AgentJson '.shippingTokens.TRACING'
    if ($Err.Count -ne 0) {
        $Message = "traces.ps1 ($ExitCode): $($Err[0])"
        Send-LogToLogzio $script:LogLevelError $Message $script:LogStepTraces $script:LogScriptTraces $FuncName $script:AgentId $script:Platform $script:Subtype $script:CurrentDataSource
        Write-TaskPostRun "Write-Error `"$Message`""

        return $ExitCode
    }
    
    $local:ShippingToken = $script:JsonValue

    $Message = "Logz.io traces token is '$ShippingToken'"
    Send-LogToLogzio $script:LogLevelDebug $Message $script:LogStepTraces $script:LogScriptTraces $FuncName $script:AgentId $script:Platform $script:Subtype $script:CurrentDataSource
    Write-Log $script:LogLevelDebug $Message

    Write-TaskPostRun "`$script:TracesToken = '$ShippingToken'"
}

# Builds enable traces Helm set
# Input:
#   ---
# Output:
#   LogHelmSets - Containt all the Helm sets for logging
#   HelmSets - Contains all the Helm sets
function Build-EnableTracesHelmSet {
    $local:FuncName = $MyInvocation.MyCommand.Name

    $local:Message = 'Building enable traces Helm set ...'
    Send-LogToLogzio $script:LogLevelDebug $Message $script:LogStepTraces $script:LogScriptTraces $FuncName $script:AgentId $script:Platform $script:Subtype $script:CurrentDataSource
    Write-Log $script:LogLevelDebug $Message

    $local:HelmSet = " --set logzio-k8s-telemetry.traces.enabled=true"

    $local:Message = "Enable traces Helm set is '$HelmSet'"
    Send-LogToLogzio $script:LogLevelDebug $Message $script:LogStepTraces $script:LogScriptTraces $FuncName $script:AgentId $script:Platform $script:Subtype $script:CurrentDataSource
    Write-Log $script:LogLevelDebug $Message

    Write-TaskPostRun "`$script:LogHelmSets += '$HelmSet'"
    Write-TaskPostRun "`$script:HelmSets += '$HelmSet'"
}

# Builds Logz.io traces token Helm set
# Input:
#   FuncArgs - Hashtable {TracesToken = $script:TracesToken}
# Output:
#   LogHelmSets - Containt all the Helm sets for logging
#   HelmSets - Contains all the Helm sets
function Build-LogzioTracesTokenHelmSet {
    param (
        [hashtable]$FuncArgs
    )

    $local:ExitCode = 2
    $local:FuncName = $MyInvocation.MyCommand.Name

    $local:Message = 'Building Logz.io traces token Helm set ...'
    Send-LogToLogzio $script:LogLevelDebug $Message $script:LogStepTraces $script:LogScriptTraces $FuncName $script:AgentId $script:Platform $script:Subtype $script:CurrentDataSource
    Write-Log $script:LogLevelDebug $Message

    $local:Err = Test-AreFuncArgsExist $FuncArgs @('TracesToken')
    if ($Err.Count -ne 0) {
        $Message = "traces.ps1 ($ExitCode): $($Err[0])"
        Send-LogToLogzio $script:LogLevelError $Message $script:LogStepTraces $script:LogScriptTraces $FuncName $script:AgentId $script:Platform $script:Subtype $script:CurrentDataSource
        Write-TaskPostRun "Write-Error `"$Message`""

        return $ExitCode
    }

    $local:TracesToken = $FuncArgs.TracesToken
    
    $local:HelmSet = " --set logzio-k8s-telemetry.secrets.TracesToken=$TracesToken"

    $local:Message = "Logz.io traces token Helm set is '$HelmSet'"
    Send-LogToLogzio $script:LogLevelDebug $Message $script:LogStepTraces $script:LogScriptTraces $FuncName $script:AgentId $script:Platform $script:Subtype $script:CurrentDataSource
    Write-Log $script:LogLevelDebug $Message

    Write-TaskPostRun "`$script:LogHelmSets += '$HelmSet'"
    Write-TaskPostRun "`$script:HelmSets += '$HelmSet'"
}

# Builds Logz.io region Helm set
# Input:
#   FuncArgs - Hashtable {ListenerUrl = $script:ListenerUrl}
# Output:
#   HelmSets - Contains all the Helm sets
function Build-LogzioRegionHelmSet {
    param (
        [hashtable]$FuncArgs
    )

    $local:ExitCode = 3
    $local:FuncName = $MyInvocation.MyCommand.Name

    $local:Message = 'Building Logz.io region Helm set ...'
    Send-LogToLogzio $script:LogLevelDebug $Message $script:LogStepTraces $script:LogScriptTraces $FuncName $script:AgentId $script:Platform $script:Subtype $script:CurrentDataSource
    Write-Log $script:LogLevelDebug $Message

    $local:Err = Test-AreFuncArgsExist $FuncArgs @('ListenerUrl')
    if ($Err.Count -ne 0) {
        $Message = "traces.ps1 ($ExitCode): $($Err[0])"
        Send-LogToLogzio $script:LogLevelError $Message $script:LogStepTraces $script:LogScriptTraces $FuncName $script:AgentId $script:Platform $script:Subtype $script:CurrentDataSource
        Write-TaskPostRun "Write-Error `"$Message`""

        return $ExitCode
    }

    $local:ListenerUrl = $FuncArgs.ListenerUrl

    $local:Region = Get-LogzioRegion $ListenerUrl

    $Message = "Logz.io region is '$LogzioRegion'"
    Send-LogToLogzio $script:LogLevelDebug $Message $script:LogStepTraces $script:LogScriptTraces $FuncName $script:AgentId $script:Platform $script:Subtype $script:CurrentDataSource
    Write-Log $script:LogLevelDebug $Message

    $local:HelmSet = " --set logzio-k8s-telemetry.secrets.LogzioRegion=$Region"

    $local:Message = "Logz.io region Helm set is '$HelmSet'"
    Send-LogToLogzio $script:LogLevelDebug $Message $script:LogStepTraces $script:LogScriptTraces $FuncName $script:AgentId $script:Platform $script:Subtype $script:CurrentDataSource
    Write-Log $script:LogLevelDebug $Message

    Write-TaskPostRun "`$script:LogHelmSets += '$HelmSet'"
    Write-TaskPostRun "`$script:HelmSets += '$HelmSet'"
}
