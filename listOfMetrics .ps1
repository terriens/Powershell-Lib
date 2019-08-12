Get-Counter
$gc =   '\Memory\% Committed Bytes In Use',
        '\Memory\Available MBytes',
        '\Network Interface(`*)\Current Bandwith',
        '\Network Interface(`*)\Packets Recieved/sec',
        '\Network Interface(`*)\Packets Sent/sec',
        "\PhysicalDisk(_Total)\Disk Write Bytes/sec"
        "\PhysicalDisk(_Total)\Disk Read Bytes/sec",
        "\Processor(_Total)\% Processor Time",
        "\Processor(_Total)\% Idle Time"
Get-Counter -counter $gc -SampleInterval 2 -MaxSamples 8

$listOfMetrics = @(
      "\processor(0)\% processor time",
      "\processor(1)\% processor time"
)
Get-Counter $listOfMetrics 