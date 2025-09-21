function Get-WmiConsumerFilterData {
    param(
        $Path
    )

    $p = "$Path\wmi-event-filter.csv"
    Get-WMIObject -Namespace root\Subscription -Class __EventFilter | Select-Object __NAMESPACE, Name, EventNamespace, Query, QueryLanguage  | Export-Csv $p -NoTypeInformation
    Get-WMIObject -Namespace root\Default -Class __EventFilter | Select-Object __NAMESPACE, Name, EventNamespace, Query, QueryLanguage  | Export-Csv -Append $p

    $p = "$Path\wmi-event-consumer.csv"
    Get-WMIObject -Namespace root\Subscription -Class __EventConsumer | 
    Select-Object __NAMESPACE, Name, SourceName, CommandLineTemplate, ExecutablePath, ScriptFilename, ScriptingEngine, ScriptText | Export-Csv $p -NoTypeInformation
    Get-WMIObject -Namespace root\Default -Class __EventConsumer | 
    Select-Object __NAMESPACE, Name, SourceName, CommandLineTemplate, ExecutablePath, ScriptFilename, ScriptingEngine, ScriptText | Export-Csv -Append $p

    $p = "$Path\wmi-event-filter-consumer-binding.csv"
    Get-WMIObject -Namespace root\Subscription -Class __FilterToConsumerBinding | Select-Object __NAMESPACE, Filter, Consumer | Export-Csv $p -NoTypeInformation
    Get-WMIObject -Namespace root\Default -Class __FilterToConsumerBinding | Select-Object __NAMESPACE, Filter, Consumer | Export-Csv -Append $p

}