# Correção de save do port nativo de Shadow of the Colossus (SotC-PC v1.1, bin\bb-probe.exe)
# Save fix for the Shadow of the Colossus native port (SotC-PC v1.1, bin\bb-probe.exe)
#
#  1. Espaço livre / free space: sceSaveDataGetMountInfo e sceSaveDataDirNameSearch informavam pouco espaço
#     livre e o jogo mostrava "não é possível salvar / verifique o armazenamento"
#     (SaveDataDialog SYSTEM_MSG tipo 8, NOSPACE_CONTINUABLE). Agora informam espaço folgado.
#  2. Save manual / manual save: o port não tem a tela de lista de saves do sistema, então cada save manual
#     criava um slot novo. Agora a lista de SALVAR responde sempre SAVEDATA0ShadowProgress1 e a lista de
#     CARREGAR abre esse mesmo slot ("Carregar"/"Load"). "Continuar" segue com o save mais recente.
#
# Uso / usage:  corrigir_save.ps1            aplica / apply
#               corrigir_save.ps1 -Desfazer  volta o original / restore the original
param([switch]$Desfazer)
$ErrorActionPreference = 'Stop'
$sha_original  = 'b899b3ecbf94e4092bb4be9b242f534094fccff3a3eb9b655d0a0896b8c9e947'
$sha_corrigido = 'd598c2953385f81a42b0483d14511b623b9ded82bd011316fc69299bd2fd25d3'
$blocos = @(
    @{ Off = 0x188; Old = 'c664'; New = '0066' },
    @{ Off = 0x200; Old = '48'; New = '88' },
    @{ Off = 0x18F5D; Old = '8000'; New = '0020' },
    @{ Off = 0x18F64; Old = 'c07f00'; New = '00ff1f' },
    @{ Off = 0x1972D; Old = '8000'; New = '0020' },
    @{ Off = 0x19736; Old = '4000'; New = 'ff1f' },
    @{ Off = 0x3368D0; Old = 'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc'; New = '534156454441544130536861646f7750726f67726573733100000000000000004885ff0f84120000008b473489057e9bb7028b47388905799bb702e9f04cceff' },
    @{ Off = 0x336930; Old = 'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc'; New = '4885ff0f8461000000c7470400000000c7470801000000833d329bb702010f8543000000833d299bb702010f840d000000833d1c9bb702020f8529000000488b47104885c00f841c0000000f10054effffff0f11000f100554ffffff0f114010c747080000000031c0c3b80600b880c3' },
    @{ Off = 0x358A48; Old = '00c201'; New = 'f07433' },
    @{ Off = 0x358A98; Old = '90c201'; New = '307533' }
)

function Hex([string]$h) {
    $b = New-Object byte[] ($h.Length / 2)
    for ($i = 0; $i -lt $b.Length; $i++) { $b[$i] = [Convert]::ToByte($h.Substring($i * 2, 2), 16) }
    return ,$b
}
function Sha($f) { (Get-FileHash $f -Algorithm SHA256).Hash.ToLower() }
function Achar-Exe {
    foreach ($p in @("$PSScriptRoot\bin\bb-probe.exe", "$PSScriptRoot\..\bin\bb-probe.exe", "$PSScriptRoot\bb-probe.exe")) {
        if (Test-Path $p) { return (Resolve-Path $p).Path }
    }
    throw "bb-probe.exe nao encontrado: coloque esta pasta dentro da pasta do port (onde fica o SotC.exe). / bb-probe.exe not found: put this folder inside the port folder (next to SotC.exe)."
}

$exe = Achar-Exe
if (Get-Process bb-probe -ErrorAction SilentlyContinue | Where-Object { $_.Path -eq $exe }) { throw "Feche o jogo primeiro. / Close the game first." }
$bkp = "$exe.original-v1.1"
$atual = Sha $exe

if ($Desfazer) {
    if (-not (Test-Path $bkp)) { throw "Backup nao encontrado / backup not found: $bkp" }
    Copy-Item $bkp $exe -Force
    Write-Host "Original restaurado. / Original restored." -ForegroundColor Green
    return
}
if ($atual -eq $sha_corrigido) { Write-Host "A correcao ja esta aplicada. / The fix is already applied." -ForegroundColor Green; return }
if ($atual -ne $sha_original) {
    throw "Este bb-probe.exe nao e o da versao v1.1 esperada (SHA256 $atual). Nada foi alterado. / This bb-probe.exe is not the expected v1.1 build. Nothing was changed."
}

$d = [IO.File]::ReadAllBytes($exe)
foreach ($b in $blocos) {   # confere tudo antes de mudar qualquer byte
    $old = Hex $b.Old
    for ($i = 0; $i -lt $old.Length; $i++) {
        if ($d[$b.Off + $i] -ne $old[$i]) { throw ("Bytes inesperados em 0x{0:X}. Nada foi alterado. / Unexpected bytes. Nothing was changed." -f ($b.Off + $i)) }
    }
}
foreach ($b in $blocos) {
    $new = Hex $b.New
    [Array]::Copy($new, 0, $d, $b.Off, $new.Length)
}
if (-not (Test-Path $bkp)) { Copy-Item $exe $bkp }
[IO.File]::WriteAllBytes("$exe.tmp", $d)
if ((Sha "$exe.tmp") -ne $sha_corrigido) { Remove-Item "$exe.tmp"; throw "Conferencia falhou; nada foi alterado. / Verification failed; nothing was changed." }
Move-Item "$exe.tmp" $exe -Force
Write-Host "Correcao aplicada! Backup: $bkp" -ForegroundColor Green
Write-Host "Fix applied! Backup: $bkp" -ForegroundColor Green
