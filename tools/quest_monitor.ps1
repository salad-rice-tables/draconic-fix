# Quest/gossip monitor digest: vytiahne relevantne riadky z aktualnych logov.
# Pouzitie: powershell -ExecutionPolicy Bypass -File C:\WowServer\Custom\tools\quest_monitor.ps1 [-Lines 400]
param([int]$Lines = 400)
$Bin = "C:\WowServer\MyServer\69587Precompiled\69587Precompiled\bin\RelWithDebInfo"
$slog = Get-ChildItem "$Bin\Server_*.log" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
$elog = Get-ChildItem "$Bin\Eluna_*.log" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
Write-Output "=== SERVER: $($slog.Name) ==="
Get-Content $slog.FullName -Tail ($Lines * 4) | Select-String -Pattern 'Gossip Select|Killcredit|does not exist, skipped|ERROR.*[Ss]mart|ERROR.*[Gg]ossip' | Select-Object -Last $Lines
Write-Output "=== ELUNA: $($elog.Name) ==="
Get-Content $elog.FullName -Tail ($Lines * 4) | Select-String -Pattern '\[evil\]|\[abyss\]|EVIL-DBG|ERROR|error.*lua|lua.*error' | Select-Object -Last $Lines
